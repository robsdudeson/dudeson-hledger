# hledger Implementation Plan - Single Account Setup

## Implementation Status

### Phase Progress
- [ ] Phase 1: Environment Setup (Day 1)
- [ ] Phase 2: Basic hledger Setup (Day 1-2)
- [ ] Phase 3: SimpleFIN Integration Setup (Day 2-3)
- [ ] Phase 4: Automation Script Development (Day 3-4)
- [ ] Phase 5: Testing and Refinement (Day 4-5)
- [ ] Phase 6: Workflow Integration (Day 5-7)
- [ ] Phase 7: Manual Account Setup (Week 2)

### Current Phase: Phase 1
**Last Updated:** 2025-10-16

---

## Phase 1: Environment Setup (Day 1)

### Task Checklist
- [x] 1.1 Install Dependencies
- [x] 1.2 Create Project Structure

### 1.1 Install Dependencies
```bash
# Install hledger and related tools using yay
yay -S hledger-bin hledger-web-bin hledger-ui-bin

# Download SimpleFIN scripts directly from GitHub (no repo clone needed)
mkdir -p bin
cd bin
curl -O https://raw.githubusercontent.com/simonmichael/hledger/master/bin/simplefinsetup
curl -O https://raw.githubusercontent.com/simonmichael/hledger/master/bin/simplefinjson
curl -O https://raw.githubusercontent.com/simonmichael/hledger/master/bin/simplefincsv
chmod +x simplefin*
cd ..

# Optional: Install Python if needed for custom scripts
# mise use -g python@latest
# pip install python-dotenv requests
```

### 1.2 Create Project Structure
```bash
# From your project root (e.g., ~/code/dudeson-hledger)
mkdir -p journal bin scripts data backups logs
```

## Phase 2: Basic hledger Setup (Day 1-2)

### Task Checklist
- [x] 2.1 Create Initial Journal Structure
- [x] 2.2 Choose Test Account
- [ ] 2.3 Manual Entry Practice

### 2.1 Create Initial Journal Structure
- [x] Create `journal/main.journal` as the primary entry point
- [x] Create `journal/accounts.journal` for account definitions
- [x] Create `journal/2025.journal` for current year transactions
- [ ] Set up basic account structure

### 2.2 Choose Test Account
**Recommended: Start with Chase Checking**
- Most transactions for testing
- Easier to verify accuracy
- Good for learning hledger basics

### 2.3 Manual Entry Practice
- [ ] Add 5-10 recent transactions manually
- [ ] Learn hledger syntax and commands
- [ ] Verify balances match bank statements

## Phase 3: SimpleFIN Integration Setup (Day 2-3)

### Task Checklist
- [x] 3.1 SimpleFIN Bridge Account
- [x] 3.2 Set Up SimpleFIN Access
- [x] 3.3 Test SimpleFIN Connection

### 3.1 SimpleFIN Bridge Account
- [x] Sign up at https://beta-bridge.simplefin.org/
- [x] Subscribe to SimpleFIN Bridge ($1.50/month or $15/year)
- [x] Connect your first bank account (Chase Checking recommended)
- [x] Get your Setup Token from the dashboard

### 3.2 Set Up SimpleFIN Access
```bash
# Run SimpleFIN setup script (one-time setup, from project root)
bin/simplefinsetup

# This will:
# 1. Prompt you to paste your Setup Token
# 2. Convert it to an Access URL
# 3. Store credentials securely in ~/.simplefin/
```

### 3.3 Test SimpleFIN Connection
```bash
# Download account data as JSON (from project root)
bin/simplefinjson > data/simplefin.json

# Verify the JSON contains your account data
cat data/simplefin.json | head -20
```
- [x] Verify account data is downloaded successfully
- [x] Check that transactions are present in JSON
- [x] Confirm account balances match your bank

## Phase 4: Automation Script Development (Day 3-4)

### Task Checklist
- [ ] 4.1 Create Transaction Sync Script
- [ ] 4.2 Automatic Transaction Categorization
- [ ] 4.3 Duplicate Detection

### 4.1 Create Transaction Sync Script
**File: `scripts/sync_simplefin.sh`**
- [ ] Create bash script to download SimpleFIN JSON data
- [ ] Convert JSON to CSV for specific accounts using simplefincsv
- [ ] Set up CSV rules files for each account
- [ ] Import CSV data into hledger journal
- [ ] Handle duplicate detection automatically via hledger import

### 4.2 Automatic Transaction Categorization
**See: `auto_categorization_plan.md` for detailed implementation**

#### Rule-Based Categorization (Start Here)
- [ ] Create `data/merchant_rules.json` with merchant mappings
- [ ] Implement exact match, pattern, and regex rules
- [ ] Start with 50+ common merchants from your transaction history
- [ ] Default unknown transactions to "Expenses:Other" for review

#### Confidence Scoring System
- High confidence (>90%): Auto-apply category
- Medium confidence (70-90%): Suggest but flag for review  
- Low confidence (<70%): Leave uncategorized

