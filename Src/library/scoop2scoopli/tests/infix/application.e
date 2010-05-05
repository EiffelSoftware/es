class APPLICATION

create
  make
  
feature
  make
    local
      i : attached separate INF
      s : STRING
    do
      create i
      s := "Hello"
      
      print (s + "%N")
      run (i)
      print ("World %N")
    end
  
   run (i : attached separate INF)
    local
      l_inf : attached INF
      l_inf_sep : attached separate INF
    do
      create l_inf
      create l_inf_sep
      i.stuff
      l_inf_sep := i.plus (l_inf)
      l_inf_sep := i + l_inf
    end
  
end

