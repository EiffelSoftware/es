class
	A2[G -> C2 rename c2_a as c2_a_ren end create default_create end]

feature
	c: G

	test(a_var_a2: INTEGER; arg_c2_a2: like c)
		local
			a_c: like c
			a2: like Current
		do
			create c
			create a_c
			
			io.putstring(c.c2_a_ren)
			io.put_new_line
			
			io.putstring(arg_c2_a2.c2_b)
			io.put_new_line
		end
end
