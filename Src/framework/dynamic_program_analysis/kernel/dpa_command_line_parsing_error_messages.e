note
	description: "Error messages which are issued when the parsing of command line options%
		%fails."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_COMMAND_LINE_PARSING_ERROR_MESSAGES

feature -- Access

	Error_message_header: STRING = "%N--------------%N%NParsing error:%N%N"
			-- Header of the error message.

	Error_message_invalid_class: STRING = "The specified class is invalid.%N%N"
			-- Error message indicating that the specified class is invalid.

	Error_message_invalid_feature: STRING = "The specified feature is invalid.%N%N"
			-- Error message indicating that the specified feature is invalid.

	Error_message_invalid_program_location: STRING =
		"One of the specified program locations is invalid.%N%N"
			-- Error message indicating that one of the specified program locations is invalid.

	Error_message_invalid_variable: STRING = "One of the specified variables is invalid.%N%N"
			-- Error message indicating that one of the specified variables is invalid.

	Error_message_invalid_expression: STRING = "One of the specified expressions is invalid.%N%N"
			-- Error message indicating that one of the specified expressions is invalid.

	Error_message_invalid_localized_variable: STRING =
		"One of the specified localized variables is invalid.%N%N"
			-- Error message indicating that one of the specified localized variables is invalid.

	Error_message_invalid_localized_expression: STRING =
		"One of the specified localized expressions is invalid.%N%N"
			-- Error message indicating that one of the specified localized expressions is invalid.

	Error_message_invalid_directory: STRING =
		"The specified directory used by the JSON file writer is invalid.%N%N"
			-- Error message indicating that the specified directory used by the JSON file writer
			-- is invalid.

	Error_message_invalid_file_name: STRING =
		"The specified file name used by the JSON file writer is invalid.%N%N"
			-- Error message indicating that the specified file name used by the JSON file writer
			-- is invalid.

	Error_message_invalid_json_file_writer_options: STRING =
		"The specified JSON file writer options are invalid.%N%N"
			-- Error message indicating that the specified JSON file writer options are invalid.

	Error_message_invalid_host: STRING = "The specified host used by the MYSQL writer is invalid.%N%N"
			-- Error message indicating that the specified host used by the MYSQL writer is
			-- invalid.

	Error_message_invalid_user: STRING = "The specified user used by the MYSQL writer is invalid.%N%N"
			-- Error message indicating that the specified user used by the MYSQL writer is
			-- invalid.

	Error_message_invalid_database: STRING =
		"The specified database used by the MYSQL writer is invalid.%N%N"
			-- Error message indicating that the specified database used by the MYSQL writer is
			-- invalid.

	Error_message_invalid_port: STRING = "The specified port used by the MYSQL writer is invalid.%N%N"
			-- Error message indicating that the specified port used by the MYSQL writer is invalid.

	Error_message_invalid_mysql_writer_options: STRING =
		"The specified MYSQL writer options are invalid.%N%N"
			-- Error message indicating that the specified MYSQL writer options are invalid.

end
