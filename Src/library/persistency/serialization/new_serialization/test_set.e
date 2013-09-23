note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	TEST_SET

inherit

	EQA_TEST_SET

feature -- Implementation

	test_binary_serializer (obj: ANY)
		local
			serializer: PS_BINARY_SERIALIZER
			file: RAW_FILE
		do
			create file.make_open_append ("file_13.bin")
			create serializer.make (file)
			serializer.store (obj)
			file.close
			create file.make_open_read ("file_13.bin")
			serializer.make (file)
			serializer.retrieve
			file.close
		--	print (obj.out)
		--	print ("%N")
		--	print (serializer.retrieved_items.first.out)
				--assert ("stop",false)
			--assert ("no retrieved object", serializer.retrieved_items.count > 0)
			assert ("object not deep_equal after serialization", obj.deep_equal (serializer.retrieved_items.first, obj))
		end

	test_classic_serializer (obj: ANY)
		local
			file: RAW_FILE
		do
			create file.make_open_append ("file_12.bin")
			file.independent_store (obj)
			file.close
			create file.make_open_read ("file_12.bin")
				--print (obj.out)
				--print ("%N")
				--print (serializer.retrieved_items.first.out)
				--assert ("stop",false)
			--assert ("no retrieved object", file.retrieved /=Void)
			assert ("object not deep_equal after serialization", obj.deep_equal (file.retrieved, obj))
			file.close
			--print ("done")
		end

feature -- Test Routines

	test_boolean
		local
			obj: BOOLEAN
		do
			obj := false
			test_binary_serializer (obj)
		end

	test_character_8
		local
			obj: CHARACTER_8
		do
			obj := obj.max_value.to_character_8
			test_binary_serializer (obj)
		end

	test_character_32
		local
			obj: CHARACTER_32
		do
			obj := obj.max_value.to_character_32
			test_binary_serializer (obj)
		end

	test_integer_8
		local
			obj: INTEGER_8
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_integer_16
		local
			obj: INTEGER_16
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_integer_32
		local
			obj: INTEGER_32
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_integer_64
		local
			obj: INTEGER_64
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_natural_8
		local
			obj: NATURAL_8
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_natural_16
		local
			obj: NATURAL_16
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_natural_32
		local
			obj: NATURAL_32
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_natural_64
		local
			obj: NATURAL_64
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_real
		local
			obj: REAL
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_double
		local
			obj: DOUBLE
		do
			obj := obj.max_value
			test_binary_serializer (obj)
		end

	test_string_8
		local
			obj: STRING_8
		do
			obj := "string_8"
			test_binary_serializer (obj)
		end

	test_string_32
		local
			obj: STRING_32
		do
			obj := "string_32"
			test_binary_serializer (obj)
		end

	test_pointer
		local
			obj: POINTER
		do
			obj := obj + 5
			test_binary_serializer (obj)
		end

	test_managed_pointer
		local
			serializer: PS_BINARY_SERIALIZER
			file: RAW_FILE
			obj: MANAGED_POINTER
		do
			create file.make_open_append ("file_13.bin")
			create serializer.make (file)
			create obj.make (128)
			serializer.store (obj)
			file.close
			create file.make_open_read ("file_13.bin")
			serializer.make (file)
			serializer.retrieve
			file.close
			if attached {MANAGED_POINTER} serializer.retrieved_items.first as obj2 then
				assert ("object not equal after serialization", (obj.is_shared = obj2.is_shared) and (obj.count = obj2.count) and (obj2.item.to_integer_32 /= 0))
			else
				assert ("error in deserializing", false)
			end
			create obj.share_from_pointer (obj.item, 64)
			create file.make_open_write ("file_13.bin")
			create serializer.make (file)
			serializer.store (obj)
			file.close
			create file.make_open_read ("file_13.bin")
			serializer.make (file)
			serializer.retrieve
			file.close
			if attached {MANAGED_POINTER} serializer.retrieved_items.first as obj2 then
				assert ("object not equal after serialization", (obj.is_shared = obj2.is_shared) and (obj.count = obj2.count) and (obj2.item.to_integer_32 /= 0))
			else
				assert ("error in deserializing", false)
			end
		end

	test_tuple_boolean
		local
			obj: TUPLE [BOOLEAN, BOOLEAN, BOOLEAN]
		do
			obj := [false, false, true]
			test_binary_serializer (obj)
		end

	test_tuple_integer
		local
			obj: TUPLE [INTEGER, INTEGER, INTEGER]
		do
			obj := [23, 1233, 654]
			test_binary_serializer (obj)
		end

	test_tuple_any
		local
			obj: TUPLE [INTEGER, STRING, BOOLEAN]
		do
			obj := [234, "string", true]
			test_binary_serializer (obj)
		end

	test_flat_1
		local
			obj: TEST_OBJECT
		do
			create obj.make
			obj.set_self_ref (obj)
			test_binary_serializer (obj)
		end

	test_array_of_integers
		local
			obj: ARRAY [INTEGER]
		do
			create obj.make_filled (1, 0, 100)
			test_binary_serializer (obj)
		end

	test_linked_list
		local
			obj: LINKED_LIST [INTEGER]
			i: INTEGER
		do
			create obj.make
			from
				i := 0
			until
				i > 2
			loop
				obj.extend (i)
				i := i + 1
			end
			test_binary_serializer (obj)
		end

	test_arrayed_list_of_string_32
		local
			obj: ARRAYED_LIST [STRING_32]
			i, n: INTEGER
		do
			n := 10
			create obj.make (n)
			from
				i := 0
			until
				i = n
			loop
				obj.extend ("hello world")
				i := i + 1
			end
			test_binary_serializer (obj)
		end

	test_arrayed_list_of_any
		local
			obj: ARRAYED_LIST [ANY]
			i, n: INTEGER
		do
			n := 100
			create obj.make (n)
			from
				i := 0
			until
				i = 25
			loop
				obj.extend ("hello world")
				obj.extend (1238746)
				obj.extend (true)
				obj.extend (create {TEST_OBJECT}.make)
				i := i + 1
			end
			test_binary_serializer (obj)
		end

	performance_new
		local
			obj: ARRAYED_LIST [TEST_OBJECT]
			i, n: INTEGER
			o: TEST_OBJECT
		do
			n := 100
			create obj.make (n)
			from
				i := 0
			until
				i = n
			loop
				create o.make
				o.set_self_ref (o)
				obj.extend (o)
				i := i + 1
			end
			test_binary_serializer (obj)
		end

	performance_old
		local
			obj: ARRAYED_LIST [TEST_OBJECT]
			i, n: INTEGER
			o: TEST_OBJECT
		do
			n := 100
			create obj.make (n)
			from
				i := 0
			until
				i = n
			loop
				create o.make
				o.set_self_ref (o)
				obj.extend (o)
				i := i + 1
			end
			test_classic_serializer (obj)
		end

end
