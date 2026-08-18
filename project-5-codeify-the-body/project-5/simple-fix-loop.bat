@echo off
echo ============================================================
echo Project 5: Simple Fix Loop Body (One Beat)
echo ============================================================
echo.

set CANDIDATES=fix1 fix2 fix3
set PROJECT_DIR=%~dp0
set SUCCESS=0

echo Starting parallel fix attempts...
echo.

for %%c in (%CANDIDATES%) do (
    echo ==============================
    echo Candidate: %%c
    echo ==============================

    REM Apply the fixes for this candidate
    call :apply_fixes %%c

    REM Review the fixes
    call :review_fixes %%c

    if !errorlevel! equ 0 (
        echo [PASS] %%c passed all tests
        set SUCCESS=1
        set WINNER=%%c
        goto :done
    ) else (
        echo [FAIL] %%c failed tests
        echo.
    )
)

:done
if %SUCCESS% equ 1 (
    echo.
    echo ============================================================
    echo SUCCESS: %WINNER% passed all tests
    echo ============================================================
    exit /b 0
) else (
    echo.
    echo ============================================================
    echo FAIL: All candidates failed - manual intervention needed
    echo ============================================================
    exit /b 1
)

:apply_fixes
set candidate=%1
echo Applying fixes for %candidate%...

REM Read SKILL.md instructions and apply fixes to src/app.js
powershell -Command "(Get-Content '%PROJECT_DIR%src\app.js') -replace 'i < items.length - 1', 'i < items.length' | Set-Content '%PROJECT_DIR%src\app.js'"
powershell -Command "(Get-Content '%PROJECT_DIR%src\app.js') -replace 'total \+ \(total', 'total - (total' | Set-Content '%PROJECT_DIR%src\app.js'"
powershell -Command "(Get-Content '%PROJECT_DIR%src\app.js') -replace 'items.length >= 0', 'items.length > 0' | Set-Content '%PROJECT_DIR%src\app.js'"

echo Fixes applied for %candidate%
exit /b 0

:review_fixes
set candidate=%1
echo Reviewing %candidate%...

REM Run tests
cd /d "%PROJECT_DIR%"
node tests\app.test.js >nul 2>&1
set test_result=%errorlevel%

if %test_result% equ 0 (
    echo Tests PASSED for %candidate%
) else (
    echo Tests FAILED for %candidate%
)

exit /b %test_result%
