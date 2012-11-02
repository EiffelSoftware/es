note
	description: "Configuration validator to validate a configuration for dynamic program%
		%analysis."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_CONFIGURATION_VALIDATOR

inherit
	DPA_CONFIGURATION_ERROR_MESSAGES
		export
			{NONE} all
		end

	EPA_UTILITY
		export
			{NONE} all
		end

create
	make, default_create

feature {NONE} -- Initialization

	make (a_configuration: like configuration)
			-- Initialize configuration validator.
		require
			a_configuration_not_void: a_configuration /= Void
		do
			set_configuration (a_configuration)
		ensure
			configuration_set: configuration = a_configuration
		end

feature -- Access

	configuration: DPA_CONFIGURATION
			-- Configuration which is validated.

	last_status_message: STRING
			-- Last status message containing configuration errors and explanations why
			-- `configuration' is not a valid configuration if the configuration is invalid.

feature -- Status report

	is_configuration_valid: BOOLEAN
			-- Is `configuration' valid?

feature -- Basic operations

	validate
			-- Validate `configuration', make result available in `is_configuration_valid' and make
			-- status message containing configuration errors and its explanations available in
			-- `last_status_message'.
		local
			l_last_status_message: STRING
			l_is_program_location_choice_valid: BOOLEAN
			l_is_expression_choice_valid: BOOLEAN
			l_is_analysis_choice_valid: BOOLEAN
			l_program_locations: DS_HASH_SET [INTEGER]
			l_feature_breakpoint_interval: INTEGER_INTERVAL
			l_is_writer_choice_valid: BOOLEAN
			l_json_file_writer_options: TUPLE [directory: STRING; file_name: STRING]
			l_directory_name: DIRECTORY_NAME
			l_file_name: FILE_NAME
			l_mysql_writer_options: TUPLE
				[host: STRING; user: STRING; password: STRING; database: STRING; port: INTEGER]
			l_mysql_client: MYSQL_CLIENT
		do
			is_configuration_valid := True

			create l_last_status_message.make (2000)
			l_last_status_message.append (error_message_header)

			if
				configuration.class_ = Void
			then
				-- `class_' as defined in `configuration' is invalid.
				is_configuration_valid := False
				l_last_status_message.append (Error_message_invalid_class)
			end

			if
				configuration.feature_ = Void
			then
				-- `feature_' as defined in `configuration' is invalid.
				is_configuration_valid := is_configuration_valid and False
				l_last_status_message.append (Error_message_invalid_feature)
			end

			l_is_program_location_choice_valid :=
				configuration.is_all_program_locations_option_used xor
				configuration.is_program_location_search_option_used xor
				configuration.is_program_locations_option_used

			l_is_expression_choice_valid :=
				configuration.is_expression_search_option_used xor
				configuration.is_expressions_option_used xor
				configuration.is_variables_option_used

			l_is_analysis_choice_valid :=
				(l_is_program_location_choice_valid and then l_is_expression_choice_valid) xor
				configuration.is_localized_expressions_option_used xor
				configuration.is_localized_variables_option_used

			-- Is the analysis choice valid?
			if
				not l_is_analysis_choice_valid
			then
				-- The analysis choice as defined in `configuration' is not valid.
				is_configuration_valid := False
				l_last_status_message.append (Error_message_invalid_analysis_choice)
			end

			if
				configuration.is_program_locations_option_used or
				configuration.is_localized_variables_option_used or
				configuration.is_localized_expressions_option_used
			then
				l_program_locations := configuration.program_locations
				create l_feature_breakpoint_interval.make (
					1,
					breakpoint_count (configuration.feature_)
				)

				from
					l_program_locations.start
				until
					l_program_locations.after
				loop
					-- Is the current program location a valid program location of the feature
					-- under analysis?
					if
						not l_feature_breakpoint_interval.has (
							l_program_locations.item_for_iteration
						)
					then
						-- The current program location is invalid.
						l_last_status_message.append (Error_message_invalid_program_location)
						is_configuration_valid := False
					end

					l_program_locations.forth
				end
			end

			l_is_writer_choice_valid :=
				configuration.is_json_file_writer_option_used xor
				configuration.is_mysql_writer_option_used

			-- Is the writer choice valid?
			if
				not l_is_writer_choice_valid
			then
				-- The writer choice as defined in `configuration' is invalid.
				is_configuration_valid := False
				l_last_status_message.append (Error_message_invalid_writer_choice)
			end

			-- Check JSON file writer options if specified.
			if
				configuration.is_json_file_writer_option_used
			then
				l_json_file_writer_options := configuration.json_file_writer_options

				-- Check validity of `directory'.
				create l_directory_name.make_from_string (l_json_file_writer_options.directory)

				if
					not l_directory_name.is_valid
				then
					-- The specified directory is invalid.
					is_configuration_valid := False
					l_last_status_message.append (Error_message_invalid_directory)
				end

				-- Check validity of `file_name'.
				create l_file_name.make_from_string (l_json_file_writer_options.file_name)

				if
					not l_file_name.is_valid
				then
					-- The specified file name is invalid.
					is_configuration_valid := False
					l_last_status_message.append (Error_message_invalid_file_name)
				end
			end

			-- Check MYSQL writer options if specified.
			if
				configuration.is_mysql_writer_option_used
			then
				l_mysql_writer_options := configuration.mysql_writer_options

				-- Check validity of `port'.
				if
					l_mysql_writer_options.port < 1 or else l_mysql_writer_options.port > 65535
				then
					-- The specified port is invalid.
					l_last_status_message.append (Error_message_invalid_port)
					is_configuration_valid := is_configuration_valid and False
				else
					-- The specified port is valid.

					create l_mysql_client.make_with_database (
						l_mysql_writer_options.host,
						l_mysql_writer_options.user,
						l_mysql_writer_options.password,
						l_mysql_writer_options.database,
						l_mysql_writer_options.port
					)

					l_mysql_client.connect

					-- Check if a connection to the database can be established.
					if
						not l_mysql_client.is_connected
					then
						-- The connection to the database couldn't be established.
						l_last_status_message.append (
							Error_message_failing_mysql_connection_attempt
						)
						l_last_status_message.append (l_mysql_client.last_error + "%N%N")
					else
						l_mysql_client.close
					end
				end
			end

			-- Set `last_status_message' according to validation result.
			if
				is_configuration_valid
			then
				last_status_message := "%N%NThe configuration is valid.%N%N"
			else
				last_status_message := l_last_status_message
			end
		ensure
			error_message_not_void: last_status_message /= Void
		end

feature -- Setting

	set_configuration (a_configuration: like configuration)
			-- Set `configuration' to `a_configuration'.
		require
			a_configuration_not_void: a_configuration /= Void
		do
			configuration := a_configuration
		ensure
			configuration_set: configuration = a_configuration
		end

end
