/*
indexing
description: "WEL: library of reusable components for Windows."
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

#ifndef __WEL_ENUMMONITOR__
#define __WEL_ENUMMONITOR__

#ifndef __WEL__
#	include "wel.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif


#ifndef EIF_IL_DLL
typedef void (* EIF_ENUM_MONITOR_PROCEDURE) (
	EIF_OBJ,     /* WEL_MONITOR_ENUMERATOR Eiffel object */
#else
typedef void (bool * EIF_ENUM_MONITOR_PROCEDURE) (
#endif
	 EIF_POINTER, /* handle to display monitor * */
	 EIF_POINTER, /* handle to monitor DC * */
	 EIF_POINTER, /* monitor intersection rectangle */
	 EIF_POINTER  /* data */
	 );

#ifdef __cplusplus
}
#endif


#ifndef __WEL_GLOBALS__
#	include "wel_globals.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif


/* Eiffel routine signature for `converter' */
bool CALLBACK cwel_enum_monitor_procedure (HMONITOR, HDC, LPRECT, LPARAM);

#ifdef EIF_THREADS

	extern void wel_set_enum_monitor_procedure_address(EIF_POINTER _addr_);
#	define cwel_set_enum_monitor_procedure_address(_addr_)  (wel_set_enum_monitor_procedure_address(_addr_))
		/* Set `wwel_enum_monitor_procedure' with `addr' */
	
	extern void wel_set_monitor_enumerator_object(EIF_POINTER _addr_);
#	define cwel_set_monitor_enumerator_object(_addr_)  (wel_set_monitor_enumerator_object(_addr_))
		/* Set `monitor_enumerator' with `addr' */
		
	extern EIF_REFERENCE wel_release_font_family_enumerator_object() ;
#	define cwel_release_monitor_enumerator_object (wel_release_monitor_enumerator_object ())
		/* Release `monitor_enumerator' with `addr' */
		
#else

#	define cwel_set_enum_monitor_procedure_address(_addr_) (wel_enum_monitor_procedure = (EIF_ENUM_MONITOR_PROCEDURE) _addr_)
		/* Set `wel_enum_monitor_procedure' with `addr' */

#	define cwel_set_monitor_enumerator_object(_addr_) (monitor_enumerator = eif_adopt ((EIF_OBJ) _addr_))
		/* Set `monitor_enumerator' with `addr' */

#	define cwel_release_monitor_enumerator_object (eif_wean (monitor_enumerator))
		/* Release `monitor_enumerator' with `addr' */

#endif

#ifdef __cplusplus
}
#endif

#endif /* __WEL_ENUMMONITOR__ */
