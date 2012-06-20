note
	description: "Summary description for {PS_MANUAL_TEST_SQLITE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_SQLITE

inherit
	PS_REPOSITORY_TESTS

feature -- Tests

	test_criteria_sqlite
		do
			criteria_tests.test_criteria_agents
			criteria_tests.test_criteria_predefined
			criteria_tests.test_criteria_agents_and_predefined
		end



feature {NONE} -- Initialization

	make_repository: PS_RELATIONA_IN_MEMORY_REPOSITORY
		local
			database: PS_SQLITE_DATABASE
			backend: PS_GENERIC_LAYOUT_SQL_BACKEND
		do
			create database.make (sqlite_file)
			create backend.make (database, create {PS_SQLITE_STRINGS})

			backend.wipe_out_all

			create Result.make (backend)
		end

	sqlite_file: STRING = "sqlite_database.db"

end
