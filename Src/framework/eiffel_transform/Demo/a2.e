class
	A2[X -> C2 rename c2_a as c2_a_ren end create default_create end]

feature
	c: X

	test(a_var_a2: INTEGER; arg_c2_a2: like c)
		local
			a_c: like c
			a2: like Current
			str_a2: STRING
		do
			create c
			create a_c
			
			io.putstring(c.c2_a_ren)
			io.put_new_line
			
			io.putstring(arg_c2_a2.c2_b)
			io.put_new_line
			
			c ?= str_a2
			a_c ?= c
			a2 ?= Current
		end
		
	test2
		local
			list: LIST[X]
			linked_list: LINKED_LIST[C2]
			weird_list: LINKED_LIST[LIST[TUPLE[detachable ARRAY[like c],attached X,TUPLE]]]
		do
			--c ?= c.c2_b
			linked_list ?= list
			list ?= linked_list
			weird_list ?= linked_list
		end
end
