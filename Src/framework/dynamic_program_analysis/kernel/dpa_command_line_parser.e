note
	description: "Command line parser for dynamic program analysis options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_COMMAND_LINE_PARSER

inherit
	DPA_COMMAND_LINE_OPTIONS
		export
			{NONE} all
		end

	DPA_COMMAND_LINE_PARSING_ERROR_MESSAGES
		export
			{NONE} all
		end

	EPA_UTILITY
		export
			{NONE} all
		end

	EXCEPTIONS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_options: like options; a_configuration: like last_configuration)
			-- Initialize command line parser.
		require
			a_options_not_void: a_options /= Void
			a_configuration_not_void: a_configuration /= Void
		do
			options := a_options
			last_configuration := a_configuration
		ensure
			options_set: options = a_options
			last_configuration_set: last_configuration = a_configuration
		end

feature -- Access

	options: LINKED_LIST [STRING]
			-- Dynamic program analysis options.

	last_configuration: DPA_CONFIGURATION
			-- Last parsed configuration whose options are set according to `options'.

feature -- Basic operations

	parse
			-- Parse `options' to set options in `last_configuration' accordingly.
		local
			l_parser: AP_PARSER
			l_parser_options: DS_LIST [AP_OPTION]
			l_options: DS_LINKED_LIST [STRING]
			l_program_location_search_option, l_expression_search_option: AP_FLAG
			l_all_program_locations_option: AP_FLAG
			l_class_option, l_feature_option: AP_STRING_OPTION
			l_program_locations_option, l_variables_option, l_expressions_option: AP_STRING_OPTION
			l_localized_expressions_option, l_localized_variables_option: AP_STRING_OPTION
			l_json_file_writer_option, l_mysql_writer_option: AP_STRING_OPTION
		do
			-- Initialize command line parser.
			create l_parser.make
			l_parser_options := l_parser.options
			create l_options.make
			options.do_all (agent l_options.force_last)

			-- Set up command line options.

			-- Option to specifiy the context class of the feature under analysis.
			create l_class_option.make_with_long_form (Option_class)
			l_class_option.set_description (
				"Specify the context class of the feature under analysis.%
				%Format: --" + Option_class + " CLASS_NAME")
			l_parser_options.force_last (l_class_option)

			-- Option to specifiy the feature under analysis.
			create l_feature_option.make_with_long_form (Option_feature)
			l_feature_option.set_description (
				"Specify the feature under analysis.%
				%Format: --" + Option_feature + " feature_name")
			l_parser_options.force_last (l_feature_option)

			-- Options related to program locations, variables and expressions.

			-- Option to specify program location search.
			create l_program_location_search_option.make_with_long_form (
				Option_program_location_search
			)
			l_program_location_search_option.set_description (
				"Search program locations in feature under analysis.%
				%Format: --" + Option_program_location_search)
			l_parser_options.force_last (l_program_location_search_option)

			-- Option to specify usage of all program locations.
			create l_all_program_locations_option.make_with_long_form (
				Option_all_program_locations
			)
			l_all_program_locations_option.set_description (
				"Use all program locations in feature under analysis.%
				%Format: --" + Option_all_program_locations)
			l_parser_options.force_last (l_all_program_locations_option)

			-- Option to specify program locations.
			create l_program_locations_option.make_with_long_form (Option_program_locations)
			l_program_locations_option.set_description (
				"Specify program locations in terms of breakpoints.%
				%Format: --" + Option_program_locations + " breakpoint[,breakpoint]")
			l_parser.options.force_last (l_program_locations_option)

			-- Option to specify variables.
			create l_variables_option.make_with_long_form (Option_variables)
			l_variables_option.set_description (
				"Specify variables which should be used to construct expressions.%
				%These expressions are evaluated during analysis.%
				%Format: --" + Option_variables + " variable[,variable]")
			l_parser_options.force_last (l_variables_option)

			-- Option to specify expression search.
			create l_expression_search_option.make_with_long_form (Option_expression_search)
			l_expression_search_option.set_description (
				"Search expressions in feature under analysis.%
				%These expressions are evaluated during analysis.%
				%Format: --" + Option_expression_search)
			l_parser_options.force_last (l_expression_search_option)

			-- Option to specify expressions.
			create l_expressions_option.make_with_long_form (Option_expressions)
			l_expressions_option.set_description (
				"Specify expressions which are evaluated during analysis.%
				%Format: --" + Option_expressions + " expression[,expression]")
			l_parser_options.force_last (l_expressions_option)

			-- Option to specify localized variables.
			create l_localized_variables_option.make_with_long_form (Option_localized_variables)
			l_localized_variables_option.set_description (
				"Specify localized variables which are pairs of variables and program locations.%
				%The variable of such a pair is used to construct expressions which are evaluated%
				%before and after the execution of the program location of that pair. Program%
				%locations are specified in terms of breakpoints.%
				%Format: --" + Option_localized_variables +
				" variable:program location[;variable:program location]")
			l_parser_options.force_last (l_localized_variables_option)

			-- Option to specify localized expressions.
			create l_localized_expressions_option.make_with_long_form (
				Option_localized_expressions
			)
			l_localized_expressions_option.set_description (
				"Specify localized expressions which are pairs of expressions and%
				%program locations. The expression of such a pair is evaluated before and after%
				%the execution of the program location of that pair.%
				%Program locations are specified in terms of breakpoints.%
				%Format: --" + Option_localized_expressions +
				" expression:program location[;expression:program location]")
			l_parser_options.force_last (l_localized_expressions_option)

			-- Options related to the persistent storage of the analysis results.

			-- Option to specify JSON file writer options.
			create l_json_file_writer_option.make_with_long_form (Option_json_file_writer)
			l_json_file_writer_option.set_description ("Specify JSON file writer options in terms%
				%of a path and a file name used for the%
				%persistent storage in a file in the JSON format.%
				%Format: --" + Option_json_file_writer + " path;file name")
			l_parser_options.force_last (l_json_file_writer_option)

			-- Option to specify MYSQL writer options.
			create l_mysql_writer_option.make_with_long_form (Option_mysql_writer)
			l_mysql_writer_option.set_description ("Specify MYSQL writer options in terms of%
				%a host, user, password, database and port%
				%used for the persistent storage in a MYSQL database.%
				%Format: --" + Option_mysql_writer + " host;user;password;database;port")
			l_parser_options.force_last (l_mysql_writer_option)

			-- Parse command line input.
			l_parser.parse_list (l_options)

			-- Set up configuration according to command line options.

			-- Parse parameter specifying the class.
			if
				l_class_option.was_found
			then
				parse_class_parameter (l_class_option.parameter)
			end

			-- Parse parameter specifying the feature.
			if
				l_feature_option.was_found
			then
				parse_feature_parameter (l_feature_option.parameter)
			end

			-- Parameters specifying the analysis choice.

			last_configuration.set_is_expression_search_option_used (
				l_expression_search_option.was_found
			)
			last_configuration.set_is_program_location_search_option_used (
				l_program_location_search_option.was_found
			)
			last_configuration.set_is_all_program_locations_option_used (
				l_all_program_locations_option.was_found
			)

			-- Parse parameter specifying the variables.
			if
				l_variables_option.was_found
			then
				last_configuration.set_is_variables_option_used (True)
				parse_variables_parameter (l_variables_option.parameter)
			end

			-- Parse parameter specifying the expressions.
			if
				l_expressions_option.was_found
			then
				last_configuration.set_is_expressions_option_used (True)
				parse_expressions_parameter (l_expressions_option.parameter)
			end

			-- Parse parameter specifying the program locations.
			if
				l_program_locations_option.was_found
			then
				last_configuration.set_is_program_locations_option_used (True)
				parse_program_locations_parameter (l_program_locations_option.parameter)
			end

			-- Parse parameter specifying the localized variables.
			if
				l_localized_variables_option.was_found
			then
				last_configuration.set_is_localized_variables_option_used (True)
				parse_localized_variables_parameter (l_localized_variables_option.parameter)
			end

			-- Parse parameter specifying the localized expressions.
			if
				l_localized_expressions_option.was_found
			then
				last_configuration.set_is_localized_expressions_option_used (True)
				parse_localized_expressions_parameter (l_localized_expressions_option.parameter)
			end

			-- Parameters specifying persistent storage of analysis results.

			-- Parse parameter specifying the JSON file writer options.
			if
				l_json_file_writer_option.was_found
			then
				last_configuration.set_is_json_file_writer_option_used (True)
				parse_json_file_writer_parameter (l_json_file_writer_option.parameter)
			end

			-- Parse parameter specifying the MYSQL writer options.
			if
				l_mysql_writer_option.was_found
			then
				last_configuration.set_is_mysql_writer_option_used (True)
				parse_mysql_writer_parameter (l_mysql_writer_option.parameter)
			end
		end

feature {NONE} -- Implementation

	handle_parsing_error (a_error_message: STRING)
			-- Handle a parsing error by issuing an error message and aborting the dynamic program
			-- analysis.
		require
			a_error_message_not_void: a_error_message /= Void
		local
			l_error_message: STRING
		do
			-- Print an error message containing the parsing error to the standard output.
			create l_error_message.make (Error_message_header.count + a_error_message.count)
			l_error_message := Error_message_header
			l_error_message.append (a_error_message)
			io.put_string (l_error_message)

			-- Abort dynamic program analysis.
			die(-1)
		end

	localized_expression_from_raw_string (a_raw_localized_expression: STRING):
		TUPLE [expression: STRING; program_location: INTEGER]
			-- Expression and program location from `a_raw_localized_expression'.
			-- `a_raw_localized_expression' is expected to be in the format
			-- "expression:program location".
		require
			a_raw_localized_expression_not_void: a_raw_localized_expression /= Void
		local
			l_localized_expression: LIST [STRING]
			l_expression, l_program_location: STRING
		do
			-- Check if `a_raw_localized_expression' is a valid expression and program location
			-- pair.
			if
				a_raw_localized_expression.occurrences (':') = 1
			then
				-- `a_raw_localized_expression' is an valid expression and program location pair.

				-- Extract expression and program location.
				l_localized_expression := a_raw_localized_expression.split (':')

				l_expression := l_localized_expression.i_th (1)
				l_expression.left_adjust
				l_expression.right_adjust

				l_program_location := l_localized_expression.i_th (2)
				l_program_location.left_adjust
				l_program_location.right_adjust

				-- Check if `l_expression' is an empty string.
				if
					l_expression.count = 0
				then
					handle_parsing_error (Error_message_invalid_expression)
				end

				-- Check if `l_program_location' is an empty string.
				if
					l_program_location.count = 0 or else not l_program_location.is_integer
				then
					handle_parsing_error (Error_message_invalid_program_location)
				end

				Result := [l_expression, l_program_location.to_integer]
			else
				-- `a_raw_localized_expression' is an invalid localized expression.
				handle_parsing_error (Error_message_invalid_localized_expression)
			end
		ensure
			Result_not_void: Result /= Void
			expression_not_void: Result.expression /= Void
			program_location_valid: Result.program_location >= 1
		end

	localized_variable_from_raw_string (a_raw_localized_variable: STRING):
		TUPLE [variable: STRING; program_location: INTEGER]
			-- Variable and program location from `a_raw_localized_variable'.
			-- `a_raw_localized_variable' is expected to be in the format
			-- "variable:program location".
		require
			a_raw_localized_variable_not_void: a_raw_localized_variable /= Void
		local
			l_localized_variable: LIST [STRING]
			l_variable, l_program_location: STRING
		do
			-- Check if `a_raw_localized_variable' is a valid variable and program location pair.
			if
				a_raw_localized_variable.occurrences (':') = 1
			then
				-- `a_raw_localized_variable' is a valid variable and  program location pair.

				-- Extract variable and program location.
				l_localized_variable := a_raw_localized_variable.split (':')

				l_variable := l_localized_variable.i_th (1)
				l_variable.left_adjust
				l_variable.right_adjust

				l_program_location := l_localized_variable.i_th (2)
				l_program_location.left_adjust
				l_program_location.right_adjust

				-- Check if `l_variable' is an empty string.
				if
					l_variable.count = 0
				then
					handle_parsing_error (Error_message_invalid_variable)
				end

				-- Check if `l_program_location' is an empty string.
				if
					l_program_location.count = 0 or else not l_program_location.is_integer
				then
					handle_parsing_error (Error_message_invalid_program_location)
				end

				Result := [l_variable, l_program_location.to_integer]
			else
				-- `a_raw_localized_variable' is an invalid localized variable.
				handle_parsing_error (Error_message_invalid_localized_variable)
			end
		ensure
			Result_not_void: Result /= Void
			variable_not_void: Result.variable /= Void
			program_location_valid: Result.program_location >= 1
		end

	parse_class_parameter (a_parameter: STRING)
			-- Parse class from `a_parameter'.
			-- Set `class_' in `last_configuration'.
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_class_name: STRING
			l_class: CLASS_C
		do
			l_class_name := a_parameter
			l_class_name.left_adjust
			l_class_name.right_adjust

			-- Check if `l_class_name' is an empty string.
			if
				l_class_name.count = 0
			then
				handle_parsing_error (Error_message_invalid_class)
			end

			l_class := first_class_starts_with_name (l_class_name)

			-- Set `class_' in `last_configuration'.
			last_configuration.set_class (l_class)
		end

	parse_feature_parameter (a_parameter: STRING)
			-- Parse feature from `a_parameter'.
			-- Set `feature_' in `last_configuration'.
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_feature_name: STRING
			l_feature: FEATURE_I
		do
			l_feature_name := a_parameter
			l_feature_name.left_adjust
			l_feature_name.right_adjust

			-- Check if `l_feature_name' is an empty string.
			if
				l_feature_name.count = 0
			then
				handle_parsing_error (Error_message_invalid_feature)
			end

			l_feature := feature_from_class (last_configuration.class_.name, l_feature_name)

			-- Set `feature_' in `last_configuration'.
			last_configuration.set_feature (l_feature)
		end

	parse_variables_parameter (a_parameter: STRING)
			-- Parse variables from `a_parameter'.
			-- Set `variables' in `last_configuration'.
			-- `a_parameter' is expected to be in the format "variable[;variable]".
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_number_of_variables: INTEGER
			l_variables: DS_HASH_SET [STRING]
			l_raw_variables: LIST [STRING]
			l_variable: STRING
		do
			a_parameter.left_adjust
			a_parameter.right_adjust

			l_number_of_variables := a_parameter.occurrences (';') + 1

			create l_variables.make (l_number_of_variables)
			l_variables.set_equality_tester (string_equality_tester)

			-- Determine input format of `a_parameter'.
			if
				l_number_of_variables > 1
			then
				-- Multiple variables are specified.
				l_raw_variables := a_parameter.split (';')

				from
					l_raw_variables.start
				until
					l_raw_variables.after
				loop
					l_variable := l_raw_variables.item_for_iteration

					l_variable.left_adjust
					l_variable.right_adjust

					-- Check if `l_variable' is an empty string.
					if
						l_variable.count = 0
					then
						handle_parsing_error (Error_message_invalid_variable)
					end

					l_variables.force_last (l_variable)

					l_raw_variables.forth
				end
			else
				-- One variable is specified.

				-- Check if `a_parameter' is an empty string.
				if
					a_parameter.count = 0
				then
					handle_parsing_error (Error_message_invalid_variable)
				end

				l_variables.force_last (a_parameter)
			end

			-- Set `variables' in `last_configuration'.
			last_configuration.set_variables (l_variables)
		ensure
			variables_not_void: last_configuration.variables /= Void
		end

	parse_expressions_parameter (a_parameter: STRING)
			-- Parse expressions from `a_parameter'.
			-- Set `expressions' in `last_configuration'.
			-- `a_parameter' is expected to be in the format "expression[;expression]".
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_number_of_expressions: INTEGER
			l_expressions: DS_HASH_SET [STRING]
			l_raw_expressions: LIST [STRING]
			l_expression: STRING
		do
			a_parameter.left_adjust
			a_parameter.right_adjust

			l_number_of_expressions := a_parameter.occurrences (';') + 1

			create l_expressions.make (l_number_of_expressions)
			l_expressions.set_equality_tester (string_equality_tester)

			-- Determine input format of `a_parameter'.
			if
				l_number_of_expressions > 1
			then
				-- Multiple expressions are specified.
				l_raw_expressions := a_parameter.split (';')

				from
					l_raw_expressions.start
				until
					l_raw_expressions.after
				loop
					l_expression := l_raw_expressions.item_for_iteration

					l_expression.left_adjust
					l_expression.right_adjust

					-- Check if `l_expression' is an empty string.
					if
						l_expression.count = 0
					then
						handle_parsing_error (Error_message_invalid_expression)
					end

					l_expressions.force_last (l_expression)

					l_raw_expressions.forth
				end
			else
				-- One expression is specified.

				-- Check if `a_parameter' is an empty string.
				if
					a_parameter.count = 0
				then
					handle_parsing_error (Error_message_invalid_expression)
				end

				l_expressions.force_last (a_parameter)
			end

			-- Set `expressions' in `last_configuration'.
			last_configuration.set_expressions (l_expressions)
		ensure
			expressions_not_void: last_configuration.expressions /= Void
		end

	parse_program_locations_parameter (a_parameter: STRING)
			-- Parse program locations from `a_parameter'.
			-- Set `program_locations' in `last_configuration'.
			-- `a_parameter' is expected to be in the format "program location[;program location]".
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_number_of_program_locations: INTEGER
			l_program_locations: DS_HASH_SET [INTEGER]
			l_raw_program_locations: LIST [STRING]
			l_program_location: STRING
		do
			a_parameter.left_adjust
			a_parameter.right_adjust

			l_number_of_program_locations := a_parameter.occurrences (';') + 1

			create l_program_locations.make (l_number_of_program_locations)

			-- Determine input format of `a_parameter'.
			if
				l_number_of_program_locations > 1
			then
				-- Multiple program locations are specified.
				l_raw_program_locations := a_parameter.split (';')

				from
					l_raw_program_locations.start
				until
					l_raw_program_locations.after
				loop
					l_program_location := l_raw_program_locations.item_for_iteration

					l_program_location.left_adjust
					l_program_location.right_adjust

					-- Check if `l_program_location' is an empty string.
					if
						l_program_location.count = 0 or else not l_program_location.is_integer
					then
						handle_parsing_error (Error_message_invalid_program_location)
					end

					l_program_locations.force_last (l_program_location.to_integer)

					l_raw_program_locations.forth
				end
			else
				-- One program location is specified.

				-- Check if `a_parameter' is an empty string.
				if
					a_parameter.count = 0 or else not a_parameter.is_integer
				then
					handle_parsing_error (Error_message_invalid_program_location)
				end

				l_program_locations.force_last (a_parameter.to_integer)
			end

			-- Set `program_location' in `last_configuration'.
			last_configuration.set_program_locations (l_program_locations)
		ensure
			locations_not_void: last_configuration.program_locations /= Void
		end

	parse_localized_variables_parameter (a_parameter: STRING)
			-- Parse localized variables from `a_parameter'.
			-- Set `localized_variables' in `last_configuration'.
			-- `a_parameter' is expected to be in the format
			-- "variable:program location[;variable:program location]".
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_number_of_localized_variables: INTEGER
			l_raw_localized_variables: LIST [STRING]
			l_variable: STRING
			l_all_variables: DS_HASH_SET [STRING]
			l_program_location: INTEGER
			l_program_locations, l_all_program_locations: DS_HASH_SET [INTEGER]
			l_localized_variables: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_parsed_localized_variable: TUPLE [variable: STRING; program_location: INTEGER]
		do
			a_parameter.left_adjust
			a_parameter.right_adjust

			l_number_of_localized_variables := a_parameter.occurrences (';') + 1

			create l_localized_variables.make (l_number_of_localized_variables)
			l_localized_variables.set_key_equality_tester (string_equality_tester)

			create l_all_variables.make (l_number_of_localized_variables)
			l_all_variables.set_equality_tester (string_equality_tester)

			create l_all_program_locations.make (l_number_of_localized_variables)

			-- Determine input format of `a_parameter'.
			if
				l_number_of_localized_variables > 1
			then
				-- Multiple localized variables are specified.
				l_raw_localized_variables := a_parameter.split (';')

				from
					l_raw_localized_variables.start
				until
					l_raw_localized_variables.after
				loop
					-- Extract localized variable.
					l_parsed_localized_variable := localized_variable_from_raw_string (
						l_raw_localized_variables.item_for_iteration
					)

					l_variable := l_parsed_localized_variable.variable
					l_program_location := l_parsed_localized_variable.program_location

					-- Add localized variable to other localized variables.
					if
						l_localized_variables.has (l_variable)
					then
						l_localized_variables.item (l_variable).force_last (l_program_location)
					else
						create l_program_locations.make_default
						l_program_locations.force_last (l_program_location)

						l_localized_variables.force_last (l_program_locations, l_variable)
					end

					-- Add variable from current localized variable to other variables.
					l_all_variables.force_last (l_variable)

					-- Add program location from current localized variable to other program
					-- locations.
					l_all_program_locations.force_last (l_program_location)

					l_raw_localized_variables.forth
				end
			else
				-- One localized variable is specified.

				-- Extract localized variable.
				l_parsed_localized_variable := localized_variable_from_raw_string (a_parameter)

				l_variable := l_parsed_localized_variable.variable
				l_program_location := l_parsed_localized_variable.program_location

				-- Add localized variable.
				create l_program_locations.make_default
				l_program_locations.force_last (l_program_location)

				l_localized_variables.force_last (l_program_locations, l_variable)

				-- Add variable.
				l_all_variables.force_last (l_variable)

				-- Add program location.
				l_all_program_locations.force_last (l_program_location)
			end

			-- Set `localized_variables', `variables' and `program_locations' in
			-- `last_configuration'.
			last_configuration.set_localized_variables (l_localized_variables)
			last_configuration.set_variables (l_all_variables)
			last_configuration.set_program_locations (l_all_program_locations)
		ensure
			localized_variables_not_void: last_configuration.localized_variables /= Void
			variables_not_void: last_configuration.variables /= Void
			program_locations_not_void: last_configuration.program_locations /= Void
		end

	parse_localized_expressions_parameter (a_parameter: STRING)
			-- Parse localized expressions from `a_parameter'.
			-- Set `localized_expressions' in `last_configuration'.
			-- `a_parameter' is expected to be in the format
			-- "expression:program location[;expression:program location]".
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_number_of_localized_expressions: INTEGER
			l_expression: STRING
			l_all_expressions: DS_HASH_SET [STRING]
			l_raw_localized_expressions: LIST [STRING]
			l_program_locations, l_all_program_locations: DS_HASH_SET [INTEGER]
			l_program_location: INTEGER
			l_localized_expressions: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			l_parsed_localized_expression: TUPLE [expression: STRING; program_location: INTEGER]
		do
			a_parameter.left_adjust
			a_parameter.right_adjust

			l_number_of_localized_expressions := a_parameter.occurrences (';') + 1

			create l_localized_expressions.make (l_number_of_localized_expressions)
			l_localized_expressions.set_key_equality_tester (string_equality_tester)

			create l_all_expressions.make (l_number_of_localized_expressions)
			l_all_expressions.set_equality_tester (string_equality_tester)

			create l_all_program_locations.make (l_number_of_localized_expressions)

			-- Determine input format of `a_parameter'.
			if
				l_number_of_localized_expressions > 1
			then
				-- Multiple localized expressions are specified.
				l_raw_localized_expressions := a_parameter.split (';')

				from
					l_raw_localized_expressions.start
				until
					l_raw_localized_expressions.after
				loop
					-- Extract expression and program location
					l_parsed_localized_expression := localized_expression_from_raw_string (
						l_raw_localized_expressions.item_for_iteration
					)

					l_expression := l_parsed_localized_expression.expression
					l_program_location := l_parsed_localized_expression.program_location

					-- Add localized expression to other localized expressions.
					if
						l_localized_expressions.has (l_expression)
					then
						l_localized_expressions.item (l_expression).force_last (l_program_location)
					else
						create l_program_locations.make_default
						l_program_locations.force_last (l_program_location)

						l_localized_expressions.force_last (l_program_locations, l_expression)
					end

					-- Add expression to other expressions.
					l_all_expressions.force_last (l_expression)

					-- Add program location to other program location.
					l_all_program_locations.force_last (l_program_location)

					l_raw_localized_expressions.forth
				end
			else
				-- One localized expression is specified.

				-- Extract expression and program location
				l_parsed_localized_expression := localized_expression_from_raw_string (a_parameter)

				l_expression := l_parsed_localized_expression.expression
				l_program_location := l_parsed_localized_expression.program_location

				-- Add localized expression.
				create l_program_locations.make (1)
				l_program_locations.force_last (l_program_location)

				l_localized_expressions.force_last (l_program_locations, l_expression)

				-- Add expression.
				l_all_expressions.force_last (l_expression)

				-- Add program location.
				l_all_program_locations.force_last (l_program_location)
			end

			-- Set `expressions', `program_locations' and `localized_expressions' in
			-- `last_configuration'.
			last_configuration.set_localized_expressions (l_localized_expressions)
			last_configuration.set_expressions (l_all_expressions)
			last_configuration.set_program_locations (l_all_program_locations)
		ensure
			localized_expressions_not_void: last_configuration.localized_expressions /= Void
			expressions_not_void: last_configuration.expressions /= Void
			program_locations_not_void: last_configuration.program_locations /= Void
		end

	parse_json_file_writer_parameter (a_parameter: STRING)
			-- Parse JSON file writer options in `a_parameter'.
			-- Set `json_file_writer_options' in `last_configuration'.
			-- `a_parameter' is expected to be in the format "path;file name".
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_json_file_writer_options: LIST [STRING]
			l_directory: STRING
			l_file_name: STRING
		do
			a_parameter.left_adjust
			a_parameter.right_adjust

			-- Determine the input format of `a_parameter'.
			if
				a_parameter.occurrences (';') = 1
			then
				-- Input format is correct.

				-- Extract path and file name.
				l_json_file_writer_options := a_parameter.split (';')

				l_directory := l_json_file_writer_options.i_th (1)
				l_directory.left_adjust
				l_directory.right_adjust

				l_file_name := l_json_file_writer_options.i_th (2)
				l_file_name.left_adjust
				l_file_name.right_adjust

				-- Check if `l_path' is an empty string.
				if
					l_directory.count = 0
				then
					handle_parsing_error (Error_message_invalid_directory)
				end

				-- Check if `l_file_name' is an empty string.
				if
					l_file_name.count = 0
				then
					handle_parsing_error (Error_message_invalid_file_name)
				end

				-- Set `json_file_writer_options' in `last_configuration'.
				last_configuration.set_json_file_writer_options ([l_directory, l_file_name])
			else
				-- Input format is invalid.
				handle_parsing_error (Error_message_invalid_json_file_writer_options)
			end
		ensure
			json_file_writer_options_not_void: last_configuration.json_file_writer_options /= Void
		end

	parse_mysql_writer_parameter (a_parameter: STRING)
			-- Parse MYSQL writer options in `a_parameter'.
			-- Set `mysql_writer_options' in `last_configuration'.
			-- `a_parameter' is expected to be in the format "host;user;password;database;port".
		require
			a_parameter_not_void: a_parameter /= Void
		local
			l_mysql_writer_options: LIST [STRING]
			l_host: STRING
			l_user: STRING
			l_password: STRING
			l_database: STRING
			l_port: STRING
		do
			a_parameter.left_adjust
			a_parameter.right_adjust

			-- Determine the input format of `a_parameter'
			if
				a_parameter.occurrences (';') = 4
			then
				-- Input format is correct.

				-- Extract host, user, password, database and port.
				l_mysql_writer_options := a_parameter.split (';')

				l_host := l_mysql_writer_options.i_th (1)
				l_host.left_adjust
				l_host.right_adjust

				l_user := l_mysql_writer_options.i_th (2)
				l_user.left_adjust
				l_user.right_adjust

				l_password := l_mysql_writer_options.i_th (3)
				l_password.left_adjust
				l_password.right_adjust

				l_database := l_mysql_writer_options.i_th (4)
				l_database.left_adjust
				l_database.right_adjust

				l_port := l_mysql_writer_options.i_th (5)
				l_port.left_adjust
				l_port.right_adjust

				-- Check if `l_host' is an empty string.
				if
					l_host.count = 0
				then
					handle_parsing_error (Error_message_invalid_host)
				end

				-- Check if `l_user' is an empty string.
				if
					l_user.count = 0
				then
					handle_parsing_error (Error_message_invalid_user)
				end

				-- Check if `l_database' is an empty string.
				if
					l_database.count = 0
				then
					handle_parsing_error (Error_message_invalid_database)
				end

				-- Check if `l_port' is an empty string.
				if
					l_port.count = 0 or else not l_port.is_integer
				then
					handle_parsing_error (Error_message_invalid_port)
				end

				-- Set `mysql_writer_options' in `last_configuration'.
				last_configuration.set_mysql_writer_options (
					[l_host, l_user, l_password, l_database, l_port.to_integer]
				)
			else
				-- Input format is invalid.
				handle_parsing_error (Error_message_invalid_mysql_writer_options)
			end
		ensure
			mysql_writer_options_not_void: last_configuration.mysql_writer_options /= Void
		end

end
