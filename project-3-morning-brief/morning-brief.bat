@echo off

echo ==================================
echo MORNING BRIEF - MEMORY AWARE
echo ==================================

echo.
echo Previous memory:
type progress.md

echo.
echo Current TODO:
type TODO.md

echo.
echo Recent commits:
git log --oneline -5

echo.
echo Updating memory...

(
echo # Progress Memory
echo.
echo ## Last Run
echo %date% - Second morning brief completed.
echo.
echo ## Previously Recorded
echo - First morning brief was completed.
echo - TODO.md was reviewed.
echo - Recent Git history was reviewed.
echo.
echo ## New Information
echo - Verify Project 3 memory was added after the first run.
echo - A new Git commit was created for the new task.
echo.
echo ## Next
echo - Future runs should compare current repository information with this memory.
) > progress.md

echo.
echo MORNING BRIEF COMPLETE.