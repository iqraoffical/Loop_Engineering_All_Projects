@echo off
echo ==============================
echo Testing FAIL Scenario (Bad Fix)
echo ==============================
echo.

echo Applying bad fix...
copy /Y app-bad-fix.js src\app.jssss >nul

echo Running tests on bad fix:
node app.test.js
echo.

if %errorlevel%==0 (
    echo ERROR: Bad fix should have failed!
    exit /b 1
) else (
    echo ✓ Bad fix correctly failed tests
)

echo.
echo ==============================
echo Testing PASS Scenario (Good Fix)
echo ==============================
echo.

echo Applying good fix...
copy /Y app-good-fix.js src\app.js >nul

echo Running tests on good fix:
node tests\app.test.js
echo.

if %errorlevel%==0 (
    echo ✓ Good fix correctly passed all tests
) else (
    echo ERROR: Good fix should have passed!
    exit /b 1
)

echo.
echo ==============================
echo Both scenarios verified!
echo ==============================
echo.
echo FAIL scenario: Bad fix was rejected ✓
echo PASS scenario: Good fix was accepted ✓
echo.
echo Restoring original buggy version...
copy /Y app-bad-fix.js src\app.js >nul
echo Done.
