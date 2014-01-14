class PARFOR_WORKER

create make

feature
  make (start_, final_, ncols_: INTEGER;
        from_array_: separate MATRIX_ARRAY;
        threshold_: INTEGER)
    do
      start := start_
      final := final_
      ncols := ncols_
      from_array := from_array_.inner
      threshold := threshold_
    end

feature
  live
    do
      if final >= start then
        get_result (fetch_array (from_array))
      end
    end

  fetch_array (a_sep_array: separate SPECIAL[INTEGER]): SPECIAL [INTEGER]
    local
      i, j: INTEGER
    do
      create Result.make_empty ((final - start) * ncols)

      from i := start
      until i >= final
      loop
        from j := 0
        until j >= ncols
        loop
          Result [(i - start) * ncols + j] := a_sep_array [i * ncols + j]
          j := j + 1
        end
        i := i + 1
      end
    end

  get_result(a_from_array: SPECIAL[INTEGER])
    local
      i, j: INTEGER
      res: INTEGER
    do
      create to_array.make_empty ((final - start) * ncols)

      from i := start
      until i >= final
      loop
        from j := 0
        until j >= ncols
        loop
          if a_from_array [(i - start) * ncols + j] >= threshold then
            to_array [(i - start) * ncols + j] := 1
          else
            to_array [(i - start) * ncols + j] := 0
          end
          j := j + 1
        end
        i := i + 1
      end
    end

  get (i,j : INTEGER): INTEGER
    do
      Result := to_array [(i - start) * ncols + j]
    end
  
  start, final: INTEGER
  
feature {NONE}
  ncols: INTEGER
  to_array: SPECIAL [INTEGER]

  from_array: separate SPECIAL[INTEGER]
  threshold: INTEGER

end
