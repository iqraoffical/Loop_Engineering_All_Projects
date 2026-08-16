@echo off
set /a attempt=0
set /a max_attempts=6

:loop
set /a attempt+=1

echo.
echo ==============================
echo Attempt %attempt% of %max_attempts%
echo ==============================

node test.js

if %errorlevel%==0 goto success

if %attempt% GEQ %max_attempts% goto limit

echo Tests failed. Continuing...
goto loop

:success
echo.
echo TESTS PASSED - LOOP STOPPING.
goto end

:limit
echo.
echo MAXIMUM ATTEMPTS REACHED - HUMAN REVIEW REQUIRED.
goto end

:end