#### Learning System (Week 2+)
- [ ] Track user corrections to improve rules
- [ ] Build ML classifier from categorized transactions
- [ ] Auto-suggest new merchant rules
- [ ] Target 90%+ auto-categorization rate

### 4.3 Duplicate Detection
- [ ] Use hledger's built-in import command for duplicate detection
- [ ] Transaction IDs automatically tracked via .latest files
- [ ] Test importing same data twice to verify duplicates are skipped

## Phase 5: Testing and Refinement (Day 4-5)

### Task Checklist
- [ ] 5.1 Sandbox Testing
- [ ] 5.2 Real Account Connection
- [ ] 5.3 Schedule Automation

### 5.1 Initial Testing
- [ ] Download SimpleFIN data for Chase Checking
- [ ] Convert to CSV and import into test journal
- [ ] Verify hledger journal format
- [ ] Test `hledger balance` and `hledger register` commands
- [ ] Check for any formatting issues

### 5.2 Real Account Connection
- [ ] Import last 30-90 days of transactions
- [ ] Manually verify accuracy against bank statement
- [ ] Test categorization rules on real transactions
- [ ] Ensure account balances match bank exactly

### 5.3 Schedule Automation
```bash
# Add to crontab for daily sync at 6 AM
crontab -e
# Replace /path/to/project with your actual project path
# Add line: 0 6 * * * cd /path/to/project && PATH=$PATH:/path/to/project/bin bash scripts/sync_simplefin.sh >> logs/sync.log 2>&1
```

## Phase 6: Workflow Integration (Day 5-7)

### Task Checklist
- [ ] 6.1 Daily Review Process
- [ ] 6.2 Create Helper Scripts
- [ ] 6.3 Backup Strategy

### 6.1 Daily Review Process
- [ ] Check sync log for any errors
- [ ] Review uncategorized transactions
- [ ] Manually categorize unknown merchants
- [ ] Verify account balance matches bank

### 6.2 Create Helper Scripts
- [ ] Create `scripts/balance.sh` - Quick balance check
- [ ] Create `scripts/recent.sh` - Show recent transactions
- [ ] Create `scripts/categorize.sh` - Interactive categorization tool

### 6.3 Backup Strategy
- [ ] Set up daily backup of journal files
- [ ] Initialize Git repository for version control
- [ ] Create export to CSV for external backup

## Phase 7: Manual Account Setup (Week 2)

Accounts that require manual data entry or CSV import from external sources (not available via SimpleFIN).

### Task Checklist
- [ ] 7.1 Income Tracking - Gusto Payroll (Your Payroll)
- [ ] 7.2 Income Tracking - Stephanie's Payroll
- [ ] 7.3 PayPal Credit Account
- [ ] 7.4 Nelnet Student Loans (Stephanie)
- [ ] 7.5 OPERS Retirement Account (Stephanie)
- [ ] 7.6 Other Manual Accounts (as needed)

---

## 7.1 Income Tracking - Gusto Payroll (Your Payroll)

### Payroll Account Structure

Add to `journal/accounts.journal`:

```
Income:
├── Salary:Gross           (gross pay before deductions)
├── Salary:Bonus           (bonuses, commissions)
└── Salary:Reimbursements  (expense reimbursements)

Expenses:
├── Taxes:Federal          (federal income tax withheld)
├── Taxes:State            (state income tax withheld)
├── Taxes:SocialSecurity   (FICA - Social Security)
├── Taxes:Medicare         (FICA - Medicare)
├── Benefits:Health        (health insurance premiums)
├── Benefits:Dental        (dental insurance premiums)
├── Benefits:Vision        (vision insurance premiums)
├── Benefits:Retirement    (401k contributions)
└── Benefits:HSA           (HSA contributions)

Assets:
└── Checking:Chase:Income  (net pay deposit account)
```

### Gusto PDF Import Strategy

**Challenge**: No admin access to Gusto means no API or CSV export access.

**Solution Options**:

1. **Manual Entry** (Recommended for payroll)
   - Payroll is predictable and low-volume (2-4 times per month)
   - Create a transaction template for consistency
   - Transcribe from PDF payroll statement
   - Most accurate method, takes 5-10 minutes per paycheck

2. **PDF Text Extraction** (Optional automation)
   - Use `pdftotext` or `poppler-utils` to extract text from PDF
   - Parse extracted text with custom script (bash/python)
   - Works if Gusto PDFs have consistent format
   - Requires initial setup and testing

3. **OCR Tools** (If PDFs are image-based)
   - Use `tesseract-ocr` for optical character recognition
   - More error-prone, requires validation
   - Only needed if PDFs are scanned images

**Recommended Approach**: Start with manual entry using a template. The consistent structure of payroll makes manual entry fast and reliable.

### Payroll Transaction Template

Create `templates/payroll.journal` with a template for manual entry:

