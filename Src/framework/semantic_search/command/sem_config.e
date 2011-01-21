note
	description: "Options for semantic search engine"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CONFIG

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

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

	input: detachable STRING
			-- Path for inputs
			-- Depending on the operation to perform, this attribute
			-- may point to a file or a directory.

	mysql_schema: STRING
			-- Name of the database schema

	class_name: detachable STRING
			-- Specified class name

	feature_name: detachable STRING
			-- Specified feature name

	timestamp: detachable STRING
			-- Time stamp

	output: detachable STRING
			-- Output file/directory for some operation

	feature_kinds: DS_HASH_SET [STRING]
			-- Set of specified feature kinds

	dot_path: detachable STRING
			-- Path to store dot file

	rapidminer_home: detachable STRING
			-- Path to the home directory of RapidMiner installation

	rapidminer_process_path: detachable STRING
			-- Path to the process file to be executed by RapidMiner

feature -- Constants

	all_feature_kind: STRING = "all"
	command_feature_kind: STRING = "command"
	query_feature_kind: STRING = "query"
	attribute_feature_kind: STRING = "attribute"
	function_feature_kind: STRING = "function"

feature -- Status report

	should_add_sql_document: BOOLEAN
			-- Should sql document be added?

	should_update_ranking: BOOLEAN
			-- Should update rankings of properties?

	should_generate_arff: BOOLEAN
			-- Should ARFF files be generated from ssql files?	

	should_generate_invariant: BOOLEAN
			-- Should invariants be generated?

	should_generate_decision_tree: BOOLEAN
			-- Should decision tree be generated from an ARFF file?

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

	set_input (a_input: like input)
			-- Set `input' with `a_input'.
		do
			input := a_input
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

	set_output (a_output: like output)
			-- Set `output' with `a_output'.
		do
			output := a_output
		end

	set_feature_kinds (a_kinds: LIST [STRING])
			-- Set feature kinds from `a_kinds' into `feature_kindes'.
		local
			l_kind: STRING
		do
			create feature_kinds.make (5)
			feature_kinds.set_equality_tester (string_equality_tester)

			across a_kinds as l_kinds loop
				l_kind := l_kinds.item.as_lower
				if
					l_kind ~ all_feature_kind or else
					l_kind ~ command_feature_kind or else
					l_kind ~ query_feature_kind or else
					l_kind ~ attribute_feature_kind or else
					l_kind ~ function_feature_kind
				then
					feature_kinds.force_last (l_kind)
				end
			end
		end

	set_should_generate_arff (b: BOOLEAN)
			-- Set `should_generate_arff' with `b'.
		do
			should_generate_arff := b
		ensure
			should_generate_arff_set: should_generate_arff = b
		end

	set_should_generate_invariant (b: BOOLEAN)
			-- Set `should_generate_invariant' with `b'.
		do
			should_generate_invariant := b
		ensure
			should_generate_invariant_set: should_generate_invariant = b
		end

	set_should_generate_decision_tree (b: BOOLEAN)
			-- Set `should_generate_decision_tree' with `b'.
		do
			should_generate_decision_tree := b
		ensure
			should_generate_decision_tree_set: should_generate_decision_tree = b
		end

	set_dot_path (a_path: STRING)
			-- Set `dot_path' with `a_path'.
		do
			dot_path := a_path
		end

	set_rapidminer_home (a_home: STRING)
			-- Set `rapidminer_home' with `a_home'.
		do
			rapidminer_home := a_home
		end

	set_rapidminer_process_path (a_path: STRING)
			-- Set `rapidminer_process_path' with `a_path'.
		do
			rapidminer_process_path := a_path
		end

end
