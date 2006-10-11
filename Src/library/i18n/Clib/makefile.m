AR = lib 
CC = cl
CFLAGS= -W3 -nologo -MT -Ox -I$(ISE_EIFFEL)\studio\spec\$(ISE_PLATFORM)\include -I..\include
LN = copy
MAKE = make
RANLIB = echo
RM = -del

SOURCES =  $(LSRCS)
OBJECTS =  $(OBJS) $(WOBJS)

all:: clean nls_locale.lib

.c.obj:
	$(CC) -c $(CFLAGS) $<

SMODE = nls_locale.c

LSRCS = $(SMODE)

OBJS = \
	nls_locale.obj

clean:
	-del *.obj

net.lib: $(OBJS)
	$(RM) $@
	$(AR) -OUT:$@ $(OBJS)
	$(RANLIB) $@
	if not exist ..\spec mkdir ..\spec
	if not exist ..\spec\$(ISE_PLATFORM) mkdir ..\spec\$(ISE_PLATFORM)
	if not exist ..\spec\$(ISE_PLATFORM)\lib mkdir ..\spec\$(ISE_PLATFORM)\lib
	if not exist ..\spec\$(ISE_PLATFORM)\lib\msc mkdir ..\spec\$(ISE_PLATFORM)\lib\msc
	copy $@ ..\spec\$(ISE_PLATFORM)\lib\bcb\$@
