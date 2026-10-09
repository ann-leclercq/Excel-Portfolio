-- October Hurricane Landfalls in the U.S., 1851–2025
-- SQLite (DB Browser for SQLite)
--
-- Tables (both cleaned in Excel Power Query, then imported from CSV):
--   hurdat_oct_landfalls : HURDAT2 track points flagged as landfalls (L),
--                          hurricane strength (HU), in October. 138 rows.
--   us_landfalls_oct     : NOAA's list of U.S. hurricanes, October only. 61 rows.


-- 1. Fix a typo in a column name from the Power Query step (Monrh -> Month).
ALTER TABLE hurdat_oct_landfalls RENAME COLUMN Monrh TO Month;


-- 2. Find landfall points that matched more than one U.S. storm.
--    Years with two unnamed U.S. hurricanes in October (1870, 1893) can only
--    be matched on year + month + "UNNAMED", so each landfall pairs with both.
SELECT h.StormId, h.Date, h.Time, COUNT(*) AS times_matched
FROM hurdat_oct_landfalls h
JOIN us_landfalls_oct u
  ON  h.Year      = u.Year
  AND h.Month     = u.Month
  AND h.StormName = u.JoinName
GROUP BY h.StormId, h.Date, h.Time
HAVING COUNT(*) > 1;
-- Result: 5 rows, all in 1870 and 1893.


-- 3. Final result: one row per October U.S. hurricane landfall (75 rows).
--    Saved as a view and exported to CSV for Tableau.
CREATE VIEW oct_us_landfalls AS
SELECT h.StormId, h.StormName, h.Year, h.Date, h.Time,
       CAST(REPLACE(h.Lat, 'N', '') AS REAL)  AS lat_num,   -- '30.0N' -> 30.0
       -CAST(REPLACE(h.Lon, 'W', '') AS REAL) AS lon_num,   -- '85.5W' -> -85.5 (west is negative)
       h.WindKt, h.Pressure,
       u.States, u.Category
FROM hurdat_oct_landfalls h
JOIN us_landfalls_oct u
  ON  h.Year      = u.Year
  AND h.Month     = u.Month
  AND h.StormName = u.JoinName
-- Keep U.S. landfalls only:
WHERE CAST(REPLACE(h.Lat, 'N', '') AS REAL) >= 24.4          -- drop Cuba, Mexico, Central America (south of the Keys)
  AND -CAST(REPLACE(h.Lon, 'W', '') AS REAL) < -66            -- drop Bermuda (east of Maine)
  AND NOT (CAST(REPLACE(h.Lat, 'N', '') AS REAL) < 27.5       -- drop the Bahamas
           AND -CAST(REPLACE(h.Lon, 'W', '') AS REAL) > -79.9)
-- Pair the doubled 1870 and 1893 landfalls with the right storm:
  AND NOT (h.StormId = 'AL091870' AND u.States LIKE '*%')     -- Oct 20, 1870: the landfalling twin, not the * one
  AND NOT (h.StormId = 'AL101893' AND u.States NOT LIKE 'LA%') -- Oct 2, 1893: Louisiana
  AND NOT (h.StormId = 'AL091893' AND u.States NOT LIKE 'SC%') -- Oct 13, 1893: the Carolinas
ORDER BY h.Date, h.Time;
