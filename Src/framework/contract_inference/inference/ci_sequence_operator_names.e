note
	description: "Names of sequence model operators"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SEQUENCE_OPERATOR_NAMES

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Sequence operators

	sequence_is_empty_un_operator: STRING = "|is_empty|"

	sequence_is_equal_bin_operator: STRING = "|=|"

	sequence_is_prefix_of_bin_operator: STRING = "|is_prefix_of|"

	sequence_concatenation_bin_operator: STRING = "|+|"

	sequence_un_operators: DS_HASH_SET [STRING]
			-- Set of unary sequence operators
		once
			create Result.make (10)
			Result.set_equality_tester (string_equality_tester)
			Result.force_last (sequence_is_empty_un_operator)
		end

	sequence_bin_operators: DS_HASH_SET [STRING]
			-- Set of binary sequence operators
		once
			create Result.make (10)
			Result.set_equality_tester (string_equality_tester)
			Result.force_last (sequence_is_equal_bin_operator)
			Result.force_last (sequence_is_prefix_of_bin_operator)
			Result.force_last (sequence_concatenation_bin_operator)
		end

end
