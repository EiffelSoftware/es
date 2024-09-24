@echo off
rem This is required to perform git commands because they may fails, so we repeat them
rem until they succeed.

set i=0
:start
if not "%i%"=="0" goto finish

git %*

if not errorlevel 1 set i=1
goto start
:finish
