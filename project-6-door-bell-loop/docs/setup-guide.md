# Setup Guide - Project 6: Door Bell Loop

## Prerequisites

Before starting, ensure you have:

- ✅ GitHub repository with admin access
- ✅ Claude Code CLI installed
- ✅ GitHub Personal Access Token with repo and workflow permissions
- ✅ Git configured locally

## Step-by-Step Setup

### 1. Configure GitHub Token

Create a GitHub Personal Access Token:

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Select scopes:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
4. Generate and copy the token

Set the token as an environment variable:

```bash
# On Linux/macOS
export GITHUB_TOKEN=ghp_your_token_here

# On Windows PowerShell
$env:GITHUB_TOKEN="ghp_your_token_here"

# Make it permanent by adding to your shell profile
```

### 2. Test the Routine Locally

Before pushing to GitHub, test the routine locally:

```bash
# Create a test branch
git checkout -b test-review

# Run the routine manually
claude routine run pr-reviewer --dry-run
```

### 3. Create Your First Test PR

```bash
# Make sure you're on the test branch
git checkout -b test-pr-review

# Add all files
git add .
git commit -m "Add sample code with planted bug for testing"

# Push to remote
git push origin test-pr-review

# Create PR using GitHub CLI
gh pr create \
  --title "Test: Automated PR Review" \
  --body "Testing the automated review system. This PR contains a planted off-by-one error in src/sample-code.js" \
  --base main
```

### 4. Monitor the Review

Watch for the automated review:

1. Go to your PR on GitHub
2. Wait 30-60 seconds for the routine to trigger
3. Check the "Files changed" tab for review comments
4. Verify the off-by-one error is flagged

Expected review comment:
```
🐛 Bug Found: Off-by-one error

Line 19: for (let i = 0; i <= array.length; i++)

Issue: Loop iterates beyond array bounds. Should be `i < array.length`
Severity: High
Impact: Causes undefined to be added to sum
```

### 5. Test the Synchronize Event

Push a fix to see the re-review trigger:

```bash
# Fix the bug in src/sample-code.js
# Change: for (let i = 0; i <= array.length; i++)
# To: for (let i = 0; i < array.length; i++)

git add src/sample-code.js
git commit -m "Fix: Correct off-by-one error in calculateSum"
git push

# The routine will automatically trigger again!
```

### 6. Verify Success

Check that:
- [ ] Initial PR received automated review
- [ ] Review correctly identified the bug
- [ ] Push triggered a new review (synchronize event)
- [ ] Second review acknowledged the fix

## Troubleshooting

### Review Doesn't Appear

**Check GitHub Actions:**
```bash
gh run list --workflow=pr-review.yml
gh run view <run-id> --log
```

**Check webhook delivery:**
1. Go to GitHub repo → Settings → Webhooks
2. Click on the webhook
3. Check "Recent Deliveries" tab
4. Verify response is 200 OK

### Review Misses the Bug

Tighten the review prompt in `.claude/routines/pr-reviewer.json`:

```json
{
  "prompt": "Focus specifically on:\n- Off-by-one errors in loops\n- Array index out of bounds\n- Null/undefined access\n\nBe extra careful with array iterations and boundary conditions."
}
```

### Token Permission Issues

Verify token scopes:
```bash
gh auth status
```

Refresh if needed:
```bash
gh auth refresh -h github.com -s repo,workflow
```

## Alternative: OpenCode Setup

If you prefer OpenCode:

```bash
# Install OpenCode
npm install -g opencode

# Install GitHub integration
opencode github install

# Follow the prompts to authorize

# Create PR - OpenCode will auto-review
git checkout -b test-opencode
git push origin test-opencode
gh pr create --title "Test OpenCode Review" --body "Testing"
```

## Advanced Configuration

### Customize Review Depth

Edit `.claude/routines/pr-reviewer.json`:

```json
{
  "instructions": {
    "prompt": "Perform a DEEP review focusing on:\n- Security vulnerabilities\n- Performance bottlenecks\n- Memory leaks\n- Race conditions\n- Error handling gaps"
  }
}
```

### Add Multiple Reviewers

Create additional routines for different aspects:
- `pr-reviewer-security.json` - Security-focused
- `pr-reviewer-performance.json` - Performance-focused
- `pr-reviewer-style.json` - Code style and best practices

### Filter by File Types

```json
{
  "trigger": {
    "filters": {
      "files": ["**/*.js", "**/*.ts", "**/*.py"],
      "exclude": ["**/test/**", "**/node_modules/**"]
    }
  }
}
```

## Next Steps

1. ✅ Complete this test PR
2. ✅ Mark project as complete in progress.json
3. ✅ Enable routine for all future PRs
4. 🎯 Move on to building your own custom routines!

## Resources

- [Claude Code Routines Docs](https://docs.anthropic.com/claude/docs/routines)
- [GitHub Actions Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [GitHub Webhooks](https://docs.github.com/en/webhooks)
- [Loop Engineering Course](https://agentfactory.panaversity.org/docs/loop-engineering-crash-course)
