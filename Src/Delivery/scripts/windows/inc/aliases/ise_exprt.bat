setlocal

:: svn export for the ISE repository
if "%1" EQU "-N" set l_opts="-N" && shift
set l_path=%1
shift
call %INIT_DIR%\svn_command.bat --force export --quiet -r %ISE_SVN_REVISION% %DEFAULT_ISE_SVN%/%l_path% %*

endlocal
