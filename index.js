export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    const cors = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
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

    try {

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
        await env.DB.prepare(
          `UPDATE bills SET bill_no=?, bill_date=?, client_id=?, total_freight=?, amount_in_words=?, note=? WHERE id=?`
        ).bind(bill_no, bill_date, client_id || null, total_freight || 0, amount_in_words || '', note || '', id).run();
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
        await env.DB.prepare(`DELETE FROM bill_items WHERE bill_id=?`).bind(id).run();
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
              row.freight || 0
            ).run();
          }
        }

        return json({ success: true, id: billId });
      }



      // ── GET STATS ──
      if (path === '/api/stats' && request.method === 'GET') {
        const totalBills = await env.DB.prepare('SELECT COUNT(*) as count FROM bills').first();
        const totalClients = await env.DB.prepare('SELECT COUNT(*) as count FROM clients').first();
        const lastBill = await env.DB.prepare('SELECT bill_no FROM bills ORDER BY id DESC LIMIT 1').first();
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
