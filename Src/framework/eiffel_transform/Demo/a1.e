class
	A1[G -> C1 rename c1_a as c1_a_renamed end create default_create end]
inherit
	A[G]

feature
	test(a_var_a1: INTEGER; arg_c1_a1: C1)
		local
			a_c: like c
			a1: like Current
			str_a1: STRING
		do
			create c
			create a_c

			io.putstring(c.c1_a_renamed)
			io.put_new_line

			io.putstring(arg_c1_a1.c1_b)
			io.put_new_line

		end
end