```journal
; Payroll Template - Copy and edit for each paycheck
; Date format: YYYY-MM-DD
; Pay period: [start date] - [end date]

YYYY-MM-DD * Paycheck | [Company Name] | Pay Period [MM/DD - MM/DD]
    ; Gross income
    Income:Salary:Gross                          $-XXXX.XX

    ; Federal taxes withheld
    Expenses:Taxes:Federal                        $XXX.XX
    Expenses:Taxes:SocialSecurity                 $XXX.XX
    Expenses:Taxes:Medicare                       $XXX.XX

    ; State taxes (if applicable)
    Expenses:Taxes:State                          $XXX.XX

    ; Benefits deductions
    Expenses:Benefits:Health                      $XXX.XX
    Expenses:Benefits:Dental                      $XXX.XX
    Expenses:Benefits:Retirement                  $XXX.XX
    Expenses:Benefits:HSA                         $XXX.XX

    ; Net pay deposited to checking
    Assets:Checking:Chase:Income                  $XXXX.XX
```

**Usage Instructions**:
1. Copy template for each new paycheck
2. Update date and pay period
3. Fill in amounts from Gusto PDF
4. Verify transaction balances: `hledger check`
5. Append to `journal/2025.journal`

**Validation Steps**:
- Total debits must equal total credits (double-entry accounting)
- Net pay amount should match bank deposit
- Gross pay minus all deductions equals net pay
- Year-to-date totals should match Gusto YTD amounts

**Helper Script** (Optional):
Create `scripts/add_paycheck.sh` for interactive payroll entry:
```bash
#!/usr/bin/env bash
# Interactive script to add paycheck from Gusto PDF
# Prompts for each amount and validates totals

echo "Enter paycheck details from Gusto PDF:"
read -p "Date (YYYY-MM-DD): " date
read -p "Gross pay: " gross
read -p "Federal tax: " fed
read -p "Social Security: " ss
read -p "Medicare: " medicare
# ... more prompts

# Calculate net pay
# Validate balances
# Generate transaction
# Append to journal
```

### Ongoing Payroll Workflow

**Per Paycheck** (5-10 minutes):
1. Download/receive Gusto PDF payroll statement
2. Copy payroll template from `templates/payroll.journal`
3. Fill in amounts from PDF
4. Validate transaction with `hledger check`
5. Append to `journal/2025.journal`

**Monthly Review**:
- Verify YTD totals match Gusto
- Check for any missed deductions or benefits changes
- Review tax withholding amounts

**Year-End**:
- Download W-2 from Gusto
- Verify journal totals match W-2 amounts
- Archive payroll transactions for tax filing

---

## 7.2 Income Tracking - Stephanie's Payroll

### Stephanie's Payroll Account Structure

Add to `journal/accounts.journal`:

```
Income:
├── Salary:Stephanie:Gross           (Stephanie's gross pay)
├── Salary:Stephanie:Bonus           (bonuses, if applicable)
└── Salary:Stephanie:Reimbursements  (expense reimbursements)

Expenses:
├── Taxes:Stephanie:Federal          (federal income tax withheld)
├── Taxes:Stephanie:State            (state income tax withheld)
├── Taxes:Stephanie:SocialSecurity   (FICA - Social Security)
├── Taxes:Stephanie:Medicare         (FICA - Medicare)
├── Benefits:Stephanie:Health        (health insurance premiums)
├── Benefits:Stephanie:Dental        (dental insurance premiums)
├── Benefits:Stephanie:Vision        (vision insurance premiums)
└── Benefits:Stephanie:OPERS         (OPERS retirement contributions)

Assets:
├── Checking:Chase:Income            (net pay deposit - if shared account)
└── Checking:Stephanie               (if separate checking account)
```

**Note**: OPERS (Ohio Public Employees Retirement System) contributions are tracked as benefit expenses since they're deducted from paycheck.

### Stephanie's Payroll PDF Import Strategy

**Challenge**: Similar to your Gusto payroll, Stephanie's employer payroll system may not provide API or CSV export.

**Solution**: Manual entry using a template (recommended for payroll)

**Recommended Approach**:
- Manual entry from PDF paycheck/paystub
- 2-4 entries per month (bi-weekly or semi-monthly)
- Takes 5-10 minutes per paycheck with template

### Stephanie's Payroll Transaction Template

Create `templates/payroll-stephanie.journal`:

```journal
; Stephanie's Payroll Template - Copy and edit for each paycheck
; Date format: YYYY-MM-DD
; Pay period: [start date] - [end date]

YYYY-MM-DD * Paycheck | [Employer Name] | Stephanie | Pay Period [MM/DD - MM/DD]
    ; Gross income
    Income:Salary:Stephanie:Gross                    $-XXXX.XX

    ; Federal taxes withheld
    Expenses:Taxes:Stephanie:Federal                  $XXX.XX
    Expenses:Taxes:Stephanie:SocialSecurity           $XXX.XX
    Expenses:Taxes:Stephanie:Medicare                 $XXX.XX

    ; State taxes (Ohio)
    Expenses:Taxes:Stephanie:State                    $XXX.XX

    ; Benefits deductions
    Expenses:Benefits:Stephanie:Health                $XXX.XX
    Expenses:Benefits:Stephanie:Dental                $XXX.XX
    Expenses:Benefits:Stephanie:OPERS                 $XXX.XX

    ; Net pay deposited to checking
    Assets:Checking:Chase:Income                      $XXXX.XX
    ; OR if Stephanie has separate checking:
    ; Assets:Checking:Stephanie                       $XXXX.XX
```

