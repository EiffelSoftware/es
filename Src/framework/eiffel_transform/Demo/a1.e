class
	A1

feature
	c: C1

	test(a_var_a1: INTEGER; arg_c: C1; bla: INTEGER)
		do
			create c
			io.putstring(c.somestring+"++%N"+arg_c.somestring)
		end
end
