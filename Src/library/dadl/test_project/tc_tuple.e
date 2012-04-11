indexing
	description: "Summary description for {TC_TUPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_TUPLE

create
	make


feature -- creation

	make is
			--
		local
			empty:EMPTY
		do
			create my_tuple_prim
			create my_tuple
			create empty

			my_tuple_prim.put ("test", 1)
			my_tuple_prim.put (2, 2)

			my_tuple.put(empty,1)
			my_tuple.put("test_2",2)

		end


feature -- access

	my_tuple_prim:TUPLE[STRING,INTEGER]

	my_tuple:TUPLE[EMPTY,STRING]

end
