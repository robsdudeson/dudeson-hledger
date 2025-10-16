# hledger Implementation Plan - Single Account Setup

## Implementation Status

### Phase Progress
- [ ] Phase 1: Environment Setup (Day 1)
- [ ] Phase 2: Basic hledger Setup (Day 1-2)
- [ ] Phase 3: SimpleFIN Integration Setup (Day 2-3)
- [ ] Phase 4: Automation Script Development (Day 3-4)
- [ ] Phase 5: Testing and Refinement (Day 4-5)
- [ ] Phase 6: Workflow Integration (Day 5-7)

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