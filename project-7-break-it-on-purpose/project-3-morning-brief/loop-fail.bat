@echo off
setlocal enabledelayedexpansion

echo ==================================
echo PROJECT 7 - CONTROLLED FAILURE LOOP
echo ==================================
echo.

REM Configuration
set MAX_ATTEMPTS=3
set ATTEMPT=0
set FAILED=0

REM Log start
echo [%date% %time%] Loop started - Max attempts: %MAX_ATTEMPTS% >> logs\loop.log

:LOOP_START
set /a ATTEMPT+=1
echo Attempt %ATTEMPT% of %MAX_ATTEMPTS%...
echo [%date% %time%] Attempt %ATTEMPT% started >> logs\loop.log

REM Simulate work - read previous memory
echo Reading previous memory...
if exist progress.md (
    echo [%date% %time%] Read progress.md successfully >> logs\loop.log
) else (
    echo [%date% %time%] WARNING: progress.md not found >> logs\loop.log
)

REM Simulate work - read TODO
echo Reading TODO list...
if exist TODO.md (
    echo [%date% %time%] Read TODO.md successfully >> logs\loop.log
) else (
    echo [%date% %time%] WARNING: TODO.md not found >> logs\loop.log
)

REM Simulate work - check git
echo Checking recent commits...
git log --oneline -3 >nul 2>&1
if %errorlevel% equ 0 (
    echo [%date% %time%] Git log successful >> logs\loop.log
) else (
    echo [%date% %time%] WARNING: Git log failed >> logs\loop.log
)

REM DELIBERATE FAILURE: On attempt 3, fail on purpose
if %ATTEMPT% equ 3 (
    echo [%date% %time%] FAILURE: Simulated dependency unavailable >> logs\loop.log
    echo [%date% %time%] FAILURE REASON: External API timeout (controlled) >> logs\loop.log
    echo [%date% %time%] NEEDS HUMAN - Loop stopped due to failure >> logs\loop.log
    echo.
    echo *** FAILURE DETECTED ***
    echo Attempt %ATTEMPT% failed: External API timeout (controlled)
    echo.
    echo NEEDS HUMAN
    echo.
    echo See logs\loop.log for details
    set FAILED=1
    goto LOOP_END
)

REM Simulate successful work
echo [%date% %time%] Work completed successfully >> logs\loop.log
echo Attempt %ATTEMPT% completed successfully.
echo.

REM Check if we've reached max attempts
if %ATTEMPT% geq %MAX_ATTEMPTS% (
    echo [%date% %time%] Max attempts reached >> logs\loop.log
    goto LOOP_END
)

goto LOOP_START

:LOOP_END
echo.
echo ==================================
echo LOOP FINISHED
echo ==================================
echo [%date% %time%] Loop ended - Total attempts: %ATTEMPT% >> logs\loop.log
if %FAILED% equ 1 (
    echo [%date% %time%] Final status: FAILED >> logs\loop.log
) else (
    echo [%date% %time%] Final status: COMPLETED >> logs\loop.log
)

endlocal
