indexing
	description: "Two-dimensional squares"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	SQUARE

inherit
	RECTANGLE
		rename
			width as side_length
		export
			{NONE} height
		select
			height, side_length
		end

	RHOMBUS
		export
			{NONE} height1, height2
		end

create
	make_with_side_length

feature
	make_with_side_length (sl: INTEGER) is
			-- Initialization
		require
			sl_positive: sl > 0
		do
			make (sl, sl)
			height1 := sl
			height2 := sl
		end

end
