/*
indexing
	description: "Functions used by the class WEL_FONT_FAMILY_ENUMERATOR."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
*/

#include "wel_globals.h"

#ifndef EIF_THREADS
	EIF_ENUM_MONITOR_PROCEDURE wel_enum_monitor_procedure = NULL;
	/* Address of the Eiffel routine `converter' (class WEL_MONITOR_ENUMERATOR ) */
	
	EIF_OBJ monitor_enumerator = NULL;
	/* Address of the Eiffel object WEL_MONITOR_ENUMERATOR created */
#endif

int CALLBACK cwel_enum_font_fam_procedure (HMONITOR hmonitor, HDC hdcMonitor, LPRECT lprcMonitor, LPARAM dwData)
{
	/*
	 * This function is called by Windows for each monitor beeing part of the virtual screen.
	 * The Eiffel routine `convert' of the class WEL_MONITOR_ENUMERATOR
	 * is called for each monitor.
	 * -- PK.
	 */

	WGTCX
	if (monitor_enumerator)
	{
		((wel_enum_monitor_procedure) (
#ifndef EIF_IL_DLL
			(EIF_OBJECT) eif_access (monitor_enumerator),
#endif
			(EIF_POINTER) hmonitor,
			(EIF_POINTER) hdcMonitor,
			(EIF_POINTER) lprcMonitor,
			(EIF_POINTER) dwData));
		return 1; /* Continue the enumeration. */
	}
	else
	{
		return 0; /* Stop the enumeration. */
	}

	WEDCX
}

#ifdef EIF_THREADS

void wel_set_enum_monitor_procedure_address(EIF_POINTER _addr_)
{
		WGTCX
		wel_enum_monitor_procedure = (EIF_ENUM_MONITOR_PROCEDURE) _addr_;
}

void wel_set_monitor_enumerator_object(EIF_POINTER _addr_)
{
		WGTCX
		monitor_enumerator = eif_adopt ((EIF_OBJ) _addr_);
}

EIF_REFERENCE wel_release_monitor_enumerator_object ()
{
		WGTCX
		return eif_wean (monitor_enumerator);
}


#endif
