# Narmada Billing — CA Statement Import: Sandbox ✅ / Production ⏳

## Done in SANDBOX
- [x] Confirmed `statement_table` schema (bill_id, company_name, bill_no, bill_date, gst_no, amount)
- [x] Built `statement_import.sql` with historical CA data (Apr 2024 → Apr 2026), `bill_id = NULL` for these rows
- [x] Removed `BEGIN TRANSACTION` / `COMMIT` (D1 doesn't support explicit transactions)
- [x] Ran import against `narmada-billing-sandbox` (remote) — **644 rows confirmed**
  ```
  npx wrangler d1 execute narmada-billing-sandbox --env sandbox --remote --file=statement_import.sql
  ```
- [ ] Add `GET /api/statement` route in `backend/src/index.js` (in progress — need to see existing `/api/bills` route to pick insert point)
- [ ] Update `loadCAReport()` in `frontend/index.html` to fetch from `/api/statement` instead of `/api/bills` + `/api/clients`

## Still PENDING for PRODUCTION
1. [ ] Confirm production D1 database name (check `wrangler.toml` — likely NOT `narmada-billing-sandbox`)
2. [ ] Re-run the same import against production DB:
   ```
   npx wrangler d1 execute <PRODUCTION_DB_NAME> --env production --remote --file=statement_import.sql
   ```
3. [ ] Verify count matches 644:
   ```
   npx wrangler d1 execute <PRODUCTION_DB_NAME> --env production --remote --command "SELECT COUNT(*) FROM statement_table;"
   ```
4. [ ] Deploy backend with new `/api/statement` route (`wrangler deploy` with production env)
5. [ ] Deploy frontend with updated `loadCAReport()` (`wrangler pages deploy dist`)
6. [ ] Spot-check CA report panel in production shows historical + live data correctly

## Notes / Gotchas
- Sandbox and production are separate D1 databases — sandbox import does **not** carry over automatically.
- Watch for wrangler upload caching old file versions — always re-check `head -1 statement_import.sql` shows `INSERT INTO...`, not `BEGIN TRANSACTION;`.
- Invoice creation/editing, `bills` table, `clients` table are untouched by this change — only CA report's data source changes.
