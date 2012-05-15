note
	description: "Summary description for {PS_CRUD_TESTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_CRUD_TESTS

inherit
	PS_TESTS_GENERAL


feature {NONE}


	test_flat_class_store
		-- Test if a simple store-and-retrieve returns the same result
		local
			query: PS_OBJECT_QUERY[FLAT_CLASS_1]
		do
			repository.clean_db_for_testing
			create query.make
			flat_executor.insert (test_data.flat_class)
			flat_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
--			print (query.result_cursor.item.a_string_32)
--			print (test_data.flat_class.a_string_32)
--			print ( (query.result_cursor.item.a_string_32.is_deep_equal (test_data.flat_class.a_string_32)).out + "%N")
--			print ( (query.result_cursor.item.real_32_max = test_data.flat_class.real_32_max).out + "%N")
--			print (query.result_cursor.item.out + test_data.flat_class.out)
--			print ((query.result_cursor.item.almost_equals (test_data.flat_class)).out)
			assert ("The results are not equal", query.result_cursor.item.is_almost_equal (test_data.flat_class, 0.00001))
		end


	test_flat_class_all_crud
		-- Test all CRUD operations on a flat class
		local
			query: PS_OBJECT_QUERY[FLAT_CLASS_1]
		do
			repository.clean_db_for_testing
			-- Insert:
			create query.make
			flat_executor.insert (test_data.flat_class)
			flat_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal after insert", query.result_cursor.item.is_almost_equal (test_data.flat_class, 0.00001))

			test_data.flat_class.update
			flat_executor.update (test_data.flat_class)
			create query.make
			flat_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
--			print (test_data.flat_class.out + query.result_cursor.item.out)
			assert ("The results are not equal after update", query.result_cursor.item.is_almost_equal (test_data.flat_class, 0.00001))

			flat_executor.delete (test_data.flat_class)
			create query.make
			flat_executor.execute_query (query)
			assert ("The query returns a result, but it should be empty", query.result_cursor.after)


		end



	test_data_structures_store
		-- Test if a simple store-and-retrieve returns the same result
		local
			query: PS_OBJECT_QUERY[DATA_STRUCTURES_CLASS_1]
		do
			repository.clean_db_for_testing
			create query.make
			structures_executor.insert (test_data.data_structures_1)
			structures_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal", query.result_cursor.item.is_deep_equal (test_data.data_structures_1))
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
			structures_executor.insert (test_data.data_structures_1)
			structures_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			retrieved:= query.result_cursor.item
			assert ("The results are not equal", retrieved.is_deep_equal (test_data.data_structures_1))

			-- perform update
			retrieved.array_1[1].update
			flat_executor.update (retrieved.array_1[1])

			-- check if update worked
			create query.make
			structures_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			retrieved:= query.result_cursor.item
			assert ("The results are equal", not retrieved.is_deep_equal (test_data.data_structures_1))

			-- check that only the updated part really is different
			testdata_copy:= test_data.data_structures_1.deep_twin
			testdata_copy.array_1[1].update
			assert ("There was more than just one update", retrieved.is_deep_equal (testdata_copy))

		end





	initialize_crud_tests
		do
			create flat_executor.make_with_repository (repository)
			create structures_executor.make_with_repository (repository)
		end




	flat_executor: PS_CRUD_EXECUTOR [FLAT_CLASS_1]
	structures_executor: PS_CRUD_EXECUTOR [DATA_STRUCTURES_CLASS_1]

end
