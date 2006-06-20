indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WEL_MONITOR_ENUMERATOR

inherit
	DISPOSABLE

feature {NONE} -- Initialization

	make is
			-- Enumerate the Monitors in the system
		do
			cwel_set_enum_monitor_procedure_address($action)
			cwel_set_monitor_enumerator_object (Current)
			enumerate
			cwel_set_enum_monitor_procedure_address (default_pointer)
			cwel_set_monitor_enumerator_object (default_pointer)
		end

feature -- Basic operations

	action (hMonitor, hDC, lprect, data: POINTER) is
			-- Called for each monitor
		deferred
		end

	init_action is
			-- Called before the enumeration.
			-- May be redefined to make special operations.
		do
		end

	finish_action is
			-- Called after the enumeration.
			-- May be redefined to make special operations
		do
		end

feature {NONE} -- Implementation

	enumerate is
			-- enumerate all monitors in system
		local
			a_default_pointer: POINTER
		do
			init_action
			cwin_enum_monitor (a_default_pointer, a_default_pointer, cwel_enum_monitor_procedure, a_default_pointer)
			finish_action
		end

feature {NONE} -- Memory management

	dispose is
			--
		do
			cwel_release_monitor_enumerator_object
		end

feature {NONE} -- Externals

	cwel_set_enum_monitor_procedure_address (address: POINTER) is
		external
			"C [macro %"enummonitor.h%"]"
		end

	cwel_set_monitor_enumerator_object (object: ANY) is
		external
			"C [macro %"enummonitor.h%"]"
		end

	cwel_release_monitor_enumerator_object is
		external
			"C [macro %"enummonitor.h%"]"
		end

	cwel_enum_monitor_procedure: POINTER is
		external
			"C [macro %"enummonitor.h%"]"
		end

	cwin_enum_monitor (hdc, lprcClip, enum_proc, dwData: POINTER) is
			-- SDK EnumFontFamilies
		external
			"C [macro %"enummonitor.h%"] (NULL, NULL, MONITORENUMPROC, 0)"
		alias
			"EnumDisplayFamilies"
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end