**Usage Instructions**:
1. Copy template for each paycheck
2. Update date and pay period
3. Fill in amounts from paycheck PDF/paystub
4. Verify transaction balances: `hledger check`
5. Append to `journal/2025.journal`

**Validation Steps**:
- Total debits must equal total credits
- Net pay amount should match bank deposit
- Gross pay minus all deductions equals net pay
- OPERS contributions should be tracked separately for retirement tracking

### Ongoing Stephanie's Payroll Workflow

**Per Paycheck** (5-10 minutes):
1. Download/receive paycheck PDF or paystub
2. Copy payroll template from `templates/payroll-stephanie.journal`
3. Fill in amounts from paystub
4. Verify transaction balances: `hledger check`
5. Append to `journal/2025.journal`

**Monthly Review**:
- Verify YTD totals match paystub
- Track OPERS contributions (important for retirement planning)
- Check for any benefits changes
- Review tax withholding amounts

**Year-End**:
- Download W-2 from employer
- Verify journal totals match W-2 amounts (Box 1: wages, Box 2: federal tax, etc.)
- Verify OPERS contributions match employer records
- Archive payroll transactions for tax filing

---

## 7.3 PayPal Credit Account

### PayPal Credit Account Setup

Add PayPal Credit account to `journal/accounts.journal`:

```journal
account Liabilities:CreditCards:PayPal:Credit
  description PayPal Credit Account
  note Manual CSV import from PayPal website
```

**Note**: PayPal Credit is not typically supported by SimpleFIN Bridge, so this requires manual CSV download and import.

### Download CSV from PayPal

**Steps to Export PayPal Credit Transactions**:

1. Log in to PayPal at https://www.paypal.com
2. Navigate to **PayPal Credit** section
3. Click **Activity** or **Statements**
4. Select date range (recommended: last 90 days for initial import)
5. Click **Download** or **Export**
6. Choose **CSV** format (or **Spreadsheet Download**)
7. Save to `data/paypal-credit-YYYY-MM-DD.csv`

**PayPal CSV Format** (typical columns):
- Date
- Description / Merchant
- Type (Purchase, Payment, Fee, etc.)
- Status (Completed, Pending)
- Amount
- Balance (running balance)

**Download Frequency**:
- Initial import: Last 90 days or full year
- Ongoing: Monthly download to capture new transactions

### Create CSV Import Rules

Create `data/paypal-credit.csv.rules` for hledger CSV import:

```rules
# PayPal Credit CSV Import Rules
# Save as: data/paypal-credit.csv.rules

# Skip header row
skip 1

# Field mapping (adjust based on actual PayPal CSV format)
fields date, description, type, status, amount, balance

# Date format (PayPal typically uses MM/DD/YYYY)
date-format %m/%d/%Y

# Account mappings
account1 Liabilities:CreditCards:PayPal:Credit

# Default account2 for unknown transactions
account2 Expenses:Other

# Currency
currency $

# Conditional rules for categorization
if description AMAZON
  account2 Expenses:Shopping:Online

if description WALMART|TARGET
  account2 Expenses:Shopping:Groceries

if description UBER|LYFT
  account2 Expenses:Transportation:Rideshare

if description STARBUCKS|COFFEE
  account2 Expenses:Food:Coffee

if description RESTAURANT|CAFE|DINER
  account2 Expenses:Food:DiningOut

if description PAYMENT.*THANK YOU
  account2 Assets:Checking:Chase:Income
  comment Payment from checking account

if type FEE
  account2 Expenses:Finance:Fees

if type INTEREST
  account2 Expenses:Finance:Interest

# Handle payments (credits to the account)
if amount ^-
  account2 Assets:Checking:Chase:Income
  comment PayPal Credit payment
```

**Customization Tips**:
- Adjust `fields` line to match actual PayPal CSV columns
- Update `date-format` if PayPal uses different format
- Add more categorization rules based on your common merchants
- Test with small CSV sample first

### Import and Categorize Transactions

**Import Process**:

```bash
# Step 1: Download CSV from PayPal website
# Save to: data/paypal-credit-2025-10-17.csv

# Step 2: Preview import (dry run, no changes)
hledger import data/paypal-credit-2025-10-17.csv \
  --rules-file data/paypal-credit.csv.rules \
  --dry-run

# Step 3: Review preview output
# - Check dates are correct
# - Verify amounts and signs (+ for purchases, - for payments)
# - Confirm categorization makes sense

# Step 4: Actual import (appends to journal/2025.journal)
hledger import data/paypal-credit-2025-10-17.csv \
  --rules-file data/paypal-credit.csv.rules

# Step 5: Verify import
hledger register paypal
hledger balance paypal

# Step 6: Check for uncategorized transactions
hledger register Expenses:Other
```

**Post-Import Tasks**:
- [ ] Review transactions categorized as `Expenses:Other`
- [ ] Manually recategorize any misclassified transactions
- [ ] Update CSV rules file with new merchant patterns
- [ ] Verify PayPal Credit balance matches website

