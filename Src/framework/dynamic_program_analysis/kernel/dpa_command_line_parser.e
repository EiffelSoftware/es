note
	description: "Command line parser for dynamic program analysis options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_COMMAND_LINE_PARSER

inherit
	EPA_UTILITY

	EXCEPTIONS

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (a_arguments: LINKED_LIST [STRING]; a_system: SYSTEM_I)
			-- Initialize `configuration' with `a_system' and
			-- `arguments' with `a_arguments'.
		require
			a_arguments_not_void: a_arguments /= Void
			a_system_not_void: a_system /= Void
		do
			create configuration.make (a_system)
			arguments := a_arguments
		ensure
			arguments_set: arguments = a_arguments
			eiffel_system_set: configuration.eiffel_system = a_system
		end

feature -- Access

	arguments: LINKED_LIST [STRING]
			-- Command line options

	configuration: DPA_CONFIGURATION
			-- Dynamic program analysis configuration

feature -- Parsing

	parse
			-- Parse `arguments' and store result in `configuration'.
		require
			arguments_not_void: arguments /= Void
		local
			l_parser: AP_PARSER
			l_arguments: DS_LINKED_LIST [STRING]
			l_location_search, l_expression_search, l_all_locations: AP_FLAG
			l_single_json_data_file, l_multiple_json_data_files, l_serialized_data_files, l_mysql_database: AP_STRING_OPTION
			l_program, l_locations, l_variables, l_expressions: AP_STRING_OPTION
			l_locs_with_exprs, l_locs_with_vars: AP_STRING_OPTION
		do
			-- Initialize command line parser
			create l_parser.make
			create l_arguments.make
			arguments.do_all (agent l_arguments.force_last)

			-- Set up command line options

			-- Option specifying the program
			create l_program.make_with_long_form ("program")
			l_program.set_description (
				"Specify the program under analysis.%
				%Format: --program CLASS_NAME.feature_name.")
			l_parser.options.force_last (l_program)


			-- Options related to program locations, variables and expressions

			create l_location_search.make_with_long_form ("location-search")
			l_location_search.set_description (
				"Choose program locations automatically.%
				%Format: --location-search")
			l_parser.options.force_last (l_location_search)

			create l_expression_search.make_with_long_form ("expression-search")
			l_expression_search.set_description (
				"Choose expressions to be evaluated automatically.%
				%Format: --expression-search")
			l_parser.options.force_last (l_expression_search)

			create l_all_locations.make_with_long_form ("all-locations")
			l_all_locations.set_description (
				"Consider all program locations.%
				%Format: --all-locations")
			l_parser.options.force_last (l_all_locations)

			create l_variables.make_with_long_form ("variables")
			l_variables.set_description (
				"Specify variables which should be used to construct expressions to be evaluated.%
				%Format: --variables variable[,variable].")
			l_parser.options.force_last (l_variables)

			create l_expressions.make_with_long_form ("expressions")
			l_expressions.set_description (
				"Specify expressions to be evaluated.%
				%Format: --expressions expression[,expression]")
			l_parser.options.force_last (l_expressions)

			create l_locations.make_with_long_form ("locations")
			l_locations.set_description (
				"Specify program locations at which expressions should be evaluated.%
				%Format: --locations bp_slot[,bp_slot]")
			l_parser.options.force_last (l_locations)

			create l_locs_with_exprs.make_with_long_form ("locations-with-expressions")
			l_locs_with_exprs.set_description (
				"Specify expressions to be evaluated at specific program locations.%
				%Format: --locations-with-expressions bp_slot:expr[;bp_slot:expr].")
			l_parser.options.force_last (l_locs_with_exprs)

			create l_locs_with_vars.make_with_long_form ("locations-with-variables")
			l_locs_with_vars.set_description (
				"Specify variables which should be used to construct expressions to be evaluated at specific program locations.%
				%Format: --locations-with-variables bp_slot:expr[;bp_slot:expr].")
			l_parser.options.force_last (l_locs_with_vars)

			-- Options related to data storage

			create l_single_json_data_file.make_with_long_form ("single-json-data-file")
			l_single_json_data_file.set_description ("Specify a path and file name used for the storage in a JSON data file.%
				%Format: --single-json-file path;file_name")
			l_parser.options.force_last (l_single_json_data_file)

			create l_multiple_json_data_files.make_with_long_form ("multiple-json-data-files")
			l_multiple_json_data_files.set_description ("Specify a path and file name prefix used for the storage in JSON data files.%
				%Format: --multiple-json-files path;file_name_prefix")
			l_parser.options.force_last (l_multiple_json_data_files)

			create l_serialized_data_files.make_with_long_form ("serialized-data-files")
			l_serialized_data_files.set_description ("Specify a path and file name prefix used for the storage in serialized data files.%
				%Format: --serialized-file path;file_name_prefix")
			l_parser.options.force_last (l_serialized_data_files)

			create l_mysql_database.make_with_long_form ("mysql")
			l_mysql_database.set_description ("Specify a host, user, password, database and port used for the storage in a MYSQL database.%
				%Format: --mysql host;user;password;database;port")
			l_parser.options.force_last (l_mysql_database)

			-- Parse command line input
			l_parser.parse_list (l_arguments)

			-- Set up configuration according to command line options

			-- Parameters specifying the program
			if l_program.was_found then
				parse_program_parameters (l_program.parameter)
			end

			-- Parameters specifying program locations, expressions and variables

			configuration.set_is_expression_search_activated (l_expression_search.was_found)
			configuration.set_is_location_search_activated (l_location_search.was_found)
			configuration.set_is_usage_of_all_locations_activated (l_all_locations.was_found)

			if l_variables.was_found then
				configuration.set_is_set_of_variables_given (True)
				parse_variables_parameters (l_variables.parameter)
			end

			if l_expressions.was_found then
				configuration.set_is_set_of_expressions_given (True)
				parse_expressions_parameters (l_expressions.parameter)
			end

			if l_locations.was_found then
				configuration.set_is_set_of_locations_given (True)
				parse_program_locations_parameters (l_locations.parameter)
			end

			if l_locs_with_exprs.was_found then
				configuration.set_is_set_of_locations_with_expressions_given (True)
				parse_program_locations_with_expressions_parameters (l_locs_with_exprs.parameter)
			end

			if l_locs_with_vars.was_found then
				configuration.set_is_set_of_locations_with_variables_given (True)
				parse_program_locations_with_variables_parameters (l_locs_with_vars.parameter)
			end

			-- Parameters specifying data storage

			if l_single_json_data_file.was_found then
				parse_single_json_data_file_parameters (l_single_json_data_file.parameter)
			end

			if l_multiple_json_data_files.was_found then
				parse_multiple_json_data_files_parameters (l_multiple_json_data_files.parameter)
			end

			if l_serialized_data_files.was_found then
				parse_serialized_data_files_parameters (l_serialized_data_files.parameter)
			end

			if l_mysql_database.was_found then
				parse_mysql_database_parameters (l_mysql_database.parameter)
			end
		end

feature {NONE} -- Implementation

	print_parsing_error_message (a_error_message: STRING)
			-- Print `a_error_message' in the standard output.
		require
			a_error_message_not_void: a_error_message /= Void
		local
			l_error_message: STRING
		do
			l_error_message := "%N----------------%NParsing failure:%N----------------%N%N"
			l_error_message.append (a_error_message)
			l_error_message.append_character ('%N')
			io.put_string (l_error_message)
		end

	location_with_expression_from_string (a_location_with_expression: STRING): TUPLE [program_location: INTEGER; expression: STRING]
			-- Extract program location and expression from `a_location_with_expression'.
			-- Input is expected to be in the format "loc:expr".
		require
			a_location_with_expression_not_void: a_location_with_expression /= Void
		local
			l_location_with_expression: LIST [STRING]
			l_location: STRING
			l_expression: STRING
		do
			if a_location_with_expression.occurrences (':') = 1 then
				-- Extract program location and expression
				l_location_with_expression := a_location_with_expression.split (':')

				-- Process program location
				l_location := l_location_with_expression.i_th (1)
				l_location.left_adjust
				l_location.right_adjust

				-- Process expression
				l_expression := l_location_with_expression.i_th (2)
				l_expression.left_adjust
				l_expression.right_adjust

				-- Check if `l_location' is empty
				if l_location.count = 0 then
					print_parsing_error_message ("One of the specified program locations is invalid.")
					die (-1)
				end

				-- Check if `l_expression' is empty
				if l_expression.count = 0 then
					print_parsing_error_message ("One of the specified expressions is invalid.")
					die (-1)
				end

				Result := [l_location.to_integer, l_expression]
			else
				print_parsing_error_message ("One of the program location and expression pairs is invalid.")
				die (-1)
			end

		ensure
			Result_not_void: Result /= Void
		end

	location_with_variable_from_string (a_location_with_variable: STRING): TUPLE [program_location: INTEGER; variable: STRING]
			-- Extract program location and variable from `a_location_with_variable'.
			-- Input is expected to be in the format "loc:var".
		require
			a_location_with_variable_not_void: a_location_with_variable /= Void
		local
			l_location_with_variable: LIST [STRING]
			l_location: STRING
			l_variable: STRING
		do
			if a_location_with_variable.occurrences (':') = 1 then
				-- Extract program location and variable
				l_location_with_variable := a_location_with_variable.split (':')

				-- Process program location
				l_location := l_location_with_variable.i_th (1)
				l_location.left_adjust
				l_location.right_adjust

				-- Process expression
				l_variable := l_location_with_variable.i_th (2)
				l_variable.left_adjust
				l_variable.right_adjust

				-- Check if `l_location' is empty
				if l_location.count = 0 then
					print_parsing_error_message ("One of the specified program locations is invalid.")
					die (-1)
				end

				-- Check if `l_variable' is empty
				if l_variable.count = 0 then
					print_parsing_error_message ("One of the specified variables is invalid.")
					die (-1)
				end

				Result := [l_location.to_integer, l_variable]
			else
				print_parsing_error_message ("One of the program location and expression pairs is invalid.")
				die (-1)
			end
		ensure
			Result_not_void: Result /= Void
		end

	parse_program_parameters (a_parameters: STRING)
			-- Parse program in `configuration'.
			-- Input is expected to be in the format "CLASS.feature".
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_program: LIST [STRING]
			l_class_name, l_feature_name: STRING
			l_class: CLASS_C
			l_feature: FEATURE_I
		do


			-- Check if `a_parameters' is a feature call.
			if a_parameters.occurrences ('.') = 1 then
				-- Case: Feature call
				l_program := a_parameters.split ('.')

				l_class_name := l_program.i_th (1)
				l_feature_name := l_program.i_th (2)

				-- Check if `l_class_name' is an empty string
				if l_class_name.count = 0 then
					print_parsing_error_message ("The specified class is invalid.")
					die (-1)
				end

				-- Check if `l_feature_name' is an empty string
				if l_feature_name.count = 0 then
					print_parsing_error_message ("The specified feature is invalid.")
					die (-1)
				end

				-- Process class name
				l_class_name.left_adjust
				l_class_name.right_adjust

				-- Process feature name
				l_feature_name.left_adjust
				l_feature_name.right_adjust

				-- Create actual class and feature object
				l_class := first_class_starts_with_name (l_class_name)
				l_feature := feature_from_class (l_class_name, l_feature_name)

				-- Set up configuration
				configuration.set_class (l_class)
				configuration.set_feature (l_feature)
			else
				-- Case: No feature call
				print_parsing_error_message ("The specified program is invalid.%N")
				die (-1)
			end
		end

	parse_variables_parameters (a_parameters: STRING)
			-- Parse variables in `configuration'.
			-- Input is expected to be in the format var[;var].
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_variable: STRING
			l_variables: DS_HASH_SET [STRING]
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			create l_variables.make_default
			l_variables.set_equality_tester (string_equality_tester)

			-- Determine input format of `a_parameters'
			if a_parameters.has (';') then
				-- Case: var;var[;var]
				across a_parameters.split (';') as l_raw_variables loop
					l_variable := l_raw_variables.item
					l_variable.left_adjust
					l_variable.right_adjust

					-- Check if `l_variable' is empty
					if l_variable.count = 0 then
						print_parsing_error_message ("One of the specified variables is invalid.")
						die (-1)
					end

					l_variables.force_last (l_variable)
				end
			else
				-- Case: var

				-- Check if `a_parameters' is empty
				if a_parameters.count = 0 then
					print_parsing_error_message ("The specified variable is invalid.")
					die (-1)
				end

				l_variables.force_last (a_parameters)
			end

			-- Set up configuration
			configuration.set_variables (l_variables)
		ensure
			variables_not_void: configuration.variables /= Void
		end

	parse_expressions_parameters (a_parameters: STRING)
			-- Parse expressions in `configuration'.
			-- Input is expected to be in the format expr[;expr].
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_expression: STRING
			l_expressions: DS_HASH_SET [STRING]
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			create l_expressions.make_default
			l_expressions.set_equality_tester (string_equality_tester)

			-- Determine input format of `a_parameters'
			if a_parameters.has (';') then
				-- Case: expr;expr[;expr]
				across a_parameters.split (';') as l_raw_expressions loop
					l_expression := l_raw_expressions.item
					l_expression.left_adjust
					l_expression.right_adjust

					-- Check if `l_expression' is empty
					if l_expression.count = 0 then
						print_parsing_error_message ("One of the specified expressions is invalid.")
						die (-1)
					end

					l_expressions.force_last (l_expression)
				end
			else
				-- Case: expr

				-- Check if `a_parameters' is empty
				if a_parameters.count = 0 then
					print_parsing_error_message ("The specified expression is invalid.")
					die (-1)
				end

				l_expressions.force_last (a_parameters)
			end

			-- Set up configuration
			configuration.set_expressions (l_expressions)
		ensure
			expressions_not_void: configuration.expressions /= Void
		end

	parse_program_locations_parameters (a_parameters: STRING)
			-- Parse program locations in `configuration'.
			-- Input is expected to be in the format loc[;loc].
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_program_location: STRING
			l_program_locations: DS_HASH_SET [INTEGER]
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			create l_program_locations.make_default

			-- Determine input format of `a_parameters'
			if a_parameters.has (';') then
				-- Case: loc;loc[;loc]
				across a_parameters.split (';') as l_raw_program_locations loop
					l_program_location := l_raw_program_locations.item
					l_program_location.left_adjust
					l_program_location.right_adjust

					-- Check if `l_program_location' is empty
					if l_program_location.count = 0 then
						print_parsing_error_message ("One of the specified program locations is invalid.")
						die (-1)
					end

					l_program_locations.force_last (l_program_location.to_integer)
				end
			else
				-- Case: loc

				-- Check if `a_parameters' is empty
				if a_parameters.count = 0 then
					print_parsing_error_message ("The specified program location is invalid.")
					die (-1)
				end

				l_program_locations.force_last (a_parameters.to_integer)
			end

			-- Set up configuration
			configuration.set_locations (l_program_locations)
		ensure
			locations_not_void: configuration.locations /= Void
		end

	parse_program_locations_with_expressions_parameters (a_parameters: STRING)
			-- Parse program locations with expressions in `configuration'.
			-- Input is expected to be in the format loc:expr[;loc:expr]
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_location_with_expression: LIST [STRING]
			l_expression: STRING
			l_expressions: DS_HASH_SET [STRING]
			l_expressions_at_location: DS_HASH_SET [STRING]
			l_location: INTEGER
			l_location_string: STRING
			l_location_expressions_map: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			l_parsed_location_with_expression: TUPLE [program_location: INTEGER; expression: STRING]
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			-- Initialize the map containing the expressions for the different program locations.
			create l_location_expressions_map.make_default

			-- Initialize the set of expressions.
			create l_expressions.make_default
			l_expressions.set_equality_tester (string_equality_tester)

			-- Determine input format of `a_parameters'.
			if a_parameters.has (';') then
				-- Case: loc:expr;loc:expr[;loc:expr]
				across a_parameters.split (';') as l_raw_locations_with_expressions loop
					-- Extract program location and expression
					l_parsed_location_with_expression := location_with_expression_from_string (l_raw_locations_with_expressions.item)
					l_location := l_parsed_location_with_expression.program_location
					l_expression := l_parsed_location_with_expression.expression

					-- Does the location already exist as a key in the map?
					if l_location_expressions_map.has (l_location) then
						l_location_expressions_map.item (l_location).force_last (l_expression)
					else
						create l_expressions_at_location.make_default
						l_expressions_at_location.set_equality_tester (string_equality_tester)
						l_expressions_at_location.force_last (l_expression)

						l_location_expressions_map.force_last (l_expressions_at_location, l_location)
					end

					-- Add the expression to the set of expressions
					l_expressions.force_last (l_expression)
				end
			elseif a_parameters.has (':') then
				-- Case: loc:expr

				-- Extract program location and expression
				l_parsed_location_with_expression := location_with_expression_from_string (a_parameters)
				l_location := l_parsed_location_with_expression.program_location
				l_expression := l_parsed_location_with_expression.expression

				-- Add the program location and expression to the map.
				create l_expressions_at_location.make_default
				l_expressions_at_location.set_equality_tester (string_equality_tester)
				l_expressions_at_location.force_last (l_expression)

				l_location_expressions_map.put (l_expressions_at_location, l_location)

				-- Add the expression to the set of expressions
				l_expressions.force_last (l_expression)
			else
				-- Case: invalid input format
				print_parsing_error_message ("The specified program location(s) with expression(s) is respectively are invalid.%N")
				die (-1)
			end

			-- Set up configuration
			configuration.set_locations_with_expressions (l_location_expressions_map)
			configuration.set_expressions (l_expressions)
		ensure
			locations_with_expressions_not_void: configuration.locations_with_expressions /= Void
			expressions_not_void: configuration.expressions /= Void
		end

	parse_program_locations_with_variables_parameters (a_parameters: STRING)
			-- Parse program locations with variables in `configuration'.
			-- Input is expected to be in the format loc:var[;loc:var]
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_location_with_variable: LIST [STRING]
			l_variable: STRING
			l_variables: DS_HASH_SET [STRING]
			l_variables_at_location: DS_HASH_SET [STRING]
			l_location: INTEGER
			l_location_string: STRING
			l_location_variables_map: DS_HASH_TABLE [DS_HASH_SET [STRING], INTEGER]
			l_parsed_location_with_variable: TUPLE [program_location: INTEGER; expression: STRING]
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			-- Initialize the map containing the variables for the different program locations.
			create l_location_variables_map.make_default

			-- Initialize the set of variables.
			create l_variables.make_default
			l_variables.set_equality_tester (string_equality_tester)

			-- Determine input format of `a_parameters'.
			if a_parameters.has (';') then
				-- Case: loc:var;loc:var[;loc:var]
				across a_parameters.split (';') as l_raw_locations_with_variables loop
					-- Extract program location and expression
					l_parsed_location_with_variable := location_with_variable_from_string (l_raw_locations_with_variables.item)
					l_location := l_parsed_location_with_variable.program_location
					l_variable := l_parsed_location_with_variable.expression

					-- Does the location already exist as a key in the map?
					if l_location_variables_map.has (l_location) then
						l_location_variables_map.item (l_location).force_last (l_variable)
					else
						create l_variables_at_location.make_default
						l_variables_at_location.set_equality_tester (string_equality_tester)
						l_variables_at_location.force_last (l_variable)

						l_location_variables_map.force_last (l_variables_at_location, l_location)
					end

					-- Add the variable to the set of expressions
					l_variables.force_last (l_variable)
				end
			elseif a_parameters.has (':') then
				-- Case: loc:var

				-- Extract program location and variable
				l_parsed_location_with_variable := location_with_variable_from_string (a_parameters)
				l_location := l_parsed_location_with_variable.program_location
				l_variable := l_parsed_location_with_variable.expression

				-- Add the program location and variable to the map.
				create l_variables_at_location.make_default
				l_variables_at_location.set_equality_tester (string_equality_tester)
				l_variables_at_location.force_last (l_variable)

				l_location_variables_map.put (l_variables_at_location, l_location)

				-- Add the variable to the set of variables
				l_variables.force_last (l_variable)
			else
				-- Case: invalid input format
				print_parsing_error_message ("The specified program location(s) with variable(s) is respectively are invalid.%N")
				die (-1)
			end

			-- Set up configuration
			configuration.set_locations_with_variables (l_location_variables_map)
			configuration.set_variables (l_variables)
		ensure
			locations_with_variables_not_void: configuration.locations_with_variables /= Void
			variables_not_void: configuration.variables /= Void
		end

	parse_single_json_data_file_parameters (a_parameters: STRING)
			-- Parse output-path and file name in `configuration'.
			-- Input is expected to be in the format output_path;file_name
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_options: LIST [STRING]
			l_output_path: STRING
			l_file_name: STRING
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			-- Check if `a_parameters' has the correct input format
			if a_parameters.occurrences (';') = 1 then
				-- Extract output-path and file name
				l_options := a_parameters.split (';')

				-- Process output-path
				l_output_path := l_options.i_th (1)
				l_output_path.left_adjust
				l_output_path.right_adjust

				-- Check if `l_output_path' is empty
				if l_output_path.count = 0 then
					print_parsing_error_message ("The output-path is invalid.")
					die (-1)
				end

				-- Process file name
				l_file_name := l_options.i_th (2)
				l_file_name.left_adjust
				l_file_name.right_adjust

				-- Check if `l_file_name' is empty
				if l_file_name.count = 0 then
					print_parsing_error_message ("The file name is invalid.")
					die (-1)
				end

				-- Set up configuration
				configuration.set_is_single_json_data_file_writer_selected (True)
				configuration.set_single_json_data_file_writer_options ([l_output_path, l_file_name])
			else
				print_parsing_error_message ("The specified single JSON data file writer options are invalid.")
				die (-1)
			end
		ensure
			is_single_json_data_file_writer_selected_set: configuration.is_single_json_data_file_writer_selected
			single_json_data_file_writer_options_not_void: configuration.single_json_data_file_writer_options /= Void
		end

	parse_multiple_json_data_files_parameters (a_parameters: STRING)
			-- Parse path and file name prefix in `configuration'.
			-- Input is expected to be in the format output_path;file_name_prefix
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_options: LIST [STRING]
			l_output_path: STRING
			l_file_name_prefix: STRING
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			-- Check if `a_parameters' has the correct input format
			if a_parameters.occurrences (';') = 1 then
				-- Extract output-path and file name prefix
				l_options := a_parameters.split (';')

				-- Process output-path
				l_output_path := l_options.i_th (1)
				l_output_path.left_adjust
				l_output_path.right_adjust

				-- Check if `l_output_path' is empty
				if l_output_path.count = 0 then
					print_parsing_error_message ("The output-path is invalid.")
					die (-1)
				end

				-- Process file name prefix
				l_file_name_prefix := l_options.i_th (2)
				l_file_name_prefix.left_adjust
				l_file_name_prefix.right_adjust

				-- Check if `l_file_name_prefix' is empty
				if l_file_name_prefix.count = 0 then
					print_parsing_error_message ("The file name prefix is invalid.")
					die (-1)
				end

				-- Set up configuration
				configuration.set_is_multiple_json_data_files_writer_selected (True)
				configuration.set_multiple_json_data_files_writer_options ([l_output_path, l_file_name_prefix])
			else
				print_parsing_error_message ("The specified multiple JSON data files writer options are invalid.")
				die (-1)
			end
		ensure
			is_multiple_json_data_files_writer_selected_set: configuration.is_multiple_json_data_files_writer_selected
			multiple_json_data_files_writer_options_not_void: configuration.multiple_json_data_files_writer_options /= Void
		end

	parse_serialized_data_files_parameters (a_parameters: STRING)
			-- Parse path and file name prefix in `configuration'.
			-- Input is expected to be in the format output_path;file_name_prefix
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_options: LIST [STRING]
			l_output_path: STRING
			l_file_name_prefix: STRING
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			-- Check if `a_parameters' has the correct input format
			if a_parameters.occurrences (';') = 1 then
				-- Extract output-path and file name prefix
				l_options := a_parameters.split (';')

				-- Process output-path
				l_output_path := l_options.i_th (1)
				l_output_path.left_adjust
				l_output_path.right_adjust

				-- Check if `l_output_path' is empty
				if l_output_path.count = 0 then
					print_parsing_error_message ("The output-path is invalid.")
					die (-1)
				end

				-- Process file name prefix
				l_file_name_prefix := l_options.i_th (2)
				l_file_name_prefix.left_adjust
				l_file_name_prefix.right_adjust

				-- Check if `l_file_name_prefix' is empty
				if l_file_name_prefix.count = 0 then
					print_parsing_error_message ("The file name prefix is invalid.")
					die (-1)
				end

				-- Set up configuration
				configuration.set_is_serialized_data_files_writer_selected (True)
				configuration.set_serialized_data_files_writer_options ([l_output_path, l_file_name_prefix])
			else
				print_parsing_error_message ("The specified serialized data files writer options are invalid.")
				die (-1)
			end
		ensure
			is_serialized_data_files_writer_selected_set: configuration.is_serialized_data_files_writer_selected
			serialized_data_files_writer_options_not_void: configuration.serialized_data_files_writer_options /= Void
		end

	parse_mysql_database_parameters (a_parameters: STRING)
			-- Parse host, user, password, database and port in `configuration'.
			-- Input is expected to be in the format host;user;password;database;port
		require
			a_parameters_not_void: a_parameters /= Void
		local
			l_options: LIST [STRING]
			l_host: STRING
			l_user: STRING
			l_password: STRING
			l_database: STRING
			l_port: STRING
		do
			a_parameters.left_adjust
			a_parameters.right_adjust

			-- Check if `a_parameters' has the correct input format
			if a_parameters.occurrences (';') = 4 then
				-- Extract output-path and file name prefix
				l_options := a_parameters.split (';')

				-- Process host
				l_host := l_options.i_th (1)
				l_host.left_adjust
				l_host.right_adjust

				-- Check if `l_host' is empty
				if l_host.count = 0 then
					print_parsing_error_message ("The host is invalid.")
					die (-1)
				end

				-- Process user
				l_user := l_options.i_th (2)
				l_user.left_adjust
				l_user.right_adjust

				-- Check if `l_user' is empty
				if l_user.count = 0 then
					print_parsing_error_message ("The user is invalid.")
					die (-1)
				end

				-- Process password
				l_password := l_options.i_th (3)
				l_password.left_adjust
				l_password.right_adjust

				-- Process database
				l_database := l_options.i_th (4)
				l_database.left_adjust
				l_database.right_adjust

				-- Check if `l_database' is empty
				if l_database.count = 0 then
					print_parsing_error_message ("The database is invalid.")
					die (-1)
				end

				-- Process port
				l_port := l_options.i_th (5)
				l_port.left_adjust
				l_port.right_adjust

				-- Check if `l_port' is empty
				if l_port.count = 0 then
					print_parsing_error_message ("The port is invalid.")
					die (-1)
				end

				-- Set up configuration
				configuration.set_is_mysql_data_writer_selected (True)
				configuration.set_mysql_data_writer_options ([l_host, l_user, l_password, l_database, l_port.to_integer])
			else
				print_parsing_error_message ("The specified MYSQL data writer options are invalid.")
				die (-1)
			end
		ensure
			is_mysql_writer_selected_set: configuration.is_mysql_data_writer_selected
			mysql_data_writer_options_not_void: configuration.mysql_data_writer_options /= Void
		end

end
