note
	description: "Command line parser for snippet extraction functionalities."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_COMMAND_LINE_PARSER

inherit
	EXT_SHARED_LOGGER

create
	make_with_arguments

feature {NONE} -- Initialization

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

	config: EXT_CONFIG
			-- Snippet extraction command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]

			l_target_types: AP_STRING_OPTION
			l_group: AP_STRING_OPTION
			l_namespace: AP_STRING_OPTION
			l_class: AP_STRING_OPTION
			l_feature: AP_STRING_OPTION
			l_output: AP_STRING_OPTION
			l_log_file: AP_STRING_OPTION
			l_maximum_cfg_level: AP_INTEGER_OPTION
			l_maximum_line: AP_INTEGER_OPTION
			l_log_snippet_file: AP_STRING_OPTION
			l_extract_contracts: AP_FLAG
			l_normalizer: AP_FLAG
			l_extract_fragments: AP_FLAG
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_target_types.make_with_long_form ("target-type")
			l_target_types.set_description ("Specify a list of type names separated by ';' that are going to be mined.")
			l_target_types.enable_mandatory
			l_parser.options.force_last (l_target_types)

			create l_group.make_with_long_form ("group")
			l_group.set_description ("Specify name of a cluster or library to restrict analysis to group contained classes.")
			l_parser.options.force_last (l_group)

			create l_namespace.make_with_long_form ("namespace")
			l_namespace.set_description ("Identifier where the snippets come from, i.e. project name.")
			l_parser.options.force_last (l_namespace)

			create l_class.make_with_long_form ("class")
			l_class.set_description ("Specify name of the class to analyze.")
			l_parser.options.force_last (l_class)

			create l_feature.make_with_long_form ("feature")
			l_feature.set_description ("Specify name of the feature to analyze.")
			l_parser.options.force_last (l_feature)

			create l_output.make_with_long_form ("output-path")
			l_output.set_description ("Specify a folder to output files.")
			l_parser.options.force_last (l_output)

			create l_log_file.make_with_long_form ("log-file")
			l_log_file.set_description ("File to write logging information to, additional to standard output.")
			l_parser.options.force_last (l_log_file)

			create l_maximum_cfg_level.make_with_long_form ("maximum-cfg-level")
			l_maximum_cfg_level.set_description ("Specify the allowed maximum control flow level for a snippet to be reported. Format: --maximum-cfg-level <level> where <level> is an integer. 0 means no limit. Default: 0.")
			l_parser.options.force_last (l_maximum_cfg_level)

			create l_maximum_line.make_with_long_form ("maximum-line")
			l_maximum_line.set_description ("Specify the allowed maximum number of lines for a snippet to be reported. Format: --maximum-lines <lines> where <lines> is an integer. 0 means no limit. Default: 0.")
			l_parser.options.force_last (l_maximum_line)

			create l_log_snippet_file.make_with_long_form ("snippet-log-file")
			l_log_snippet_file.set_description ("Specify the absolute file path to log ONLY snippets. Format: --log-snippet-file <file>.")
			l_parser.options.force_last (l_log_snippet_file)

			create l_extract_contracts.make_with_long_form ("extract-contract")
			l_extract_contracts.set_description ("Extract contracts from callees in the snippet.")
			l_parser.options.force_last (l_extract_contracts)

			create l_normalizer.make_with_long_form ("normalize-variable")
			l_normalizer.set_description ("Should variable names in snippets be normalized?")
			l_parser.options.force_last (l_normalizer)

			create l_extract_fragments.make_with_long_form ("extract-fragment")
			l_extract_fragments.set_description ("Extract fragments of the snippets.")
			l_parser.options.force_last (l_extract_fragments)

			l_parser.parse_list (l_args)

			if l_target_types.was_found then
				config.set_target_types (l_target_types.parameter.split (';'))
			end

			if l_namespace.was_found then
				config.set_namespace (l_namespace.parameter)
			end

			if l_class.was_found then
				config.set_class_name (l_class.parameter)
			end

			if l_feature.was_found then
				config.set_feature_name (l_feature.parameter)
			end

			if l_group.was_found then
				config.set_group_name (l_group.parameter)
			end

			if l_output.was_found then
				config.set_output (l_output.parameter)
			end

			if l_log_file.was_found then
				config.set_log_file_name (l_log_file.parameter)
					-- Add a logging file to the logging setup.
				log.loggers.force (create {ELOG_FILE_LOGGER}.make_with_path (config.log_file_name))
			end

			if l_maximum_cfg_level.was_found then
				config.set_maximum_cfg_structure_level (l_maximum_cfg_level.parameter)
			end

			if l_maximum_line.was_found then
				config.set_maximum_lines_of_code (l_maximum_line.parameter)
			end

			if l_log_snippet_file.was_found then
				config.set_snippet_log_file (l_log_snippet_file.parameter)
			end

			if l_extract_contracts.was_found then
				config.set_should_extract_contract (True)
			end

			if l_normalizer.was_found then
				config.set_should_normalize_variable_name (True)
			end

			if l_extract_fragments.was_found then
				config.set_should_extract_fragment (True)
			end
		end

end
