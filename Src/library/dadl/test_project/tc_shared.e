indexing
	description: "Summary description for {TC_SHARED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_SHARED

create
	make

feature --init

	make is
			--
		local
			my_obj:MY_CLASS1
			list:LINKED_LIST[MY_SHARED]

			list_prim:LINKED_LIST[INTEGER]
			l_shared:MY_SHARED
		do
--			create my_str.make_from_string("test")
--			create my_class.make_single
			create my_array.make(1,3)


			create my_obj


			create shared.make

			create my_obj3
			create my_hash.make (2)
			my_obj3.put_shared(shared)

			create shared.make
			my_hash.put (shared, "1")

			create my_seq.make
			my_seq.extend(shared)

			my_array.put (shared,1)

			create my_tuple
			my_tuple.put (1, 1)
			my_tuple.put (shared,2)

			create my_special.make(2)
			my_special.put(shared,1)

			create my_str.make_from_string("shared")
			my_shared_str := my_str

			create l_shared.make
			create list.make
			list.extend (l_shared)

			create list_sharing.make
			list_sharing.extend(list)

			create list.make
			list.extend (l_shared)
			list_sharing.extend(list)

			create list_sharing2.make
			list_sharing2.extend(list)

			create list_prim.make
			list_prim.extend (1)
			list_prim.extend (2)

			create list_prim_sharing.make
			list_prim_sharing.extend(list_prim)

			create list_prim_sharing2.make
			list_prim_sharing2.extend(list_prim)
			list_prim_sharing2.extend(list_prim)

		end
feature --shared

	shared:MY_SHARED

	list_sharing:LINKED_LIST[LINKED_LIST[MY_SHARED]]

	list_sharing2:LINKED_LIST[LINKED_LIST[MY_SHARED]]

	list_prim_sharing:LINKED_LIST[LINKED_LIST[INTEGER]]

	list_prim_sharing2:LINKED_LIST[LINKED_LIST[INTEGER]]

	my_str:STRING

	my_shared_str:STRING

	put_shared(a_shared:MY_SHARED) is
			--
		do
			shared := a_shared
		end

--	my_str:STRING

--	my_class:MY_CLASS

	my_obj3:MY_CLASS3

	my_hash:HASH_TABLE[MY_SHARED,STRING]

	my_seq:LINKED_LIST[MY_SHARED]


	my_array:ARRAY[MY_SHARED]

	my_tuple:TUPLE[INTEGER,MY_SHARED]

	my_special:SPECIAL[MY_SHARED]


end
