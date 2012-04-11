indexing
	description: "Summary description for {TC_SHARED_PERF100}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_SHARED_PERF100

create
	make

feature --init

	make is
			--
		do
			create tc_str_perf100.make

			create list.make
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)
			list.extend (tc_str_perf100)


			create array.make (1, 100)

			array.put (tc_str_perf100, 1)
			array.put (tc_str_perf100, 2)
			array.put (tc_str_perf100, 3)
			array.put (tc_str_perf100, 4)
			array.put (tc_str_perf100, 5)
			array.put (tc_str_perf100, 6)
			array.put (tc_str_perf100, 7)
			array.put (tc_str_perf100, 8)
			array.put (tc_str_perf100, 9)
			array.put (tc_str_perf100, 10)
			array.put (tc_str_perf100, 11)
			array.put (tc_str_perf100, 12)
			array.put (tc_str_perf100, 13)
			array.put (tc_str_perf100, 14)
			array.put (tc_str_perf100, 15)
			array.put (tc_str_perf100, 16)
			array.put (tc_str_perf100, 17)
			array.put (tc_str_perf100, 18)
			array.put (tc_str_perf100, 19)
			array.put (tc_str_perf100, 20)




		end

feature -- attr

	tc_str_perf100:TC_STR_PERF100

	list:LINKED_LIST[TC_STR_PERF100]

	array:ARRAY[TC_STR_PERF100]




end
