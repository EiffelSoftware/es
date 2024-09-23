setlocal
:: checkout for the EiffelStudio repository
set l_rec="no" 
if "%1" EQU "-N" set l_rec="yes"
if "%1" EQU "-N" shift

set l_path=%1
shift
set l_dest=%~dpnx1
shift

set dir=%SCM_DIR%\repo-es
call %INIT_DIR%\inc\aliases\get_es.bat "%dir%"
set dir=%SCM_DIR%\repo-es\%l_path%

if not exist "%dir%" goto NOT_FOUND

if %l_rec% EQU "yes" goto REC
goto NOT_REC

goto EOF

:REC
:: Hopefully the files are not modified		
	mkdir "%l_dest%"
	COPY "%dir%\*" "%l_dest"\. 
goto EOF

:NOT_REC
:: FIXME jfiat [2024/09/23] : link or copy?
:: mklink /J "%l_dest%"  "%dir%\"
	XCOPY /Y /E /I "%dir%\" "%l_dest%\"
goto EOF

:NOT_FOUND
	echo "Checkout %l_path% [NOT FOUND] directory %dir%" is missing
goto EOF

:EOF
endlocal
