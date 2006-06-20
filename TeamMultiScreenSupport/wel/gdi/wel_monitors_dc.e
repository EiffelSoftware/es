indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEL_MONITORS_DC

inherit
	WEL_DISPLAY_DC

	WEL_MONITOR_ENUMERATOR
		rename
			make as enumerate_monitors,
			dispose as dispose_enumerator
		select
			dispose_enumerator
		end

create
	make

feature {NONE} -- Initialization

	make is
			-- create allmonitors_dc
		do
			create allmonitors_dc.make (monitorcount)
		end

feature -- Basic operations

	get is
			-- get primary monitor DC
		local
			a_default_pointer: POINTER
		do
			if item = a_default_pointer then
				item := cwin_get_dc (a_default_pointer)
			end
		end


	get_n(n: INTEGER) is
			-- Get the device context of monitor n
		local
			a_default_pointer: POINTER
		do
			enumerate_monitors
			if item = a_default_pointer then
				item := allmonitors_dc[n]
			end
		end

	release is
			-- Release the device context
		local
			a_default_pointer: POINTER
		do
			if item /= a_default_pointer then
				unselect_all
				cwin_release_dc (a_default_pointer, item)
				item := a_default_pointer
			end
		end

	quick_release is
			-- Release the device context
		local
			a_default_pointer: POINTER
		do
			if item /= a_default_pointer then
				cwin_release_dc (a_default_pointer, item)
				item := a_default_pointer
			end
		end

feature {NONE} --Implementation

	allmonitors_dc: ARRAYED_LIST [POINTER]
			-- list of pointers to monitor device context

	action (hMonitor, hDC, lprect, data: POINTER) is
			-- Called for each Monitor
		do
			if not allmonitors_dc.has(hDC) then
				allmonitors_dc.extend(hDC)
			end
		end

	monitorcount: INTEGER is
			-- count of monitors in system
		local
			l_metrics: WEL_SYSTEM_METRICS
		do
			create l_metrics
			Result := l_metrics.monitor_count
		end

invariant
	invariant_clause: True -- Your invariant here

end
