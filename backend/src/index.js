function isValidCalendarDate(dateStr) {
  if (!dateStr) return false;
  const parts = String(dateStr).split('-');
  if (parts.length !== 3) return false;
  const [y, m, d] = parts.map(Number);
  if (!y || !m || !d) return false;
  const dt = new Date(Date.UTC(y, m - 1, d));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === d;
}

function getFinancialYear(dateStr) {
  const d = new Date(dateStr);
  const y = d.getFullYear();
  const m = d.getMonth();
  return m >= 3 ? (y + '-' + (y + 1)) : ((y - 1) + '-' + y);
}

function validateBillNo(billNo, billDate) {
  const match = String(billNo).trim().match(/^(\d+)\s*\/\s*(\d{4})-(\d{4})$/);
  if (!match) return { valid: false, error: 'Invoice number must be in format NN / YYYY-YYYY' };
  const serial = parseInt(match[1], 10);
  if (serial < 1) return { valid: false, error: 'Invoice number must start from 1' };
  const y1 = parseInt(match[2], 10);
  const y2 = parseInt(match[3], 10);
  if (y2 !== y1 + 1) return { valid: false, error: 'Invalid financial year in invoice number' };
  const expectedFY = getFinancialYear(billDate);
  if (expectedFY !== (y1 + '-' + y2)) return { valid: false, error: 'Invoice number FY does not match invoice date' };
  return { valid: true };
}


function validateAmounts(total_freight, items) {
  if (total_freight !== undefined && total_freight !== null && Number(total_freight) < 0) {
    return { valid: false, error: 'Total freight cannot be negative' };
  }
  if (items && items.length > 0) {
    for (const row of items) {
      if (row.freight !== undefined && row.freight !== null && Number(row.freight) < 0) {
        return { valid: false, error: 'Item freight cannot be negative' };
      }
    }
  }
  return { valid: true };
}

async function uploadToDrive(env, fileName, pdfBytes) {
  const base64 = btoa(String.fromCharCode(...new Uint8Array(pdfBytes)));
  const res = await fetch(env.APPS_SCRIPT_URL, {
    method: 'POST',
    body: JSON.stringify({ fileName, pdfBase64: base64 })
  });
  const data = await res.json();
  if (!data.success) throw new Error(JSON.stringify(data));
  return data;
}

async function generateInvoicePdf(bill, items) {
  const { PDFDocument, StandardFonts } = await import('pdf-lib');
  const pdfDoc = await PDFDocument.create();
  const page = pdfDoc.addPage([595, 842]);
  const font = await pdfDoc.embedFont(StandardFonts.Helvetica);

  let y = 800;
  page.drawText(`Invoice No: ${bill.bill_no}`, { x: 50, y, size: 14, font });
  y -= 25;
  page.drawText(`Date: ${bill.bill_date}`, { x: 50, y, size: 12, font });
  y -= 25;
  page.drawText(`Total Freight: ${bill.total_freight}`, { x: 50, y, size: 12, font });
  y -= 35;

  items.forEach((it, i) => {
    page.drawText(`${i + 1}. ${it.vehicle_no} | ${it.from_location} -> ${it.to_location} | ${it.freight}`, {
      x: 50, y, size: 10, font
    });
    y -= 18;
  });

  return await pdfDoc.save();
}



