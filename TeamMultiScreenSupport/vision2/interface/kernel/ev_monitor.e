indexing
	description: "add multi-screen awarness to EV_SCREEN"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "screen, root, window, visual, top"
	date: "$Date$"
	revision: "$Revision: 59442 $"

class
	EV_MONITOR

inherit
	EV_ANY
		redefine
			implementation
		end

create
	make

feature {NONE}

	make (n: INTEGER) is
			-- create monitor object and set monitor_number
		require
			n_positive: n>=0
		do
			default_create
			monitor_number := n
		end

feature -- access

	get_monitor_position: EV_COORDINATE is
			-- returns the position of the monitor in the screen
		do
			result := implementation.get_monitor_position
		end



feature -- Measurement

	width: INTEGER is
			-- Horizontal size in pixels.
		do
			result := implementation.width

		end

	height: INTEGER is
			-- Vertical size in pixels.
		do
			result := implementation.height
		end

feature {EV_ANY, EV_ANY_I, EV_MONITOR_I} -- Implementation

	monitor_number: INTEGER

	implementation: EV_MONITOR_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	create_implementation is
			-- See `{EV_ANY}.create_implementation'.
		do
			create {EV_MONITOR_IMP} implementation.make (Current)
		end



invariant
	monitor_number_positive: monitor_number >= 0

end
