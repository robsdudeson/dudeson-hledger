# dudeson-hledger

Financial tracking system using hledger with SimpleFIN Bridge integration.

## Quick Start

```bash
# 1. Bootstrap environment (install tools and SimpleFIN scripts)
./scripts/bootstrap

# 2. Set up SimpleFIN credentials
cp .env.example .env
# Edit .env and add your SIMPLEFIN_SETUP_TOKEN
bin/simplefinsetup
# Add the output SIMPLEFIN_ACCESS_URL to .env

# 3. Download account data
bin/simplefinjson --transactions > data/simplefin.json

# 4. View balances
hledger balance
```

## Account Structure (Chart of Accounts)

```
Assets:
├── Checking        (your checking accounts)
├── Savings         (savings accounts)
├── Cash            (physical cash)
└── Investments     (stocks, bonds, retirement)

Liabilities:
├── CreditCards     (credit card debt)
├── Loans           (personal, auto, mortgage)
└── Other           (other debts)

Income:
├── Salary          (primary job income)
├── Freelance       (side income)
├── Interest        (bank interest)
└── Other           (gifts, etc.)

Expenses:
├── Housing         (rent/mortgage, utilities)
├── Food            (groceries, dining out)
├── Transportation  (gas, maintenance, transit)
├── Healthcare      (medical, insurance)
├── Entertainment   (movies, hobbies)
├── Shopping        (clothes, personal items)
└── Other           (misc expenses)
```

## Project Structure

```
dudeson-hledger/
├── journal/
│   ├── main.journal         # Main entry point
│   ├── accounts.journal     # Account declarations with SimpleFIN IDs
│   └── 2025.journal         # Current year transactions
├── bin/
│   ├── simplefinsetup       # SimpleFIN setup (with .env support)
│   ├── simplefinjson        # Download account data (with .env support)
│   ├── simplefincsv         # Convert JSON to CSV
│   └── load-env             # Helper to load .env files
├── scripts/
│   ├── bootstrap            # Environment setup script
│   └── sync_simplefin.sh    # (Future) Automated sync script
├── data/                    # Downloaded SimpleFIN JSON/CSV files
├── plan/                    # Implementation plans and documentation
├── .env                     # SimpleFIN credentials (gitignored)
├── .env.example             # Template for .env
└── hledger.conf             # hledger configuration
```

## Daily Workflow

1. **Automated sync** via SimpleFIN (scheduled daily)
2. **Review and categorize** new transactions
3. **Record cash transactions** manually
4. **Reconcile accounts** weekly
5. **Generate reports** monthly

### Quick Commands

```bash
# Download latest transactions (last 30 days)
bin/simplefinjson --transactions > data/simplefin.json

# Download last 90 days
bin/simplefinjson --start-date 90 > data/simplefin.json

# Download balances only (fast, default)
bin/simplefinjson > data/balances.json

# Convert to CSV for specific account
bin/simplefincsv data/simplefin.json 'chase.*income' > data/chase-income.csv

# Import into hledger (with CSV rules file)
hledger import data/chase-income.csv --rules-file data/chase-income.csv.rules
```

## Essential hledger Commands

```bash
# View account balances
hledger balance

# View specific account activity
hledger register checking

# Profit/loss report
hledger incomestatement

# Web interface
hledger web

# Check for errors
hledger check
```

## SimpleFIN Integration

### Setup

1. **Sign up for SimpleFIN Bridge** - https://beta-bridge.simplefin.org/
   - $1.50/month or $15/year
   - Connect your bank accounts via the dashboard

2. **Configure SimpleFIN**
   ```bash
   # Copy environment template
   cp .env.example .env

   # Add your Setup Token to .env
   # SIMPLEFIN_SETUP_TOKEN="your_token_here"

   # Run setup
   bin/simplefinsetup

   # Add the output URL to .env
   # SIMPLEFIN_ACCESS_URL="https://..."
   ```

3. **Download Account Data**
   ```bash
   # Get balances only (fast)
   bin/simplefinjson > data/balances.json

   # Get transactions (last 30 days)
   bin/simplefinjson --transactions > data/simplefin.json
   ```

### Automated Transaction Sync

- Download account data as JSON with `bin/simplefinjson`
- Convert JSON to CSV for specific accounts with `bin/simplefincsv`
- Import CSV into hledger using CSV rules files
- Automatic categorization based on merchant/description patterns
- Duplicate detection via hledger's built-in import system
- Schedule daily sync via cron

### Account Management

- SimpleFIN IDs stored as metadata in `journal/accounts.journal`
- Supports checking, savings, credit cards, and loans
- Balance verification against SimpleFIN data
- Transaction history available (30-90 days default)

### Benefits Over Plaid

- ✅ Lower cost ($15/year vs Plaid's pricing)
- ✅ Official hledger integration scripts
- ✅ Privacy-focused (read-only access)
- ✅ Simpler setup (no API keys, just Setup Token)
- ✅ Native CSV workflow with hledger

## Automation Scripts

- **SimpleFIN sync script** - Fetch and import transactions automatically
- **CSV import rules** - Account-specific categorization rules
- **Monthly report generator** - Automated financial reports
- **Backup script for journal files** - Data protection via git

## Documentation

- [Implementation Plan](plan/hledger_implementation_plan.md) - Step-by-step setup guide
- [Auto Categorization Plan](plan/auto_categorization_plan.md) - Transaction categorization strategy
- [Bank Setup Plan](plan/bank_setup_plan.md) - Account tracking and status
- [SimpleFIN Scripts README](bin/README.md) - Detailed SimpleFIN usage

## Environment Variables

The project uses a `.env` file to store SimpleFIN credentials:

```bash
# SimpleFIN Configuration
SIMPLEFIN_SETUP_TOKEN=""      # Get from SimpleFIN Bridge dashboard
SIMPLEFIN_ACCESS_URL=""       # Generated by bin/simplefinsetup

# Optional custom settings
# AUTO_CATEGORIZE=true
# CONFIDENCE_THRESHOLD=0.9
```

The SimpleFIN wrapper scripts (`bin/simplefinsetup` and `bin/simplefinjson`) automatically load `.env` before running.

## Contributing

This is a personal finance tracking project, but feel free to use it as a template for your own hledger setup.

## License

Personal project - use as you see fit.
