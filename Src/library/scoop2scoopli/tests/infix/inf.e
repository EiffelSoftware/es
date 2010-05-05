class INF

feature
  stuff
    do
      print ("Inf doing stuff %N")
    end

  plus alias "+" (i : attached INF) : attached INF
    do
      Result := i
    end
  
end

