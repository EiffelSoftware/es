class
	TEST2_REN_C

inherit
	TEST2_REN_B
		redefine foo end

feature

	foo : attached STRING
		do
			Result := "C"
		end
		
end
