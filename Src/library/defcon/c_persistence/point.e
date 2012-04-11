indexing
	description: "Wrapper class for struct Point"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	POINT

create
	make,
	make_with_x_y

feature {NONE} -- Initlization

	make is
			-- Creation method
		do
			create  internal_item.make (structure_size)
		end

	make_with_x_y (a_x, a_y : INTEGER) is
			-- Initlialize Current with `a_x' and `a_y'.
		do
			make
			set_x (a_x)
			set_y (a_y)
		end

feature -- Command

	set_x (a_x: INTEGER) is
			-- Set `x' with `a_x'.
		do
			c_set_x (item, a_x)
			x := a_x
		ensure
			set: x = a_x
		end

	set_y (a_y: INTEGER) is
			-- Set `y' with `a_y'.
		do
			c_set_y (item, a_y)
			y := a_y
		ensure
			set: y = a_y
		end

feature -- Query

	structure_size: INTEGER is
			-- Size of Current structure.
		do
			Result := c_size_of_point
		end

	x: INTEGER
			-- x position

	y: INTEGER
			-- y position

	item: POINTER is
			-- Pointer to C struct
		do
			Result := internal_item.item
		ensure
			not_null: Result /= default_pointer
		end

feature {NONE} -- Implementation

	internal_item: MANAGED_POINTER
			-- Managed pointer to the struct.

feature {NONE} -- C externals

	c_size_of_point: INTEGER is
			-- Point struct size.
		external
			"C [macro %"point.h%"]"
		alias
			"sizeof (Point)"
		end

	c_set_x (a_item: POINTER; a_x: INTEGER) is
			-- Set `a_item''s x with `a_x'
		external
			"C inline use %"point.h%""
		alias
			"[
			{
				((Point *)$a_item)->x = (EIF_INTEGER)$a_x;
			}
			]"
		end

	c_set_y (a_item: POINTER; a_y: INTEGER) is
			-- Set `a_item''s y with `a_y'
		external
			"C inline use %"point.h%""
		alias
			"[
			{
				((Point *)$a_item)->y = (EIF_INTEGER)$a_y;
			}
			]"
		end

	c_x (a_item: POINTER): INTEGER is
			-- `a_item''s x
		external
			"C inline use %"point.h%""
		alias
			"[
				((Point *)$a_item)->x
			]"
		end

	c_y (a_item: POINTER): INTEGER is
			-- `a_item''s y
		external
			"C inline use %"point.h%""
		alias
			"[
				((Point *)$a_item)->y
			]"
		end

end
