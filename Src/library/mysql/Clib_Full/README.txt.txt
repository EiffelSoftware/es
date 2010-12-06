To compile external C files for this mysql library:

On Windows
1. Install MySQL connector for C from http://dev.mysql.com/downloads/connector/c/ into %ISE_EIFFEL%\library\mysql\Clib_Full\connector-win
2. In %ISE_EIFFEL%\library\mysql\Clib_Full, run "compile_library.bat".

On Linux
1. Install MySQL connector for C in usual place. that is:
   /usr/include/mysql for header files,
   /usr/lib for libraries.

2. In %ISE_EIFFEL%\library\mysql\Clib_Full, run "finish_freezing -library".


