note
	description: "Summary description for {AFX_COMMAND_LINE_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_COMMAND_LINE_PARSER

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
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)
			create l_retrieve_state_option.make ('s', "--state")
			l_retrieve_state_option.set_description ("Retrieve system state at specified break points.")
			l_parser.options.force_last (l_retrieve_state_option)

				-- Parse `arguments'.
			l_parser.parse_list (l_args)

				-- Setup `options'.
			options.set_should_retrieve_state (l_retrieve_state_option.was_found)
		end

end
