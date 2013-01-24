class
  MAP

inherit
  ARRAY2 [REAL_64]
  
create
  generate_map
  
feature {NONE}
  generate_map (n: INTEGER; max_dist: REAL_64)
    local
      i, j: INTEGER
      rand: RANDOM
    do
      make_filled (0, n, n)
      create rand.set_seed (42)

      from i := 1 until i > n loop
        from j := 1 until j > n loop
          Current [i, j] := rand.real_item * max_dist
          rand.forth
          j := j + 1
        end
        i := i + 1
      end
    end

end
