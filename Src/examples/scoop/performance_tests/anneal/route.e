class
  ROUTE

create
  make
  
feature {NONE}
  make (size: INTEGER)
    local
      i: INTEGER
    do
      create a.make_filled (0, 1, size)
      from i := 1 until i > size loop
        a[i] := i
        i := i + 1
      end
    end

  a: ARRAY[INTEGER]
  
feature
  item alias "[]" (i: INTEGER): INTEGER
    do
      Result := a [i]
    end
  
  swap (i, j: INTEGER)
    local
      x, y: INTEGER
    do
      x := a[i]
      y := a[j]
      a[i] := y
      a[j] := x
    end

  valid: BOOLEAN
    local
      i: INTEGER
    do
      Result := True
      from i := 1 until i > a.count or not Result loop
        Result := a.occurrences (a[i]) = 1
        i := i + 1
      end
    end
  
end
