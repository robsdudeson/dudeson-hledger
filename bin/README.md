# SimpleFIN Scripts with .env Support

This directory contains SimpleFIN scripts that automatically load environment variables from `.env`.

## Files

### Original Scripts (from hledger repository)
- `simplefinsetup.orig` - Original SimpleFIN setup script
- `simplefinjson.orig` - Original SimpleFIN JSON downloader
- `simplefincsv` - SimpleFIN CSV converter (Python, no wrapper needed)

### Wrapper Scripts (load .env automatically)
- `simplefinsetup` - Wrapper that loads SIMPLEFIN_SETUP_TOKEN from .env
- `simplefinjson` - Wrapper that loads SIMPLEFIN_ACCESS_URL from .env

### Helper Scripts
- `load-env` - Reusable script to safely load .env files

## Usage

### 1. Set up your .env file

Copy the example and add your SimpleFIN credentials:

```bash
cp .env.example .env
```

Edit `.env` and add your SimpleFIN Setup Token:

```bash
SIMPLEFIN_SETUP_TOKEN="your_token_here"
```

### 2. Run simplefinsetup

The wrapper will automatically load the token from .env:

```bash
bin/simplefinsetup
```

This will output your SIMPLEFIN_ACCESS_URL. Add it to `.env`:

```bash
SIMPLEFIN_ACCESS_URL="https://..."
```

### 3. Download account data

The `simplefinjson` script supports multiple options:

**Default behavior (NEW):** Returns account info and balances WITHOUT transaction history.
This is faster and useful for checking balances. Use `--transactions` or `--start-date` to include transactions.

```bash
# Download all accounts with balances only (NEW DEFAULT - fast)
bin/simplefinjson > data/simplefin.json

# Download all accounts with last 30 days of transactions
bin/simplefinjson --transactions > data/simplefin.json

# Download specific account (positional argument)
bin/simplefinjson --transactions ACT-123456 > data/chase.json

# Download last 90 days of transactions
bin/simplefinjson --start-date 90 > data/simplefin.json

# Include pending transactions
bin/simplefinjson --transactions --pending > data/simplefin.json

# Download balances only (explicit, same as default now)
bin/simplefinjson --balances-only > data/balances.json

# Download specific account with named parameter
bin/simplefinjson --account ACT-123456 > data/chase.json

# Multiple accounts with transactions
bin/simplefinjson --transactions --account ACT-123 --account ACT-456 > data/accounts.json

# Combine options
bin/simplefinjson --start-date 90 --pending --account ACT-123456 > data/chase.json

# Show help
bin/simplefinjson --help
```

#### Available Options:

- `--transactions` - Include transactions from last 30 days (shortcut for `--start-date 30`)
- `--start-date DAYS` - Number of days to look back for transactions
- `--end-date TIMESTAMP` - Unix epoch timestamp for end date
- `--pending` - Include pending transactions (if supported by institution)
- `--balances-only` - Return only balances, no transaction data (now the default)
- `--account ACCTID` - Specific account ID (can be specified multiple times)
- `--help` - Show help message

#### Performance Note:

The default behavior (balances only) is much faster since it doesn't download transaction history.
Use this for quick balance checks, then use `--transactions` or `--start-date` when you need transaction data.

### 4. Convert to CSV

```bash
# Convert all accounts
bin/simplefincsv data/simplefin.json

# Convert specific account matching pattern
bin/simplefincsv data/simplefin.json 'chase.*checking'
```

## How It Works

The wrapper scripts:
1. Detect the project root directory
2. Load `.env` file using bash's `set -a` (allexport)
3. Optionally use the `load-env` helper for safer parsing
4. Execute the original `.orig` script with the environment loaded

## Direct Execution (bypass wrappers)

If you need to run the original scripts directly:

```bash
export SIMPLEFIN_SETUP_TOKEN="your_token"
bin/simplefinsetup.orig

export SIMPLEFIN_ACCESS_URL="your_url"
bin/simplefinjson.orig
```

## Troubleshooting

**Error: SIMPLEFIN_ACCESS_URL not found**
- Make sure you've run `bin/simplefinsetup` first
- Check that `.env` contains `SIMPLEFIN_ACCESS_URL=...`
- Try sourcing the env manually: `source bin/load-env`

**Wrapper script not found**
- The wrappers are part of this project in version control
- If missing, they should be created from the examples in `bin/`
