note
	description: "Command line parser for dynamic program analysis options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_DYN_ANALYSIS_CMD_LINE_PARSER

inherit
	EPA_UTILITY

	KL_SHARED_STRING_EQUALITY_TESTER

	EXCEPTIONS

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_args: LINKED_LIST [STRING]; a_system: SYSTEM_I)
			-- Initialize `config' with `a_system' and
			-- `arguments' with `a_args'.
		require
			a_args_not_void: a_args /= Void
			a_system_not_void: a_system /= Void
		do
			create config.make (a_system)
			arguments := a_args
		ensure
			arguments_set: arguments = a_args
			eiffel_system_set: config.eiffel_system = a_system
		end

feature -- Access

	config: EPA_DYNAMIC_ANALYSIS_CONFIG
			-- Dynamic program analysis configuration

feature -- Parsing

	parse
			-- Parse `arguments' and store result in `config'.
		local
			l_parser: AP_PARSER
			l_args: DS_LINKED_LIST [STRING]
			l_aut_choice_of_prgm_locs, l_all_prgm_locs, l_aut_choice_of_exprs: AP_FLAG
			l_location, l_specific_prgm_locs, l_specific_vars, l_specific_exprs, l_prgm_locs_with_exprs, l_output_path: AP_STRING_OPTION
		do
			-- Setup command line argument parser.
			create l_parser.make
			create l_args.make
			arguments.do_all (agent l_args.force_last)

			create l_location.make_with_long_form ("location")
			l_location.set_description (
				"Specify the location where annotations should be collected.%
				%Format: --locations CLASS_NAME.feature_name.")
			l_parser.options.force_last (l_location)

			create l_aut_choice_of_prgm_locs.make_with_long_form ("aut_choice_of_prgm_locs")
			l_aut_choice_of_prgm_locs.set_description (
				"Choose program locations for analysis automatically.%
				%Format: --aut_choice_of_prgm_locs")
			l_parser.options.force_last (l_aut_choice_of_prgm_locs)

			create l_aut_choice_of_exprs.make_with_long_form ("aut_choice_of_exprs")
			l_aut_choice_of_exprs.set_description (
				"Choose expressions to be evaluated automatically.%
				%Format: --l_aut_choice_of_exprs")
			l_parser.options.force_last (l_aut_choice_of_exprs)

			create l_all_prgm_locs.make_with_long_form ("all_prgm_locs")
			l_all_prgm_locs.set_description (
				"Consider all program locations.%
				%Format: --all_progm_locs")
			l_parser.options.force_last (l_all_prgm_locs)

			create l_specific_vars.make_with_long_form ("specific_vars")
			l_specific_vars.set_description (
				"Specify the name of variables which should be used to construct expressions to be evaluated.%
				%Format: --specific_vars variable[,variable].")
			l_parser.options.force_last (l_specific_vars)

			create l_specific_exprs.make_with_long_form ("specific_exprs")
			l_specific_exprs.set_description (
				"Specify expressions which should be evaluated.%
				%Format: --specific_exprs expression[,expression]")
			l_parser.options.force_last (l_specific_exprs)

			create l_specific_prgm_locs.make_with_long_form ("specific_prgm_locs")
			l_specific_prgm_locs.set_description (
				"Specify specific program locations which should be evaluated.%
				%Format: --specific_prgm_locs bp_slot[,bp_slot]")
			l_parser.options.force_last (l_specific_prgm_locs)

			create l_prgm_locs_with_exprs.make_with_long_form ("prgm_locs_with_exprs")
			l_prgm_locs_with_exprs.set_description (
				"Specify selected program locations with expresions which should be evaluated.%
				%Format: --prgm_locs_with_exprs bp_slot:expr[;bp_slot:expr].")
			l_parser.options.force_last (l_prgm_locs_with_exprs)

			create l_output_path.make_with_long_form ("output-path")
			l_output_path.set_description ("Specify a path where the collected equations should be stored.")
			l_parser.options.force_last (l_output_path)

			l_parser.parse_list (l_args)

			config.set_is_aut_choice_of_exprs_set (l_aut_choice_of_exprs.was_found)
			config.set_is_aut_choice_of_prgm_locs_set (l_aut_choice_of_prgm_locs.was_found)
			config.set_is_all_prgm_locs_set (l_all_prgm_locs.was_found)
			config.set_is_output_path_specified (l_output_path.was_found)

			if l_location.was_found then
				setup_location (l_location.parameter)
			end

			if l_specific_vars.was_found then
				config.set_is_specific_vars_set (True)
				setup_variables (l_specific_vars.parameter)
			end

			if l_specific_exprs.was_found then
				config.set_is_specific_exprs_set (True)
				setup_expressions (l_specific_exprs.parameter)
			end

			if l_specific_prgm_locs.was_found then
				config.set_is_specific_prgm_locs_set (True)
				setup_program_locations (l_specific_prgm_locs.parameter)
			end

			if l_prgm_locs_with_exprs.was_found then
				config.set_is_prgm_locs_with_exprs_set (True)
				setup_program_locations_with_expressions (l_prgm_locs_with_exprs.parameter)
			end

			if l_output_path.was_found then
				config.set_output (l_output_path.parameter)
			end
		end

feature {NONE} -- Implementation

	post_error_message (a_messge: STRING)
			--
		require
			a_message_not_void: a_messge /= Void
		local
			l_message: STRING
		do
			l_message := "%N----------------%NParsing failure:%N----------------%N%N"
			l_message.append (a_messge)
			io.put_string (l_message)
		end

	setup_location (a_location: STRING)
			-- Setup location in `config'.			
		require
			a_location_not_void: a_location /= Void
		local
			l_location: LIST [STRING]
			l_class_name, l_feat_name: STRING
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			a_location.left_adjust
			a_location.right_adjust
			if a_location.has ('.') then
				l_location := a_location.split ('.')
				l_class_name := l_location.i_th (1)
				l_feat_name := l_location.i_th (2)
				l_class := first_class_starts_with_name (l_class_name)
				l_feature := feature_from_class (l_class_name, l_feat_name)
				config.set_location ([l_class, l_feature])
			else
				post_error_message ("The specified location is invalid.%N")
				die (-1)
			end
		ensure
			location_not_void: config.location /= Void
		end

	setup_variables (a_variables: STRING)
			-- Setup variables in `config'.
		require
			a_variables_not_void: a_variables /= Void
		local
			l_var: STRING
			l_variables: LINKED_LIST [STRING]
		do
			a_variables.left_adjust
			a_variables.right_adjust
			create l_variables.make
			if a_variables.has (';') then
				across a_variables.split (';') as l_vars loop
					l_var := l_vars.item
					l_var.left_adjust
					l_var.right_adjust
					l_variables.extend (l_var)
				end
			else
				l_variables.extend (a_variables)
			end
			config.set_variables (l_variables)
		ensure
			variables_not_void: config.variables /= Void
		end

	setup_expressions (a_expressions: STRING)
			-- Setup expressions in `config'.
		require
			a_expressions_not_void: a_expressions /= Void
		local
			l_expr: STRING
			l_expressions: LINKED_LIST [STRING]
		do
			a_expressions.left_adjust
			a_expressions.right_adjust
			create l_expressions.make
			if a_expressions.has (';') then
				across a_expressions.split (';') as l_exprs loop
					l_expr := l_exprs.item
					l_expr.left_adjust
					l_expr.right_adjust
					l_expressions.extend (l_expr)
				end
			else
				l_expressions.extend (a_expressions)
			end
			config.set_expressions (l_expressions)
		ensure
			expressions_not_void: config.expressions /= Void
		end

	setup_program_locations (a_program_locations: STRING)
			-- Setup specific program locations in `config'.
		require
			a_program_locations_not_void: a_program_locations /= Void
		local
			l_program_location: STRING
			l_program_locations: DS_HASH_SET [INTEGER]
		do
			a_program_locations.left_adjust
			a_program_locations.right_adjust
			create l_program_locations.make_default
			if a_program_locations.has (';') then
				across a_program_locations.split (';') as l_locations loop
					l_program_location := l_locations.item
					l_program_location.left_adjust
					l_program_location.right_adjust
					l_program_locations.force_last (l_program_location.to_integer)
				end
			else
				l_program_locations.force_last (a_program_locations.to_integer)
			end

			config.set_specific_prgm_locs (l_program_locations)
		ensure
			specific_prgm_locs_not_void:  config.specific_prgm_locs /= Void
		end

	setup_program_locations_with_expressions (a_program_locations_with_expressions: STRING)
			-- Setup specific program locations with expressions in `config'.
		require
			a_program_locations_with_expressions_not_void: a_program_locations_with_expressions /= Void
		local
			l_location_with_expression: LIST [STRING]
			l_expressions: LINKED_LIST [STRING]
			l_tmp_set: DS_HASH_SET [STRING]
			l_bp_slot: INTEGER
			l_bp_slot_string: STRING
			l_expression: STRING
			l_tmp: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
		do
			a_program_locations_with_expressions.left_adjust
			a_program_locations_with_expressions.right_adjust
			create l_tmp.make_default
			create l_expressions.make
			if a_program_locations_with_expressions.has (';') then
				across a_program_locations_with_expressions.split (';') as l_locations_with_expressions loop
					l_locations_with_expressions.item.left_adjust
					l_locations_with_expressions.item.right_adjust
					l_location_with_expression := l_locations_with_expressions.item.split (':')
					l_bp_slot_string := l_location_with_expression.i_th (1)
					l_bp_slot_string.left_adjust
					l_bp_slot_string.right_adjust
					l_bp_slot := l_bp_slot_string.to_integer
					l_expression := l_location_with_expression.i_th (2)
					l_expression.left_adjust
					l_expression.right_adjust
					if l_tmp.has (l_bp_slot) then
						l_tmp.item (l_bp_slot).force_last (l_expression)
					else
						create l_tmp_set.make_default
						l_tmp_set.set_equality_tester (string_equality_tester)
						l_tmp_set.force_last (l_expression)
						l_tmp.put (l_tmp_set, l_bp_slot)
					end
					l_expressions.extend (l_expression)
				end
			else
				if a_program_locations_with_expressions.has (':') then
					l_location_with_expression := a_program_locations_with_expressions.split (':')
					l_bp_slot_string := l_location_with_expression.i_th (1)
					l_bp_slot_string.left_adjust
					l_bp_slot_string.right_adjust
					l_bp_slot := l_bp_slot_string.to_integer
					l_expression := l_location_with_expression.i_th (2)
					l_expression.left_adjust
					l_expression.right_adjust
					create l_tmp_set.make_default
					l_tmp_set.set_equality_tester (string_equality_tester)
					l_tmp_set.force_last (l_expression)
					l_tmp.put (l_tmp_set, l_bp_slot)
					l_expressions.extend (l_expression)
				else
					post_error_message ("The specified program locations with expressions are invalid.%N")
					die (-1)
				end
			end
			config.set_prgm_locs_with_exprs (l_tmp)
			config.set_expressions (l_expressions)
		ensure
			prgm_locs_with_exprs_not_void: config.prgm_locs_with_exprs /= Void
			expressions_not_void: config.expressions /= Void
		end

feature {NONE} -- Implementation

	arguments: LINKED_LIST [STRING]
			-- Command line options

end

