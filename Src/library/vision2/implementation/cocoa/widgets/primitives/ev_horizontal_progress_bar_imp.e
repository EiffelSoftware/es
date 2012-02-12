note
	description: "EiffelV ision horizontal progress bar. Cocoa implementation."
	author:	"Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_HORIZONTAL_PROGRESS_BAR_IMP

inherit
	EV_HORIZONTAL_PROGRESS_BAR_I
		redefine
			interface
		end

	EV_PROGRESS_BAR_IMP
		redefine
			interface,
			minimum_height,
			minimum_width
		end

create
	make

feature {NONE} -- Implementation

	minimum_height: INTEGER
			-- Minimum height that the widget may occupy.
		do
			Result := 15 -- Hardcoded
		end

	minimum_width: INTEGER
			-- Minimum width that the widget may occupy.
		do
			Result := 150 -- Hardcoded
		end


feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_HORIZONTAL_PROGRESS_BAR note option: stable attribute end;

end -- class EV_HORIZONTAL_PROGRESS_BAR_IMP
