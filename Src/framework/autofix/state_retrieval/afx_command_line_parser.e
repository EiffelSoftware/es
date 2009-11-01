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
			create options.make (a_system)
			arguments := a_args
		ensure
			arguments_set: arguments = a_args
			options_set: options.eiffel_system = a_system
		end

feature -- Access

	options: AFX_CONFIG
			-- AutoFix command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `options'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_retrieve_state_option: AP_FLAG
			l_recipient: AP_STRING_OPTION
			l_feat_under_test: AP_STRING_OPTION
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_retrieve_state_option.make ('s', "state")
			l_retrieve_state_option.set_description ("Retrieve system state at specified break points.")
			l_parser.options.force_last (l_retrieve_state_option)

			create l_recipient.make_with_long_form ("s-recipient")
			l_recipient.set_description ("Specify the recipient of the exception in the test case. The format is CLASS_NAME.feature_name. If this option is provided while the <feature_under_test> option is not provided, the value of <feature_under_test> will be set to current value as well.")
			l_parser.options.force_last (l_recipient)

			create l_feat_under_test.make_with_long_form ("s-feature-under-test")
			l_feat_under_test.set_description ("Specify the feature under test. The format is CLASS_NAME.feature_name. When presents, its value will overwrite the one which is set by <recipient>.")
			l_parser.options.force_last (l_feat_under_test)

				-- Parse `arguments'.
			l_parser.parse_list (l_args)

				-- Setup `options'.
			options.set_should_retrieve_state (l_retrieve_state_option.was_found)

			if l_recipient.was_found then
				options.set_state_recipient (feature_from_string (l_recipient.parameter))
				options.set_state_feature_under_test (options.state_recipient)
			end

			if l_feat_under_test.was_found then
				options.set_state_feature_under_test (feature_from_string (l_feat_under_test.parameter))
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
