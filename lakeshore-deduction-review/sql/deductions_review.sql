-- =====================================================================
-- Lakeshore Chocolate Co.: Retail Deduction Review
-- Tool: DB Browser for SQLite
-- Data: synthetic (Lakeshore Chocolate Co. and its retail customers are invented)
-- Report Date: 10/31/2026 (October month-end)
--
-- The problem:
--   When a retailer pays our invoices, they often take money off the check
--   (a "deduction") for promotions, short shipments, damaged product and
--   other reasons. Some deductions are valid. Some are not, and every invalid
--   one we don't dispute in time is money we lose for good. Each retailer
--   gives us a set number of days (the dispute window) to push back.
--
-- The question:
--   How much did retailers deduct July through October, how much of it is
--   invalid, and which disputes do we need to file first before the window
--   closes?
--
-- The data (two tables, joined on Retailer_ID):
--   Deductions: one row per deduction (176 rows), with the review result
--               from checking each one against the trade spend plan,
--               proof of delivery and pricing records.
--   Retailers:  one row per customer (5 rows): name, channel, account
--               manager and dispute window. The deduction file only has
--               Retailer_ID, so the join brings in who the customer is and
--               who owns the account.
--
-- Query 9 is exported to CSV and becomes the data for the Excel dashboard.
-- =====================================================================


-- 1. Explore the Deductions table
--    (176 rows)

SELECT * FROM Deductions;


-- 2. Explore the Retailers table
--    (5 rows)

SELECT * FROM Retailers;


-- 3. Join each deduction to its retailer on Retailer_ID, the column both
--    tables share, to see who took each deduction and who owns the account
--    (176 rows)

SELECT * FROM Retailers
JOIN Deductions
ON Retailers.Retailer_ID = Deductions.Retailer_ID;


-- 4. Recovery list: every invalid deduction, soonest dispute deadline
--    first, so the most urgent disputes get filed first
--    (43 rows)

SELECT * FROM Retailers
JOIN Deductions
ON Retailers.Retailer_ID = Deductions.Retailer_ID
WHERE Deductions.Review_Result = 'Invalid'
ORDER BY Dispute_Deadline ASC;


-- 5. Key accounts: invalid deductions for the three largest accounts,
--    grouped by retailer. IN keeps the three retailers in one filter.
--    (42 rows)

SELECT * FROM Retailers
JOIN Deductions
ON Retailers.Retailer_ID = Deductions.Retailer_ID
WHERE Retailer_Name IN ('Prairie Fresh Markets', 'Lone Star Grocers', 'Heartland Foods Distribution')
AND Review_Result = 'Invalid'
ORDER BY Retailer_Name;


-- 6. Duplicate check: promotion and ad/display deductions sorted by
--    Promo_ID, so a promotion charged twice shows up as two rows together
--    (101 rows; 6 Promo_IDs appear twice)

SELECT * FROM Deductions
WHERE Deduction_Type IN ('Promotion', 'Ad / Display Fee')
ORDER BY Promo_ID;


-- 7. File this month: invalid deductions whose dispute deadline falls
--    in November 2026, soonest first
--    (8 rows)

SELECT * FROM Retailers
JOIN Deductions
ON Retailers.Retailer_ID = Deductions.Retailer_ID
WHERE Review_Result = 'Invalid'
AND Dispute_Deadline BETWEEN '2026-11-01' AND '2026-11-30'
ORDER BY Dispute_Deadline ASC;


-- 8. Lost money: invalid deductions whose dispute window closed before
--    the Report Date, grouped by retailer to see where the losses happened
--    (11 rows)

SELECT * FROM Retailers
JOIN Deductions
ON Retailers.Retailer_ID = Deductions.Retailer_ID
WHERE Review_Result = 'Invalid'
AND Dispute_Deadline < '2026-10-31'
ORDER BY Retailer_Name;


-- 9. Export for Excel: the joined data with only the columns the
--    dashboard needs (Retailer_ID left out so it isn't doubled),
--    oldest check first. Exported as Deductions_Export.csv.
--    (176 rows)

SELECT Deduction_ID, Retailer_Name, Channel, Account_Manager, Check_Date, Invoice_Number, Deduction_Type, Promo_ID, Plan_Amount, Amount, Backup_Received, Review_Result, Invalid_Reason, Invalid_Amount, Dispute_Deadline
FROM Retailers
JOIN Deductions
ON Retailers.Retailer_ID = Deductions.Retailer_ID
ORDER BY Check_Date ASC;
