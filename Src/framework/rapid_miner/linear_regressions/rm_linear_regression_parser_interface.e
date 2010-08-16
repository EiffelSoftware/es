note
	description: "Summary description for {RM_LINEAR_REGRESSION_PARSER_INTERFACE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RM_LINEAR_REGRESSION_PARSER_INTERFACE

feature -- Access

	last_linear_regression: RM_LINEAR_REGRESSION

feature -- Interface

	parse_linear_regression
			-- Parses the linear regression from the file located at `model_file_path'
		deferred
		end

feature{RM_LINEAR_REGRESSION_PARSER_INTERFACE} -- Internal data holders

	model_file_path: STRING

end
