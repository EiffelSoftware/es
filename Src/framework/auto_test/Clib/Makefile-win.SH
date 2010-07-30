TOP = ..
DIR = $dir_sep
OUTDIR= .
INDIR= .
CC = $cc
OUTPUT_CMD = $output_cmd
CFLAGS = -I"$rt_include" -I..$(DIR)spec$(DIR)include -I. \
	-I..$(DIR)..$(DIR)..$(DIR)C_library$(DIR)libpng  -I..$(DIR)..$(DIR)..$(DIR)C_library$(DIR)zlib
JCFLAGS = $(CFLAGS) $ccflags $optimize
JMTCFLAGS = $(CFLAGS) $mtccflags $optimize
JILCFLAGS = $(CFLAGS) $mtccflags $optimize -DEIF_IL_DLL
LN = copy
MV = $mv
RM = RD /S /Q
DEL = del
MKDIR = $mkdir
LINK = $link32
DLL_FLAGS = $dll_flags
DLL_LIBS = $dll_libs
CD = cd
CP = copy

all:: lib_dir build_lpsolve_$(ISE_PLATFORM)
	$(MAKE) clean

build_lpsolve_windows:
	$(CD) lp_solve$(DIR)lpsolve55
	CALL cvc8NOmsvcrt.bat	
	$(CD) ..$(DIR)..$(DIR)
	$(MV) lp_solve$(DIR)lpsolve55$(DIR)bin$(DIR)win32$(DIR)* ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)$(DIR)lib$(DIR)

build_lpsolve_win64:
	$(CD) lp_solve$(DIR)lpsolve55
	CALL cvc8NOmsvcrt.bat	
	$(CD) ..$(DIR)..$(DIR)
	$(MV) lp_solve$(DIR)lpsolve55$(DIR)bin$(DIR)win64$(DIR)* ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)$(DIR)lib$(DIR)
	
lib_dir: ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)$(DIR)lib


..$(DIR)spec:
	$(MKDIR) ..$(DIR)spec

..$(DIR)spec$(DIR)$(ISE_C_COMPILER): ..$(DIR)spec
	$(MKDIR) ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)

..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM): ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)
	$(MKDIR) ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)

..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)$(DIR)lib: ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)
	$(MKDIR) ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)$(DIR)lib
	
..$(DIR)spec$(DIR)include: ..$(DIR)spec
	$(MKDIR) ..$(DIR)spec$(DIR)include

clean:
	$(RM) lp_solve$(DIR)lpsolve55$(DIR)bin
	$(DEL) lp_solve$(DIR)lpsolve55$(DIR)lpsolve.RES
