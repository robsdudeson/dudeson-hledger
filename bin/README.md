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

```bash
# Download all accounts as JSON
bin/simplefinjson > data/simplefin.json

# Download specific account
bin/simplefinjson ACT-123456 > data/chase.json
```

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
