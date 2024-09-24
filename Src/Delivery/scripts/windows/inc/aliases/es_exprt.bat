setlocal
echo Export from EiffelStudio repository : %*
:: export for the EiffelStudio repository
set l_rec="no" 
if "%1" EQU "-N" set l_rec="yes"
if "%1" EQU "-N" shift
set l_path=%1
shift
set l_dest=%~dpnx1
shift
echo DEST=%l_dest%

set dir=%SCM_DIR%\repo-es
call %INIT_DIR%\inc\aliases\get_es.bat "%dir%" 
set dir=%SCM_DIR%\repo-es\%l_path%
if not exist "%dir%" goto NOT_FOUND
if %l_rec% EQU "yes" goto REC
goto NOT_REC

:REC
:: Hopefully the files are not modified		
	mkdir "%l_dest%"
	COPY "%dir%\*" "%l_dest"\. 
goto EOF

:NOT_REC
:: Note: even if the local files are modified, git archive gets the not modified files and dirs
	set PREC_CWD=%CD%
	cd "%dir%"

	mkdir "%l_dest%"
	git archive --format="tar" %DEFAULT_ES_BRANCH% > %l_dest%.tar 
	cd %l_dest%
	tar -xf %l_dest%.tar
	rm %l_dest%.tar
	cd %PREC_CWD%
	unset PREC_CWD
goto EOF

:NOT_FOUND
	echo "Export %l_path% [NOT FOUND] directory %dir%" is missing 
	echo "Checkout %l_path% [NOT FOUND] directory %dir%" is missing
goto EOF

:EOF
endlocal
