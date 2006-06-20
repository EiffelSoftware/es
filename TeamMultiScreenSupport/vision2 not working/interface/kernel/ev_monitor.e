indexing
	description: "add multi-screen awarness to EV_SCREEN"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "screen, root, window, visual, top"
	date: "$Date$"
	revision: "$Revision: 59442 $"

class
	EV_MONITOR

--inherit
--	EV_SCREEN
--	  redefine
--	  	width,
--	  	height,
--	  	vertical_resolution,
--	  	horizontal_resolution
--	  end

create
	default_create

feature -- Conversion

	 monitor_at_position (pos: EV_COORDINATE): INTEGER is
	 		-- get the Monitor number on which pos is.
	 	do

	 	end

	 get_global_coordinate (pos: EV_COORDINATE; screen_nr: INTEGER): EV_COORDINATE is
	 		-- convert local coordinate pos and screen_nr to global coordinate in virtual-screen.
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

	vertical_resolution: INTEGER is
			-- Number of pixels per inch along screen height.
		do

		end

	horizontal_resolution: INTEGER is
			-- Number of pixels per inch along screen width.
		do

		end


feature {NONE} -- Implementation


invariant
	invariant_clause: True -- Your invariant here

end
