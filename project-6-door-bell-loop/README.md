# Project 6: Door Bell Loop - Event-Driven PR Reviews

**Difficulty:** Medium  
**Concepts:** Event-driven loops (Concept 7), Connectors (Concept 10)

## Overview

This project demonstrates event-driven automation by creating a system that automatically reviews pull requests when they're opened or updated. The "door bell" rings whenever a PR event occurs, triggering an automated review that catches bugs before human review.

## What You'll Build

A GitHub-integrated routine that:
- Listens for PR events (opened, synchronized)
- Automatically reviews code changes
- Flags planted bugs and potential issues
- Re-runs on every push to the PR

## Project Structure

```
project-6-door-bell-loop/
├── .github/
│   └── workflows/
│       └── pr-review.yml          # GitHub Actions workflow
├── .claude/
│   └── routines/
│       └── pr-reviewer.json       # Claude Code routine definition
├── src/
│   └── sample-code.js             # Sample code with planted bug
├── tests/
│   └── sample.test.js             # Tests for the sample code
├── docs/
│   └── setup-guide.md             # Detailed setup instructions
├── progress.json                  # Track completion status
└── README.md                      # This file
```

## Quick Start

### Option 1: Claude Code Approach (Recommended)

1. **Set up GitHub connector:**
   ```bash
   export GITHUB_TOKEN=your_token_here
   ```

2. **Create a PR with the planted bug:**
   ```bash
   git checkout -b test-pr-review
   git add .
   git commit -m "Add sample code with planted bug"
   git push origin test-pr-review
   gh pr create --title "Test PR Review" --body "Testing automated review"
   ```

3. **The routine will automatically trigger and review the PR**

### Option 2: OpenCode Approach

1. **Install OpenCode GitHub integration:**
   ```bash
   opencode github install
   ```

2. **Accept the generated workflow**

3. **Create PR with planted bug**

## The Planted Bug

The sample code contains an off-by-one error:

```javascript
// Bug: Should iterate to i < array.length, not i <= array.length
for (let i = 0; i <= array.length; i++) {
  sum += array[i];  // Accesses undefined on last iteration
}
```

## Expected Outcome

✅ Automated review appears on PR  
✅ Review identifies the off-by-one error  
✅ Pushing updates triggers re-review  

## Four Heartbeat Completion

1. ✅ **In-session** (Projects 1-2): Direct loop execution
2. ✅ **Conditional** (Project 3): File/state change triggers  
3. ✅ **Scheduled** (Projects 4-5): Time-based cron
4. ✅ **Event-driven** (Project 6): External system events

## Resources

- [Loop Engineering Course](https://agentfactory.panaversity.org/docs/loop-engineering-crash-course)
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs)

---

**Status:** Ready for testing  

