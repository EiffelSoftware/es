note
	description: "Summary description for {MATRIX_ARRAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MATRIX_ARRAY

create
  make_with_content

feature
  -- FIXME: this should take the name of the input file to read from.
  -- So far it will not work as expected if it has to read input from 
  -- the  a file, for i.e., the tests.
  make_with_content (a_rows, a_cols: INTEGER; a_bench: BOOLEAN)
  	local
  	  i, j, v: INTEGER
    do
			create inner.make_empty (a_rows * a_cols)

      from i := 0
      until i >= a_rows
      loop
        from j := 0
        until j >= a_cols
        loop
          if a_bench then
            v := (i * j) \\ 100
          else
            v := read_integer
          end
          inner [i * a_cols + j] := v
          j := j + 1
        end
        i := i + 1
      end
    end
  
  inner: SPECIAL [INTEGER]
  
  read_integer: INTEGER
    do
    	-- FIXME: read from the file, how to pass the file appropriately to
    	-- different processors?
      Result := 0
    end
end
