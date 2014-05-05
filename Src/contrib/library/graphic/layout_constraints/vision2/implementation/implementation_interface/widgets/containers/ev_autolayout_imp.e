note
	description: "Summary description for {EV_AUTOLAYOUT_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_AUTOLAYOUT_IMP

inherit
	EV_AUTOLAYOUT_I
		undefine
			propagate_foreground_color,
			propagate_background_color,
			extend_with_position_and_size,
			set_item_position_and_size
		redefine
			interface,
			make
		end

	EV_FIXED_IMP
		undefine
			extend
		redefine
			interface,
			make
		end

create
	make

feature {NONE} -- Implementation

	make
			-- Initialize `Current'.
		do
			Precursor {EV_FIXED_IMP}
			Precursor {EV_AUTOLAYOUT_I}
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_AUTOLAYOUT note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
