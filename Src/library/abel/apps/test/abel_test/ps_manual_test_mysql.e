note
	description: "Tests ABEL with a MySQL backend"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_MYSQL

inherit
	PS_REPOSITORY_TESTS


feature

	test_crud_flat_mysql
		do
			crud_tests.test_flat_class_store
			crud_tests.test_flat_class_all_crud
		end

	test_criteria_mysql
		do
			criteria_tests.test_criteria_agents
			criteria_tests.test_criteria_predefined
			criteria_tests.test_criteria_agents_and_predefined
		end

	test_references_mysql
		do
			crud_tests.test_insert_void_reference
			crud_tests.test_insert_one_reference
			crud_tests.test_insert_reference_cycle
		end


feature {NONE} -- Initialization





	make_repository: PS_RELATIONA_IN_MEMORY_REPOSITORY
		local
			database: PS_MYSQL_DATABASE
			backend: PS_GENERIC_LAYOUT_SQL_BACKEND
		do
			create database.make (username, password, db_name, db_host, db_port)
			create backend.make (database)

			backend.wipe_out_all

			create Result.make (backend)
		end


	username:STRING = "pfadief_eiffel"
	password:STRING = "eiffelstore"

	db_name:STRING = "pfadief_eiffelstoretest"
	db_host:STRING = "pfadief.mysql.db.hostpoint.ch"
	db_port:INTEGER = 3306



end
