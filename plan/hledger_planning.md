# Financial Tracking Plan with hledger

## 1. Account Structure (Chart of Accounts)

```
Assets:
├── Checking        (your checking account)
├── Savings         (savings accounts)
├── Cash           (physical cash)
└── Investments    (stocks, bonds, retirement)

Liabilities:
├── CreditCards    (credit card debt)
├── Loans          (personal, auto, mortgage)
└── Other          (other debts)

Income:
├── Salary         (primary job income)
├── Freelance      (side income)
├── Interest       (bank interest)
└── Other          (gifts, etc.)

Expenses:
├── Housing        (rent/mortgage, utilities)
├── Food           (groceries, dining out)
├── Transportation (gas, maintenance, transit)
├── Healthcare     (medical, insurance)
├── Entertainment  (movies, hobbies)
├── Shopping       (clothes, personal items)
└── Other          (misc expenses)
```

## 2. Key Files Structure

- `journal/main.journal` - Primary journal file
- `journal/accounts.journal` - Account declarations and aliases
- `journal/2024.journal` - Yearly transaction file
- `scripts/` - Helper scripts for common operations

## 3. Daily Workflow

1. **Automated sync** via Plaid (scheduled daily)
2. **Review and categorize** new transactions
3. **Record cash transactions** manually
4. **Reconcile accounts** weekly
5. **Generate reports** monthly

## 4. Essential hledger Commands

- `hledger balance` - View account balances
- `hledger register checking` - View checking account activity  
- `hledger incomestatement` - Profit/loss report
- `hledger web` - Web interface for browsing

## 5. Plaid Integration

### Setup
- Create Plaid developer account and get API keys
- Install Plaid client library (`pip install plaid-python`)
- Set up secure credential storage for API keys

### Automated Transaction Sync
- Script to fetch transactions from connected bank accounts
- Transform Plaid transaction data to hledger format
- Automatic categorization based on merchant/description
- Duplicate detection and handling
- Schedule daily/weekly sync via cron

### Account Linking
- Web interface or CLI tool to link bank accounts
- Support for checking, savings, and credit card accounts
- Real-time balance verification against hledger balances

## 6. Automation Scripts

- **Plaid sync script** - Fetch and import transactions automatically
- **Import script for manual CSV files** - For accounts not supported by Plaid
- **Monthly report generator** - Automated financial reports
- **Backup script for journal files** - Data protection