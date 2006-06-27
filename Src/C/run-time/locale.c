/*
	description: "Routines for retrieving and manipulating locales."
	author:		"i18n Team, ETH Zurich"
	date:		"$Date$"
	revision:	"$Revision$"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
*/

/*
doc:<file name="locale.c" header="eif_locale.h" version="$Id$" summary="Externals for locales handling">
*/

#ifdef EIF_WINDOWS
#include <windows.h>
#endif

#include "eif_locale.h"


/*
**  This makes sense only on windows, returns the locale's code.
**  on other platforms always returns English.
*/
rt_public EIF_NATURAL_32 locale_getUserDefaultLCID (void)
{
#ifdef EIF_WINDOWS
	return GetUserDefaultLCID();
#else
	return 0x09;
#endif
}


/*
doc:</file>
*/
