indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEST_OBJECT_ID

inherit
	TS_TEST_CASE
	redefine
		set_up,
		tear_down
	end

feature -- Test Variables:

feature -- Helpers
	set_up
			-- Set up the environment
		do
		end

	tear_down
			-- tear down the environment.
		do
		end

feature -- Testing the tests:

	test_read_any is
			-- Test if object id's can be read from an any - type.
		local
			ex, ex2: EXAMPLE_CLASS
			an_id, an_id2: INTEGER
		do
			create ex.make
			create ex2.make
			an_id := ex.cr_object_id
			an_id2 := ex2.cr_object_id
			assert_not_equal ("an_id assigned", 0, an_id)
			assert_not_equal ("an_id2 assigned", 0, an_id2)
			assert ("id's are assigned in ascending order", an_id < an_id2)
		end

	test_read_special is
			-- Test if object id's can be read from a special type.
		local
			s1, s2: SPECIAL[CHARACTER]
			an_id, an_id2: INTEGER
		do
			create s1.make (10)
			create s2.make (10)

			an_id := s1.cr_object_id
			an_id2 := s2.cr_object_id
			assert_not_equal ("an_id assigned", 0, an_id)
			assert_not_equal ("an_id2 assigned", 0, an_id2)
			assert ("id's are assigned in ascending order", an_id < an_id2)
		end

	test_read_tuple is
			-- Test if object id's can be read from tuple types.
			-- XXX object id's not implemented for tuples, yet.
		local
			t1, t2: TUPLE
			an_id1, an_id2: INTEGER
		do
			t1 := [1, 2, "hello world"]
			t2 := ["hello world", 2, 3]
			an_id1 := t1.cr_object_id
			an_id2 := t2.cr_object_id


			assert_not_equal ("an_id assigned", 0, an_id1)
			assert_not_equal ("an_id2 assigned", 0, an_id2)
			assert ("id's are assigned in ascending order", an_id1 < an_id2)
		end


	test_set_any is
			-- Test if the object id in an object can successfully be set.
		local
			ex: EXAMPLE_CLASS
			id_old, expected_id: INTEGER
		do
			create ex.make
			id_old := ex.cr_object_id
			expected_id := 99874
			ex.cr_set_object_id(expected_id)

			assert_equal("object id set", expected_id, ex.cr_object_id)
		end

	test_set_special is
			-- Test if the object id in a special can successfully be set.
		local
			ex: SPECIAL[INTEGER]
			id_old, expected_id: INTEGER
			i: INTEGER
		do
			create ex.make(100)
			from
				i := ex.lower
			until
				i = ex.upper
			loop
				ex[i] := i
				i := i + 1
			end

			id_old := ex.cr_object_id
			expected_id := 99874
			ex.cr_set_object_id(expected_id)

			from
				i := ex.lower
			until
				i = ex.upper
			loop
				assert_equal("content still valid: element " + i.out, i, ex[i])
				i := i + 1
			end

			assert_equal ("object id set", expected_id, ex.cr_object_id)
		end

	test_set_tuple is
			-- Test if the object id in a tuple can successfully be set.
		local
			t1: TUPLE [INTEGER, STRING]
			original_id, expected_id: INTEGER
		do
			t1 := [12, "hi!"]
			original_id := t1.cr_object_id
			expected_id := 88
			t1.cr_set_object_id (expected_id)
			assert_equal ("object id set", expected_id, t1.cr_object_id)
		end

	test_is_equal_any is
			-- Test if the object id doesn't have an impact on the is_equal operator
			-- Note: objects can be equal even though their object id differs.
		local
			ex1, ex2: EXAMPLE_CLASS
			temp_id: INTEGER
		do
			create ex1.make
			create ex2.make

			-- Set the two only fields of ex1, ex2
			ex1.set_basic_field (99)
			ex2.set_basic_field (ex1.basic_field)
			ex1.set_non_basic_field (ex1)
			ex2.set_non_basic_field (ex1)

			--request object id's to make sure they're set:
			temp_id := ex1.cr_object_id
			temp_id := ex2.cr_object_id
			assert_equal ("objects with equal content are equal", ex1, ex2)
		end

	test_deep_equal_any is
			-- Tests if deep equal works with different object ID's
		local
			ex1, ex2, ex3: EXAMPLE_CLASS
			temp_id: INTEGER
		do
			create ex1.make
			create ex2.make
			create ex3.make

			-- Set the two only fields of ex1, ex2
			ex1.set_basic_field (99)
			ex2.set_basic_field (ex1.basic_field)
			ex3.set_basic_field(10)
			ex3.set_non_basic_field (ex1)
			ex1.set_non_basic_field (ex3)
			ex2.set_non_basic_field (ex3)

			-- Request an object ID, to make sure it is set:
			temp_id := ex1.cr_object_id
			temp_id := ex2.cr_object_id

			assert ("objects with same references are deep equal", ex1.is_deep_equal(ex2))
		end

	test_copy is
			-- Tests if copy works on the example class as expected
		local
			ex1, ex2: EXAMPLE_CLASS
			temp_object_id: INTEGER
		do
			create ex1.make
			ex1.set_basic_field (999)
			ex1.set_non_basic_field (ex1)
			temp_object_id := ex1.cr_object_id
			create ex2.make
			ex2.copy(ex1)

			assert_equal ("copied object equals original object:", ex1, ex2)
			assert_not_equal ("copied object has different object id", ex1.cr_object_id, ex2.cr_object_id)
		end

	test_manifest_string_8 is
			-- Test if object ID works correct together with STRING_8 built from a manifest
		do
			check_string ("I'm a string...")
		end

	test_once_manifest_string_8 is
			-- Test if object ID works correct together with STRING_8 built from a manifest
		do
			check_string (once "I'm a string...")
		end

	test_string_8 is
			-- Test if object ID works correct together with STRING_8 that was manually created.
		local
			string: STRING
		do
			create string.make (10)
			string.put ('a',1)
			string.put ('b',2)
			string.put ('c',3)
			string.put ('d',4)
			string.put ('e',5)
			string.put ('f',6)
			check_string (string)
		end



feature {NONE} -- Implementation
	check_string (string: STRING) is
			-- Test if object ID works correct for `string'
		local
			original_count: INTEGER
			new_object_id: INTEGER
		do
			original_count := string.count
			new_object_id := 9999
			string.cr_set_object_id(new_object_id)
			assert_equal ("String count did not change due to change of object_id", original_count, string.count)
			assert_equal ("String object - id is set", new_object_id, string.cr_object_id)
		end

invariant
	invariant_clause: True -- Your invariant here

end
