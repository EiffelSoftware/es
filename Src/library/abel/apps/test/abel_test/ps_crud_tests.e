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
			create query.make
			flat_executor.insert (test_data.flat_class)
			flat_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal", query.result_cursor.item.is_deep_equal (test_data.flat_class))
		end


	test_flat_class_all_crud
		-- Test all CRUD operations on a flat class
		local
			query: PS_OBJECT_QUERY[FLAT_CLASS_1]
		do
			-- todo: wipe out repository before each test

			-- Insert:
			create query.make
			flat_executor.insert (test_data.flat_class)
			flat_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal", query.result_cursor.item.is_deep_equal (test_data.flat_class))

			test_data.flat_class.update
			flat_executor.update (test_data.flat_class)
			create query.make
			flat_executor.execute_query (query)
			assert ("The query doesn't return a result", not query.result_cursor.after)
			assert ("The results are not equal", query.result_cursor.item.is_deep_equal (test_data.flat_class))

			flat_executor.delete (test_data.flat_class)
			create query.make
			flat_executor.execute_deletion_query (query)
			assert ("The query returns a result, but it should be empty", query.result_cursor.after)


		end



	initialize_crud_tests
	do
		create flat_executor.make_with_repository (repository)
	end




	flat_executor: PS_CRUD_EXECUTOR [FLAT_CLASS_1]

end
