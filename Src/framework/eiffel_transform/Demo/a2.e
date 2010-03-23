class
	A2[X -> C2 rename c2_a as c2_a_ren end create default_create end]
inherit
	A[X]
		rename
			c as c_ren
		end

feature

	index: INTEGER

	test(a_var_a2: INTEGER; arg_c2_a2: like c_ren)
		local
			a_c: like c_ren
			a: like Current
			str_a2: STRING
		do
			create c_ren
			create a_c

			io.putstring(c_ren.c2_a_ren)
			io.put_new_line

			io.putstring(arg_c2_a2.c2_b)
			io.put_new_line

			c_ren ?= str_a2
			a_c ?= c_ren
			a ?= Current
		end

	test2
		local
			list: LIST[X]
			linked_list: LINKED_LIST[C2]
			weird_list: LINKED_LIST[LIST[TUPLE[detachable ARRAY[like c_ren],attached X,TUPLE]]]
			str: STRING
			i : INTEGER
		do
			if attached {STRING}c_ren as l_c then
				str ?= l_c
				if attached l_c.count as cnt then
					i?= cnt
				end
			end
			c_ren ?= c_ren.c2_b
			linked_list ?= list
			list ?= linked_list
			weird_list ?= linked_list
		end
end
