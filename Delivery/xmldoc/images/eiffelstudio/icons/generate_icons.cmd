rd /s /q 10x10
rd /s /q 12x12
rd /s /q 16x16
rd /s /q cursors
mkdir 10x10
mkdir 12x12
mkdir 16x16
mkdir cursors
set PNGDIR="%EIFFEL_SRC%/Delivery/studio/bitmaps/png/"
emcgen -slice "%PNGDIR%/10x10.png" "%PNGDIR%/10x10.ini" -pngs 10x10
emcgen -slice "%PNGDIR%/12x12.png" "%PNGDIR%/12x12.ini" -pngs 12x12
emcgen -slice "%PNGDIR%/16x16.png" "%PNGDIR%/16x16.ini" -pngs 16x16
emcgen -slice "%PNGDIR%/cursors.png" "%PNGDIR%/cursors.ini" -pngs cursors