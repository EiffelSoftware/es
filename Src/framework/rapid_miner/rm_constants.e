note
	description: "Summary description for {RM_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_CONSTANTS

create
	make

feature{NONE}

	make
		do
			if {PLATFORM}.is_windows then
				create{RM_ENVIRONMENT_WINDOWS} rm_environment
			else
				create{RM_ENVIRONMENT_UNIX} rm_environment
			end

		end

feature -- translators from codes to strings

	algorithm_code_to_string(code: INTEGER):STRING
			-- 	returns the string name of the algorithm with code
		do
			Result := ""
			if code = decision_tree then
				Result := "decision_tree"
			elseif code = linear_regression then
				Result := "linear_regression"
			end
		end

	validation_code_to_string(code: INTEGER):STRING
			-- 	returns the string name of the validation with code
		do
			Result := ""
			if code = x_validation then
				Result := "x_validation"
			end
		end

feature -- algorithm types

	decision_tree: INTEGER = 1

	linear_regression: INTEGER = 2

feature -- validation types

	no_validation: INTEGER = 1

	x_validation: INTEGER = 2

feature -- placeholders

	data_file_placeholder: STRING = "${data_file_placeholder}"

	label_name_placeholder: STRING = "${label_name_placeholder}"

	algorithm_name_placeholder: STRING = "${algorithm_name_placeholder}"

	algorithm_parameters_placeholder: STRING = "${algorithm_parameters_placeholder}"

	selected_attributes_placeholder: STRING = "${selected_attributes_placeholder}"

	validation_parameters_placeholder: STRING = "${validation_parameters_placeholder}"

	validation_name_placeholder: STRING = "${validation_name_placeholder}"

feature -- env

	rm_environment: RM_ENVIRONMENT

end
