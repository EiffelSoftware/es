indexing
	description: "Summary description for {CUSTOM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CUSTOM

create
	make

feature --init

	make is
			--
		do
			my_int := 100
			my_string := "test"

			create my_array.make_from_array(<<1,2,3>>)

			create my_tuple
			my_tuple.put(my_array,1)
			my_tuple.put("test_tuple_string",2)
			my_tuple.put(1,1)
		end


feature -- attributes

	my_int:INTEGER

	my_string:STRING

	my_array:ARRAY[INTEGER]

	my_tuple:TUPLE[ARRAY[INTEGER],STRING,INTEGER]



end
