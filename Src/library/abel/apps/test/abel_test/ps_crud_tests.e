note
	description: "Provides tests for the CRUD (Create, Read, Update, Delete) operations"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_CRUD_TESTS

inherit
	PS_TEST_PROVIDER

create make

feature {PS_REPOSITORY_TESTS}

	test_insert_void_reference
		local
			test: PS_GENERIC_CRUD_TEST[REFERENCE_CLASS_1]
		do
			create test.make (repository)
			test.test_insert (test_data.void_reference)
			repository.clean_db_for_testing
		end


	test_insert_one_reference
		local
			test: PS_GENERIC_CRUD_TEST [REFERENCE_CLASS_1]
		do
			create test.make (repository)
			test.test_insert (test_data.reference_to_single_other)

			assert ("The result does not have exactly two items", test.count_results = 2)
			repository.clean_db_for_testing
		end

	test_insert_reference_cycle
		local
			test: PS_GENERIC_CRUD_TEST[REFERENCE_CLASS_1]
		do
			create test.make (repository)
			test.test_insert (test_data.reference_cycle)
			assert ("The wrong number of items has been inserted", test.count_results = 3)
			repository.clean_db_for_testing
		end

	test_crud_reference_cycle
		local
			test: PS_GENERIC_CRUD_TEST[REFERENCE_CLASS_1]
		do
			create test.make (repository)
			test.test_crud_operations (test_data.reference_cycle, agent {REFERENCE_CLASS_1}.update)
			repository.clean_db_for_testing
		end

	test_crud_update_on_reference
		local
			test: PS_GENERIC_CRUD_TEST [REFERENCE_CLASS_1]
		do
			create test.make (repository)
			test.test_crud_operations (test_data.reference_to_single_other, agent update_reference)
		end


	test_flat_class_store
		-- Test if a simple store-and-retrieve returns the same result
		local
			test: PS_GENERIC_CRUD_TEST[FLAT_CLASS_1]
		do
			create test.make (repository)
			test.test_insert_special_equality (test_data.flat_class, agent {FLAT_CLASS_1}.is_almost_equal (?, 0.00001))
			repository.clean_db_for_testing
		end


	test_flat_class_all_crud
		-- Test all CRUD operations on a flat class
		local
			test: PS_GENERIC_CRUD_TEST[FLAT_CLASS_1]
		do
			create test.make (repository)
			test.test_crud_operations_special_equality (test_data.flat_class, agent{FLAT_CLASS_1}.update,  agent {FLAT_CLASS_1}.is_almost_equal (?, 0.00001))
			repository.clean_db_for_testing
		end



	test_data_structures_store
		-- Test if a simple store-and-retrieve returns the same result
		local
			test: PS_GENERIC_CRUD_TEST[DATA_STRUCTURES_CLASS_1]
			query: PS_OBJECT_QUERY[DATA_STRUCTURES_CLASS_1]
		do
			create test.make (repository)
			test.test_insert (test_data.data_structures_1)
			-- TODO: They are probably not equal, as DATA_STRUCTURES uses FLAT_CLASS, which uses REALs that have a rounding error.
			repository.clean_db_for_testing
		end


	test_update_on_reference
		-- test if an update on a referenced object works
		local
			query: PS_OBJECT_QUERY[DATA_STRUCTURES_CLASS_1]
			retrieved: DATA_STRUCTURES_CLASS_1
			testdata_copy: DATA_STRUCTURES_CLASS_1
		do
			repository.clean_db_for_testing

			create query.make
			executor.insert (test_data.data_structures_1)
			executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			retrieved:= query.result_cursor.item
			assert ("The results are not equal", retrieved.is_deep_equal (test_data.data_structures_1))

			-- perform update
			retrieved.array_1[1].update
			executor.update (retrieved.array_1[1])

			-- check if update worked
			create query.make
			executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			retrieved:= query.result_cursor.item
			assert ("The results are equal", not retrieved.is_deep_equal (test_data.data_structures_1))

			-- check that only the updated part really is different
			testdata_copy:= test_data.data_structures_1.deep_twin
			testdata_copy.array_1[1].update
			assert ("There was more than just one update", retrieved.is_deep_equal (testdata_copy))

			repository.clean_db_for_testing
		end


feature {NONE}

	update_reference (obj: REFERENCE_CLASS_1)
		local
			ref_obj: REFERENCE_CLASS_1
		do
			ref_obj:= attach (obj.refer)
			ref_obj.update
			executor.update (ref_obj)
		end

end
