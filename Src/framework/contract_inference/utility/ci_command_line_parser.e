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
			l_generate_weka_option: AP_FLAG
			l_weka_assertion_option: AP_STRING_OPTION
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

			create l_generate_weka_option.make_with_long_form ("generate-weka")
			l_generate_weka_option.set_description (
				"Generate Weka relations from test cases. %N%
				%Format --class <CLASS_NAME> --generate-weka <test case directory> <weka relation output directory>. %N%
				%<test case directory> can be a directory for a single feature or a directory  for a class. In the first case, a single Weka%
				%relation will be generated; in the second case, multiple Weka relations will be generated, one for each feature in the same class.%N%
				%<CLASS_NAME> specifies the class whose Weka relations are to be generated.")
			l_parser.options.force_last (l_generate_weka_option)

			create l_weka_assertion_option.make_with_long_form ("weka-assertion-selection")
			l_weka_assertion_option.set_description ("Mode to select assertions as Weka attributes in the relations. Valid values are %"union%" and %"intersection%". If this option is not specified, the default is %"intersection%".")
			l_parser.options.force_last (l_weka_assertion_option)

			l_parser.parse_list (l_args)
			if l_build_project_option.was_found then
				config.set_should_build_project (True)
				config.set_test_case_directory (l_build_project_option.parameter)
			end

			if l_feature_name_option.was_found then
				config.set_feature_name_for_test_cases (l_feature_name_option.parameter)
			end

			if l_class_name_option.was_found then
				config.set_class_name (l_class_name_option.parameter)
			end

			config.set_should_infer_contracts (l_infer_option.was_found)

			if l_generate_weka_option.was_found then
				setup_generate_weka (config, l_parser.parameters)
			end

			if l_weka_assertion_option.was_found then
				setup_weka_assertion_selection (config, l_weka_assertion_option.parameter)
			else
				setup_weka_assertion_selection (config, Void)
			end
		end

feature{NONE} -- Implementation

	setup_generate_weka (a_config: CI_CONFIG; a_parameters: DS_LIST [STRING])
			-- Setup `a_config' using data given in `a_parser' for Weka relation generation.
		do
			a_config.set_should_generate_weka_relations (True)
			check a_parameters.count = 2 end
			config.set_test_case_directory (a_parameters.first)
			config.set_output_directory (a_parameters.last)
		end

	setup_weka_assertion_selection (a_config: CI_CONFIG; a_mode: detachable STRING)
			-- Setup `a_cnofig' using `a_mode' for weka assertion selection mode.
		do
			if a_mode /= Void and then a_mode.is_case_insensitive_equal ("union") then
				a_config.set_weka_assertion_selection_mode ({CI_CONFIG}.weka_assertion_union_selection_mode)
			else
				a_config.set_weka_assertion_selection_mode ({CI_CONFIG}.weka_assertion_intersection_selection_mode)
			end
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
