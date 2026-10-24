-- ============================================================
-- Fox River Supply Co. | Accounts Receivable Aging (SQL)
-- Database: DB Browser for SQLite   Table: ar_invoices
-- Report Date: 9/30/2026. Synthetic data.
-- Each query says which Excel number it should match.
-- Run ONE query at a time: highlight the whole query with your mouse,
-- then press Ctrl+Enter (or click the Play button).
-- ============================================================


-- ---------- PART A: what I already know ----------

-- Q1. Did the import work? Look at the first 10 rows.
SELECT *
FROM ar_invoices
LIMIT 10;

-- Q2. Collections call list: everything 90+ days past due, oldest first.
--     Expect 4 rows (Ironwood Construction and Northgate Auto Parts).
SELECT Invoice_Number, Customer, Due_Date, Balance, Days_Past_Due, Status
FROM ar_invoices
WHERE Aging_Bucket = '90+ Days'
ORDER BY Days_Past_Due DESC;

-- Q3. Billing discrepancies: every disputed invoice, biggest first.
--     Expect 8 rows. Matches Excel pivot 3.
SELECT Invoice_Number, Customer, Balance, Dispute_Reason, Aging_Bucket
FROM ar_invoices
WHERE Status = 'Disputed'
ORDER BY Balance DESC;

-- Q4. The 10 biggest open balances.
--     Expect INV-24112 (Ironwood Construction, 15341.52) on top.
SELECT Invoice_Number, Customer, Balance, Aging_Bucket
FROM ar_invoices
ORDER BY Balance DESC
LIMIT 10;

-- Q5. One customer's open invoices: Ironwood Construction, oldest first.
--     Expect 10 rows.
SELECT Invoice_Number, Invoice_Date, Due_Date, Balance, Days_Past_Due, Aging_Bucket
FROM ar_invoices
WHERE Customer = 'Ironwood Construction'
ORDER BY Days_Past_Due DESC;

-- Q6. Find the duplicate invoice: same customer, same amount.
--     Expect 2 rows: INV-24111 and INV-24202, both 1757.56 on 2026-06-22.
SELECT Invoice_Number, Customer, Invoice_Date, Invoice_Amount, Status, Dispute_Reason
FROM ar_invoices
WHERE Customer = 'Harvest Table Catering'
  AND Invoice_Amount = 1757.56;


-- ---------- PART B: NEW. SUM, COUNT, GROUP BY ----------

-- Q7. Total open AR. Matches the Excel "Total Open AR" tile.
--     Expect 102 invoices and 490372.81.
SELECT COUNT(*) AS Invoices,
       ROUND(SUM(Balance), 2) AS Total_AR
FROM ar_invoices;

-- Q8. Total past due. Matches the Excel "Past Due" tile.
--     Expect 234086.9
SELECT ROUND(SUM(Balance), 2) AS Past_Due
FROM ar_invoices
WHERE Days_Past_Due > 0;

-- Q9. The aging summary. Matches Excel pivot 1.
--     Expect 5 rows, Current first: 51 / 256285.91 ... 90+ Days: 4 / 20147.92
SELECT Aging_Bucket,
       COUNT(*) AS Invoices,
       ROUND(SUM(Balance), 2) AS Balance
FROM ar_invoices
GROUP BY Bucket_Sort, Aging_Bucket
ORDER BY Bucket_Sort;

-- Q10. Top 5 customers by balance. Matches the top of Excel pivot 2.
--      Expect Riverbend Medical Supply 120138.23 on top.
SELECT Customer,
       ROUND(SUM(Balance), 2) AS Total_Balance
FROM ar_invoices
GROUP BY Customer
ORDER BY Total_Balance DESC
LIMIT 5;

-- Q11. Disputes by reason. Matches Excel pivot 3.
--      Expect Pricing error 4 / 13174.01 on top.
SELECT Dispute_Reason,
       COUNT(*) AS Invoices,
       ROUND(SUM(Balance), 2) AS Balance
FROM ar_invoices
WHERE Status = 'Disputed'
GROUP BY Dispute_Reason
ORDER BY Balance DESC;
