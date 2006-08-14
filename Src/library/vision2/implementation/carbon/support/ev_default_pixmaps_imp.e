indexing
	description	: "Facilities for accessing default pixmaps."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords	: "pixmap, default"
	date		: "$Date$"
	revision	: "$Revision$"

class
	EV_STOCK_PIXMAPS_IMP

feature -- Access

	Information_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing a piece of information.
		do
		end

	Error_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing an error.
		do
		end

	Warning_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing a warning.
		do
		end

	Question_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing a question.
		do
			create Result.default_create
		end

	Collate_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing collated printing.
		do
		end

	No_collate_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing non collated printing.
		do
		end

	Landscape_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing landscape printing.
		do
		end

	Portrait_pixmap: EV_PIXMAP is
			-- Pixmap symbolizing portrait printing.
		do
		end

	Default_window_icon: EV_PIXMAP is
			-- Pixmap used as default icon for new windows.
		do
			create Result.default_create
		end

feature -- Default cursors

	Busy_cursor: EV_CURSOR is
			-- Standard arrow and small hourglass
		do
		end

--	busy_cursor_bits: ARRAY [INTEGER_8] is
--			--
--		do
--		end
--
--	busy_cursor_mask: ARRAY [INTEGER_8] is
--			--
--		do
--		end

	Standard_cursor: EV_CURSOR is
			-- Standard arrow
		do
		end

	Crosshair_cursor: EV_CURSOR is
			-- Crosshair
		do
		end

	Help_cursor: EV_CURSOR is
			-- Arrow and question mark
		do
		end

	Ibeam_cursor: EV_CURSOR is
			-- I-beam
		do
		end

	No_cursor: EV_CURSOR is
			-- Slashed_circle
		do
		end

	Sizeall_cursor: EV_CURSOR is
			-- Four-pointed arrow pointing north, south, east and west
		do
		end

	Sizens_cursor: EV_CURSOR is
			-- Double-pointed arrow pointing north and south
		do
		end

	Sizenwse_cursor: EV_CURSOR is
			-- Double-pointed arrow pointing north-west and south-east
		do
		end

	Sizenesw_cursor: EV_CURSOR is
			-- Double-pointed arrow pointing north-east and south-west
		do
		end

	Sizewe_cursor: EV_CURSOR is
			-- Double-pointed arrow pointing west and east
		do
		end

	Uparrow_cursor: EV_CURSOR is
			-- Vertical arrow
		do
		end

	Wait_cursor: EV_CURSOR is
			-- Hourglass
		do
		end

indexing
	copyright:	"Copyright (c) 2006, The Eiffel.Mac Team"
end -- class EV_STOCK_PIXMAPS_IMP

