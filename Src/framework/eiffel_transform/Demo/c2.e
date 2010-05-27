class
	C2
inherit
	C1
		rename
			c1_a as c2_a,
			c1_b as c2_b
		redefine
			c2_a,
			c2_b
		end
feature
	c2_a:STRING
		do
			Result := "This is c2_a%N"
		end
		
	c2_b:STRING
		do
			Result := "This is c2_b%N"
		end
end
