@echo off
setlocal enabledelayedexpansion

REM Implementer Agent Script
REM This agent applies fixes based on SKILL.md

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

REM Call Claude as a separate implementer subagent
claude --no-input "You are an implementer agent. Your job is to fix bugs in code.

Your task:
1. Navigate to: %worktree_path%\project-4-fix-loop
2. Read SKILL.md to understand the bugs and required fixes
3. Read the current app.js file
4. Apply ALL THREE fixes exactly as instructed in SKILL.md:
   - Fix calculateTotal() loop condition
   - Fix applyDiscount() formula
   - Fix validateCart() condition
5. Write the corrected code to app.js

Rules:
- Apply the fixes directly to app.js
- Do not run tests (the reviewer will do that)
- Do not explain or comment
- Just fix the code and confirm when done

After fixing, respond with: FIXES APPLIED"

echo.
echo Implementer agent completed.
