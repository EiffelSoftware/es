@echo off
rem
rem	<description>
rem		description: "Entry point to the automatic build script, for use on windows machines"
rem		author: "bherlig, es-make Project Team, ETH Zurich"
rem	</description>
rem


rem common definitions
set find_bin=%SYSTEMROOT%\system32\find

rem checking for find.exe
%FIND_BIN% 2> NUL:
if not %ERRORLEVEL%==2 goto find_error

rem checking for geant
geant nonexistingtarget 2> NUL:
if not %ERRORLEVEL%==1 goto geant_error

rem **********************************************************************
rem ATTENTION
rem 
rem win2000 needs reg.exe from the support_tools on the win2k cd to be installed!
rem or get it from here:
rem		http://www.dynawell.com/reskit/microsoft/win2000/reg.zip
rem **********************************************************************

rem checking for reg.exe
reg > tmp
%FIND_BIN% /C "Microsoft" tmp > NUL:
if %ERRORLEVEL%==1 goto reg_error
del tmp

rem version switch
ver > tmp
%FIND_BIN% /C "2000" tmp > NUL:
if %ERRORLEVEL%==0 goto reg_val_win2k
goto reg_val_xp

:reg_val_xp
rem get env-vars from registry
del tmp
reg query HKEY_LOCAL_MACHINE\SOFTWARE\ISE\Eiffel60 2> NUL: | %FIND_BIN% "REG_SZ" > keys.txt
for /f "tokens=1,2*" %%a in (keys.txt) do set %%a=%%c
del keys.txt
goto command_switch

:reg_val_win2k
del tmp
rem get env-vars from registry
reg query HKEY_LOCAL_MACHINE\SOFTWARE\ISE\Eiffel60 | %FIND_BIN% "REG_SZ" > keys.txt
for /f "tokens=1,2*" %%a in (keys.txt) do set %%b=%%c
del keys.txt
goto command_switch

:command_switch
if .%1. == .. goto usage
geant %1 %2 %3 %4 %5 %6
goto end

:usage
echo usage:
echo    make.bat [defines ...] target
echo.
geant help
goto end
	
:find_error
echo ===============================================================================
echo ERROR: find.exe not found.
echo.
echo Make sure that Windows find.exe is in your PATH. Also, make sure that Cygwin
echo find.exe is not in your path first.
echo ===============================================================================
goto end

:geant_error
del tmp
echo ===============================================================================
echo ERROR: geant not found.
echo.
echo You can compile geant from precompiled c code, for example by calling
echo cl library\gobo\src\geant\geant.c
echo.
echo Make sure to add the binary to your PATH afterwards
echo ===============================================================================
goto end

:reg_error
del tmp
echo ===============================================================================
echo ERROR: Reg.exe is not installed. 
echo.
echo If you are using Windows 2000, please install it from the Windows 2000 Support 
echo Tools (from the Install CD), or download it from here: 
echo http://www.dynawell.com/reskit/microsoft/win2000/reg.zip 
echo.
echo If you are using Windows XP and beyond, make sure that it is in your PATH
echo ===============================================================================
goto end

:end
set find_bin=
echo.

