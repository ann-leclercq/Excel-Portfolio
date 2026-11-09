# Shared Data: Lakeshore Chocolate Co. Retail Deduction Review

Synthetic data. Lakeshore Chocolate Co., its retail customers, account managers, promotions and dollars are all invented. SQL and Excel use this same data, so the answers must match in both.

**Report Date: 10/31/2026 (October month-end).** Review_Result, Invalid_Amount and Dispute_Deadline are already filled in, so no formulas are needed to get them.

## The question

**How much did retailers deduct July through October, how much of it is invalid, and which disputes do we need to file first before the window closes?**

## Background

When a retailer pays an invoice, it often takes money off the check. That's a deduction. Promotion deductions should match what we agreed to in the trade spend plan. Shortage claims should match the proof of delivery (POD). Damage claims may already be covered by the unsaleables allowance we pay each retailer. Each deduction was checked against those records, and the result is in Review_Result. **No disputes have been filed yet.** Every retailer allows a set number of days after the check date to dispute a deduction. After that, the money is gone.

## Files

| File | Use it for |
|---|---|
| `Deductions.csv` | SQL. 176 deductions. Dates are written YYYY-MM-DD. |
| `Retailers.csv` | SQL. 5 retail customers. |
| `Deductions_Joined.csv` | Backup only. The same result as SQL query 9, in case the export gives you trouble. |

## Why two tables

The deduction file only has the Retailer_ID. The retailer's name, channel, account manager and dispute window live in the customer list. To see deductions by retailer or account manager, the two tables have to be **joined on Retailer_ID**.

## Deductions.csv columns

| Column | What it means |
|---|---|
| Deduction_ID | DED-5001 to DED-5176 |
| Retailer_ID | Links to Retailers (R01 to R05) |
| Check_Date | Date of the retailer's payment that took the deduction |
| Invoice_Number | Our invoice the deduction was taken against |
| Deduction_Type | Promotion, Ad / Display Fee, Shortage, Damaged / Unsaleable, Pricing, Compliance Fine |
| Promo_ID | The promotion in the trade spend plan. **N/A** for deductions that aren't promotions. |
| Plan_Amount | What the trade spend plan approved for that promotion. Blank for non-promotion deductions. |
| Amount | What the retailer took off the check |
| Backup_Received | Yes if the retailer sent paperwork supporting the deduction |
| Review_Result | **Valid**, **Invalid** or **Need Backup** |
| Invalid_Reason | Why it's invalid. **None** for Valid and Need Backup rows. |
| Invalid_Amount | The dollars we can recover. For "Over approved amount" this is only the overage, not the whole deduction. 0 for Valid and Need Backup. |
| Dispute_Deadline | Last day to dispute: Check_Date plus the retailer's dispute window |

## Retailers.csv columns

| Column | What it means |
|---|---|
| Retailer_ID | R01 to R05 |
| Retailer_Name | The customer |
| Channel | Supercenter, Grocery or Wholesale Distributor |
| Region | Where the customer operates |
| Dispute_Window_Days | Days after the check date we have to dispute (60 or 90) |
| Account_Manager | Who owns the account at Lakeshore |

## Answer key: check your numbers here

**Totals**

| Measure | Answer |
|---|---|
| Deductions | 176 |
| Total deducted | $523,894.04 |
| Valid | 116 deductions, $374,624.28 |
| Invalid | 43 deductions, $134,251.31 deducted, **$88,776.31 recoverable** (Invalid_Amount) |
| Need Backup | 17 deductions, $15,018.45 |

**Invalid dollars by dispute deadline (recoverable $)**

| Deadline | Deductions | Invalid_Amount |
|---|---|---|
| Already passed (before 10/31/2026) | 11 | $27,350.10 |
| November 2026: file now | 8 | $18,961.29 |
| December 2026 or later | 24 | $42,464.92 |
| **Total** | **43** | **$88,776.31** |

**By retailer (needs the join)**

| Retailer | Window | Deductions | Amount | Invalid_Amount | Need Backup |
|---|---|---|---|---|---|
| Prairie Fresh Markets | 60 | 54 | $148,471.41 | $34,312.92 | 2 |
| Lone Star Grocers | 90 | 41 | $146,962.43 | $18,223.05 | 2 |
| Heartland Foods Distribution | 90 | 44 | $116,140.03 | $35,637.18 | 2 |
| Great Lakes Grocers Co-op | 90 | 23 | $52,091.85 | $0.00 | 11 |
| Riverbend Markets | 60 | 14 | $60,228.32 | $603.16 | 0 |
| **Total** | | **176** | **$523,894.04** | **$88,776.31** | **17** |

**Invalid dollars already past the deadline, by retailer**

| Retailer | Invalid_Amount lost |
|---|---|
| Prairie Fresh Markets | $23,769.22 |
| Heartland Foods Distribution | $3,067.45 |
| Lone Star Grocers | $513.43 |
| **Total** | **$27,350.10** |

**By invalid reason**

| Invalid_Reason | Deductions | Invalid_Amount |
|---|---|---|
| Duplicate claim | 6 | $31,388.04 |
| Outside promo dates | 7 | $22,506.68 |
| POD shows full delivery | 14 | $18,896.74 |
| Over approved amount | 8 | $10,544.58 |
| Price was correct | 5 | $3,525.99 |
| Covered by unsaleables allowance | 3 | $1,914.28 |
| **Total** | **43** | **$88,776.31** |

**By month (Check_Date)**

| Month | Deductions | Amount | Invalid_Amount |
|---|---|---|---|
| July | 36 | $89,322.87 | $14,580.86 |
| August | 40 | $132,884.11 | $24,200.65 |
| September | 46 | $129,699.51 | $18,251.09 |
| October | 54 | $171,987.55 | $31,743.71 |
