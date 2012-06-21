note
	description: "Summary description for {PS_MANUAL_TEST_SQLITE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_SQLITE

inherit
	PS_REPOSITORY_TESTS
	redefine on_clean end

feature -- Tests

	test_criteria_sqlite
		do
			criteria_tests.test_criteria_agents
			criteria_tests.test_criteria_predefined
			criteria_tests.test_criteria_agents_and_predefined
		end

	test_crud_flat_sqlite
		do
			crud_tests.all_flat_object_tests
		end

	test_references_sqlite
		do
			crud_tests.all_references_tests
		end




feature {NONE} -- Initialization

	make_repository: PS_RELATIONA_IN_MEMORY_REPOSITORY
		local
			backend: PS_GENERIC_LAYOUT_SQL_BACKEND
		do
			create database.make (sqlite_file)
			create backend.make (database, create {PS_SQLITE_STRINGS})

			backend.wipe_out_all

			create Result.make (backend)
		end

	sqlite_file: STRING = "/home/roman_arch/sqlite_database.db"
	--sqlite_file: STRING = "sqlite_database.db"

	database: PS_SQLITE_DATABASE



	on_clean
		do
			database.close_connections
		end

end