**Handling Duplicate Imports**:
- hledger's `import` command tracks imported transactions in `.latest` files
- Safe to run import multiple times - duplicates will be skipped
- `.latest` files stored in same directory as CSV

**Monthly Workflow**:
1. Download monthly PayPal Credit statement as CSV
2. Run import command with CSV rules file
3. Review new transactions
4. Update categorization rules as needed

### PayPal Credit Balance Reconciliation

**Verify Balance Matches PayPal**:

```bash
# Check hledger balance
hledger balance paypal --end 2025-10-17

# Should match PayPal Credit balance on their website as of 10/17
```

**Common Balance Issues**:
- **Pending transactions**: PayPal may show pending, hledger only shows posted
- **Statement date vs current balance**: Use `--end` flag to match specific date
- **Sign confusion**: In hledger, credit card balances are positive (liability)

**Opening Balance Entry** (if needed):

```journal
; Add to journal/2025.journal if starting mid-year
2025-01-01 * Opening Balance | PayPal Credit
    Liabilities:CreditCards:PayPal:Credit         $XXX.XX
    Equity:Opening
```

### Troubleshooting PayPal CSV Import

**CSV Format Issues**:
- PayPal may change CSV format periodically
- Use `head -5 data/paypal-credit-*.csv` to inspect format
- Adjust `fields` line in rules file accordingly

**Date Parsing Errors**:
- Check `date-format` matches PayPal's format
- PayPal typically uses `MM/DD/YYYY` or `DD/MM/YYYY`
- Use `hledger import --dry-run` to test

**Amount Sign Issues**:
- Purchases should be positive (increase liability)
- Payments should be negative (decrease liability)
- May need to negate amounts in rules file with `amount -%amount`

**Missing Transactions**:
- Check date range of downloaded CSV
- Ensure all statement periods are downloaded
- PayPal may limit export to 90 days at a time

---

## 7.3 Nelnet Student Loans (Stephanie)

### Nelnet Account Setup

Add Nelnet student loan account to `journal/accounts.journal`:

```journal
account Liabilities:Loans:Nelnet:Stephanie
  description Stephanie's Nelnet Student Loans
  note Manual CSV import or manual entry from Nelnet website
```

**Note**: Nelnet student loans are typically not supported by SimpleFIN Bridge, so this requires manual CSV download or manual entry.

### Download Transaction History from Nelnet

**Steps to Export Nelnet Transaction Data**:

1. Log in to Nelnet at https://www.nelnet.com
2. Navigate to **Account Overview** or **Transaction History**
3. Select the relevant loan account(s)
4. Choose date range (recommended: last 12 months for initial import)
5. Click **Download** or **Export** (if available)
6. Choose **CSV** or **Excel** format
7. Save to `data/nelnet-stephanie-YYYY-MM-DD.csv`

**Nelnet CSV Format** (typical columns):
- Date / Payment Date
- Description / Transaction Type
- Principal Payment
- Interest Payment
- Fees (if any)
- Total Payment Amount
- Remaining Balance

**Download Frequency**:
- Initial import: Last 12 months or account history
- Ongoing: Monthly (after each payment)

**Alternative - Manual Entry**:
If Nelnet doesn't provide CSV export, manually record loan payments from monthly statements.

### Create CSV Import Rules

Create `data/nelnet-stephanie.csv.rules` for hledger CSV import:

```rules
# Nelnet Student Loan CSV Import Rules
# Save as: data/nelnet-stephanie.csv.rules

# Skip header row
skip 1

# Field mapping (adjust based on actual Nelnet CSV format)
# Common formats: date, description, principal, interest, fees, total, balance
fields date, description, principal, interest, fees, total, balance

# Date format (Nelnet typically uses MM/DD/YYYY)
date-format %m/%d/%Y

# Currency
currency $

# Account mappings - Student loan payments
account1 Liabilities:Loans:Nelnet:Stephanie

# Split payment between principal and interest
if principal .
  account2 Liabilities:Loans:Nelnet:Stephanie
  amount2 -%principal
  comment Principal payment

if interest .
  account3 Expenses:Finance:Interest:StudentLoans
  amount3 %interest
  comment Interest payment

if fees .
  account4 Expenses:Finance:Fees:StudentLoans
  amount4 %fees
  comment Loan fees

# Source of payment (typically from checking account)
# Note: This may need adjustment based on actual CSV format
if total .
  account5 Assets:Checking:Chase:Income
  amount5 -%total
  comment Student loan payment from checking
```

**Important Notes**:
- Student loan payments split between principal and interest
- Principal reduces the liability (Liabilities:Loans:Nelnet:Stephanie)
- Interest is an expense (Expenses:Finance:Interest:StudentLoans)
- Payment source is typically checking account

### Manual Entry Alternative

If Nelnet doesn't provide CSV export, use manual entry template:

Create `templates/student-loan-payment.journal`:

