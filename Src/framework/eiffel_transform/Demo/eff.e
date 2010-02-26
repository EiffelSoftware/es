class
	EFF
inherit
	DEF_B

feature
	test_a
		require else
			in_eff: true
		do
			io.put_integer(1)
		ensure then
			in_eff:true
		end
		
	test_b
		require else
			in_eff: true
		do
			io.put_integer(2)
		ensure then
			in_eff:true
		end
			
end
