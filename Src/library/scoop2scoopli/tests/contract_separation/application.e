class
	APPLICATION


create
	make

feature {NONE} -- Initialization
	make
		do
		end

	simple_computed (a_separate_argument: attached separate A; a_non_separate_argument: A): BOOLEAN
		require
			separate_call: a_separate_argument.is_condition_satisfied
			non_separate_call: a_non_separate_argument.is_condition_satisfied
		do
			Result := True
		ensure
			old_keyword: a_separate_argument = old a_separate_argument
			result_keyword: Result = True
			non_separate_call: a_non_separate_argument.is_condition_satisfied
			separate_call: a_separate_argument.is_condition_satisfied
		end

	complex_computed (a_separate_argument: attached separate A; a_non_separate_argument: A): BOOLEAN
		require
			separate_call_in_main_chain: a_separate_argument.non_separate_query_with_argument (a_non_separate_argument.non_separate_query_without_argument).is_condition_satisfied
			separate_call_in_actual_arguments: a_non_separate_argument.non_separate_query_with_argument (a_separate_argument.non_separate_query_without_argument).is_condition_satisfied
			only_non_separate_calls: a_non_separate_argument.non_separate_query_with_argument (a_non_separate_argument.non_separate_query_without_argument).is_condition_satisfied
			separate_call_in_strict_conjunction: a_separate_argument.is_condition_satisfied and then a_non_separate_argument.is_condition_satisfied
		do
			Result := True
		ensure
			old_keyword: a_separate_argument.is_condition_satisfied = old a_non_separate_argument.is_condition_satisfied
			result_keyword: Result = a_separate_argument.is_condition_satisfied or a_non_separate_argument.is_condition_satisfied
			non_separate_call_in_main_chain: a_non_separate_argument.is_condition_satisfied
			non_separate_call_in_actual_arguments: a_separate_argument.non_separate_query_with_argument (a_non_separate_argument.non_separate_query_without_argument).is_condition_satisfied
			only_separate_calls: a_separate_argument.is_condition_satisfied
		end
end
