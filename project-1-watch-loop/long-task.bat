@echo off
echo Long task started...
timeout /t 60 /nobreak
echo Task completed > task-complete.txt
echo Long task finished.
