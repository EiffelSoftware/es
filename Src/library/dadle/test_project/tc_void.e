indexing
	description: "Summary description for {TC_VOID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_VOID

create
	make

feature --init

	make is
			--
		do
			create my_hash.make (5)
			my_hash.put ("test", "key1")
			my_hash.put (void, "key2")

			create my_list.make
			my_list.extend("test")
			my_list.extend(void)
			my_list.extend("test2")

			create my_tuple
			my_tuple.put(client,1)
			my_tuple.put (void, 2)
			my_tuple.put ("test", 3)
			my_tuple.put (100, 4)

			


		end


feature --attrb

	my_hash:HASH_TABLE[STRING,STRING]

	my_list:LINKED_LIST[STRING]

	my_tuple:TUPLE[A_CLIENT,STRING,STRING,INTEGER]

	my_void_string:STRING

	client:A_CLIENT
end
