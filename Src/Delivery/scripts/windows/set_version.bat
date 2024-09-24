@echo off
rem Set Version
rem %1 : wc path
rem %2 : 0000
rem %3 : filename.e
setlocal
set WCT=%1
set REVVAL=%2
set EFILE=%3
set EFILE_TMP=%EFILE%.tmp
set LC_MESSAGES=C

set T_CWD=%CD%
cd %WCT%
FOR /F "tokens=* USEBACKQ" %%F IN (`git rev-list HEAD ^| wc -l`) DO (
SET BUILDNUMBER=%%F
)
FOR /F "tokens=* USEBACKQ" %%F IN (`git rev-parse HEAD`) DO (
SET BUILDSHA1=%%F
)
:: ECHO BUILDNUMBER=%BUILDNUMBER%
if .%BUILDNUMBER%. == .. set BUILDNUMBER=%REVVAL% -- Script was unable to set this value

if .%EFILE%. == .. GOTO DISPLAY_BUILD_ID

for /f %%x in ('wmic path win32_utctime get /format:list ^| findstr "="') do set %%x
 IF %month% LSS 10 SET month=0%month%
 IF %day% LSS 10 SET day=0%day%
 IF %hour% LSS 10 SET hour=0%hour%
 IF %minute% LSS 10 SET minute=0%minute%
 IF %second% LSS 10 SET second=0%second%
set CURRDATE=%Year%-%Month%-%Day%
set CURRTIME=%hour%:%minute%:%second%

echo Set build number: BUILDNUMBER=%BUILDNUMBER%
git checkout -- %EFILE%
sed -e "s/:= 0000/:= %BUILDNUMBER%/" %EFILE% > %EFILE_TMP%
move %EFILE_TMP% %EFILE%

rem update the version_info ...
sed -e "s/Version_info:\ STRING\ =\ \"[0-9a-zA-Z_\,\ \/\:()\.\=\-]*\"/Version_info:\ STRING\ =\ \"Build:\ %BUILDNUMBER% (%BUILDSHA1%) , Compilation:\ %CURRDATE%\ %CURRTIME%\"/g" %EFILE% > %EFILE_TMP%
move %EFILE_TMP% %EFILE%
goto END

:DISPLAY_BUILD_ID
echo %BUILDNUMBER%
goto END

:END
cd %T_CWD%
endlocal
@echo on

