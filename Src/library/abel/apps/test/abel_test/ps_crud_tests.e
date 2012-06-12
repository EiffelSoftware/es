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
			ref:REFERENCE_CLASS_1
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
		do
			create ref.make (1)
			create query.make

			executor.insert (ref)
			executor.execute_query (query)

			assert ("Equal results", ref.is_deep_equal (query.result_cursor.item))
			repository.clean_db_for_testing
		end


	test_insert_one_reference
		local
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
			first_result, second_result: REFERENCE_CLASS_1
		do
			create query.make
			executor.insert (test_data.reference_to_single_other)
			executor.execute_query (query)

			assert ("The result is empty", not query.result_cursor.after)
			first_result:= query.result_cursor.item
			query.result_cursor.forth
			assert ("The result has only one item", not query.result_cursor.after)
			second_result:= query.result_cursor.item
			query.result_cursor.forth
			assert ("The result has more than two items", query.result_cursor.after)

			assert ("The items are not equal", test_data.reference_to_single_other.is_deep_equal (first_result) or test_data.reference_to_single_other.is_deep_equal (second_result))

			repository.clean_db_for_testing
		end

	test_insert_reference_cycle
		local
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
			original:REFERENCE_CLASS_1
			ref_list: LINKED_LIST[REFERENCE_CLASS_1]
			equality: BOOLEAN
		do
			executor.insert (test_data.reference_1)
			create query.make
			executor.execute_query (query)

			assert ("The result is empty", not query.result_cursor.after)

			-- collect results
			create ref_list.make
			across query as cursor loop
				ref_list.extend (cursor.item)
			end

			assert ("The result contains less than 3 items", ref_list.count >= 3)
			assert ("The result contains more than 3 items", ref_list.count <= 3)

			-- here we have the problem that the result is not sorted...
			original:= test_data.reference_1
			equality:= original.is_deep_equal (ref_list[1]) or original.is_deep_equal (ref_list[2]) or original.is_deep_equal (ref_list[3])

			assert ("The results are not the same", equality)
			repository.clean_db_for_testing
		end


	test_flat_class_store
		-- Test if a simple store-and-retrieve returns the same result
		local
			query: PS_OBJECT_QUERY[FLAT_CLASS_1]
		do
--			repository.clean_db_for_testing
			create query.make
			executor.insert (test_data.flat_class)
			executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal", query.result_cursor.item.is_almost_equal (test_data.flat_class, 0.00001))
			repository.clean_db_for_testing
		end


	test_flat_class_all_crud
		-- Test all CRUD operations on a flat class
		local
			query: PS_OBJECT_QUERY[FLAT_CLASS_1]
		do
--			repository.clean_db_for_testing
			-- Insert:
			create query.make
			executor.insert (test_data.flat_class)
			executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal after insert", query.result_cursor.item.is_almost_equal (test_data.flat_class, 0.00001))

			test_data.flat_class.update
			executor.update (test_data.flat_class)
			create query.make
			executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
--			print (test_data.flat_class.out + query.result_cursor.item.out)
			assert ("The results are not equal after update", query.result_cursor.item.is_almost_equal (test_data.flat_class, 0.00001))

			executor.delete (test_data.flat_class)
			create query.make
			executor.execute_query (query)
			assert ("The query returns a result, but it should be empty", query.result_cursor.after)

			repository.clean_db_for_testing
		end



	test_data_structures_store
		-- Test if a simple store-and-retrieve returns the same result
		local
			query: PS_OBJECT_QUERY[DATA_STRUCTURES_CLASS_1]
		do
			repository.clean_db_for_testing
			create query.make
			executor.insert (test_data.data_structures_1)
			executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal", query.result_cursor.item.is_deep_equal (test_data.data_structures_1))

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
end
