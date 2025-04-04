@echo off
setlocal enabledelayedexpansion

:: Get user input
set /p testName=Enter test name: 
set "folderName=%testName%"
mkdir "%folderName%"

copy "oracle.m" "%folderName%\oracle.m"
cd /d "%folderName%"
matlab -nodisplay -nosplash -nodesktop -r "run('oracle.m');exit;"

set /p wait=Press any key to quit:
