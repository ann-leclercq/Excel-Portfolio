# Shared Data: Prairie Gate IT Services Ticket Review

Synthetic data. Prairie Gate IT Services, its clients, technicians, tickets and dollars are all invented. Excel and SQL use this same data, so the answers must match in both.

**Report Date: 10/31/2026 (October month-end).** Days_Open and Past_SLA are already filled in as of this date, so you don't need any formulas to get them.

## The question

**What's driving our ticket volume and our missed SLAs, and what should the service team fix first?**

## Files

| File | Use it for |
|---|---|
| `Tickets.csv` | SQL. 329 tickets. Dates are written YYYY-MM-DD. |
| `Clients.csv` | SQL. 10 clients. |
| `Tickets_Joined.csv` | Backup. The same result as the SQL join. |
| `Ticket_Data.xlsx` | Excel. All three tables, real Excel dates, and an About tab. |

## Why two tables

The ticketing system knows the Client_ID on each ticket, but not the client's name, industry or service tier. Those live in the client list. To see tickets by client or tier, the two tables have to be **joined on Client_ID**.

## Tickets.csv columns

| Column | What it means |
|---|---|
| Ticket_ID | TKT-4001 to TKT-4329 |
| Client_ID | Links to Clients (C01 to C10) |
| Date_Opened | Date the client opened the ticket |
| Date_Closed | Blank for Open tickets |
| Status | Open or Closed |
| Priority | P1 - Critical, P2 - High, P3 - Medium, P4 - Low |
| Category | Password / Access, Email, Network, Hardware, Software, Printer, Security |
| Technician | Who worked the ticket (6 technicians) |
| Days_Open | Closed: days from opened to closed. Open: days from opened to the Report Date. |
| SLA_Target_Days | Days allowed by priority: P1 1, P2 2, P3 5, P4 10 |
| Past_SLA | Yes if Days_Open is more than SLA_Target_Days |
| Delay_Reason | Why it went past SLA. **No delay** for every ticket inside its SLA. |
| Tech_Hours | Technician hours spent on the ticket |

## Clients.csv columns

| Column | What it means |
|---|---|
| Client_ID | C01 to C10 |
| Client_Name | The client business |
| Industry | Healthcare, Financial, Legal, and so on |
| Service_Tier | Gold, Silver or Bronze support plan |
| Monthly_Fee | What the client pays each month for managed services |

## Answer key: check your numbers here

**Totals**

| Measure | Answer |
|---|---|
| Tickets | 329 (288 Closed, 41 Open) |
| Technician hours | 553.25 |
| Past SLA (Open + Closed) | 67 tickets (20.4%) |
| Inside SLA | 262 tickets (79.6%) |
| **Open AND past SLA (the work queue)** | **17 tickets** |

**Tickets by month opened**

| Month | Tickets | Past SLA |
|---|---|---|
| August | 88 | 15 |
| September | 101 | 18 |
| October | 140 | 34 |

**By category**

| Category | Tickets | Tech hours | Past SLA |
|---|---|---|---|
| Password / Access | 95 | 41.00 | 4 |
| Network | 67 | 207.50 | 26 |
| Software | 47 | 72.75 | 3 |
| Hardware | 42 | 106.00 | 20 |
| Email | 39 | 53.75 | 8 |
| Printer | 24 | 27.25 | 3 |
| Security | 15 | 45.00 | 3 |
| **Total** | **329** | **553.25** | **67** |

**Past-SLA tickets by delay reason**

| Delay_Reason | All past SLA | Open past SLA |
|---|---|---|
| Waiting on vendor | 20 | 3 |
| Escalated to Tier 2 | 14 | 4 |
| Waiting on client | 13 | 7 |
| Technician workload | 12 | 2 |
| Parts on order | 8 | 1 |
| **Total** | **67** | **17** |

**By service tier (needs the join)**

| Service_Tier | Clients | Tickets | Past SLA |
|---|---|---|---|
| Gold | 3 | 157 | 38 |
| Silver | 4 | 127 | 20 |
| Bronze | 3 | 45 | 9 |
| **Total** | **10** | **329** | **67** |

**Top 3 clients by tickets (needs the join)**

| Client | Tier | Tickets | Past SLA | Tech hours |
|---|---|---|---|---|
| Cedar Ridge Dental | Gold | 66 | 16 | 122.00 |
| Naper Ridge Pediatrics | Gold | 48 | 13 | 82.75 |
| Fox Valley Title Co. | Gold | 43 | 9 | 69.25 |
