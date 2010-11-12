note
	description: "Command line parser for semantic search functionalities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_COMMAND_LINE_PARSER

create
	make_with_arguments

feature{NONE} -- Initialization

	make_with_arguments (a_args: LINKED_LIST [STRING]; a_system: SYSTEM_I)
			-- Initialize Current with arguments `a_args'.
		do
			create config.make (a_system)
			arguments := a_args
		ensure
			arguments_set: arguments = a_args
			options_set: config.eiffel_system = a_system
		end

feature -- Access

	config: SEM_CONFIG
			-- AutoFix command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_add_doc_flag: AP_FLAG
			l_mysql_host: AP_STRING_OPTION
			l_mysql_port: AP_INTEGER_OPTION
			l_mysql_user: AP_STRING_OPTION
			l_mysql_password: AP_STRING_OPTION
			l_directory: AP_STRING_OPTION
			l_mysql_schema: AP_STRING_OPTION
			l_class: AP_STRING_OPTION
			l_feature: AP_STRING_OPTION
			l_update_ranking_flag: AP_FLAG
			l_timestamp: AP_STRING_OPTION
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_add_doc_flag.make_with_long_form ("add-sql-documents")
			l_add_doc_flag.set_description ("Add documents specified by --directory into MySQL database.")
			l_parser.options.force_last (l_add_doc_flag)

			create l_mysql_host.make_with_long_form ("mysql-host")
			l_mysql_host.set_description ("Specify host name of MySQL server. Default: localhost")
			l_parser.options.force_last (l_mysql_host)

			create l_mysql_user.make_with_long_form ("mysql-user")
			l_mysql_user.set_description ("Specify user name of MySQL server. Default: root")
			l_parser.options.force_last (l_mysql_user)

			create l_mysql_port.make_with_long_form ("mysql-port")
			l_mysql_port.set_description ("Specify port of MySQL server. Default: 3306")
			l_parser.options.force_last (l_mysql_port)

			create l_mysql_password.make_with_long_form ("mysql-password")
			l_mysql_password.set_description ("Specify password of MySQL server.")
			l_parser.options.force_last (l_mysql_password)

			create l_directory.make_with_long_form ("directory")
			l_directory.set_description ("Specify the directory of the sql related files.")
			l_parser.options.force_last (l_directory)

			create l_mysql_schema.make_with_long_form ("mysql-schema")
			l_mysql_schema.set_description ("Specify the schema of the semantic search database.")
			l_parser.options.force_last (l_mysql_schema)

			create l_class.make_with_long_form ("class")
			l_class.set_description ("Specify name of the class to analyze.")
			l_parser.options.force_last (l_class)

			create l_feature.make_with_long_form ("feature")
			l_class.set_description ("Specify name of the feature to analyze. If current option is present, the --class option must be present as well.")
			l_parser.options.force_last (l_feature)

			create l_update_ranking_flag.make_with_long_form ("update-ranking")
			l_update_ranking_flag.set_description ("Update property rankings. The class and feature whose properties are to be ranked are specified through --class and --feature options.")
			l_parser.options.force_last (l_update_ranking_flag)

			create l_timestamp.make_with_long_form ("timestamp")
			l_timestamp.set_description ("Specify timestamp of the documents.")
			l_parser.options.force_last (l_timestamp)

			l_parser.parse_list (l_args)

			if l_add_doc_flag.was_found then
				config.set_should_add_sql_document (True)
			end

			if l_directory.was_found then
				config.set_mysql_file_directory (l_directory.parameter)
			end

			if l_mysql_host.was_found then
				config.set_mysql_host (l_mysql_host.parameter)
			end

			if l_mysql_user.was_found then
				config.set_mysql_user (l_mysql_user.parameter)
			end

			if l_mysql_port.was_found then
				config.set_mysql_port (l_mysql_port.parameter)
			end

			if l_mysql_password.was_found then
				config.set_mysql_password (l_mysql_password.parameter)
			end

			if l_mysql_schema.was_found then
				config.set_mysql_schema (l_mysql_schema.parameter)
			end

			if l_class.was_found then
				config.set_class_name (l_class.parameter)
			end

			if l_feature.was_found then
				config.set_feature_name (l_feature.parameter)
			end

			if l_update_ranking_flag.was_found then
				config.set_should_update_ranking (True)
			end

			if l_timestamp.was_found then
				config.set_timestamp (l_timestamp.parameter)
			end
		end

end
