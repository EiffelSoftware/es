class
  CITY

create
  make

feature {NONE}
  make (i, idx, l, r: INTEGER)
    do
      left := l
      right := r
      id := i
      indexInRoute := idx
    end
  
feature
  left: INTEGER
  right: INTEGER
  id: INTEGER
  indexInRoute: INTEGER

  setId (i: INTEGER)
    do
      id := i
    end
  
  setIndex (i: INTEGER)
    do
      indexInRoute := i
    end
  
end
