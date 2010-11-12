note
	description: "Options for semantic search engine"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CONFIG

create
	make

feature{NONE} -- Initialization

	make (a_system: like eiffel_system)
			-- Initialize `eiffel_system' with `a_system'.
		local
			l_relation: EPA_EXPRESSION_RELATION
		do
			eiffel_system := a_system
			set_mysql_host ("localhost")
			set_mysql_user ("root")
			set_mysql_password ("")
			set_mysql_schema ("")
			set_mysql_port (3306)
		end

feature -- Access

	eiffel_system: SYSTEM_I
			-- Current system

	mysql_host: STRING
			-- Host name of MySQL server
			-- Default: localhost

	mysql_user: STRING
			-- User name of MySQL connection
			-- Default: root

	mysql_port: INTEGER
			-- Port number for MySQL connection
			-- Default: 3306

	mysql_password: STRING
			-- Password for `mysql_user'

	mysql_file_directory: STRING
			-- Path to sql files

	mysql_schema: STRING
			-- Name of the database schema

	class_name: detachable STRING
			-- Specified class name

	feature_name: detachable STRING
			-- Specified feature name

	timestamp: detachable STRING
			-- Time stamp

feature -- Status report

	should_add_sql_document: BOOLEAN
			-- Should sql document be added?

	should_update_ranking: BOOLEAN
			-- Should update rankings of properties?

feature -- Setting

	set_mysql_host (a_host: like mysql_host)
			-- Set `mysql_host' with `a_host'.
		do
			mysql_host := a_host.twin
		end

	set_mysql_user (a_user: like mysql_user)
			-- Set `mysql_user' with `a_user'.
		do
			mysql_user := a_user.twin
		end

	set_mysql_password (a_password: like mysql_password)
			-- Set `mysql_password' with `a_password'.
		do
			mysql_password := a_password.twin
		end

	set_mysql_schema (a_schema: like mysql_schema)
			-- Set `mysql_schema' with `a_schema'.
		do
			mysql_schema := a_schema.twin
		end

	set_mysql_port (a_port: INTEGER)
			-- Set `mysql_port' with `a_port'.
		do
			mysql_port := a_port
		end

	set_mysql_file_directory (a_sql_file_directory: like mysql_file_directory)
			-- Set `mysql_sql_file_directory' with `a_sql_file_directory'.
		do
			mysql_file_directory := a_sql_file_directory.twin
		end

	set_should_add_sql_document (b: BOOLEAN)
			-- Set `should_add_sql_document' with `b'.
		do
			should_add_sql_document := b
		ensure
			should_add_sql_document_set: should_add_sql_document = b
		end

	set_should_update_ranking (b: BOOLEAN)
			-- Set `should_update_ranking' with `b'.
		do
			should_update_ranking := b
		ensure
			should_update_ranking_set: should_update_ranking = b
		end

	set_class_name (a_class_name: like class_name)
			-- Set `class_name' with `a_class_name'.
		do
			if a_class_name = Void then
				class_name := Void
			else
				class_name := a_class_name.twin
			end
		end

	set_feature_name (a_feature_name: like feature_name)
			-- Set `feature_name' with `a_feature_name'.
		do
			if a_feature_name = Void then
				feature_name := Void
			else
				feature_name := a_feature_name.twin
			end
		end

	set_timestamp (a_timestamp: like timestamp)
			-- Set `timestamp' with `a_timestamp'.
		do
			timestamp := a_timestamp
		end

end
