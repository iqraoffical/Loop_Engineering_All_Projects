@echo off
setlocal enabledelayedexpansion

set worktree_path=%1

if "%worktree_path%"=="" (
    echo ERROR: Worktree path required
    exit /b 1
)

echo ==============================
echo IMPLEMENTER AGENT
echo ==============================
echo.
echo Working in worktree: %worktree_path%
echo.

claude --no-input "You are an implementer agent. Your job is to fix bugs in code.

Your task:
1. Navigate to: %worktree_path%\project-5
2. Read SKILL.md to understand the bugs and required fixes
3. Read the current src\app.js file
4. Apply ALL THREE fixes exactly as instructed in SKILL.md:
   - Fix calculateTotal() loop condition
   - Fix applyDiscount() formula
   - Fix validateCart() condition
5. Write the corrected code to src\app.js

Rules:
- Apply the fixes directly to src/app.js
- Do not run tests (the reviewer will do that)
- Do not explain or comment
- Just fix the code and confirm when done

After fixing, respond with: FIXES APPLIED"

echo.
echo Implementer agent completed.

exit /b 0