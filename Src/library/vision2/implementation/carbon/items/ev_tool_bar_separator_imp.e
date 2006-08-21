indexing
	description:
		"Eiffel Vision tool bar separator. Implementation interface."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EV_TOOL_BAR_SEPARATOR_IMP

inherit
	EV_TOOL_BAR_SEPARATOR_I
		redefine
			interface
		end

	EV_ITEM_IMP
		redefine
			interface
		end

create
	make

feature {NONE} -- Initialization

	needs_event_box: BOOLEAN is False

	is_dockable: BOOLEAN is False

	make (an_interface: like interface) is
			-- Create the tool bar button.
		do
		end

feature {EV_ANY_I} -- Implementation

	interface: EV_TOOL_BAR_SEPARATOR;

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




end -- class EV_TOOL_BAR_SEPARATOR_I

