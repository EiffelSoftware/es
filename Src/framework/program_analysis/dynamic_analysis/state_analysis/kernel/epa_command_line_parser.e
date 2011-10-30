note
	description: "Command line parser for annotation facilities"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COMMAND_LINE_PARSER

inherit
	EPA_UTILITY

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

	config: EPA_CONFIG
			-- AutoFix command line options

	arguments: LINKED_LIST [STRING]
			-- Command line options

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_dynamic_flag: AP_FLAG
			l_static_flag: AP_FLAG
			l_locations, l_variables, l_output_path: AP_STRING_OPTION
		do
				-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_dynamic_flag.make_with_long_form ("dynamic")
			l_dynamic_flag.set_description ("Enable annotation collection through dynamic means.")
			l_parser.options.force_last (l_dynamic_flag)

			create l_static_flag.make_with_long_form ("static")
			l_static_flag.set_description ("Enable annotation collection through static means.")
			l_parser.options.force_last (l_static_flag)

			create l_locations.make_with_long_form ("locations")
			l_locations.set_description (
				"Specify the locations where annotations should be collected.%
				%Format: --locations CLASS_NAME.feature_name[,CLASS_NAME.feature_name].")
			l_parser.options.force_last (l_locations)

			create l_variables.make_with_long_form ("variables")
			l_variables.set_description (
				"Specify the name of variables which should be used to construct interesting expressions.%
				%Format: --variables variable[,variable].")
			l_parser.options.force_last (l_variables)

			create l_output_path.make_with_long_form ("output-path")
			l_output_path.set_description ("Specify a path where the collected equations should be stored.")
			l_parser.options.force_last (l_output_path)

			l_parser.parse_list (l_args)

			config.set_is_dynamic_annotation_enabled (l_dynamic_flag.was_found)
			config.set_is_static_annotation_enabled (l_static_flag.was_found)
			config.set_is_variables_specified (l_variables.was_found)
			config.set_is_output_path_specified (l_output_path.was_found)

			if l_locations.was_found then
				setup_locations (l_locations.parameter)
			end

			if l_variables.was_found then
				setup_variables (l_variables.parameter)
			end

			if l_output_path.was_found then
				config.set_output (l_output_path.parameter)
			end
		end

feature {NONE} -- Implementation

	setup_locations (a_locations: STRING)
			-- Setup locations in `config'.			
		local
			l_feat: STRING
			l_index: INTEGER
			l_class_name: STRING
			l_feat_name: STRING
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			across a_locations.split (',') as l_feats loop
				l_feat := l_feats.item
				l_feat.left_adjust
				l_feat.right_adjust
				l_index := l_feat.index_of ('.', 1)
				if l_index > 0 then
					l_class_name := l_feat.substring (1, l_index - 1).as_upper
					l_feat_name := l_feat.substring (l_index + 1, l_feat.count).as_lower
					l_class := first_class_starts_with_name (l_class_name)
					if l_class /= Void then
						l_feature := l_class.feature_named (l_feat_name)
						if l_feature /= Void then
							config.locations.extend ([l_class, l_feature])
						end
					end
				end
			end
		end

	setup_variables (a_variables: STRING)
			-- Setup variables in `config'.			
		local
			l_var: STRING
		do
			across a_variables.split (',') as l_vars loop
				l_var := l_vars.item
				l_var.left_adjust
				l_var.right_adjust
				config.variables.extend (l_var)
			end
		end

end
