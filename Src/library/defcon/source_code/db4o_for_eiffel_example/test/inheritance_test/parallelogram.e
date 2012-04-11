indexing
	description: "Two-dimensional parallelograms"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	PARALLELOGRAM

create
	make

feature {NONE}  -- Initialization

	make (h1: INTEGER; h2: INTEGER) is
			-- Initialize `height1' with `h1' and `height2' with `h2'.
		require
			h1_positive: h1 > 0
			h2_positive: h2 > 0
		do
			height1 := h1
			height2 := h2
		end

feature  -- Status report

	h1_plus_h2_greater_than (v: INTEGER): BOOLEAN is
			-- Is `height1+height2' greater than `v'?
			-- Used as an agent in a Native Query
		do
			Result := (height1 + height2) > v
		end

feature  -- Print

	to_eiffel_string: STRING is
			-- `STRING' representation of `Current'
		local
			obj: SYSTEM_OBJECT
		do
			obj ?= Current
			Result := obj.get_type.name + " (" + height1.out + ", " + height2.out + ")"
		end

feature  -- Access

	height1: INTEGER
	height2: INTEGER

end
