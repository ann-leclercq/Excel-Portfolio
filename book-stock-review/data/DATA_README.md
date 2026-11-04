# Shared Data: Lakeshore Press Book Stock Review

Synthetic data. Lakeshore Press, its imprints, titles, ISBNs and dollars are all invented. Excel, SQL and Tableau all use this same data, so the answers must match in all three.

**Report Date: 10/31/2026 (October month-end).** Months_of_Supply, Stock_Status and Inventory_Value are already filled in, so you don't need any formulas to get them.

## The question

**Which titles have too much stock tied up, which are about to run out, and what would cleaning it up save?**

## Files

| File | Use it for |
|---|---|
| `Titles.csv` | SQL and Tableau. 80 titles. |
| `Stock.csv` | SQL and Tableau. 160 rows: one per title per warehouse (US and UK). |
| `Stock_Joined.csv` | Tableau backup. The same result as the SQL join. |
| `Book_Stock_Data.xlsx` | Excel. All three tables, real dates, dollar formatting, and an About tab. |

## Why two tables

The warehouse system knows how many copies of each ISBN are on the shelf and how many sold, but not the title, imprint or print program. Those live in the title list. To see stock by imprint, the two tables have to be **joined on ISBN**.

## Titles.csv columns

| Column | What it means |
|---|---|
| ISBN | The book's ID number (stored as text) |
| Title | Book title |
| Imprint | Lakeshore Fiction, Little Lantern Books (children's), Northpoint Nonfiction, Hearthstone Kitchen (cookbooks) |
| Format | Hardcover, Paperback, Board Book, Picture Book |
| Pub_Date | Date the book came out |
| Unit_Cost | Cost to print one copy |
| List_Price | Cover price |
| Print_Program | **Offset** (printed in big runs and stored) or **Print on Demand** (printed when ordered) |

## Stock.csv columns

| Column | What it means |
|---|---|
| ISBN | Links to Titles |
| Warehouse | US or UK |
| On_Hand | Copies on the shelf |
| Units_Sold_12M | Copies sold in the last 12 months |
| Months_of_Supply | How many months the stock will last at the current sales pace: On_Hand ÷ (Units_Sold_12M ÷ 12) |
| Stock_Status | Out of Stock (0 on hand), Low (under 2 months), Healthy (2–12 months), Overstock (more than 12 months) |
| Inventory_Value | On_Hand × Unit_Cost: the dollars sitting on the shelf |

**Print on Demand titles keep very little stock on purpose,** so Low is normal for them. When looking for real stock problems, look at **Offset** titles.

## Answer key: check your numbers here

**Totals**

| Measure | Answer |
|---|---|
| Titles | 80 (69 Offset, 11 Print on Demand) |
| Stock rows | 160 (80 US, 80 UK) |
| Total inventory value | **$975,985.63** (US $888,866.05, UK $87,119.58) |
| Overstock | **25 rows, $262,174.72 (26.9% of inventory $)** |

**By Stock_Status**

| Stock_Status | Rows | Inventory value | % of $ |
|---|---|---|---|
| Out of Stock | 19 | $0.00 | 0.0% |
| Low | 40 | $43,424.27 | 4.4% |
| Healthy | 76 | $670,386.64 | 68.7% |
| Overstock | 25 | $262,174.72 | 26.9% |
| **Total** | **160** | **$975,985.63** | 100% |

**By warehouse and status (rows)**

| Warehouse | Out of Stock | Low | Healthy | Overstock |
|---|---|---|---|---|
| US | 1 | 19 | 40 | 20 |
| UK | 18 | 21 | 36 | 5 |

**By imprint (needs the join)**

| Imprint | Titles | Inventory value | Overstock rows | Overstock $ |
|---|---|---|---|---|
| Hearthstone Kitchen | 16 | $390,167.26 | 5 | $133,678.31 |
| Northpoint Nonfiction | 20 | $242,727.72 | 10 | $87,997.92 |
| Lakeshore Fiction | 24 | $230,096.23 | 4 | $19,537.75 |
| Little Lantern Books | 20 | $112,994.42 | 6 | $20,960.74 |
| **Total** | **80** | **$975,985.63** | **25** | **$262,174.72** |

**Every Overstock row is an Offset title.** Print on Demand rows are all Low (21) or Out of Stock (1).

## The story in the data

- **$262K is tied up in overstock**, about 27% of all inventory dollars, on 25 title/warehouse rows.
- **Cookbooks hold half of it.** Hearthstone Kitchen has only 5 overstock rows, but $134K of the $262K (51%).
- **Most overstock is slow sellers.** 21 of the 25 overstock rows sold fewer than 1,200 copies in the last year, worth **$134,707.43**. These are the **print-on-demand candidates**: stop printing big runs and print them when ordered. The biggest is *The Patient Machine* (US, $24,001.38, 39.7 months of supply).
- **4 overstocked titles are steady sellers** (1,200+ a year): *Cast Iron Breads*, *Slow Sunday Dinners*, *One Pot Baking* and *The Small Year*, all US, worth $127,467.29. They'll sell through; the fix is a smaller next reprint, not print on demand.
- **The UK is short on titles the US has too many of.** 9 titles are Overstock in the US but Low or Out of Stock in the UK. That's a **transfer** list: move copies across instead of printing more. Biggest: *Cast Iron Breads* (US 4,790 on hand, UK 0).

| ISBN | Title | US on hand | UK on hand | UK status |
|---|---|---|---|---|
| 978-1-95510-074-8 | Cast Iron Breads | 4,790 | 0 | Out of Stock |
| 978-1-95510-071-7 | Slow Sunday Dinners | 3,296 | 37 | Low |
| 978-1-95510-026-7 | Hello, Tractor | 1,905 | 0 | Out of Stock |
| 978-1-95510-049-6 | The Small Workday | 1,872 | 10 | Low |
| 978-1-95510-068-7 | One Pot Suppers | 1,524 | 16 | Low |
| 978-1-95510-044-1 | Bouncy Firefly | 1,068 | 0 | Out of Stock |
| 978-1-95510-037-3 | Little Firefly | 507 | 0 | Out of Stock |
| 978-1-95510-053-3 | The Hidden Map | 338 | 3 | Low |
| 978-1-95510-036-6 | Happy Rain Cloud | 126 | 0 | Out of Stock |