```journal
; Student Loan Payment Template - Nelnet (Stephanie)
; Copy and edit for each payment

YYYY-MM-DD * Student Loan Payment | Nelnet | [Loan ID or Account Number]
    ; Principal portion (reduces loan balance)
    Liabilities:Loans:Nelnet:Stephanie              $-XXX.XX

    ; Interest portion (expense)
    Expenses:Finance:Interest:StudentLoans           $XX.XX

    ; Fees (if applicable)
    Expenses:Finance:Fees:StudentLoans               $X.XX

    ; Payment from checking account
    Assets:Checking:Chase:Income                    $-XXX.XX
```

**Usage Instructions**:
1. Copy template for each loan payment
2. Update date (payment date)
3. Fill in principal, interest, and fee amounts from Nelnet statement
4. Verify total payment amount matches checking account debit
5. Verify transaction balances: `hledger check`
6. Append to `journal/2025.journal`

**Validation**:
- Total debits = Total credits
- Principal + Interest + Fees = Total payment from checking
- Loan balance in hledger should decrease by principal amount

### Import and Track Student Loans

**If using CSV import**:

```bash
# Step 1: Download CSV from Nelnet website
# Save to: data/nelnet-stephanie-2025-10-17.csv

# Step 2: Preview import (dry run)
hledger import data/nelnet-stephanie-2025-10-17.csv \
  --rules-file data/nelnet-stephanie.csv.rules \
  --dry-run

# Step 3: Review output and verify amounts

# Step 4: Actual import
hledger import data/nelnet-stephanie-2025-10-17.csv \
  --rules-file data/nelnet-stephanie.csv.rules

# Step 5: Verify import
hledger register nelnet
hledger balance liabilities:loans
```

**Post-Import Tasks**:
- [ ] Verify loan balance matches Nelnet website
- [ ] Check principal vs interest breakdown
- [ ] Review any fees charged
- [ ] Confirm payment source account is correct

### Student Loan Balance Reconciliation

**Verify Balance Matches Nelnet**:

```bash
# Check current loan balance
hledger balance liabilities:loans:nelnet

# Check balance as of specific date
hledger balance liabilities:loans:nelnet --end 2025-10-17

# View payment history
hledger register liabilities:loans:nelnet
```

**Track Interest Paid**:

```bash
# Total interest paid year-to-date
hledger register expenses:finance:interest:studentloans --begin 2025-01-01

# Total interest for tax reporting
hledger balance expenses:finance:interest:studentloans --begin 2025-01-01 --end 2025-12-31
```

**Opening Balance Entry** (if needed):

```journal
; Add to journal/2025.journal - Initial loan balance
2025-01-01 * Opening Balance | Nelnet Student Loan (Stephanie)
    Liabilities:Loans:Nelnet:Stephanie               $XX,XXX.XX
    Equity:Opening
```

### Ongoing Student Loan Workflow

**Monthly** (5-10 minutes per payment):
1. Download Nelnet statement or CSV
2. Record payment using CSV import or manual template
3. Verify principal/interest split matches statement
4. Confirm loan balance decreased correctly

**Quarterly Review**:
- Verify loan balance matches Nelnet website
- Check year-to-date interest paid (for tax purposes)
- Review payment history for accuracy

**Annual (Tax Time)**:
- Generate interest paid report: `hledger register expenses:finance:interest:studentloans`
- Compare to IRS Form 1098-E from Nelnet
- Verify total matches for tax deduction purposes

### Troubleshooting Nelnet Import

**CSV Format Issues**:
- Nelnet CSV format may vary by loan type or servicer
- Use `head -5 data/nelnet-*.csv` to inspect format
- Adjust `fields` line in rules file accordingly

**Principal/Interest Split**:
- Some loan servicers combine principal and interest
- May need to manually split based on loan amortization schedule
- Check monthly statement for breakdown

**Multiple Loans**:
- If tracking multiple Nelnet loans separately, create sub-accounts:
  - `Liabilities:Loans:Nelnet:Stephanie:Loan1`
  - `Liabilities:Loans:Nelnet:Stephanie:Loan2`
- Create separate CSV rules files for each loan

**Forbearance/Deferment**:
- During forbearance, interest may still accrue
- Record accrued interest as it's capitalized:
  ```journal
  YYYY-MM-DD * Interest Capitalization | Nelnet
      Liabilities:Loans:Nelnet:Stephanie           $XXX.XX
      Expenses:Finance:Interest:StudentLoans      $-XXX.XX
  ```

---

## 7.5 OPERS Retirement Account (Stephanie)

### OPERS Account Setup

Add OPERS retirement account to `journal/accounts.journal`:

```journal
account Assets:Retirement:OPERS:Stephanie
  description Stephanie's OPERS Retirement Account
  note Ohio Public Employees Retirement System
  note Manual tracking from quarterly statements or website
```

**Note**: OPERS is a defined benefit pension plan, so tracking works differently than 401(k) accounts.

### Understanding OPERS Tracking

**OPERS Contributions**:
- Employee contributions (deducted from paycheck) - already tracked in payroll
- Employer contributions (not deducted from pay, but important for retirement planning)
- Both contribute to pension calculation but aren't "owned" like a 401(k) balance

**Two Tracking Approaches**:

