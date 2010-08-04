class SPHERE

feature
  c : VECTOR
  r : REAL

  make (a_c : VECTOR ; a_r : REAL)
    do
      c := a_c
      r := a_r
    end

  intersect (start, dir : VECTOR) : HIT
    local
      t1, t2, disc : REAL
      vdotd : REAL
      refl : VECTOR
    do
      dir := dir.norm
      v := start - c
      vdotd := v.dot (dir)

      disc := -(vdotd^2) - (v.dot (v) - r^2)

      if disc >= 0 then
        t1 := -vdotd + sqrt (disc)
        t2 := -vdotd - sqrt (disc)

        if t1 < t2 then
          t := t1
        else
          t := t2
        end
        
        if t < 0 then
          create Result.make_no_hit
        else
          create Result.make_hit (start + dir.scalar (t))
        end
      else
        create Result.make_no_hit
      end
    end
end
