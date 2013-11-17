class PARFOR_WORKER
create make
feature
  make (start_, final_, nelts_: INTEGER;
        matrix_: separate ARRAY2[DOUBLE];
        vector_: separate ARRAY[DOUBLE])
    do
      start := start_
      final := final_
      nelts := nelts_
      matrix := matrix_
      vector := vector_
      create res.make_filled (0, 1, final - start)
    end

feature
  live
    do
      get_result(fetch_array(matrix), fetch_vector (vector))
    end

  get_res (i: INTEGER): REAL_64
    do
      Result := res[to_local(i - start)]
    end

  fetch_array (a_sep_array: separate ARRAY2[DOUBLE]): ARRAY2 [DOUBLE]
--     require
--       a_sep_array.generator /= Void
    local
      i, j: INTEGER
      e: DOUBLE
    do
      print ("Fetching array start%N")
      create Result.make_filled (0, final - start + 1, nelts)
      from i := start
      until i > final
      loop
        from j := 1
        until j > nelts
        loop
          e := a_sep_array.item (i, j)
          Result [to_local (i), j] := e
          j := j + 1
        end
        i := i + 1
      end
      print ("Fetching array end%N")
    end

  fetch_vector (a_sep_vector: separate ARRAY [DOUBLE]): ARRAY [DOUBLE]
--    require
--      a_sep_vector.generator /= Void
    local
      i: INTEGER
      e: DOUBLE
    do
      create Result.make_filled (0, 1, nelts)

      from i := 1
      until i > nelts
      loop
        e := a_sep_vector.item (i)
        Result [i] := e
        i := i + 1
      end
    end


  to_local (i: INTEGER): INTEGER
    do
      Result := i - start + 1
    end

  get_result(a_matrix: ARRAY2[DOUBLE];
             a_vector: ARRAY[DOUBLE])
    local
      i, j: INTEGER
      sum: DOUBLE
    do
      print ("Calculation start%N")
      create res.make_filled (0, 1, final - start + 1)

      from i := start
      until i > final
      loop
        sum := 0
        from j := 1
        until j > nelts
        loop
          sum := sum + a_matrix [to_local (i), j] * a_vector [j]
          j := j + 1
        end
        res [to_local (i)] := sum
        i := i + 1
      end
      print ("Calculation end%N")
    end

feature
  nelts, start, final: INTEGER
  matrix: separate ARRAY2[DOUBLE]
  vector: separate ARRAY[DOUBLE]
  res: ARRAY[DOUBLE]
end
