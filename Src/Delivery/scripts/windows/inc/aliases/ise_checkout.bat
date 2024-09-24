setlocal
:: svn checkout for the ISE repository
echo ISE_CHECKOUT %1 %2 %3
if "%1" EQU "-N" set l_opts="-N"
if "%1" EQU "-N" shift

set l_path=%1
shift
call %INIT_DIR%\svn_command.bat checkout --quiet %l_opts% -r %ISE_SVN_REVISION% %DEFAULT_ISE_SVN%/%l_path% %*

endlocal
