class F_OOM_CLIENT

feature

  test_d
    local
      s: F_OOM_SUBJECT_D
      o1, o2: F_OOM_OBSERVER_D
    do
      create s
      create o1.make (s)
      create o2.make (s)
      s.update (5)
      check o1.cache = 5 and o2.cache = 5 end      
    end
end