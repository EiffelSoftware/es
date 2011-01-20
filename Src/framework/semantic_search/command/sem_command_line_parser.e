
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
			l_output: AP_STRING_OPTION
			l_input: AP_STRING_OPTION
			l_generate_arff: AP_FLAG
			l_feature_kind: AP_STRING_OPTION
			l_generate_inv: AP_FLAG
			l_str_list: LINKED_LIST [STRING]
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

				-- Note: this option is duplicated with l_ssql_directory.
			create l_directory.make_with_long_form ("input")
			l_directory.set_description ("Specify the path for inputs. Depending on the operation to perform, input can point to a file or a directory.")
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

			create l_output.make_with_long_form ("output")
			l_output.set_description ("Specify the path for outputs. Depending on the operation to perform, output can point to a file or a directory.")
			l_parser.options.force_last (l_output)

			create l_generate_arff.make_with_long_form ("generate-arff")
			l_generate_arff.set_description (
				"Generate ARFF files from ssql files. %
				%Format: --generate-arff [--class CLASS_NAME] [--feature FEATURE_NAME] [--feature-kind FEAT_KIND[,FEAT_KIND]] --input SSQL_DIR --output OUTPUT_DIR.%
				%SSQL_DIR is the directory storing ssql files. If CLASS_NAME is given, we assume SSQL_DIR contains ssql files for only that class;%
				%If CLASS_NAME is not given, we assume SSQL_DIR stores ssql files for a set of classes, and we'll generate ARFF for all found classes.%N%
				%FEAT_KIND specifies the kinds of features, valid kinds include all, command, query, attribute, function. If feature-kind is not present,%
				%the default is all.%N. FEATURE_NAME specifies the feature whose ARFF needs to be generated. If not present, ARFF files will be generated%N%
				%for all features passing the feature-kind test. OUTPUT_DIR is the place to store generated ARFF files.%N")
			l_parser.options.force_last (l_generate_arff)

			create l_feature_kind.make_with_long_form ("feature-kind")
			l_feature_kind.set_description (
				"Specifiy the kinds of features used in some operation.%N%
				%Format: --feature-kind FEAT_KIND[,FEAT_KIND]%N%
				%Valid values for FEAT_KIND are: all, command, query, attribute, function.%N")
			l_parser.options.force_last (l_feature_kind)


			create l_generate_inv.make_with_long_form ("generate-invariant")
			l_generate_inv.set_description (
				"Generate invariants using Daikon files from ARFF files. %
				%Format: --generate-arff [--class CLASS_NAME] [--feature FEATURE_NAME] [--feature-kind FEAT_KIND[,FEAT_KIND]] --input ARFF_DIR --output OUTPUT_DIR.%
				%ARFF_DIR is the directory storing ARFF files. If CLASS_NAME is given, we assume SSQL_DIR contains ssql files for only that class;%
				%If CLASS_NAME is not given, we assume ARFF_DIR stores ARFF files for a set of classes, and we'll generate invariants for all found classes.%N%
				%FEAT_KIND specifies the kinds of features, valid kinds include all, command, query, attribute, function. If feature-kind is not present,%
				%the default is all.%N. FEATURE_NAME specifies the feature whose invariants needs to be generated. If not present, invariant files will be generated%N%
				%for all features passing the feature-kind test. OUTPUT_DIR is the place to store generated invariant files.%N")
			l_parser.options.force_last (l_generate_inv)

			l_parser.parse_list (l_args)

			if l_add_doc_flag.was_found then
				config.set_should_add_sql_document (True)
			end

			if l_directory.was_found then
				config.set_input (l_directory.parameter)
			end

			if l_output.was_found then
				config.set_output (l_output.parameter)
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
			else
				config.set_timestamp ("")
			end

			if l_feature_kind.was_found then
				config.set_feature_kinds (l_feature_kind.parameter.split (','))
			else
				create l_str_list.make
				l_str_list.extend ({SEM_CONFIG}.all_feature_kind)
				config.set_feature_kinds (l_str_list)
			end

			if l_generate_arff.was_found then
				config.set_should_generate_arff (True)
			end

			if l_generate_inv.was_found then
				config.set_should_generate_invariant (True)
			end
		end

end