1. **Simple Approach**: Track only employee contributions via payroll
   - Employee contributions already recorded in `Expenses:Benefits:Stephanie:OPERS`
   - Don't track account balance (since it's a pension, not investment account)
   - Use reports to see total contributions year-to-date

2. **Detailed Approach**: Track total contributions as retirement asset
   - Record both employee and employer contributions
   - Track as `Assets:Retirement:OPERS:Stephanie`
   - Provides visibility into total retirement funding

**Recommended**: Use detailed approach to track total retirement savings.

### OPERS Contribution Tracking

**Option 1: Track with Payroll Entry**

Modify Stephanie's payroll template to track employer match:

```journal
YYYY-MM-DD * Paycheck | [Employer] | Stephanie | Pay Period [MM/DD - MM/DD]
    ; Gross income
    Income:Salary:Stephanie:Gross                    $-XXXX.XX

    ; ... other deductions ...

    ; Employee OPERS contribution (deducted from paycheck)
    Expenses:Benefits:Stephanie:OPERS                 $XXX.XX
    Assets:Retirement:OPERS:Stephanie                $-XXX.XX

    ; Employer OPERS contribution (not deducted, but tracks total)
    Income:Salary:Stephanie:EmployerMatch           $-XXX.XX
    Assets:Retirement:OPERS:Stephanie                 $XXX.XX

    ; Net pay
    Assets:Checking:Chase:Income                      $XXXX.XX
```

**Option 2: Separate Quarterly Entry**

Record OPERS contributions quarterly from statement:

```journal
; Record quarterly OPERS contributions from statement
2025-03-31 * OPERS Quarterly Contributions | Q1 2025
    ; Employee contributions (sum from paychecks)
    Assets:Retirement:OPERS:Stephanie                 $XXX.XX
    Expenses:Benefits:Stephanie:OPERS               $-XXX.XX

    ; Employer contributions (from OPERS statement)
    Assets:Retirement:OPERS:Stephanie                 $XXX.XX
    Income:Salary:Stephanie:EmployerMatch           $-XXX.XX
```

### Download OPERS Account Information

**Steps to Access OPERS Account Data**:

1. Log in to OPERS member portal at https://www.opers.org
2. Navigate to **Account Summary** or **Member Statement**
3. Review quarterly or annual statement
4. Note:
   - Employee contributions (year-to-date)
   - Employer contributions (year-to-date)
   - Account balance (total contributions + investment earnings)
   - Estimated monthly benefit (at retirement)

**OPERS Statement Information**:
- **Contributions**: Employee + Employer contributions
- **Account Balance**: Total value (for defined contribution plans)
- **Service Credit**: Years of service (for pension calculation)
- **Estimated Benefit**: Monthly pension estimate at retirement age

**Download Frequency**:
- Initial: Get current year-to-date totals
- Ongoing: Quarterly when statements are issued
- Annual: Year-end statement for tax purposes

### OPERS Balance Reconciliation

**Option 1: Track Contributions Only** (simpler)

```bash
# Total OPERS contributions year-to-date
hledger register expenses:benefits:stephanie:opers --begin 2025-01-01

# View as total
hledger balance expenses:benefits:stephanie:opers --begin 2025-01-01
```

**Option 2: Track Full Retirement Balance** (comprehensive)

```bash
# Check OPERS retirement account balance
hledger balance assets:retirement:opers:stephanie

# View contribution history
hledger register assets:retirement:opers:stephanie

# Compare employee vs employer contributions
hledger register income:salary:stephanie:employermatch
```

**Reconciliation**:
- Compare hledger totals to OPERS quarterly statement
- Employee contributions should match year-to-date on statement
- Employer contributions typically 14% of gross salary (Ohio public employees)

### OPERS Opening Balance

**If tracking full balance**, add opening balance from OPERS statement:

```journal
; Add to journal/2025.journal - OPERS opening balance
2025-01-01 * Opening Balance | OPERS Retirement Account (Stephanie)
    Assets:Retirement:OPERS:Stephanie                $XX,XXX.XX
    Equity:Opening
```

**Note**: Use the account balance from OPERS statement as of January 1, 2025 (or your tracking start date).

### OPERS Investment Earnings (Optional)

If OPERS provides investment earnings information, you can track this:

```journal
; Quarterly investment earnings from OPERS statement
2025-03-31 * Investment Earnings | OPERS Q1 2025
    Assets:Retirement:OPERS:Stephanie                 $XXX.XX
    Income:Investment:OPERS                         $-XXX.XX
```

### Ongoing OPERS Workflow

**Per Paycheck** (included in payroll entry):
- Record employee OPERS contribution (deducted from gross pay)
- Optionally record employer match (not deducted, but adds to retirement)

**Quarterly** (when OPERS statement received):
1. Download OPERS quarterly statement
2. Verify year-to-date contributions match hledger totals
3. Record investment earnings (if tracking full balance)
4. Update any changes in contribution rates

**Annual Review**:
- Download OPERS annual statement
- Verify total contributions for the year
- Check estimated retirement benefit
- Compare to W-2 Box 14 (retirement plan contributions)
- Update retirement planning spreadsheets

