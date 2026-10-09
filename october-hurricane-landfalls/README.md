# October Hurricane Landfalls in the U.S., 1851–2025

**Question:** Where have hurricanes made landfall in the United States in October, and how strong were they?

**Interactive map:** [View on Tableau Public](https://public.tableau.com/views/OctoberHurricanes/Sheet1)

**Tools:** Excel Power Query · SQL (SQLite, DB Browser) · Tableau Public

---

## The data

Two NOAA sources, both public:

| Source | What it has | What it's missing |
|---|---|---|
| [HURDAT2](https://www.aoml.noaa.gov/hrd/hurdat/Data_Storm.html) (Atlantic hurricane database) | Every storm's track every 6 hours: date, time, latitude, longitude, wind, pressure, and an `L` flag at each landfall | Which country the landfall was in |
| [Continental U.S. Hurricane Impacts/Landfalls](https://www.aoml.noaa.gov/hrd/hurdat/All_U.S._Hurricanes.html) | Every U.S. hurricane with year, month, states hit, and category | Exact location, and storm names before 1950 |

Neither source answers the question alone, so I joined them.

## How I built it

**1. Cleaned HURDAT2 in Power Query (57,516 rows).** The raw file stacks each storm's header line above its track rows, so the storm name only appears once per storm. I used conditional columns and Fill Down to copy each storm's ID and name onto its track rows, removed the empty wind-radii columns, replaced the `-999` placeholders with nulls, and filtered to landfalls (`L`), hurricane strength (`HU`), and October. That left 138 landfalls across the whole Atlantic.

**2. Cleaned the U.S. landfall list in Power Query.** Filtered to October (61 storms), matched the month and year formats to HURDAT2, and built a join-friendly name column (uppercase, with pre-1950 nicknames set to `UNNAMED` to match HURDAT2).

**3. Joined the two tables in SQL** on year + month + storm name. See [`queries.sql`](queries.sql).

**4. Checked the results and fixed what was wrong.** The first join returned 102 rows. Working through them:
- **Foreign landfalls rode along on U.S. storm names.** Storms like Wilma hit Mexico before Florida. Filtering out landfalls south of the Florida Keys (24.4°N) removed 20 rows.
- **Two years matched twice.** October 1870 and 1893 each had two unnamed U.S. hurricanes, so the join paired each landfall with both. A `GROUP BY ... HAVING COUNT(*) > 1` query found the 5 doubled rows, and I matched each to the right storm by date and coast.
- **The map caught two more.** Plotted in Tableau, one dot sat near Bermuda and one in the Bahamas (Matthew, 2016). I added longitude filters in SQL so the fix lives in the data, not just the chart.
- **A dot showed 160 knots, which no October U.S. landfall reached.** Two unnamed storms at the same coordinates had merged into one mark and Tableau added their winds together. Using Storm ID instead of Storm Name to separate the marks fixed it.

Final result: **75 October hurricane landfalls on the U.S. coast.**

## What I found

- **October landfalls cluster on the Gulf Coast and Florida.** Late-season storms tend to form in the Caribbean and the Gulf, so they come ashore there rather than up the East Coast.
- **The strongest was Michael (2018), at 140 knots,** a Category 5 at Mexico Beach in the Florida Panhandle. It's the only October Category 5 landfall in U.S. records.
- **Michael came ashore at the same spot as a hurricane 141 years earlier.** An unnamed hurricane made landfall at 30.0°N, 85.5°W on October 3, 1877; Michael made landfall at 30.0°N, 85.5°W on October 10, 2018. (HURDAT2 records positions to one decimal place, so "same spot" means within about 7 miles.) The 1877 storm was a Category 3: about 100 knots and 955 mb. In Tableau, the 1877 dot sits directly on top of Michael's and hides it, which is how I found the match.
- **The 1877 numbers came back around on the day I finished this project.** On the morning of October 9, 2026, Hurricane Isaias was in the Gulf at about 952 mb and strengthening toward Category 3, with landfall forecast for Escambia Bay in the Florida Panhandle overnight. That's nearly the same pressure as the 1877 storm, and the same stretch of coast.

## Sources

Both data sets are from NOAA's Atlantic Oceanographic and Meteorological Laboratory, Hurricane Research Division. Accessed October 9, 2026.

- **HURDAT2, Atlantic hurricane database (1851–2025).** NOAA AOML Hurricane Research Division. https://www.aoml.noaa.gov/hrd/hurdat/Data_Storm.html
  - Database format described in: Landsea, C. W., and J. L. Franklin, 2013: Atlantic Hurricane Database Uncertainty and Presentation of a New Database Format. *Monthly Weather Review*, 141, 3576–3592.
- **Continental United States Hurricane Impacts/Landfalls, 1851–2025** (revised September 2026). NOAA AOML Hurricane Research Division. https://www.aoml.noaa.gov/hrd/hurdat/All_U.S._Hurricanes.html

## Notes on the data

- Wind speeds and pressures for 19th-century storms are estimates rebuilt from ship logs and sparse coast reports, which is why they're round numbers (70, 80, 90, 100 knots).
- A few storms on NOAA's U.S. list brought hurricane winds ashore without their center making landfall (marked `*` on that list, for example Sandy in 2012). Those aren't counted as landfalls here.
- Storms that made landfall in October but were tropical storms at the time aren't included. This project counts hurricane-strength landfalls only.
