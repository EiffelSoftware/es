class
	MASK_ARRAY

inherit
  ARRAY2[INTEGER]

create
  make_with_content

feature
  make_with_content (a_rows, a_cols: INTEGER; a_bench: BOOLEAN)
  	local
  	  i, j, v: INTEGER
    do
			make_filled (0, a_rows, a_cols)

      from i := 1
      until i > a_rows
      loop
        from j := 1
        until j > a_cols
        loop
          if a_bench then
            if ((i * j) \\ (a_cols + 1)) = 1 then
              v := 1
            else
              v := 0
            end
          else
            v := read_integer
          end

          Current [i, j] := v
          j := j + 1
        end
        i := i + 1
      end
    end

  read_integer: INTEGER
    do
    	-- FIXME: read from the file, how to pass the file appropriately to
    	-- different processors?
      Result := 0
    end
end
