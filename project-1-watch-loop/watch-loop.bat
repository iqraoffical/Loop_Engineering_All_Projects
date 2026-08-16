@echo off
@echo off
:watch
if exist task-complete.txt goto done
echo Task not finished. Checking again in 60 seconds...
timeout /t 60 /nobreak >nul
goto watch

:done
echo TASK COMPLETED!