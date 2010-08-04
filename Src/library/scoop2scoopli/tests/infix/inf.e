class INF

inherit
	PARENT_INF
		redefine
			plus,
			infix "-"
		end

feature
  stuff
    do
      print ("Inf doing stuff %N")
    end

  plus alias "+" (i : attached INF) : attached INF
    do
      Result := i
    end

  infix "-" (i: attached INF) : attached INF
  	do
  		Result := i
  	end

end

