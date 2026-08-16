@echo off

echo ==================================
echo MORNING BRIEF
echo ==================================

echo.
echo Reading TODO items...
type TODO.md

echo.
echo Checking Git history...
git log --oneline -5

echo.
echo Updating progress memory...

(
echo # Progress Memory
echo.
echo ## Last Run
echo %date% - First morning brief completed.
echo.
echo ## Completed
echo - Read TODO.md
echo - Reviewed recent Git commits
echo - Created the first morning brief
echo.
echo ## Next
echo - On the next run, review this file first.
echo - Report only new work instead of repeating this run.
) > progress.md

echo.
echo MORNING BRIEF COMPLETE.