### OPERS Contribution Rates

**Standard OPERS Contribution Rates** (2025 - verify with current rates):
- **Employee**: 10% of gross salary
- **Employer**: 14% of gross salary
- **Total**: 24% of gross salary goes to OPERS

**Example Calculation**:
- Gross pay: $3,000
- Employee contribution: $300 (deducted from paycheck)
- Employer contribution: $420 (paid by employer, not deducted)
- Net impact on paycheck: $300 reduction
- Total OPERS funding: $720

### Troubleshooting OPERS Tracking

**Contribution Rate Changes**:
- OPERS rates may change annually
- Check OPERS website or statement for current rates
- Update payroll template calculations accordingly

**Employee vs Employer Contributions**:
- Employee contributions reduce take-home pay
- Employer contributions don't affect paycheck but add to retirement
- Both show on OPERS statement

**Defined Benefit vs Defined Contribution**:
- Traditional OPERS: Defined benefit (pension based on salary and years)
- OPERS Combined Plan: Part defined benefit, part defined contribution
- Check Stephanie's plan type on OPERS statement

**Service Credit**:
- OPERS pension based on "service credit" (years of service)
- Track years separately if planning for retirement
- Some leaves of absence may affect service credit

---

## 7.6 Other Manual Accounts (as needed)

For additional accounts not supported by SimpleFIN or requiring manual tracking:

**Examples**:
- Cash transactions
- Cryptocurrency wallets
- Gift cards
- Peer-to-peer payment apps (Venmo, Cash App, etc.)
- Investment accounts (if not automated)

**Process**:
1. Add account to `journal/accounts.journal`
2. Determine data source (CSV export, manual entry, PDF)
3. Create CSV rules file if applicable
4. Set up import or manual entry workflow
5. Schedule regular updates (weekly/monthly)

**Refer to**:
- Section 7.1 for manual entry workflows (like Gusto payroll)
- Section 7.2 for CSV import workflows (like PayPal Credit)

## Success Criteria

### Week 1 Goals
- [ ] hledger installed and basic journals created
- [ ] Chase checking account connected to SimpleFIN Bridge
- [ ] Automated daily sync working
- [ ] Last 30 days of transactions imported and categorized
- [ ] Daily balance reconciliation working

### Verification Steps
- [ ] `hledger balance` shows correct checking account balance
- [ ] `hledger register checking` shows recent transactions
- [ ] Sync script runs without errors
- [ ] No duplicate transactions in journal

## Next Steps (After Success)

1. **Add Second Account**: Repeat process for Chase Credit Card
2. **Improve Categorization**: Refine merchant mapping rules
3. **Add Reporting**: Monthly expense reports and budgeting
4. **Scale Up**: Add remaining accounts one by one

## Troubleshooting Common Issues

### SimpleFIN Connection Issues
- Verify Setup Token is correctly saved
- Check SimpleFIN Bridge dashboard for account status
- Ensure bank account is connected and syncing
- Re-run `simplefinsetup` if credentials are lost

### Transaction Format Issues  
- Validate journal syntax with `hledger check`
- Check for special characters in merchant names
- Verify date format (YYYY-MM-DD)

### Duplicate Detection Problems
- Clear transaction ID cache and reimport
- Adjust duplicate detection criteria
- Manual cleanup of duplicates

## Time Estimate
- **Total Setup Time**: 5-7 days (1-2 hours per day)
- **Ongoing Maintenance**: 5-10 minutes daily
- **Monthly Review**: 30 minutes

This plan focuses on getting one account working perfectly before scaling up to your full 21-account setup.

## SimpleFIN vs Plaid Comparison

### Why SimpleFIN?
- **Better hledger integration**: Official scripts (simplefinjson, simplefincsv)
- **Lower cost**: $1.50/month or $15/year vs Plaid's pricing
- **Simpler setup**: No API keys, just a Setup Token
- **Privacy-focused**: Read-only access, data stays local
- **Native CSV workflow**: Works with hledger's CSV import system

### SimpleFIN Limitations
- Requires SimpleFIN Bridge subscription
- May have fewer supported banks than Plaid
- Transaction data typically limited to last 90 days initially

---

## 📝 Documentation Maintenance

**IMPORTANT:** This implementation plan should be the single source of truth for the project setup and workflow.

### When to Update This Plan:
- ✅ Adding or removing accounts
- ✅ Changing workflow or automation scripts
- ✅ Updating SimpleFIN integration methods
- ✅ Modifying file structure or directory organization
- ✅ Changing configuration files or environment setup
- ✅ Adding new tools or dependencies

### Related Documentation:
- **README.md** - Project overview, should mirror key sections from this plan
- **plan/hledger_planning.md** - High-level planning document
- **bin/README.md** - SimpleFIN scripts documentation
- **.env.example** - Environment variable template

**Action Required:** After any significant changes to workflow, file structure, or setup:
1. Update this implementation plan first
2. Update README.md to reflect changes (if user-facing)
3. Update other related documentation as needed
4. Mark the update date in "Implementation Status" section