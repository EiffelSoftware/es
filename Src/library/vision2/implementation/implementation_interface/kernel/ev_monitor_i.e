indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_MONITOR_I

inherit
	EV_ANY_I
		redefine
			interface
		end


feature -- access

	get_monitor_position: EV_COORDINATE is
			-- returns the position of the monitor in the screen
		deferred
		end

feature -- Measurement

	width: INTEGER is
			-- Horizontal size in pixels.
		deferred
		end

	height: INTEGER is
			-- Vertical size in pixels.
		deferred
		end

feature {NONE} -- Implementation

	monitor_number: INTEGER is
			-- get monitor_number
		do
			result := interface.monitor_number
		end


	interface: EV_MONITOR;


invariant
	invariant_clause: True -- Your invariant here

end
