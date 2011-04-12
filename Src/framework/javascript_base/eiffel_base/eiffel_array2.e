note
	description : "JavaScript implementation of EiffelBase class ARRAY2."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"
	javascript  : "EiffelBase: ARRAY2"
class
	EIFFEL_ARRAY2 [G]

create
	make

feature {NONE} -- Initialization

	make (nb_rows, nb_columns: INTEGER)
		do
			create inner_array.make_empty
			height := 0
			resize (nb_rows, nb_columns)
		end

feature -- Basic Operation

	item (row, column: INTEGER): G
		do
			Result := (inner_array [row])[column]
		end

	put (v: G; row, column: INTEGER)
		do
			(inner_array [row]) [column] := v
		end

	resize (nb_rows, nb_columns: INTEGER)
		local
			i: INTEGER
			l_row: ARRAY[G]
		do
			from
				i := height + 1
			until
				i > nb_rows
			loop
				create l_row.make_empty
				inner_array [i] := l_row
				i := i + 1
			end
			height := nb_rows
			width := nb_columns
		end

	height: INTEGER
	width: INTEGER

feature {NONE} -- Implementation

	inner_array: attached ARRAY[attached ARRAY[G]]

end
