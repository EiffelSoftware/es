set ISE_C_COMPILER=msc
set ISE_PLATFORM=win64
set ISE_EIFFEL=%CD%
set ISE_LIBRARY=%ISE_EIFFEL%
set ISE_PRECOMP=%ISE_EIFFEL%\precomp\spec\win64
set PATH=%ISE_EIFFEL%\studio\tools\boogie;%ISE_EIFFEL%\studio\spec\%ISE_PLATFORM%\bin;%PATH%

start ec.exe -gui
