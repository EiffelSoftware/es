class
	TEST2_REN_B

inherit
	TEST2_REN_A
		rename bar as foo end

feature

	foo: attached STRING
		do
			Result := "B"
		end
		
end
