setlocal
set DIR=%~dpnx1
for %%F in (%DIR%) do set PDIR=%%~dpF
if NOT exist "%PDIR%" mkdir "%PDIR%"

if exist %DIR% goto EOF
echo Get EiffelStudio source code ... dir=%DIR%
%INIT_DIR%\git_command.bat clone --quiet --single-branch --branch %DEFAULT_ES_BRANCH% %DEFAULT_ES_ROOT% %DIR% 

:EOF
endlocal
