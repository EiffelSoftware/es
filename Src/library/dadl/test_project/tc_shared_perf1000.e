indexing
	description: "Summary description for {TC_SHARED_PERF1000}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_SHARED_PERF1000

create
	make

feature --init

	make is
			--
		do
			create tc_str_perf1000.make

			create list.make
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)
			list.extend (tc_str_perf1000)


			create array.make (1, 100)

			array.put (tc_str_perf1000, 1)
			array.put (tc_str_perf1000, 2)
			array.put (tc_str_perf1000, 3)
			array.put (tc_str_perf1000, 4)
			array.put (tc_str_perf1000, 5)
			array.put (tc_str_perf1000, 6)
			array.put (tc_str_perf1000, 7)
			array.put (tc_str_perf1000, 8)
			array.put (tc_str_perf1000, 9)
			array.put (tc_str_perf1000, 10)
			array.put (tc_str_perf1000, 11)
			array.put (tc_str_perf1000, 12)
			array.put (tc_str_perf1000, 13)
			array.put (tc_str_perf1000, 14)
			array.put (tc_str_perf1000, 15)
			array.put (tc_str_perf1000, 16)
			array.put (tc_str_perf1000, 17)
			array.put (tc_str_perf1000, 18)
			array.put (tc_str_perf1000, 19)
			array.put (tc_str_perf1000, 20)




		end

feature -- attr

	tc_str_perf1000:TC_STR_PERF1000

	list:LINKED_LIST[TC_STR_PERF1000]

	array:ARRAY[TC_STR_PERF1000]




end
