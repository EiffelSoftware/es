class
	A1

feature
	c: C1

	test(a_var_a1: INTEGER; arg_c1_a1: C1)
		local
			a_c: like c
			a1: like Current
		do
			create c
			create a_c
			
			io.putstring(c.c1_a)
			io.put_new_line
			
			io.putstring(arg_c1_a1.c1_b)
			io.put_new_line
			
		end
end
