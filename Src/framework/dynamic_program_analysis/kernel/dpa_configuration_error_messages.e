note
	description: "Error messages which are issued when the validation of the command line options%
		%fails."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_CONFIGURATION_ERROR_MESSAGES

feature -- Access

	Error_message_header: STRING = "%N--------------------%N%NConfiguration error:%N%N"
			-- Header of the error message.

	Error_message_invalid_class: STRING = "The specified class is invalid.%N%N"
			-- Error message indicating that the specified class is invalid.

	Error_message_invalid_feature: STRING = "The specified feature is invalid.%N%N"
			-- Error message indicating that the specified feature is invalid.

	Error_message_invalid_analysis_choice: STRING = "The analysis choice is invalid. Choose either%
		%one of the program location and expression choice options or the localized%
		%expression option or the localized variable option.%N%N"
			-- Error message indicating that the analysis choice is invalid.

	Error_message_invalid_program_location: STRING =
		"One of the specified program locations is invalid."
			-- Error message indicating that one of the specified program locations is invalid.

	Error_message_invalid_writer_choice: STRING = "Multiple writers instead of one writer were %
		%specified.%N%N"
			-- Error message indicating that Multiple writers instead of one writer were specified.

	Error_message_invalid_directory: STRING = "The specified directory is invalid.%N%N"
			-- Error message indicating that the specified directory is invalid.

	Error_message_invalid_file_name: STRING = "The specified file name is invalid.%N%N"
			-- Error message indicating that the specified file name is invalid.

	Error_message_invalid_port: STRING = "The specified port used by the MYSQL data%
		%writer must be in the interval between 1 (inclusive) and 65535 (inclusive).%
		%%N%N"
			-- Error message indicating that the specified port used by the MYSQL data writer must
			-- be in the interval between 1 (inclusive) and 65535 (inclusive).

	Error_message_failing_mysql_connection_attempt: STRING =
		"The connection attempt to MYSQL database failed.%
		%MYSQL client error message:%N%N"
			-- Error message indicating that the connection attempt to MYSQL database failed.

end
