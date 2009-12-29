class
	A2

feature
	c: C2

	test(a_var_a2: INTEGER; arg_c: C2)
		do
			create c
			io.putstring(c.str+"++%N"+arg_c.str)
		end
end
