TOP = ..
DIR = $dir_sep
OUTDIR= .
INDIR= .
CC = $cc
OUTPUT_CMD = $output_cmd
CFLAGS = -I"$rt_include" -I. -I. /D_CRT_SECURE_NO_WARNINGS /wd4132 /wd4005 /wd4127
JCFLAGS = $(CFLAGS) $optimize $ccflags
JMTCFLAGS = $(CFLAGS) $optimize $mtccflags
JILCFLAGS = $(CFLAGS) $optimize $mtccflags  -DEIF_IL_DLL

LN = copy
MV = $mv
RM = $del
MAKE = $make
MKDIR = $mkdir
OBJECTS = eif_miniz_zip.$obj eif_miniz_unzip.$obj miniz.$obj
MT_OBJECTS = MTeif_miniz_unzip.$obj MTeif_miniz_unzip.$obj MTminiz.$obj
IL_OBJECTS = ILeif_miniz_unzip.$obj ILeif_miniz_unzip.$obj ILminiz.$obj

.c.$obj:
	$(CC) -c $(JCFLAGS) $<

all:: $output_libraries
	$(MAKE) clean

standard:: miniz.lib 
mtstandard:: mtminiz.lib

clean:
	$(RM) *.$obj
	$(RM) *.lib

miniz.lib: $(OBJECTS)
	$alib_line
	$(MKDIR) ..$(DIR)spec$(DIR)$(ISE_PLATFORM)$(DIR)$(ISE_C_COMPILER)$(DIR)lib
	$(MV) $@ ..$(DIR)spec$(DIR)$(ISE_PLATFORM)$(DIR)$(ISE_C_COMPILER)$(DIR)lib$(DIR)$@

mtminiz.lib: $(MT_OBJECTS)
	$alib_line
	$(MKDIR) ..$(DIR)spec$(DIR)$(ISE_PLATFORM)$(DIR)$(ISE_C_COMPILER)$(DIR)lib
	$(MV) $@ ..$(DIR)spec$(DIR)$(ISE_PLATFORM)$(DIR)$(ISE_C_COMPILER)$(DIR)lib$(DIR)$@

ilminiz.lib: $(IL_OBJECTS)
	$alib_line
	$(MKDIR) ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)$(DIR)lib
	$(MV) $@ ..$(DIR)spec$(DIR)$(ISE_C_COMPILER)$(DIR)$(ISE_PLATFORM)$(DIR)lib$(DIR)$@

miniz.$obj: miniz.c
	$(CC) $(JCFLAGS) $(OUTPUT_CMD)$@ -c $?

MTminiz.$obj: miniz.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $?

ILminiz.$obj: miniz.c
	$(CC) $(JILCFLAGS) $(OUTPUT_CMD)$@ -c $?

eif_miniz_zip.$obj: eif_miniz_zip.c
	$(CC) $(JCFLAGS) $(OUTPUT_CMD)$@ -c $?

MTeif_miniz_zip.$obj: eif_miniz_zip.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $?

ILeif_miniz_zip.$obj: eif_miniz_zip.c
	$(CC) $(JILCFLAGS) $(OUTPUT_CMD)$@ -c $?

eif_miniz_unzip.$obj: eif_miniz_unzip.c
	$(CC) $(JCFLAGS) $(OUTPUT_CMD)$@ -c $?

MTeif_miniz_unzip.$obj: eif_miniz_unzip.c
	$(CC) $(JMTCFLAGS) $(OUTPUT_CMD)$@ -c $?

ILeif_miniz_unzip.$obj: eif_miniz_unzip.c
	$(CC) $(JILCFLAGS) $(OUTPUT_CMD)$@ -c $?

