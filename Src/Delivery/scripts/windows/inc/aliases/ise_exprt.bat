setlocal

:: svn export for the ISE repository
if "%1" EQU "-N" set l_opts="-N"
if "%1" EQU "-N" shift

set l_path=%1
shift
call %INIT_DIR%\svn_command.bat --force export --quiet -r %ISE_SVN_REVISION% %DEFAULT_ISE_SVN%/%l_path% %1 %2 %3 %4 %5 %6 %7 %8 %9

endlocal
