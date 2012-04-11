note
	description: "Summary description for {PS_MANUAL_TEST_MYSQL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_MANUAL_TEST_MYSQL

inherit
	PS_CRITERIA_TESTS

feature




	test_criteria_mysql
		do
			test_criteria_agents
			test_criteria_predefined
			test_criteria_agents_and_predefined
		end


feature {NONE} -- Database connection details

	on_prepare
		local
			rep: PS_RDB_REPOSITORY
			strategy: PS_GENERIC_LAYOUT_STRATEGY
		--	database:MYSQLI_CLIENT

		do

			create strategy.make
			create rep.make (strategy, username, password, db_name, db_host, db_port)
			rep.clean_db_for_testing
			repository:=rep
			initialize_criteria_tests

		end



	username:STRING = "pfadief_eiffel"
	password:STRING = "eiffelstore"

	db_name:STRING = "pfadief_eiffelstoretest"
	db_host:STRING = "pfadief.mysql.db.hostpoint.ch"
	db_port:INTEGER = 3306



end
