# hledger Implementation Plan - Single Account Setup

## Phase 1: Environment Setup (Day 1)

### 1.1 Install Dependencies
```bash
# Install hledger (if not already installed)
sudo apt update
sudo apt install hledger

# Install Python and dependencies for Plaid integration
sudo apt install python3 python3-pip
pip3 install plaid-python python-dotenv requests
```

### 1.2 Create Project Structure
```bash
mkdir -p ~/hledger/{scripts,data,backups}
cd ~/hledger
```

## Phase 2: Basic hledger Setup (Day 1-2)

### 2.1 Create Initial Journal Structure
- Create `main.journal` as the primary entry point
- Create `accounts.journal` for account definitions
- Create `2024.journal` for current year transactions
- Set up basic account structure

### 2.2 Choose Test Account
**Recommended: Start with Chase Checking**
- Most transactions for testing
- Easier to verify accuracy
- Good for learning hledger basics

### 2.3 Manual Entry Practice
- Add 5-10 recent transactions manually
- Learn hledger syntax and commands
- Verify balances match bank statements

## Phase 3: Plaid Integration Setup (Day 2-3)

### 3.1 Plaid Developer Account
1. Sign up at https://dashboard.plaid.com/signup
2. Create a new application
3. Get sandbox API keys (client_id, secret_key)
4. Note: Sandbox mode for testing first

### 3.2 Create Environment File
```bash
# Create .env file
cat > .env << EOF
PLAID_CLIENT_ID=your_client_id_here
PLAID_SECRET=your_secret_here
PLAID_ENV=sandbox  # Use 'development' or 'production' later
EOF
```

### 3.3 Test Plaid Connection
- Create simple Python script to test API connection
- Use Plaid's test credentials to verify setup
- Test transaction retrieval

## Phase 4: Automation Script Development (Day 3-4)

### 4.1 Create Transaction Sync Script
**File: `scripts/sync_plaid.py`**
- Connect to Plaid API
- Fetch transactions from last 30 days
- Convert to hledger format
- Check for duplicates
- Append new transactions to journal

### 4.2 Automatic Transaction Categorization
**See: `auto_categorization_plan.md` for detailed implementation**

#### Rule-Based Categorization (Start Here)
- Create `data/merchant_rules.json` with merchant mappings
- Implement exact match, pattern, and regex rules
- Start with 50+ common merchants from your transaction history
- Default unknown transactions to "Expenses:Other" for review

#### Confidence Scoring System
- High confidence (>90%): Auto-apply category
- Medium confidence (70-90%): Suggest but flag for review  
- Low confidence (<70%): Leave uncategorized

#### Learning System (Week 2+)
- Track user corrections to improve rules
- Build ML classifier from categorized transactions
- Auto-suggest new merchant rules
- Target 90%+ auto-categorization rate

### 4.3 Duplicate Detection
- Track transaction IDs in separate file
- Check amount + date + merchant for matches
- Skip already imported transactions

## Phase 5: Testing and Refinement (Day 4-5)

### 5.1 Sandbox Testing
1. Run sync script against Plaid sandbox
2. Verify hledger journal format
3. Test `hledger balance` and `hledger register` commands
4. Check for any formatting issues

### 5.2 Real Account Connection
1. Switch to Plaid development environment
2. Connect your actual Chase checking account
3. Import last 7 days of transactions
4. Manually verify accuracy against bank statement

### 5.3 Schedule Automation
```bash
# Add to crontab for daily sync at 6 AM
crontab -e
# Add line: 0 6 * * * cd ~/hledger && python3 scripts/sync_plaid.py
```

## Phase 6: Workflow Integration (Day 5-7)

### 6.1 Daily Review Process
1. Check sync log for any errors
2. Review uncategorized transactions
3. Manually categorize unknown merchants
4. Verify account balance matches bank

### 6.2 Create Helper Scripts
- `scripts/balance.sh` - Quick balance check
- `scripts/recent.sh` - Show recent transactions
- `scripts/categorize.sh` - Interactive categorization tool

### 6.3 Backup Strategy
- Daily backup of journal files
- Git repository for version control
- Export to CSV for external backup

## Success Criteria

### Week 1 Goals
- [ ] hledger installed and basic journals created
- [ ] Chase checking account connected to Plaid
- [ ] Automated daily sync working
- [ ] Last 30 days of transactions imported and categorized
- [ ] Daily balance reconciliation working

### Verification Steps
1. `hledger balance` shows correct checking account balance
2. `hledger register checking` shows recent transactions
3. Sync script runs without errors
4. No duplicate transactions in journal

## Next Steps (After Success)

1. **Add Second Account**: Repeat process for Chase Credit Card
2. **Improve Categorization**: Refine merchant mapping rules
3. **Add Reporting**: Monthly expense reports and budgeting
4. **Scale Up**: Add remaining accounts one by one

## Troubleshooting Common Issues

### Plaid Connection Issues
- Verify API credentials in .env file
- Check Plaid dashboard for account status
- Ensure institution supports Plaid

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