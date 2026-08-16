@echo off
setlocal enabledelayedexpansion

REM Reviewer Agent Script
REM This agent is READ-ONLY and returns only PASS or FAIL

set worktree_path=%1

if "%worktree_path%"=="" (
    echo ERROR: Worktree path required
    exit /b 1
)

echo ==============================
echo REVIEWER AGENT (Read-Only)
echo ==============================
echo.
echo Inspecting worktree: %worktree_path%
echo.

REM Create a temporary file for the reviewer's verdict
set verdict_file=reviewer-verdict-%RANDOM%.txt

REM Call Claude as a separate reviewer subagent with strict read-only instructions
claude --no-input "You are a READ-ONLY code reviewer agent. DO NOT modify any files.

Your task:
1. Navigate to the worktree at: %worktree_path%\project-4-fix-loop
2. Read the ORIGINAL buggy version from git: git show HEAD:project-4-fix-loop/app.js
3. Read the FIXED version: project-4-fix-loop/app.js
4. Compare the diff between original and fixed
5. Run the tests: cd project-4-fix-loop && node app.test.js
6. Read SKILL.md to understand what fixes were required

Your verdict must be based on:
- Do all tests pass? (exit code 0)
- Are all THREE bugs fixed correctly?
  * calculateTotal: loop must be 'i < items.length' (not length-1)
  * applyDiscount: must subtract discount (not add)
  * validateCart: must check 'items.length > 0' (not >=)

Return EXACTLY one of these formats:

If all tests pass AND all fixes are correct:
PASS

If any test fails OR any fix is incorrect:
FAIL: [specific reason]

Examples of FAIL:
FAIL: calculateTotal still has off-by-one error - loop uses length-1
FAIL: applyDiscount still adds discount instead of subtracting
FAIL: validateCart still accepts empty carts - uses >= instead of >
FAIL: 3 tests failed - multiple bugs remain

Return ONLY the verdict line. No explanations, no suggestions, no code." > "%verdict_file%"

REM Read the verdict
if exist "%verdict_file%" (
    set /p verdict=<"%verdict_file%"
    echo !verdict!

    REM Check if it's a PASS
    echo !verdict! | findstr /C:"PASS" >nul
    if !errorlevel!==0 (
        echo !verdict! | findstr /C:"FAIL" >nul
        if !errorlevel! neq 0 (
            REM Pure PASS - no FAIL substring
            del "%verdict_file%"
            exit /b 0
        )
    )

    REM Either FAIL or malformed response
    del "%verdict_file%"
    exit /b 1
) else (
    echo ERROR: Reviewer failed to produce verdict
    exit /b 1
)
