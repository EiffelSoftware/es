indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_MONITOR_IMP

inherit
	EV_MONITOR_I
	redefine
		interface
	end

create
	make


feature {NONE} -- init

	make (an_interface: like interface) is
			--
		do
		end


	initialize is
			--
		do

		end

feature -- access

	get_monitor_position: EV_COORDINATE is
			-- returns the position of the monitor in the screen
		do
		end

feature -- Status report

	destroyed: BOOLEAN is
			-- Is 'Current' destroyed?
		do

		end


feature -- Measurement

	width: INTEGER is
			-- Horizontal size in pixels.
		do
		end

	height: INTEGER is
			-- Vertical size in pixels.
		do
		end

feature -- status setting

	destroy is
			-- Destroy actual object
		do

		end


feature {NONE} -- Implementation

	interface: EV_MONITOR;


invariant
	invariant_clause: True -- Your invariant here

end
