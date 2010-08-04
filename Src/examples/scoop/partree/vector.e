class VECTOR

create
  make

feature
  x, y, z : REAL

  make (a_x, a_y, a_z : REAL)
    do
      x := a_x
      y := a_y
      z := a_z
    end

  plus  (v : VECTOR) : VECTOR
    do
      create Result.make (x+v.x, y+v.y, z+v.z)
    end

  scalar (a : REAL) : VECTOR
    do
      create Result.make (a*x, a*y, a*z)
    end

  sub (v : VECTOR) : VECTOR
    do
      Result := plus (v.scalar (-1))
    end

  dot (v : VECTOR) : REAL
    do
      Result := x*v.x + y*v.y + z*v.z
    end

  mag : REAL
    do
      Result := (create {SINGLE_MATH}).sqrt (dot (Current))
    end

  norm : VECTOR
    require
      non_zero : mag /= 0
    do
      create Result.make (x/mag, y/mag, z/mag)
    end
end
