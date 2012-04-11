indexing
	description: "Summary description for {MY_CLASS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_CLASS

create
	make,
	make_single

feature --init

	make is
			--
		local
			list:LINKED_LIST[STRING]
		do
			my_int := 4
			my_int2 := 5
			my_bool := true
			my_char := 'c'
			create my_str.make_from_string("test")
			create my_class2.make
			
			--create my_list.make(4)
			--my_list.put_front (1)


			create my_list.make
			create list.make
			list.put_front ("test1")
			list.put_front ("test2")
			my_list.put_front (list)

			create my_single_list.make
			my_single_list.put_front("test")
		end

	make_single is
			-- no back ref.
		do
			my_int := 4
			my_int2 := 5
		end

	my_int:INTEGER
	my_str:STRING

	my_int2:INTEGER
	my_class2:MY_CLASS2
	my_bool:BOOLEAN
	my_char:CHARACTER

	my_array:ARRAY[INTEGER]

	my_single_list:LINKED_LIST[STRING]
	my_list:LINKED_LIST[LINKED_LIST[STRING]]

	--my_list:ARRAYED_LIST[INTEGER]

end
