# Project 4 — Fix Loop with Real Checker

## Objective

This project demonstrates a fix loop with separate implementer and reviewer agents, using worktree isolation and conditional PR creation based on strict code review.

## Project Structure

- `app.js` — Application with realistic bugs (cart calculation module)
- `app.test.js` — Test suite that catches the bugs
- `SKILL.md` — Fix instructions for implementer agent
- `implementer-agent.bat` — Separate implementer subagent script
- `reviewer-agent.bat` — Separate read-only reviewer subagent script
- `reviewer-prompt.md` — Instructions for reviewer agent
- `fix-loop.bat` — Main orchestration loop
- `test-scenarios.bat` — Script to test both PASS and FAIL scenarios
- `app-good-fix.js` — Correct fix (for testing PASS scenario)
- `app-bad-fix.js` — Incorrect fix (for testing FAIL scenario)
- `README.md` — Project documentation

## The Bugs

The application contains three realistic bugs:

1. **calculateTotal()** - Off-by-one error: skips the last item in the cart
2. **applyDiscount()** - Wrong formula: adds discount instead of subtracting
3. **validateCart()** - Logic error: accepts empty carts when it should reject them

## The Loop

`fix-loop.bat` orchestrates the maker-checker pattern with **separate agent scripts**:

1. Creates a git worktree with a new branch for isolation
2. Copies project files to the worktree
3. Calls `implementer-agent.bat` - **separate subagent** that:
   - Reads `SKILL.md` for fix instructions
   - Applies fixes to `app.js` in the worktree
   - Does not run tests or verify its own work
4. Calls `reviewer-agent.bat` - **separate read-only subagent** that:
   - Inspects the diff between original and fixed code
   - Runs the test suite (`node app.test.js`)
   - Compares fixes against requirements in `SKILL.md`
   - Returns **only** `PASS` or `FAIL: [reasons]`
   - **Cannot modify** any files
5. On PASS: commits, pushes, and opens a GitHub PR
6. On FAIL: logs reasons and retries (max 3 attempts)
7. Cleans up worktree after completion

## Key Features

### Separate Agents
- **Implementer** (`implementer-agent.bat`): 
  - Reads SKILL.md and applies fixes
  - Works in the worktree
  - Does not verify its own work
- **Reviewer** (`reviewer-agent.bat`): 
  - **Read-only** - cannot modify code
  - Inspects diff from original to fixed
  - Runs tests and returns strict PASS/FAIL verdict
  - Provides specific reasons for FAIL

### Worktree Isolation
- Each fix attempt happens in a separate git worktree
- Clean separation from main working tree
- Branch created for the fix

### Strict Checker
- Reviewer only returns: `PASS` or `FAIL: [specific reasons]`
- No suggestions, no explanations beyond failure reason
- Objective, test-based verification

### Conditional PR Creation
- GitHub PR created **only** on PASS
- Bad fixes never reach PR stage
- Loop capped at 3 attempts to prevent infinite runs

## Testing

### Test a Good Fix
1. Ensure bugs are present in `app.js`
2. Run `fix-loop.bat`
3. Implementer should fix all bugs
4. Reviewer should return PASS
5. PR should be created

### Test a Bad Fix
1. Modify SKILL.md to provide incorrect fix instructions
2. Run `fix-loop.bat`
3. Implementer applies bad fix
4. Reviewer should return FAIL with reasons
5. No PR should be created
6. Loop retries up to max attempts

## Verification

Run tests manually:
```bash
cd project-4-fix-loop
node app.test.js
```

Initial state (with bugs):
- Passed: 0
- Failed: 6

After fix:
- Passed: 6
- Failed: 0

## Maker-Checker Pattern

**Maker (Implementer Agent):**
- Reads fix instructions from SKILL.md
- Applies fixes to app.js in worktree
- Does not verify their own work

**Checker (Reviewer Agent):**
- Reads reviewer instructions from reviewer-prompt.md
- Runs test suite objectively
- Returns strict PASS or FAIL verdict
- Determines if PR should be opened

The checker is independent and makes the final decision.
