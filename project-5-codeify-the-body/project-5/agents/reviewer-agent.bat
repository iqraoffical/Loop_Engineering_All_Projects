@echo off
setlocal enabledelayedexpansion

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

set project_path=%worktree_path%\project-5

cd /d "%project_path%" 2>nul

echo.
echo Running test suite...
echo.

node tests\app.test.js
set test_exit=%errorlevel%

echo.
echo Test exit code: %test_exit%

if %test_exit% equ 0 (
    echo.
    echo PASS
    exit /b 0
) else (
    echo.
    echo Analyzing failures...
    cd /d "%project_path%"
    
    node -e "const app = require('./src/app.js'); const tests = require('./tests/app.test.js');" 2>nul
    
    echo FAIL: One or more tests failed - review test output above
    exit /b 1
)

exit /b 1