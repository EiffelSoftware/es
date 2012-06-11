note
	description: "Summary description for {PS_MANUAL_TEST_MYSQL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_MYSQL

inherit
	PS_CRITERIA_TESTS
	PS_CRUD_TESTS

feature

	test_initial_insert
		local
			ref_executor: PS_CRUD_EXECUTOR--[REFERENCE_CLASS_1]
			query:PS_OBJECT_QUERY[REFERENCE_CLASS_1]
			original, one, two, three:REFERENCE_CLASS_1
			ref_list: LINKED_LIST[REFERENCE_CLASS_1]
			eq: BOOLEAN
		do
			repository.clean_db_for_testing
--			flat_executor.insert (test_data.flat_class)
			create ref_executor.make_with_repository (repository)
			ref_executor.insert (test_data.reference_1)
--			print (int_repo.disassembler.disassembled_object.to_string)
--			structures_executor.insert (test_data.data_structures_1)

--			print (int_repo.memory_db.string_representation)
			create query.make
			ref_executor.execute_query (query)

			assert ("The result is empty", not query.result_cursor.after)

			create ref_list.make

			across query as cursor loop
				ref_list.extend (cursor.item)
			end

			-- here we have the problem that the result is not sorted...
--			one:= query.result_cursor.item
--			query.result_cursor.forth
--			two:= query.result_cursor.item
--			query.result_cursor.forth
--			three:= query.result_cursor.item

			original:= test_data.reference_1

			eq:= original.is_deep_equal (ref_list[1]) or original.is_deep_equal (ref_list[2]) or original.is_deep_equal (ref_list[3])

--			eq:= original.is_deep_equal (one) or original.is_deep_equal (two) or original.is_deep_equal (three)
--			print ( three.tagged_out+ attach (three.refer).tagged_out + attach (attach (three.refer).refer).tagged_out + "%N")
--			print ( original.tagged_out+ attach (original.refer).tagged_out + attach (attach (original.refer).refer).tagged_out)

--			print (original.ref_arrays.out + ref_list[3].ref_arrays.out)
--			print (original.ref_arrays.area.count.out + " " + ref_list[3].ref_arrays.area.count.out)

			assert ("The results are not the same", eq)
		end


	test_crud_flat_in_memory
		do
			test_flat_class_store
			test_flat_class_all_crud
		end

	test_criteria_mysql
		do
			insert_data
			test_criteria_agents
			test_criteria_predefined
			test_criteria_agents_and_predefined
		end


feature {NONE} -- Database connection details

	on_prepare
		local
			database: PS_MYSQL_DATABASE
			backend: PS_GENERIC_LAYOUT_SQL_BACKEND
			repo: PS_RELATIONA_IN_MEMORY_REPOSITORY
		do
			create database.make (username, password, db_name, db_host, db_port)
			create backend.make (database)

			backend.wipe_out_all

			create repo.make (backend)

			repository:= repo
			initialize_criteria_tests
			initialize_crud_tests

		end



	username:STRING = "pfadief_eiffel"
	password:STRING = "eiffelstore"

	db_name:STRING = "pfadief_eiffelstoretest"
	db_host:STRING = "pfadief.mysql.db.hostpoint.ch"
	db_port:INTEGER = 3306



end
