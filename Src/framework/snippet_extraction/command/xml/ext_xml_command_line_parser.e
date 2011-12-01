note
	description: "Command line parser for class to XML transformation."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_XML_COMMAND_LINE_PARSER

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

	config: EXT_XML_CONFIG
			-- XML transformation command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]

			l_class: AP_STRING_OPTION
			l_group: AP_STRING_OPTION
			l_output_path: AP_STRING_OPTION
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_class.make_with_long_form ("class")
			l_class.set_description ("Specify name of the class to analyze.")
			l_parser.options.force_last (l_class)

			create l_group.make_with_long_form ("group")
			l_group.set_description ("Specify name of a cluster or library to restrict analysis to group contained classes.")
			l_parser.options.force_last (l_group)

			create l_output_path.make_with_long_form ("output-path")
			l_output_path.set_description ("Specify a folder to output files.")
			l_output_path.enable_mandatory
			l_parser.options.force_last (l_output_path)

			l_parser.parse_list (l_args)

			if l_class.was_found then
				config.set_class_name (l_class.parameter)
			end

			if l_group.was_found then
				config.set_group_name (l_group.parameter)
			end

			if l_output_path.was_found then
				config.set_output_path (l_output_path.parameter)
			end
		end

end
