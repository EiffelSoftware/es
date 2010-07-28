note
	description: "Keeps all the constants needed by rapidminer and the belonging infrastructure."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_CONSTANTS

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Translators from codes to strings

	algorithm_code_to_string(code: INTEGER):STRING
			-- 	Returns the string name of the algorithm with code.
		do
			Result := ""
			if code = decision_tree then
				Result := "decision_tree"
			elseif code = linear_regression then
				Result := "linear_regression"
			end
		end

	validation_code_to_string(code: INTEGER):STRING
			-- Returns the string name of the validation with code.
		do
			Result := ""
			if code = x_validation then
				Result := "x_validation"
			end
		end

feature -- Algorithm types

	decision_tree: INTEGER = 1

	linear_regression: INTEGER = 2

	algorithm_decision_tree: STRING = "decision_tree"
			-- Name of the default decision tree algorithm

feature -- Access

	decision_tree_algorithms: DS_HASH_SET [STRING]
			-- Set of the names of supported decision tree algorithms
		once
			create Result.make (10)
			Result.set_equality_tester (string_equality_tester)

			Result.force_last (algorithm_decision_tree)
		end

feature -- Status report

	is_valid_algorithm_code(a_code: INTEGER):BOOLEAN
			-- Does `a_code' represent a supported rapidminer algorithm?
		do
			Result := (a_code>0 and a_code<3)
		end

	is_valid_validation_code(a_code: INTEGER):BOOLEAN
			-- Does `a_code' represent a supported rapidminer validation?
		do
			Result := (a_code>0 and a_code<3)
		end

feature -- Validation types

	no_validation: INTEGER = 1

	x_validation: INTEGER = 2

feature -- Placeholders

	data_file_placeholder: STRING = "${data_file_placeholder}"

	label_name_placeholder: STRING = "${label_name_placeholder}"

	algorithm_name_placeholder: STRING = "${algorithm_name_placeholder}"

	algorithm_parameters_placeholder: STRING = "${algorithm_parameters_placeholder}"

	selected_attributes_placeholder: STRING = "${selected_attributes_placeholder}"

	validation_parameters_placeholder: STRING = "${validation_parameters_placeholder}"

	validation_name_placeholder: STRING = "${validation_name_placeholder}"

feature -- Environment

	rm_environment: RM_ENVIRONMENT
			-- Environment for file manipulations according to
			-- currently used operating system.
		once
			if {PLATFORM}.is_windows then
				create{RM_ENVIRONMENT_WINDOWS} Result
			else
				create{RM_ENVIRONMENT_UNIX} Result
			end

		end

end
