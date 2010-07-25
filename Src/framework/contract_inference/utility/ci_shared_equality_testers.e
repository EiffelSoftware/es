note
	description: "Equality testers"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SHARED_EQUALITY_TESTERS

feature -- Access

	ci_quantified_expression_equality_tester: CI_QUANTIFIED_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for quantified expressions
		once
			create Result
		end

	ci_function_with_integer_domain_partial_equality_tester: CI_FUNCITON_WITH_INTEGER_DOMAIN_PARTIAL_EQUALITY_TESTER
			-- Equality tester for quantified expressions
		once
			create Result
		end

	ci_sequence_equality_tester: CI_SEQUENCE_EQUALITY_TESTER [EPA_EXPRESSION_VALUE]
			-- Equality tester for {CI_SEQUENCE [EPA_EXPRESSION_VALUE]}
		once
			create Result
		end

	ci_sequence_signature_equality_tester: CI_SEQUENCE_SIGNATURE_EQUALITY_TESTER
			-- Equality tester for {CI_SEQUENCE_SIGNATURE}
		once
			create Result
		end

	ci_test_case_info_equality_tester: CI_TEST_CASE_INFO_EQUALITY_TESTER
			-- Equality tester for {CI_TEST_CASE_INFO}
		once
			create Result
		end

	ci_test_case_transition_info_equality_tester: CI_TEST_CASE_TRANSITION_INFO_EQUALITY_TESTER
			-- Equality tester for {CI_TEST_CASE_INFO}
		once
			create Result
		end

	ci_single_arg_function_signature_equality_tester: CI_SINGLE_ARG_FUNCTION_SIGNATURE_EQUALITY_TESTER
			-- Equality tester for {CI_SINGLE_ARG_FUNCTION_SIGNATURE_EQUALITY_TESTER}
		once
			create Result
		end

	ci_integer_query_equality_tester: CI_INTEGER_QUERY_EQUALITY_TESTER
			-- Equality tester for {CI_INTEGER_QUERY}
		once
			create Result
		end

	ci_expression_value_hash_set_equality_tester: CI_HASH_SET_EQUALITY_TESTER [EPA_EXPRESSION_VALUE]
			-- Equality for {CI_HASH_SET [EPA_EXPRESSION_VALUE]}
		once
			create Result
		end

end
