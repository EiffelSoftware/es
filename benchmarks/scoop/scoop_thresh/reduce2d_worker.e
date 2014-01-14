class REDUCE2D_WORKER

create
  make_with_filter

feature
  make_with_filter
       (start_, final_: INTEGER;
        ncols_: INTEGER;
        array_: separate MATRIX_ARRAY;
        accum_: separate ARRAY [INTEGER];
        histogram_: separate ARRAY[INTEGER]
        )
    do
      start := start_
      final := final_
      ncols := ncols_
      input_array := array_.inner
      accum := accum_
      histogram := histogram_
    end

feature
  live
    do
      if start /= final + 1 then
        get_result (fetch_array (input_array))
      end
    end

  to_local_row (x: INTEGER) : INTEGER
    do
      Result := x - start + 1
    end

  fetch_array (a_sep_array: separate SPECIAL[INTEGER]): SPECIAL [INTEGER]
    require
      a_sep_array.generator /= Void
    local
      i, j: INTEGER
      e: INTEGER
    do
      create Result.make_empty ((final - start) * ncols)

      from i := start
      until i >= final
      loop
        from j := 0
        until j >= ncols
        loop
          e := a_sep_array [i * ncols + j]
          Result [(i - start) + j] := e
          j := j + 1
        end
        i := i + 1
      end
    end

  get_result(a_array: SPECIAL[INTEGER])
    local
      i, j: INTEGER
      max: INTEGER
      hist: ARRAY [INTEGER]
      e: INTEGER
    do
      create hist.make_filled (0, 0, 100)
      max := 0

      from i := start
      until i >= final
      loop
        from j := 0
        until j >= ncols
        loop
          e        := a_array [(i - start) * ncols + j]
          hist [e] := hist [e] + 1
          max      := e.max (max)
          j := j + 1
        end
        i := i + 1
      end
      update_separate_accumulator (max, accum, hist, histogram)
    end

  update_separate_accumulator (max: INTEGER;
                               acc: separate ARRAY [INTEGER];
                               hist: ARRAY [INTEGER];
                               sep_hist: separate ARRAY [INTEGER])
    require
      acc.generator /= Void and sep_hist.generator /= Void
    local
      i: INTEGER
      h: INTEGER
      newmax: INTEGER
    do
      i := acc.item (1)
      newmax := i.max (max)

      if newmax > 100 then
      	(1 / (i-i)).do_nothing
      end
      acc.put (newmax, 1)

      from i := 0
      until i > 100
      loop
      	h := sep_hist.item (i)
      	sep_hist.put (h + hist [i], i)
        i := i + 1
      end
    end

  start, final: INTEGER

feature {NONE}
  histogram: separate ARRAY[INTEGER]
  accum: separate ARRAY [INTEGER]

  ncols: INTEGER
  input_array: separate SPECIAL[INTEGER]

end
