# Shared Data: Fox River Supply Co. Accounts Receivable

Synthetic data. Fox River Supply Co., its customers, invoice numbers and dollars are all invented. Excel, SQL and Tableau all use this same data, so the answers must match in all three.

**Report Date: 9/30/2026 (September month-end).** Every aging number is figured as of this date, not today's date. Days_Past_Due and Aging_Bucket are already filled in, so you don't need any formulas to get them.

## Files

| File | Use it for |
|---|---|
| `AR_Invoices.xlsx` | Excel. Real Excel dates, dollar formatting, and an About tab. |
| `AR_Invoices.csv` | SQL (DB Browser for SQLite) and Tableau. Same 102 rows. Dates are written YYYY-MM-DD. |

## Columns

| Column | What it means |
|---|---|
| Invoice_Number | The invoice we sent (INV-24101 to INV-24202) |
| Customer | Who owes us (12 customers) |
| Invoice_Date | Date the invoice was sent |
| Terms | Days the customer has to pay: Net 30, Net 45 or Net 60 |
| Due_Date | Invoice_Date plus the terms |
| Invoice_Amount | The full invoice |
| Amount_Paid | Payments already applied to the invoice |
| Balance | What is still owed (Invoice_Amount minus Amount_Paid) |
| Days_Past_Due | Report Date minus Due_Date. 0 means not due yet. |
| Aging_Bucket | Current, 1-30 Days, 31-60 Days, 61-90 Days, 90+ Days |
| Bucket_Sort | 1 to 5, so the buckets sort in order (Current first) instead of alphabetically |
| Status | Open, Partial Payment, or Disputed |
| Dispute_Reason | Only for Disputed invoices: Pricing error, Short shipment, Missing PO, Duplicate invoice |

Every invoice in the file is still open (Balance is more than $0).

## Answer key: check your numbers here

**Totals**

| Measure | Answer |
|---|---|
| Open invoices | 102 |
| Customers | 12 |
| Total open AR (sum of Balance) | **$490,372.81** |
| Past due (everything except Current) | **$234,086.90** |
| % past due | **47.7%** |
| Disputed | $28,534.49 on 8 invoices |
| Partial payments | $34,269.67 still owed on 12 invoices |

**By aging bucket**

| Aging_Bucket | Invoices | Balance | % of total |
|---|---|---|---|
| Current | 51 | $256,285.91 | 52.3% |
| 1-30 Days | 30 | $126,613.12 | 25.8% |
| 31-60 Days | 10 | $46,267.71 | 9.4% |
| 61-90 Days | 7 | $41,058.15 | 8.4% |
| 90+ Days | 4 | $20,147.92 | 4.1% |
| **Total** | **102** | **$490,372.81** | 100% |

**Top 5 customers by total balance**

| Customer | Total balance | Past due |
|---|---|---|
| Riverbend Medical Supply | $120,138.23 | $9,504.72 |
| Ironwood Construction | $106,511.25 | $70,430.13 |
| Prairie Path Foods | $61,020.06 | $24,250.51 |
| Blue Heron Logistics | $49,006.71 | $37,397.50 |
| Northgate Auto Parts | $38,506.21 | $25,923.77 |

**Disputes by reason**

| Dispute_Reason | Invoices | Balance |
|---|---|---|
| Pricing error | 4 | $13,174.01 |
| Short shipment | 2 | $10,610.33 |
| Missing PO | 1 | $2,992.59 |
| Duplicate invoice | 1 | $1,757.56 |

**The catch:** INV-24202 is a duplicate of INV-24111. Same customer (Harvest Table Catering), same invoice date (6/22/2026), same amount ($1,757.56). The customer doesn't really owe it twice, so that $1,757.56 is overstating AR until a credit memo cancels it.
