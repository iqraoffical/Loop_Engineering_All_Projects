@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo Project 5: Fix Loop Body (One Beat)
echo ============================================================
echo.

cd /d "%~dp0"

REM This is the BODY of one beat - it tries to fix and verify
REM It does NOT loop - that would require a heartbeat + progress file

echo Applying fixes to src\app.js...
echo.

REM Fix 1: calculateTotal loop condition
powershell -Command "$content = Get-Content 'src\app.js' -Raw; $content = $content -replace 'for \(let i = 0; i < items\.length - 1; i\+\+\)', 'for (let i = 0; i < items.length; i++)'; Set-Content 'src\app.js' -Value $content -NoNewline"

REM Fix 2: applyDiscount formula
powershell -Command "$content = Get-Content 'src\app.js' -Raw; $content = $content -replace 'return total \+ \(total \* discountPercent / 100\);', 'return total - (total * discountPercent / 100);'; Set-Content 'src\app.js' -Value $content -NoNewline"

REM Fix 3: validateCart condition
powershell -Command "$content = Get-Content 'src\app.js' -Raw; $content = $content -replace 'if \(items\.length >= 0\)', 'if (items.length > 0)'; Set-Content 'src\app.js' -Value $content -NoNewline"

echo Fixes applied!
echo.
echo Running tests...
echo.

node tests\app.test.js
set TEST_RESULT=%errorlevel%

echo.
echo ============================================================
if %TEST_RESULT% equ 0 (
    echo RESULT: PASS - All tests passed
    echo ============================================================
    exit /b 0
) else (
    echo RESULT: FAIL - Some tests failed
    echo ============================================================
    exit /b 1
)
