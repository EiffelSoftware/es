setlocal
:: svn cat for the ISE repository
set l_path=%1
shift
set l_dest=%1
shift
call %INIT_DIR%\svn_command.bat cat -r %ISE_SVN_REVISION% %DEFAULT_ISE_SVN%/%l_path% %$  > %l_dest%

endlocal
