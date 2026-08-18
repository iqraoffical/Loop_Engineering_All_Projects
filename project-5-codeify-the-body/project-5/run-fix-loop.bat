@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo Project 5: Multi-Candidate Fix Loop with Parallel Processing
echo ============================================================
echo.

set MAX_ATTEMPTS=3
set CANDIDATES=fix1 fix2 fix3
set SCRIPT_DIR=%~dp0
set WORKTREE_BASE=%SCRIPT_DIR%worktrees
set RESULTS_DIR=%WORKTREE_BASE%\results
set LOG_DIR=%WORKTREE_BASE%\logs

if not exist "%WORKTREE_BASE%" mkdir "%WORKTREE_BASE%"
if not exist "%RESULTS_DIR%" mkdir "%RESULTS_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

call :create_all_worktrees

echo All worktrees created. Starting parallel fix attempts...
echo.

set /a attempt=0

:loop
set /a attempt+=1
echo ==============================
echo Attempt %attempt% of %MAX_ATTEMPTS%
echo ==============================
echo.

del /q "%RESULTS_DIR%\final-*.txt" 2>nul

for %%c in (%CANDIDATES%) do (
    if not exist "%RESULTS_DIR%\%%c-PASS.txt" (
        if not exist "%RESULTS_DIR%\%%c-FAIL.txt" (
            echo launching> "%RESULTS_DIR%\%%c-running.txt"
        )
    )
)

for %%c in (%CANDIDATES%) do (
    if exist "%RESULTS_DIR%\%%c-running.txt" del "%RESULTS_DIR%\%%c-running.txt"
    call :launch_candidate "%%c"
)

call :wait_for_completion

call :show_results

for %%c in (%CANDIDATES%) do (
    if exist "%RESULTS_DIR%\%%c-PASS.txt" goto :success
)

if %attempt% geq %MAX_ATTEMPTS% goto :max_reached

echo Retrying...
goto :loop

:create_all_worktrees
for %%c in (%CANDIDATES%) do call :setup_worktree "%%c"
exit /b 0

:setup_worktree
set candidate=%~1
set worktree_path=%WORKTREE_BASE%\wt-%candidate%

if not exist "%worktree_path%" (
    echo Creating worktree: %candidate%
    git -C "%SCRIPT_DIR%" worktree add "%worktree_path%" -b fix/%candidate% 2>nul
    if errorlevel 1 (
        echo ERROR: Failed to create worktree for %candidate%
        exit /b 1
    )
    
    git -C "%worktree_path%" config user.email "agent@fix.local" 2>nul
    git -C "%worktree_path%" config user.name "Fix Agent" 2>nul
)

for %%f in (%candidate%) do echo %worktree_path%>"%RESULTS_DIR%\%%f-path.txt"
exit /b 0

:launch_candidate
set candidate=%~1
set worktree_path=
for %%p in (%candidate%) do if exist "%RESULTS_DIR%\%%p-path.txt" set /p worktree_path=<%RESULTS_DIR%\%%p-path.txt

echo Launching candidate %candidate% in background...

start "" /b cmd /c "call :process_candidate \"%candidate%\" \"%worktree_path%\" \"%LOG_DIR%\" \"%RESULTS_DIR%\""

exit /b 0

:process_candidate
set candidate=%~1
set wt=%~2
set log_dir=%~3
set results_dir=%~4

cd /d "%wt%\project-5" 2>nul

echo [%candidate%] Running implementer...
call agents\implementer-agent.bat "%wt%\project-5" 2>nul > "%log_dir%\%candidate%-impl.log"

echo [%candidate%] Running reviewer...
call agents\reviewer-agent.bat "%wt%\project-5" 2>nul > "%log_dir%\%candidate%-review.log"
set rev_exit=%errorlevel%

if %rev_exit% equ 0 (
    echo PASS > "%results_dir%\%candidate%-PASS.txt"
) else (
    echo FAIL > "%results_dir%\%candidate%-FAIL.txt"
)

cd /d "%SCRIPT_DIR%"
exit /b %rev_exit%

:wait_for_completion
echo Waiting for candidates...
for /l %%i in (1,1,15) do (
    set all_done=1
    for %%c in (%CANDIDATES%) do (
        if exist "%RESULTS_DIR%\%%c-PASS.txt" goto :done_wait
        if exist "%RESULTS_DIR%\%%c-FAIL.txt" goto :done_wait
    )
    timeout /t 1 /nobreak >nul 2>&1
)
:done_wait
exit /b 0

:show_results
echo.
echo ============================================================
echo RESULTS FOR ATTEMPT %attempt%
echo ============================================================

for %%c in (%CANDIDATES%) do (
    if exist "%RESULTS_DIR%\%%c-PASS.txt" (
        echo [PASS] %%c
    ) else if exist "%RESULTS_DIR%\%%c-FAIL.txt" (
        echo [FAIL] %%c
        type "%log_dir%\%%c-review.log" 2>nul | findstr /C:"FAIL" >nul && echo Review log: check logs\%%c-review.log
    ) else (
        echo [RUNNING] %%c
    )
)
exit /b 0

:success
echo.
echo ============================================================
echo ✓ SUCCESS: Candidate %%c passed review
echo ============================================================
echo.

set candidate=
for %%c in (%CANDIDATES%) do (
    if exist "%RESULTS_DIR%\%%c-PASS.txt" (
        set candidate=%%c
    )
)

if defined candidate (
    set worktree_path=
    for %%p in (%candidate%) do if exist "%RESULTS_DIR%\%%p-path.txt" set /p worktree_path=<%RESULTS_DIR%\%%p-path.txt>
    
    echo Creating PR for %candidate%...
    cd /d "!worktree_path!"
    git add project-5\src\app.js 2>nul
    git commit -m "Fix cart bugs - candidate %candidate% passed review" 2>nul
    git push -u origin fix/%candidate% 2>nul
    gh pr create --title "Fix cart bugs (candidate %candidate%)" --body "Automated fix applied. All tests pass." --base main 2>nul
    echo PR created for %candidate%
    cd /d "%SCRIPT_DIR%"
)

goto :cleanup

:max_reached
echo.
echo ============================================================
echo ✗ MAXIMUM ATTEMPTS REACHED
echo ============================================================
echo.

for %%c in (%CANDIDATES%) do (
    if exist "%RESULTS_DIR%\%%c-FAIL.txt" (
        echo Candidate %%c: Review failed
    )
)
echo Human intervention required.
goto :cleanup

:cleanup
echo.
echo Cleaning up worktrees...

for %%c in (%CANDIDATES%) do (
    if exist "%RESULTS_DIR%\%%c-path.txt" (
        set /p wt=<%RESULTS_DIR%\%%c-path.txt>
        if exist "!wt!" git worktree remove "!wt!" --force 2>nul
    )
)

rmdir /s /q "%RESULTS_DIR%" 2>nul
rmdir /s /q "%LOG_DIR%" 2>nul

echo Done.

endlocal
exit /b 0