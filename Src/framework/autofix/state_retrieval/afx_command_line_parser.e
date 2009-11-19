note
	description: "Summary description for {AFX_COMMAND_LINE_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_COMMAND_LINE_PARSER

inherit
	AFX_UTILITY

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

	config: AFX_CONFIG
			-- AutoFix command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_retrieve_state_option: AP_FLAG
			l_recipient: AP_STRING_OPTION
			l_feat_under_test: AP_STRING_OPTION
			l_analyze_test_case_option: AP_STRING_OPTION
			l_max_test_case_no_option: AP_INTEGER_OPTION
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_retrieve_state_option.make ('s', "retrieve-state")
			l_retrieve_state_option.set_description ("Retrieve system state at specified break points.")
			l_parser.options.force_last (l_retrieve_state_option)

			create l_recipient.make_with_long_form ("recipient")
			l_recipient.set_description ("Specify the recipient of the exception in the test case. The format is CLASS_NAME.feature_name. If this option is provided while the <feature_under_test> option is not provided, the value of <feature_under_test> will be set to current value as well.")
			l_parser.options.force_last (l_recipient)

			create l_feat_under_test.make_with_long_form ("feature-under-test")
			l_feat_under_test.set_description ("Specify the feature under test. The format is CLASS_NAME.feature_name. When presents, its value will overwrite the one which is set by <recipient>.")
			l_parser.options.force_last (l_feat_under_test)

			create l_analyze_test_case_option.make_with_long_form ("analyze-tc")
			l_analyze_test_case_option.set_description ("Analyze test cases storeing in the folder specified by the parameter.")
			l_parser.options.force_last (l_analyze_test_case_option)

			create l_max_test_case_no_option.make_with_long_form ("max-tc-number")
			l_max_test_case_no_option.set_description ("Maximum number of test cases that are used for invariant inference. 0 means no upper bound. Default: 0")
			l_parser.options.force_last (l_max_test_case_no_option)

				-- Parse `arguments'.
			l_parser.parse_list (l_args)

				-- Setup `config'.
			config.set_should_retrieve_state (l_retrieve_state_option.was_found)

			if l_recipient.was_found then
				config.set_state_recipient (feature_from_string (l_recipient.parameter))
				config.set_state_feature_under_test (config.state_recipient)
			end

			if l_feat_under_test.was_found then
				config.set_state_feature_under_test (feature_from_string (l_feat_under_test.parameter))
			end

			config.set_should_analyze_test_cases (l_analyze_test_case_option.was_found)
			if config.should_analyze_test_cases then
				config.set_test_case_path (l_analyze_test_case_option.parameter)
			end

			if l_max_test_case_no_option.was_found then
				config.set_max_test_case_number (l_max_test_case_no_option.parameter)
			else
				config.set_max_test_case_number (0)
			end
		end

feature{NONE} -- Implementation

	feature_from_string (a_string: STRING): detachable FEATURE_I
			-- Feature from string in format "CLASS_NAME.feature_name".
			-- Void if no such feature exists.
		local
			l_dot_index: INTEGER
			l_class_name: STRING
			l_feat_name: STRING
			l_classes: LIST [CLASS_I]
			l_class_c: CLASS_C
		do
			l_dot_index := a_string.index_of ('.', 1)
			if l_dot_index > 0 then
				l_class_name := a_string.substring (1, l_dot_index - 1).as_upper
				l_feat_name := a_string.substring (l_dot_index + 1, a_string.count).as_lower
				l_classes := universe.classes_with_name (l_class_name)
				if not l_classes.is_empty then
					l_class_c := l_classes.first.compiled_representation
					Result := l_class_c.feature_named (l_feat_name)
				end
			end
		end

end
