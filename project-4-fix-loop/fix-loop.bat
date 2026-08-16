@echo off
setlocal enabledelayedexpansion

echo ==============================
echo Project 4: Fix Loop with Real Checker
echo ==============================
echo.

set /a attempt=0
set /a max_attempts=3
set branch_name=fix/cart-bugs-%RANDOM%
set worktree_path=.claude\worktrees\%branch_name%

echo Creating worktree and branch: %branch_name%
git worktree add "%worktree_path%" -b %branch_name% 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to create worktree
    exit /b 1
)

echo Worktree created at: %worktree_path%
echo.

:loop
set /a attempt+=1

echo ==============================
echo Attempt %attempt% of %max_attempts%
echo ==============================
echo.

echo [IMPLEMENTER AGENT] Applying fixes...
echo.

REM Copy project files to worktree
xcopy /Y /Q project-4-fix-loop\*.js "%worktree_path%\project-4-fix-loop\" >nul 2>&1
xcopy /Y /Q project-4-fix-loop\*.md "%worktree_path%\project-4-fix-loop\" >nul 2>&1

REM Run implementer agent
claude --no-input "You are in the worktree at %worktree_path%. Read project-4-fix-loop/SKILL.md and fix all bugs in project-4-fix-loop/app.js according to the instructions. Make the changes directly. Do not explain, just fix the code."

echo.
echo [REVIEWER AGENT] Checking the fix...
echo.

REM Run reviewer agent
claude --no-input "You are a code reviewer. Read project-4-fix-loop/reviewer-prompt.md for your instructions. Check the fixed code in project-4-fix-loop/app.js by running 'cd project-4-fix-loop && node app.test.js'. Return ONLY 'PASS' or 'FAIL: [reasons]'." > review-result.txt

REM Parse reviewer result
findstr /C:"PASS" review-result.txt >nul
if %errorlevel%==0 (
    findstr /C:"FAIL" review-result.txt >nul
    if %errorlevel% neq 0 goto success
)

echo Review result:
type review-result.txt
echo.

if %attempt% GEQ %max_attempts% goto limit

echo Fix did not pass review. Retrying...
echo.
goto loop

:success
echo.
echo ==============================
echo ✓ FIX PASSED REVIEW
echo ==============================
echo.

REM Commit the fix
cd "%worktree_path%"
git add project-4-fix-loop\app.js
git commit -m "Fix cart calculation bugs: off-by-one, discount formula, empty cart validation"

REM Push and create PR
git push -u origin %branch_name%
gh pr create --title "Fix cart calculation bugs" --body "Fixes three bugs in cart calculation module:^

- calculateTotal: Fixed off-by-one error^
- applyDiscount: Fixed discount formula (subtract instead of add)^
- validateCart: Reject empty carts^

All tests now pass." --base main

echo.
echo GitHub PR created successfully!
goto cleanup

:limit
echo.
echo ==============================
echo ✗ MAXIMUM ATTEMPTS REACHED
echo ==============================
echo Fix failed review %max_attempts% times.
echo No PR will be created.
echo Human review required.
goto cleanup

:cleanup
echo.
echo Cleaning up worktree...
cd ..\..\..
git worktree remove "%worktree_path%" --force
del review-result.txt 2>nul

:end
echo.
echo Loop complete.
