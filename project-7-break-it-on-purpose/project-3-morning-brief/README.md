# Project 7 — Break It On Purpose

## Objective

Build a loop that deliberately fails in a controlled manner, demonstrating failure detection, logging, and human intervention requirements.

This project demonstrates:
- Controlled failure injection
- Failure logging and tracking
- Human intervention triggers ("NEEDS HUMAN")
- Cost estimation for loop operations
- Diagnosis without rerunning the loop

## Project Structure

- `loop-fail.bat` — Main loop with controlled failure
- `progress.md` — Failure tracking and loop state
- `logs/loop.log` — Detailed timestamped logs
- `TODO.md` — Repository information (from Project 3)
- `README.md` — Project documentation

## How It Works

Each run performs these steps:

1. Read previous `progress.md` for loop state
2. Read current `TODO.md` information
3. Check recent Git commits
4. Attempt work (up to 3 attempts)
5. On attempt 3: **Deliberately fail**
6. Log failure details to `logs/loop.log`
7. Display "NEEDS HUMAN" message
8. Stop loop - requires human intervention

## Controlled Failure

The failure is **deliberate and controlled**:
- **Trigger**: Attempt 3 of 3
- **Type**: Simulated external API timeout
- **Message**: "External API timeout (controlled)"
- **Safety**: Failure is logged and documented

## Failure Diagnosis

To diagnose failure **without rerunning**:

1. Check `progress.md`:
   - See "NEEDS HUMAN" status
   - Review failure details section
   - Check attempt history

2. Check `logs/loop.log`:
   - Timestamp of each attempt
   - Exact failure point
   - Failure reason logged

3. Example log output:
   ```
   [08/19/2026 10:30:15] Attempt 3 started
   [08/19/2026 10:30:15] FAILURE: Simulated dependency unavailable
   [08/19/2026 10:30:15] FAILURE REASON: External API timeout (controlled)
   [08/19/2026 10:30:15] NEEDS HUMAN - Loop stopped due to failure
   ```

## Monthly Cost Estimate

**Loop Operation Costs (Estimated)**:

| Item | Cost | Notes |
|------|------|-------|
| API calls (if real) | $5-20/month | Depends on frequency |
| Storage (logs) | $0.10/month | Minimal log files |
| Compute time | $0.05/month | Batch file execution |
| **Total** | **~$5-20/month** | Conservative estimate |

**Cost Factors**:
- Loop frequency (daily vs hourly)
- External API costs (if applicable)
- Log retention period
- Storage requirements

**Cost Optimization**:
- Limit loop attempts (currently 3)
- Compress old logs
- Use local storage only
- Monitor API usage

## Safety Features

1. **Attempt Limit**: Maximum 3 attempts per run
2. **Controlled Failure**: Failure is intentional and documented
3. **Clear Messaging**: "NEEDS HUMAN" displayed prominently
4. **Detailed Logging**: Every step timestamped
5. **State Preservation**: progress.md maintained across runs

## Acceptance Test

Project 7 passes when:

- Loop runs and fails on attempt 3
- Failure is logged in `logs/loop.log`
- `progress.md` shows "NEEDS HUMAN" status
- Failure can be diagnosed from logs alone
- No rerunning required for diagnosis
- Monthly cost estimate is documented

## Result

The project demonstrates that loops can fail safely with proper logging, human intervention triggers, and cost awareness.

## Course Concept

This project demonstrates Concept 7 (failure handling) and Concept 14 (cost awareness) from the Panaversity Loop Engineering Crash Course.
