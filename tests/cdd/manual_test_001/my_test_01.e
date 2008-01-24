indexing
	description: "Bunch of manual testcases for testing of CDD_ASSERTION_ROUTINES"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_TEST_01

inherit
	CDD_TEST_CASE

feature -- Access

	test_assert_1 is
			-- test something
		indexing
		 tag: "assert.pass"
		do
			assert("assert", True)
		end

	test_assert_2 is
			-- test something
		indexing
		 tag: "assert.fail"
		do
			assert("assert", False)
		end

	test_assert_true_1 is
			-- test something
		indexing
		 tag: "assert_true.pass"
		do
			assert_true("assert_true", True)
		end

	test_assert_true_2 is
			-- test something
		indexing
		 tag: "assert_true.fail"
		do
			assert_true("assert_true", False)
		end

	test_assert_false_1 is
			-- test something
		indexing
		 tag: "assert_false.pass"
		do
			assert_false("assert_false", False)
		end

	test_assert_false_2 is
			-- test something
		indexing
		 tag: "assert_false.fail"
		do
			assert_false("assert_false", True)
		end

	test_assert_equal_1 is
			-- test something
		indexing
		 tag: "assert_equal.pass"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := create {LINKED_LIST[INTEGER]}.make
			assert_equal("assert_equal", obj1, obj2)
		end

	test_assert_equal_2 is
			-- test something
		indexing
		 tag: "assert_equal.fail"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := create {LINKED_LIST[DOUBLE]}.make
			assert_equal("assert_equal", obj1, obj2)
		end

	test_assert_equal_3 is
			-- test something
		indexing
		 tag: "assert_equal.fail"
		local
			obj1: LINKED_LIST[INTEGER]
			obj2: LINKED_LIST[INTEGER]
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj1.extend(1)
			obj2 := create {LINKED_LIST[INTEGER]}.make
			obj2.extend(2)
			assert_equal("assert_equal", obj1, obj2)
		end

	test_assert_not_equal_1 is
			-- test something
		indexing
		 tag: "assert_not_equal.fail"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := create {LINKED_LIST[INTEGER]}.make
			assert_not_equal("assert_not_equal", obj1, obj2)
		end

	test_assert_not_equal_2 is
			-- test something
		indexing
		 tag: "assert_not_equal.pass"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := create {LINKED_LIST[DOUBLE]}.make
			assert_not_equal("assert_not_equal", obj1, obj2)
		end

	test_assert_not_equal_3 is
			-- test something
		indexing
		 tag: "assert_not_equal.pass"
		local
			obj1: LINKED_LIST[INTEGER]
			obj2: LINKED_LIST[INTEGER]
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj1.extend(1)
			obj2 := create {LINKED_LIST[INTEGER]}.make
			obj2.extend(2)
			assert_not_equal("assert_not_equal", obj1, obj2)
		end

	test_assert_same_1 is
			-- test something
		indexing
		 tag: "assert_same.pass"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := obj1
			assert_same("assert_same", obj1, obj2)
		end

	test_assert_same_2 is
			-- test something
		indexing
		 tag: "assert_same.fail"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := create {LINKED_LIST[INTEGER]}.make
			assert_same("assert_same", obj1, obj2)
		end

	test_assert_same_3 is
			-- test something
		indexing
		 tag: "assert_same.fail"
		local
			obj1: LINKED_LIST[INTEGER]
			obj2: LINKED_LIST[INTEGER]
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj1.extend(1)
			obj2 := create {LINKED_LIST[INTEGER]}.make
			obj2.extend(1)
			assert_same("assert_same", obj1, obj2)
		end

	test_assert_not_same_1 is
			-- test something
		indexing
		 tag: "assert_not_same.fail"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := obj1
			assert_not_same("assert_not_same", obj1, obj2)
		end

	test_assert_not_same_2 is
			-- test something
		indexing
		 tag: "assert_not_same.pass"
		local
			obj1: ANY
			obj2: ANY
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj2 := create {LINKED_LIST[INTEGER]}.make
			assert_not_same("assert_not_same", obj1, obj2)
		end

	test_assert_not_same_3 is
			-- test something
		indexing
		 tag: "assert_not_same.pass"
		local
			obj1: LINKED_LIST[INTEGER]
			obj2: LINKED_LIST[INTEGER]
		do
			obj1 := create {LINKED_LIST[INTEGER]}.make
			obj1.extend(1)
			obj2 := create {LINKED_LIST[INTEGER]}.make
			obj2.extend(1)
			assert_not_same("assert_not_same", obj1, obj2)
		end

	test_assert_integers_equal_1 is
			-- test something
		indexing
		 tag: "assert_integers_equal.pass"
		do
			assert_integers_equal("assert_integers_equal", 10000, 10000)
		end

	test_assert_integers_equal_2 is
			-- test something
		indexing
		 tag: "assert_integers_equal.fail"
		do
			assert_integers_equal("assert_integers_equal", 23987, 22323213)
		end

	test_assert_integers_not_equal_1 is
			-- test something
		indexing
		 tag: "assert_integers_not_equal.fail"
		do
			assert_integers_not_equal("assert_integers_not_equal", 10000, 10000)
		end

	test_assert_integers_not_equal_2 is
			-- test something
		indexing
		 tag: "assert_integers_not_equal.pass"
		do
			assert_integers_not_equal("assert_integers_not_equal", 23987, 22323213)
		end

	test_assert_strings_equal_1 is
			-- test something
		indexing
		 tag: "assert_strings_equal.pass"
		do
			assert_strings_equal("assert_strings_equal", "Hello World", "Hello World")
		end

	test_assert_strings_equal_2 is
			-- test something
		indexing
		 tag: "assert_strings_equal.fail"
		do
			assert_strings_equal("assert_strings_equal", "Hello World", "Hallo Welt")
		end

	test_assert_strings_not_equal_1 is
			-- test something
		indexing
		 tag: "assert_strings_not_equal.fail"
		do
			assert_strings_not_equal("assert_strings_not_equal", "Hello World", "Hello World")
		end

	test_assert_strings_not_equal_2 is
			-- test something
		indexing
		 tag: "assert_strings_not_equal.pass"
		do
			assert_strings_not_equal("assert_strings_not_equal", "Hello World", "Hallo Welt")
		end

	test_assert_strings_case_insensitive_equal_1 is
			-- test something
		indexing
		 tag: "assert_strings_case_insensitive_equal.pass"
		do
			assert_strings_case_insensitive_equal("assert_strings_case_insensitive_equal", "hELLO wORLD", "Hello World")
		end

	test_assert_strings_case_insensitive_equal_2 is
			-- test something
		indexing
		 tag: "assert_strings_case_insensitive_equal.fail"
		do
			assert_strings_case_insensitive_equal("assert_strings_case_insensitive_equal", "hELLO wORLD", "Hello World0")
		end

	test_assert_characters_equal_1 is
			-- test something
		indexing
		 tag: "assert_characters_equal.pass"
		do
			assert_characters_equal("assert_characters_equal", 'A', 'A')
		end

	test_assert_characters_equal_2 is
			-- test something
		indexing
		 tag: "assert_characters_equal.fail"
		do
			assert_characters_equal("assert_characters_equal", 'A', 'B')
		end

	test_assert_characters_not_equal_1 is
			-- test something
		indexing
		 tag: "assert_characters_not_equal.fail"
		do
			assert_characters_not_equal("assert_characters_not_equal", 'A', 'A')
		end

	test_assert_characters_not_equal_2 is
			-- test something
		indexing
		 tag: "assert_characters_not_equal.pass"
		do
			assert_characters_not_equal("assert_characters_not_equal", 'A', 'B')
		end

	test_assert_booleans_equal_1 is
			-- test something
		indexing
		 tag: "assert_booleans_equal.pass"
		do
			assert_booleans_equal("assert_booleans_equal", False, False)
		end

	test_assert_booleans_equal_2 is
			-- test something
		indexing
		 tag: "assert_booleans_equal.fail"
		do
			assert_booleans_equal("assert_booleans_equal", False, True)
		end

	test_assert_booleans_not_equal_1 is
			-- test something
		indexing
		 tag: "assert_booleans_not_equal.fail"
		do
			assert_booleans_not_equal("assert_booleans_not_equal", False, False)
		end

	test_assert_booleans_not_equal_2 is
			-- test something
		indexing
		 tag: "assert_booleans_not_equal.pass"
		do
			assert_booleans_not_equal("assert_booleans_not_equal", False, True)
		end

	test_assert_files_equal_1 is
			-- test something
		indexing
		 tag: "assert_files_equal.pass"
		do
			assert_files_equal("assert_files_equal", "$EIFFEL_SRC\build\esbuilder.ecf", "$EIFFEL_SRC/build/esbuilder.ecf")
		end

	test_assert_files_equal_2 is
			-- test something
		indexing
		 tag: "assert_files_equal.pass"
		do
			assert_files_equal("assert_files_equal", "./file1.txt", "./file2.txt")
		end

	test_assert_files_equal_3 is
			-- test something
		indexing
		 tag: "assert_files_equal.fail"
		do
			assert_files_equal("assert_files_equal", "$EIFFEL_SRC\build\esbuilder.ecf", "$EIFFEL_SRC/build/esbuilder.rc")
		end

	test_assert_files_equal_4 is
			-- test something
		indexing
		 tag: "assert_files_equal.fail"
		do
			assert_files_equal("assert_files_equal", "$FOO\bla", "$BLA/foo")
		end

	test_assert_filenames_equal_1 is
			-- test something
		indexing
		 tag: "assert_filenames_equal.pass"
		do
			assert_filenames_equal("assert_filenames_equal", "$EIFFEL_SRC\build\esbuilder.ecf", "$EIFFEL_SRC/build/esbuilder.ecf")
		end

	test_assert_filenames_equal_2 is
			-- test something
		indexing
		 tag: "assert_filenames_equal.fail"
		do
			assert_filenames_equal("assert_filenames_equal", "$EIFFEL_SRC\build\esbuilder.ecf", "$EIFFEL_SRC/build/esbuilder.rc")
		end

	test_assert_arrays_same_1 is
			-- test something
		indexing
		 tag: "assert_arrays_same.pass"
		local
			obj1: ARRAY[ANY]
			obj2: ARRAY[ANY]
			obj3: LINKED_LIST[INTEGER]
		do
			obj1 := create {ARRAY[ANY]}.make(1, 10)
			obj2 := create {ARRAY[LINKED_LIST[INTEGER]]}.make (1, 10)
			create obj3.make
			obj3.extend(10)
			obj1.put(obj3, 1)
			obj2.put(obj3, 1)
			assert_arrays_same("assert_arrays_same", obj1, obj2)
		end

	test_assert_arrays_same_2 is
			-- test something
		indexing
		 tag: "assert_arrays_same.fail"
		local
			obj1: ARRAY[ANY]
			obj2: ARRAY[ANY]
			obj3: LINKED_LIST[INTEGER]
		do
			obj1 := create {ARRAY[ANY]}.make(1, 10)
			obj2 := create {ARRAY[LINKED_LIST[INTEGER]]}.make (1, 10)
			create obj3.make
			obj3.extend(10)
			obj1.put(obj3, 1)
			create obj3.make
			obj3.extend(10)
			obj2.put(obj3, 1)
			assert_arrays_same("assert_arrays_same", obj1, obj2)
		end

	test_assert_arrays_equal_1 is
			-- test something
		indexing
		 tag: "assert_arrays_equal.pass"
		local
			obj1: ARRAY[ANY]
			obj2: ARRAY[ANY]
		do
			obj1 := << create {LINKED_LIST[INTEGER]}.make >>
			obj2 := << create {LINKED_LIST[INTEGER]}.make >>
			assert_arrays_equal("assert_arrays_equal", obj1, obj2)
		end

	test_assert_arrays_equal_2 is
			-- test something
		indexing
		 tag: "assert_arrays_equal.fail"
		local
			obj1: ARRAY[ANY]
			obj2: ARRAY[ANY]
		do
			obj1 := << create {LINKED_LIST[DOUBLE]}.make >>
			obj2 := << create {LINKED_LIST[INTEGER]}.make >>
			assert_arrays_equal("assert_arrays_equal", obj1, obj2)
		end

	test_assert_arrays_equal_3 is
			-- test something
		indexing
		 tag: "assert_arrays_equal.fail"
		local
			obj1: ARRAY[ANY]
			obj2: ARRAY[ANY]
		do
			create obj1.make(1, 10)
			create obj2.make(1, 9)
			obj1[1] := 1
			obj2[2] := 1
			assert_arrays_equal("assert_arrays_equal", obj1, obj2)
		end

	test_assert_iarrays_same_1 is
			-- test something
		indexing
		 tag: "assert_iarrays_same.pass"
		local
			obj1: ARRAY[INTEGER]
			obj2: ARRAY[INTEGER]
		do
			obj1 := <<0, 1, 2, 3, 4, 5, 6, 7, 8, 9>>
			obj2 := <<0, 1, 2, 3, 4, 5, 6, 7, 8, 9>>
			assert_iarrays_same("assert_iarrays_same", obj1, obj2)
		end

	test_assert_iarrays_same_2 is
			-- test something
		indexing
		 tag: "assert_iarrays_same.fail"
		local
			obj1: ARRAY[INTEGER]
			obj2: ARRAY[INTEGER]
		do
			obj1 := <<0, 1, 2, 3, 4, 5, 6, 7, 8, 9>>
			obj2 := <<0, 1, 2, 3, 4, 5, 6, 7, 8, 10>>
			assert_iarrays_same("assert_iarrays_same", obj1, obj2)
		end

	test_assert_iarrays_same_3 is
			-- test something
		indexing
		 tag: "assert_iarrays_same.fail"
		local
			obj1: ARRAY[INTEGER]
			obj2: ARRAY[INTEGER]
		do
			obj1 := <<0, 1, 2, 3, 4, 5, 6, 7, 8, 9>>
			obj2 := <<0, 1, 2, 3, 4, 5, 6, 7, 8>>
			assert_iarrays_same("assert_iarrays_same", obj1, obj2)
		end

	test_assert_execute_1 is
			-- test something
		indexing
		 tag: "assert_execute.pass"
		do
			assert_execute("echo Hello World")
		end

	test_assert_execute_2 is
			-- test something
		indexing
		 tag: "assert_execute.fail"
		do
			assert_execute("mkdir ???")
		end

	test_assert_exit_code_execute_1 is
			-- test something
		indexing
		 tag: "assert_exit_code_execute.pass"
		do
			assert_exit_code_execute("echo Hello World", 0)
		end

	test_assert_exit_code_execute_2 is
			-- test something
		indexing
		 tag: "assert_exit_code_execute.fail"
		do
			assert_exit_code_execute("echo Hello World", -1)
		end

	test_assert_not_exit_code_execute_1 is
			-- test something
		indexing
		 tag: "assert_not_exit_code_execute.fail"
		do
			assert_not_exit_code_execute("echo Hello World", 0)
		end

	test_assert_not_exit_code_execute_2 is
			-- test something
		indexing
		 tag: "assert_not_exit_code_execute.pass"
		do
			assert_not_exit_code_execute("echo Hello World", -1)
		end

invariant
	invariant_clause: True

end
