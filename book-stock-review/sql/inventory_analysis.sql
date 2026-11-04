-- Lakeshore Press: Book Stock Review
-- Report Date: 10/31/2026. Written in DB Browser for SQLite.

-- Explore: look at each table before joining them.

SELECT * FROM Stock;

SELECT * FROM Titles;

-- Join: Stock only has ISBNs and copy counts. Titles has the title, imprint
-- and print program. Joining on ISBN puts them together (160 rows).

SELECT * FROM Stock
JOIN Titles
ON Stock.ISBN = Titles.ISBN;

-- Query 1: Overstock list (25 rows, $262,175)
-- Titles with more than 12 months of stock on the shelf, biggest dollars first.
-- This is the money tied up in inventory that isn't selling fast enough.

SELECT * FROM Stock
JOIN Titles
ON Stock.ISBN = Titles.ISBN
WHERE Stock.Stock_Status = 'Overstock'
ORDER BY Stock.Inventory_Value DESC;

-- Query 2: Print-on-demand candidates (21 rows, $134,707)
-- Overstocked titles that sold fewer than 1,200 copies last year.
-- These are too slow for big print runs. Printing them when ordered
-- would stop new money from sitting on the shelf.

SELECT * FROM Stock
JOIN Titles
ON Stock.ISBN = Titles.ISBN
WHERE Stock.Stock_Status = 'Overstock'
AND Stock.Units_Sold_12M < 1200
ORDER BY Stock.Inventory_Value DESC;

-- Query 3: Reprint or transfer needs (37 rows, 28 in the UK)
-- Offset titles that are Low or Out of Stock. Print on Demand titles are left out
-- because they keep little stock on purpose. Sorted by copies sold so the
-- fastest sellers at risk of missing sales come first.

SELECT * FROM Stock
JOIN Titles
ON Stock.ISBN = Titles.ISBN
WHERE (Stock.Stock_Status = 'Low' OR Stock.Stock_Status = 'Out of Stock')
AND Titles.Print_Program = 'Offset'
ORDER BY Stock.Units_Sold_12M DESC;
