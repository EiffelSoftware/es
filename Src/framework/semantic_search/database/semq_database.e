note
	description: "Base class for all database operations"
	author: "haroth@student.ethz.ch"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEMQ_DATABASE

feature{SEMQ_DATABASE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
			mysql := Void
		end

feature -- Access

	config: SEM_CONFIG
			-- Configuration for semantic search

feature{SEMQ_DATABASE} -- Field Names

	sem_field_names: SEM_FIELD_NAMES

	make_sem_field_names
			-- Initialize field names
		do
			if sem_field_names = Void then
				create sem_field_names
			end
		ensure
			sem_field_names /= Void
		end

feature{SEMQ_DATABASE} -- Type Conformance Calculator

	type_conformance_calc: SQL_TYPE_CONFORMANCE_CALCULATOR
			-- Calculates Conformance Hierarchy for set of Eiffel types

	make_type_conformance_calc
			-- Initialize calculator
		do
			if type_conformance_calc = Void then
				create type_conformance_calc.make_empty
			end
		ensure
			type_conformance_calc /= Void
		end

feature{SEMQ_DATABASE} -- MySQL Client

	mysql: MYSQL_CLIENT
			-- Instance of a MySQL Client

	open_mysql
			-- Initialize MySQL Client
		do
			if mysql = Void then
				create mysql.make (config.mysql_host, config.mysql_user, config.mysql_password, config.mysql_schema)
			end
		end

	cleanup_mysql
			-- Close statements
		deferred
		end

	close_mysql
			-- Close MySQL Client
		do
			if mysql /= Void and mysql.is_connected then
				cleanup_mysql
				mysql.close
				mysql := Void
			end
		ensure
			mysql = Void
		end

end
