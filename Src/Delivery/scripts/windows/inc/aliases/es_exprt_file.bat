setlocal
echo Export file from EiffelStudio repository : %*
:: export file content for the EiffelStudio repository

set l_path=%1
shift
set l_dest=%~dpnx1
shift

set dir=%SCM_DIR%\repo-es
call %INIT_DIR%\inc\aliases\get_es.bat "%dir%" 

if not exist "%dir%" goto NOT_FOUND

set PREC_CWD=%CD%
cd "%dir%"
git show HEAD:%l_path% > %l_dest%
cd %PREC_CWD%
unset PREC_CWD

goto EOF

:NOT_FOUND
	echo "Export %l_path% [NOT FOUND] directory %dir% is missing"
goto EOF

:EOF
endlocal
