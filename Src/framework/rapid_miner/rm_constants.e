note
	description: "Keeps all the constants needed by rapidminer and the belonging infrastructure."
	author: ""
	date: "$Date: 2010-07-28 15:37:12 +0200 "
	revision: "$Revision$"

class
	RM_CONSTANTS

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Translators from codes to strings

	validation_code_to_string (code: INTEGER): STRING
			-- Returns the string name of the validation with code.
		do
			Result := ""
			if code = x_validation then
				Result := "x_validation"
			end
		end

feature -- Algorithm types

	algorithm_decision_tree: STRING = "decision_tree"
			-- Name of the default decision tree algorithm.

	algorithm_linear_regression: STRING = "linear_regression"
			-- Name of the default linear regression algorithm.

	algorithm_decision_stump: STRING = "decision_stump"
			-- Learns only a root node of a decision tree.

	algorithm_chaid: STRING = "chaid"
			-- Learns a pruned decision tree based on a chi squared attribute relevance test.

	algorithm_id3: STRING = "id3"
			-- Learns an unpruned decision tree from nominal attributes only.

feature -- Access

	decision_tree_algorithms: DS_HASH_SET [STRING]
			-- Set of the names of supported decision tree algorithms
		once
			create Result.make (10)
			Result.set_equality_tester (string_equality_tester)

			Result.force_last (algorithm_decision_tree)
			Result.force_last (algorithm_decision_stump)
			Result.force_last (algorithm_chaid)
			Result.force_last (algorithm_id3)
		end

	linear_regression_algorithms: DS_HASH_SET [STRING]
			-- Set of the names of supported decision tree algorithms
		once
			create Result.make (10)
			Result.set_equality_tester (string_equality_tester)

			Result.force_last (algorithm_linear_regression)
		end

feature -- Status report

	is_valid_algorithm_name (a_name: STRING): BOOLEAN
			-- Does `a_name' represent a supported rapidminer algorithm?
		do
			Result := decision_tree_algorithms.has (a_name) or linear_regression_algorithms.has (a_name)
		end

	is_valid_validation_code (a_code: INTEGER): BOOLEAN
			-- Does `a_code' represent a supported rapidminer validation?
		do
			Result := (a_code > 0 and a_code < 3)
		end

feature -- Validation types

	no_validation: INTEGER = 1
			-- constant representing the no validation option for rapidminer

	x_validation: INTEGER = 2
			-- constant representing the x_validation option for rapidminer

feature -- Placeholders. They will be put into the seed xml string and will be replaced by the appropriate values afterwards.

	placeholder_data_file: STRING = "${data_file_placeholder}"

	placeholder_label_name: STRING = "${label_name_placeholder}"

	placeholder_algorithm_name: STRING = "${algorithm_name_placeholder}"

	placeholder_algorithm_parameters: STRING = "${algorithm_parameters_placeholder}"

	placeholder_selected_attributes: STRING = "${selected_attributes_placeholder}"

	placeholder_validation_parameters: STRING = "${validation_parameters_placeholder}"

	placeholder_validation_name: STRING = "${validation_name_placeholder}"

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
