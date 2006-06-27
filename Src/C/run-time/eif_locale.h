/*
	description: "Declaration of public locales functions."
	author:		"i18n Team, ETH Zurich"
	date:		"$Date$"
	revision:	"$Revision$"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
*/

#ifndef _eif_locale_h_
#define _eif_locale_h_

#include "eif_eiffel.h"

#ifdef __cplusplus
extern "C" {
#endif

RT_LNK EIF_NATURAL_32 locale_getUserDefaultLCID (void);
	/* This makes sense only on windows, returns the locale's code.
		on other platforms always returns English. */

#ifdef __cplusplus
}
#endif

#endif /* _eif_locale_h_ */
