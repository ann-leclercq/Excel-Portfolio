-- ============================================================
-- Ridgeline Power Transformers: Pricing Escalations Analysis
-- Tool: DB Browser for SQLite   Database: quote_pricing.db
-- All data is synthetic.
-- ============================================================


-- ---------- Getting to know the data ----------

-- 1. All sales reps (6 rows)
SELECT * FROM reps;

-- 2. Reps in the Southeast region (2 rows)
SELECT * FROM reps
WHERE region = 'Southeast';

-- 3. OEM customers, A to Z (11 rows)
SELECT * FROM customers
WHERE segment = 'OEM'
ORDER BY customer_name ASC;

-- 4. Escalations still open, biggest dollar impact first (21 rows)
SELECT * FROM pricing_escalations
WHERE status = 'Open'
ORDER BY dollar_impact DESC;


-- ---------- Which root cause comes up most? ----------

-- 5. Escalations for one root cause. Ran once per root cause, changing the name each time:
--      Stale cost - not repriced      86   <-- #1 root cause, about 1 in 3
--      Expired quote at order entry   66
--      No issue - pricing correct     47
--      Markup below approved          36
--      Wrong customer segment tier    15
--      Data entry error               12
--      Total                         262   (ties to all rows in the table)
SELECT * FROM pricing_escalations
WHERE root_cause = 'No issue - pricing correct';


-- ---------- Where are the big dollars? ----------

-- 6. Top 10 escalations by dollar impact
--    Result: 6 of the top 10 are stale cost
SELECT * FROM pricing_escalations
ORDER BY dollar_impact DESC
LIMIT 10;

-- 7. Work queue: open escalations from the two biggest problem areas (14 rows)
SELECT * FROM pricing_escalations
WHERE status = 'Open'
AND (root_cause = 'Stale cost - not repriced'
OR root_cause = 'Expired quote at order entry')
ORDER BY dollar_impact DESC;

-- 8. Smallest dollar impact first
--    Result: negative amounts are overcharges (mostly data entry errors).
--    The customer was quoted too high, so these become customer credits.
SELECT * FROM pricing_escalations
ORDER BY dollar_impact ASC;
