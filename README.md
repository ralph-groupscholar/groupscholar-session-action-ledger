# Group Scholar Session Action Ledger

Common Lisp CLI to track mentor session action items, owners, due dates, and status. Designed for Group Scholar ops teams to log follow-ups and generate quick summaries.

## Features
- Log sessions and associated action items.
- Close action items when completed.
- List actions (optionally filtered by status).
- Summary counts by status and due-soon view.

## Tech
- Common Lisp (SBCL)
- Postmodern (PostgreSQL)
- FiveAM (tests)

## Setup

### 1) Install SBCL
```bash
brew install sbcl
```

### 2) Configure environment variables
```bash
export GS_SAL_DB_NAME=ralph
export GS_SAL_DB_USER=ralph
export GS_SAL_DB_PASSWORD=***
export GS_SAL_DB_HOST=db-acupinir.groupscholar.com
export GS_SAL_DB_PORT=23947
export GS_SAL_DB_SSLMODE=require
```

### 3) Install Quicklisp and run
```bash
bin/session-action-ledger summary
```

## Database setup
The production database uses a dedicated schema: `gs_session_action_ledger`.

```bash
psql "postgresql://$GS_SAL_DB_USER:$GS_SAL_DB_PASSWORD@$GS_SAL_DB_HOST:$GS_SAL_DB_PORT/$GS_SAL_DB_NAME" \
  -v ON_ERROR_STOP=1 \
  -f scripts/schema.sql
```

## Usage
```bash
bin/session-action-ledger add-session 2026-02-08 "career coaching" "Alicia Barnes" "Jordan Lee" "Reviewed internship strategy"

bin/session-action-ledger add-action 1 "Jordan Lee" 2026-02-12 open "Draft outreach email to alumni contacts"

bin/session-action-ledger list-actions open

bin/session-action-ledger close-action 3

bin/session-action-ledger summary
```

## Tests
```bash
sbcl --script scripts/run-tests.lisp
```
