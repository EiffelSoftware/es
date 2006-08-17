indexing
	description:
		"Eiffel Vision tooltipable. GTK+ implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "tooltip, popup"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_TOOLTIPABLE_IMP

inherit
	EV_TOOLTIPABLE_I
		redefine
			interface
		end

	EV_ANY_IMP
		undefine
			needs_event_box,
			destroy
		redefine
			interface
		end

feature -- Initialization

	tooltip: STRING_32 is
			-- Tooltip that has been set.
		do
			create Result.make_empty
		end

feature -- Element change

	set_tooltip (a_text: STRING_GENERAL) is
			-- Set `tooltip' to `a_text'.
		local
			hmrect: HMHELP_CONTENT_REC_STRUCT
			hm_rect : HMHELP_CONTENT_REC_STRUCT
			hm: HMHELP_CONTENT_STRUCT
		do
			create hm_rect.make_new_unshared
			create hm.make_new_unshared
		

		end

feature {NONE} -- Implementation

	tooltips_pointer: POINTER is
			-- Pointer to the tooltips pointer
		do
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_TOOLTIPABLE;

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




end -- EV_TOOLTIPABLE_IMP

