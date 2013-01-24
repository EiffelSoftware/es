class
  BARRIER

create
  make

feature {NONE}
  make (max: INTEGER)
    do
      max_count := max
    end
  
feature
  max_count: INTEGER
  count: INTEGER
  done: INTEGER

  leaveable: BOOLEAN
    do
      Result := count = max_count
    end

  joinable: BOOLEAN
    do
      Result := done = 0
    end
  
  join
    require
      joinable
    do
      count := count + 1
    end

  leave
    require
      leaveable
    do
      done := done + 1
      if done = max_count then
        done := 0
        count := 0
      end
    end

end
