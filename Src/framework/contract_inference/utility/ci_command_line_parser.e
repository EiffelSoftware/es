note
	description: "Command line parser for contract inference"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_COMMAND_LINE_PARSER

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

	config: CI_CONFIG
			-- AutoFix command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

feature -- Basic operations

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_build_project_option: AP_STRING_OPTION
			l_feature_name_option: AP_STRING_OPTION
			l_class_name_option: AP_STRING_OPTION
			l_infer_option: AP_FLAG
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_build_project_option.make_with_long_form ("build-from")
			l_build_project_option.set_description ("Transform current project into a project containing infrastructure to support contract inference. Format: --build-from <test case directory>. <test case directory> contains test cases from which contract inference should be performed. The directory is recursively searched to find test cases. <test case directory> should contain test cases for only one class.")
			l_parser.options.force_last (l_build_project_option)

			create l_feature_name_option.make_with_long_form ("feature")
			l_feature_name_option.set_description ("Format: feature <feature_name>. Specify that when building project for contract inference, only test cases for <feature_name> is used. When this option is not present, test cases for all features in the class are used. Only have effect when used with option %"build-from%" or %"infer%".")
			l_parser.options.force_last (l_feature_name_option)

			create l_class_name_option.make_with_long_form ("class")
			l_class_name_option.set_description ("Specify name of class whose contracts are to be inferred.")
			l_parser.options.force_last (l_class_name_option)

			create l_infer_option.make_with_long_form ("infer")
			l_infer_option.set_description ("Infer contracts for feature specified with %"feature%" option in class specified in %"class%" option.")
			l_parser.options.force_last (l_infer_option)

			l_parser.parse_list (l_args)
			if l_build_project_option.was_found then
				config.set_test_case_directory (l_build_project_option.parameter)
			end

			if l_feature_name_option.was_found then
				config.set_feature_name_for_test_cases (l_feature_name_option.parameter)
			end

			if l_class_name_option.was_found then
				config.set_class_name (l_class_name_option.parameter)
			end

			config.set_should_infer_contracts (l_infer_option.was_found)
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