export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    const cors = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: cors });
    }

    function json(data, status = 200) {
      return new Response(JSON.stringify(data), {
        status,
        headers: { ...cors, 'Content-Type': 'application/json' },
      });
    }

    async function upsertStatementRow(env, billId) {
      const bill = await env.DB.prepare(
        `SELECT b.bill_no, b.bill_date, b.total_freight, b.note, b.client_id,
                c.company_name, c.gst_no
         FROM bills b LEFT JOIN clients c ON b.client_id = c.id
         WHERE b.id = ?`
      ).bind(billId).first();
      if (!bill) return;

      let companyName = bill.company_name || '';
      let gstNo = bill.gst_no || '';

      if (!bill.client_id && bill.note && bill.note.startsWith('__RAILWAY__:')) {
        try {
          const railData = JSON.parse(bill.note.slice('__RAILWAY__:'.length));
          companyName = railData.client_name || '';
          gstNo = '';
        } catch { }
      }

      await env.DB.prepare(`DELETE FROM statement_table WHERE bill_id = ?`).bind(billId).run();
      await env.DB.prepare(
        `INSERT INTO statement_table (bill_id, company_name, bill_no, bill_date, gst_no, amount)
         VALUES (?, ?, ?, ?, ?, ?)`
      ).bind(billId, companyName, bill.bill_no, bill.bill_date, gstNo, bill.total_freight || 0).run();
    }

    async function signToken(payload, secret) {
      const header = { alg: 'HS256', typ: 'JWT' };
      const encode = (obj) => btoa(JSON.stringify(obj)).replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_');
      const headerB64 = encode(header);
      const payloadB64 = encode(payload);
      const data = `${headerB64}.${payloadB64}`;
      const key = await crypto.subtle.importKey(
        'raw', new TextEncoder().encode(secret),
        { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']
      );
      const sigBuffer = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(data));
      const sigB64 = btoa(String.fromCharCode(...new Uint8Array(sigBuffer))).replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_');
      return `${data}.${sigB64}`;
    }

    async function verifyToken(token, secret) {
      try {
        const [headerB64, payloadB64, sigB64] = token.split('.');
        const data = `${headerB64}.${payloadB64}`;
        const key = await crypto.subtle.importKey(
          'raw', new TextEncoder().encode(secret),
          { name: 'HMAC', hash: 'SHA-256' }, false, ['verify']
        );
        const sig = Uint8Array.from(atob(sigB64.replace(/-/g, '+').replace(/_/g, '/')), c => c.charCodeAt(0));
        const valid = await crypto.subtle.verify('HMAC', key, sig, new TextEncoder().encode(data));
        if (!valid) return null;
        const payload = JSON.parse(atob(payloadB64.replace(/-/g, '+').replace(/_/g, '/')));
        if (payload.exp && Date.now() > payload.exp) return null;
        return payload;
      } catch {
        return null;
      }
    }

    async function requireAuth(request, env) {
      const authHeader = request.headers.get('Authorization');
      if (!authHeader || !authHeader.startsWith('Bearer ')) return null;
      const token = authHeader.replace('Bearer ', '');
      const payload = await verifyToken(token, env.JWT_SECRET);
      return payload;
    }

    try {

      // ── SIGNUP ──
      if (path === '/api/signup' && request.method === 'POST') {
        const body = await request.json();
        const { name, email, password, confirmPassword } = body;
        if (!name || !email || !password || !confirmPassword) {
          return json({ success: false, error: 'All fields are required' }, 400);
        }
        if (password !== confirmPassword) {
          return json({ success: false, error: 'Passwords do not match' }, 400);
        }
        if (password.length < 6) {
          return json({ success: false, error: 'Password must be at least 6 characters' }, 400);
        }
        const existing = await env.DB.prepare('SELECT id FROM users WHERE email = ?').bind(email).first();
        if (existing) {
          return json({ success: false, error: 'An account with this email already exists' }, 400);
        }
        const encoder = new TextEncoder();
        const data = encoder.encode(password);
        const hashBuffer = await crypto.subtle.digest('SHA-256', data);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        const password_hash = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
        await env.DB.prepare(
          'INSERT INTO users (name, email, password_hash, status) VALUES (?, ?, ?, ?)'
        ).bind(name, email, password_hash, 'pending').run();
        return json({ success: true, message: 'Account created. Waiting for admin approval.' });
      }

      // ── LOGIN ──
      if (path === '/api/login' && request.method === 'POST') {
        const body = await request.json();
        const { email, password } = body;
        if (!email || !password) {
          return json({ success: false, error: 'Email and password are required' }, 400);
        }
        const user = await env.DB.prepare('SELECT * FROM users WHERE email = ?').bind(email).first();
        if (!user) {
          return json({ success: false, error: 'Invalid email or password' }, 401);
        }
        const encoder = new TextEncoder();
        const data = encoder.encode(password);
        const hashBuffer = await crypto.subtle.digest('SHA-256', data);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        const password_hash = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
        if (password_hash !== user.password_hash) {
          return json({ success: false, error: 'Invalid email or password' }, 401);
        }
        if (user.status === 'pending') {
          return json({ success: false, error: 'Your account is awaiting approval' }, 403);
        }
        if (user.status === 'rejected') {
          return json({ success: false, error: 'Your account access has been denied' }, 403);
        }
        const token = await signToken(
          { id: user.id, email: user.email, exp: Date.now() + 6 * 60 * 60 * 1000 },
          env.JWT_SECRET
        );
        return json({
          success: true,
          token,
          user: { id: user.id, name: user.name, email: user.email }
        });
      }

      // ── AUTH GUARD (protects everything except /api/signup and /api/login) ──
      if (path !== '/api/signup' && path !== '/api/login') {
        const user = await requireAuth(request, env);
        if (!user) {
          return json({ success: false, error: 'Unauthorized. Please log in.' }, 401);
        }
      }


      // ── GET ALL CLIENTS ──
      if (path === '/api/clients' && request.method === 'GET') {
        const { results } = await env.DB.prepare(
          'SELECT * FROM clients ORDER BY company_name ASC'
        ).all();
        return json({ success: true, data: results });
      }

      // ── ADD NEW CLIENT ──
      if (path === '/api/clients' && request.method === 'POST') {
        const body = await request.json();
        const { company_name, address, city, pin_code, state, phone1, phone2, gst_no } = body;
        if (!company_name) return json({ success: false, error: 'Company name is required' }, 400);
        const result = await env.DB.prepare(
          `INSERT INTO clients (company_name, address, city, pin_code, state, phone1, phone2, gst_no)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?)`
        ).bind(company_name, address || '', city || '', pin_code || '', state || 'Gujarat[24]', phone1 || '', phone2 || '', gst_no || '').run();
        return json({ success: true, id: result.meta.last_row_id });
      }



      // ── UPDATE CLIENT ──
      const editMatch = path.match(/^\/api\/clients\/(\d+)$/);
      if (editMatch && request.method === 'PUT') {
        const id = editMatch[1];
        const body = await request.json();
        const { company_name, address, city, pin_code, state, phone1, phone2, gst_no } = body;
        if (!company_name) return json({ success: false, error: 'Company name is required' }, 400);
        await env.DB.prepare(
          `UPDATE clients SET company_name=?, address=?, city=?, pin_code=?, state=?, phone1=?, phone2=?, gst_no=? WHERE id=?`
        ).bind(company_name, address || '', city || '', pin_code || '', state || 'Gujarat[24]', phone1 || '', phone2 || '', gst_no || '', id).run();
        return json({ success: true });
      }

      // ── DELETE CLIENT ──
      if (editMatch && request.method === 'DELETE') {
        const id = editMatch[1];
        const existing = await env.DB.prepare('SELECT id FROM clients WHERE id=?').bind(id).first();
        if (!existing) return json({ success: false, error: 'Client not found' }, 404);
        const linkedBill = await env.DB.prepare('SELECT id FROM bills WHERE client_id=? LIMIT 1').bind(id).first();
        if (linkedBill) return json({ success: false, error: 'Cannot delete: this client has existing invoices' }, 400);
        await env.DB.prepare('DELETE FROM clients WHERE id=?').bind(id).run();
        return json({ success: true });
      }

      // ── GET ALL BILLS ──
      if (path === '/api/bills' && request.method === 'GET') {
        const { results } = await env.DB.prepare(
          `SELECT b.*, c.company_name, c.gst_no as client_gst
           FROM bills b LEFT JOIN clients c ON b.client_id = c.id
           ORDER BY b.created_at DESC`
        ).all();
        return json({ success: true, data: results });
      }

      // ── GET STATEMENT (CA REPORT) ──
      if (path === '/api/statement' && request.method === 'GET') {
        const { results } = await env.DB.prepare(
          `SELECT * FROM statement_table ORDER BY bill_date ASC, bill_id ASC`
        ).all();
        return json({ success: true, data: results });
      }

      // ── GET SINGLE BILL WITH ITEMS ──
      const billMatch = path.match(/^\/api\/bills\/(\d+)$/);
      if (billMatch && request.method === 'GET') {
        const id = billMatch[1];
        const bill = await env.DB.prepare(
          `SELECT b.*, c.company_name, c.address as company_address, c.city as company_city,
                  c.pin_code as company_pin, c.state as company_state,
                  c.phone1 as company_phone1, c.phone2 as company_phone2,
                  c.gst_no as client_gst
           FROM bills b LEFT JOIN clients c ON b.client_id = c.id
           WHERE b.id = ?`
        ).bind(id).first();
        if (!bill) return json({ success: false, error: 'Bill not found' }, 404);
        const { results: items } = await env.DB.prepare(
          `SELECT * FROM bill_items WHERE bill_id = ? ORDER BY sr_no ASC`
        ).bind(id).all();
        return json({ success: true, data: { ...bill, items } });
      }

      // ── UPDATE BILL ──
      if (billMatch && request.method === 'PUT') {
        const id = billMatch[1];
        const body = await request.json();
        const { bill_no, bill_date, client_id, total_freight, amount_in_words, note, items } = body;
        if (!bill_no || !bill_date) return json({ success: false, error: 'Bill number and date required' }, 400);
        if (!isValidCalendarDate(bill_date)) return json({ success: false, error: 'Invoice date is not a valid calendar date' }, 400);
        {
          const billNoCheck = validateBillNo(bill_no, bill_date);
          if (!billNoCheck.valid) return json({ success: false, error: billNoCheck.error }, 400);
        }
        {
          const amountCheck = validateAmounts(total_freight, items);
          if (!amountCheck.valid) return json({ success: false, error: amountCheck.error }, 400);
        }

        const current = await env.DB.prepare('SELECT bill_no FROM bills WHERE id = ?').bind(id).first();
        if (!current) return json({ success: false, error: 'Bill not found' }, 404);

        if (bill_no !== current.bill_no) {
          const conflict = await env.DB.prepare('SELECT id FROM bills WHERE bill_no = ? AND id != ?').bind(bill_no, id).first();
          if (conflict) {
            // swap: give the other bill this bill's old number
            await env.DB.prepare('UPDATE bills SET bill_no = ? WHERE id = ?').bind(current.bill_no, conflict.id).run();
            await upsertStatementRow(env, conflict.id);
          }
        }

        await env.DB.prepare(
          `UPDATE bills SET bill_no=?, bill_date=?, client_id=?, total_freight=?, amount_in_words=?, note=? WHERE id=?`
        ).bind(bill_no, bill_date, client_id || null, total_freight || 0, amount_in_words || '', note || '', id).run();
        await upsertStatementRow(env, id);
        // Replace items
        await env.DB.prepare(`DELETE FROM bill_items WHERE bill_id=?`).bind(id).run();
        if (items && items.length > 0) {
          for (let i = 0; i < items.length; i++) {
            const row = items[i];
            await env.DB.prepare(
              `INSERT INTO bill_items (bill_id, sr_no, item_date, vehicle_no, from_location, to_location, lr_no, weight, freight)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
            ).bind(
              id,
              i + 1,
              row.date ?? '',
              row.vehicle ?? '',
              row.from ?? '',
              row.to ?? '',
              row.lr ?? '',
              row.weight ?? '',
              Number(row.freight) || 0
            ).run();
          }
        }

        return json({ success: true });
      }

      // ── DELETE BILL ──
      if (billMatch && request.method === 'DELETE') {
        const id = billMatch[1];
        const existing = await env.DB.prepare('SELECT id FROM bills WHERE id=?').bind(id).first();
        if (!existing) return json({ success: false, error: 'Bill not found' }, 404);
        await env.DB.prepare(`DELETE FROM bill_items WHERE bill_id=?`).bind(id).run();
        await env.DB.prepare(`DELETE FROM statement_table WHERE bill_id=?`).bind(id).run();
        await env.DB.prepare(`DELETE FROM bills WHERE id=?`).bind(id).run();
        return json({ success: true });
      }


      // ── ADD NEW BILL ──
      if (path === '/api/bills' && request.method === 'POST') {
        const body = await request.json();

        const {
          bill_no,
          bill_date,
          client_id,
          total_freight,
          amount_in_words,
          note,   // 👈 ADD THIS
          items
        } = body;

        if (!bill_no || !bill_date) {
          return json({ success: false, error: 'Bill number and date required' }, 400);
        }
        if (!isValidCalendarDate(bill_date)) {
          return json({ success: false, error: 'Invoice date is not a valid calendar date' }, 400);
        }
        {
          const billNoCheck = validateBillNo(bill_no, bill_date);
          if (!billNoCheck.valid) {
            return json({ success: false, error: billNoCheck.error }, 400);
          }
        }
        {
          const amountCheck = validateAmounts(total_freight, items);
          if (!amountCheck.valid) {
            return json({ success: false, error: amountCheck.error }, 400);
          }
        }

        const dupe = await env.DB.prepare('SELECT id FROM bills WHERE bill_no = ?').bind(bill_no).first();
        if (dupe) {
          return json({ success: false, error: 'This bill number is already used by another invoice' }, 400);
        }

        // 1. Insert main bill
        const result = await env.DB.prepare(`
          INSERT INTO bills 
          (bill_no, bill_date, client_id, total_freight, amount_in_words,note)
          VALUES (?, ?, ?, ?, ?, ?)
        `).bind(
          bill_no,
          bill_date,
          client_id || null,
          total_freight || 0,
          amount_in_words || '',
          note || ''
        ).run();

        const billId = result.meta.last_row_id;
        await upsertStatementRow(env, billId);

        // 2. Insert items
        if (items && items.length > 0) {
          for (let i = 0; i < items.length; i++) {
            const row = items[i];

            await env.DB.prepare(`
              INSERT INTO bill_items 
              (bill_id, sr_no, item_date, vehicle_no, from_location, to_location, lr_no, weight, freight)
              VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            `).bind(
              billId,
              i + 1,
              row.date || '',
              row.vehicle || '',
              row.from || '',
              row.to || '',
              row.lr || '',
              row.weight || '',
              Number(row.freight) || 0
            ).run();
          }
        }

        

        return json({ success: true, id: billId });
      }



      // ── GET STATS ──
      if (path === '/api/stats' && request.method === 'GET') {
        const totalBills = await env.DB.prepare('SELECT COUNT(*) as count FROM bills').first();
        const totalClients = await env.DB.prepare('SELECT COUNT(*) as count FROM clients').first();
        const lastBill = await env.DB.prepare('SELECT bill_no FROM bills ORDER BY bill_date DESC, id DESC LIMIT 1').first();
        const thisMonth = await env.DB.prepare(
          `SELECT COALESCE(SUM(total_freight),0) as total FROM bills
           WHERE strftime('%Y-%m', bill_date) = strftime('%Y-%m','now')`
        ).first();
        return json({
          success: true,
          data: {
            totalBills: totalBills?.count || 0,
            totalClients: totalClients?.count || 0,
            lastBillNo: lastBill?.bill_no || '311',
            thisMonth: thisMonth?.total || 0,
          }
        });
      }

      return json({ success: false, error: 'Route not found' }, 404);

    } catch (err) {
      return json({ success: false, error: err.message }, 500);
    }
  }
};
