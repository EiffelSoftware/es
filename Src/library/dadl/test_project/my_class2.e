indexing
	description: "Summary description for {MY_CLASS2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_CLASS2

create
	make

feature --init

	make is
			--
		local
			my_obj:MY_CLASS1
		do
--			create my_str.make_from_string("test")
--			create my_class.make_single
			--create my_array.make_from_array(<<<<1>>,<<2>>,<<3>>,<<4>>>>)

			create my_obj


			create shared.make

			create my_obj3
			create my_hash.make (2)
			my_obj3.put_shared(shared)

			create shared.make
			my_hash.put (shared, "1")

		end
feature --shared

	shared:MY_SHARED


	put_shared(a_shared:MY_SHARED) is
			--
		do
			shared := a_shared
		end

--	my_str:STRING

--	my_class:MY_CLASS

	my_obj3:MY_CLASS3

	my_hash:HASH_TABLE[MY_SHARED,STRING]

	my_array:ARRAY[ARRAY[INTEGER]]




end
