@echo off
if .%1. == .. (
set DELIV_DIR=%EIFFEL_SRC%\Delivery
) else (
set DELIV_DIR=%1
)

REM Check out bitmaps from Build delivery
XCOPY /Y /E /I  %DELIV_DIR%\esbuilder\bitmaps _Delivery_esbuilder_bitmaps

REM Check out files from vision2_demo
XCOPY /Y /E /I  %DELIV_DIR%\vision2_demo _Delivery_vision2_demo

REM Copy template files
XCOPY /Y /E /I _Delivery_vision2_demo\templates .\templates

REM Copy icons for different widget types across. The /E option moves the whole directory structure.
XCOPY /Y /E /I _Delivery_esbuilder_bitmaps .\bitmaps

REM Copy icons for standard buttons.
XCOPY /Y _Delivery\vision2_demo\bitmaps\ico\documentation.ico .\bitmaps\ico\
XCOPY /Y _Delivery\vision2_demo\bitmaps\ico\testing.ico .\bitmaps\ico\
XCOPY /Y _Delivery\vision2_demo\bitmaps\ico\properties.ico .\bitmaps\ico\
XCOPY /Y _Delivery\vision2_demo\bitmaps\ico\size_down.ico .\bitmaps\ico\
XCOPY /Y _Delivery\vision2_demo\bitmaps\ico\size_up.ico .\bitmaps\ico\
XCOPY /Y _Delivery\vision2_demo\bitmaps\png\image1.png .\bitmaps\png\
XCOPY /Y _Delivery\vision2_demo\bitmaps\png\image2.png .\bitmaps\png\

REM Copy image used for executable icon.

XCOPY /Y %EIFFEL_SRC%\library\vision2\Clib\default_vision2_icon.ico .
ren default_vision2_icon.ico vision2_demo.ico


REM Remove all temporary checked out files.
rd /Q /S _Delivery
