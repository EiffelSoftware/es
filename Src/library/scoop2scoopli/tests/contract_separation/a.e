class
	A

feature
	separate_query_with_argument (a_separate_argument: separate A): separate A
		do
			Result := Current
		end
		
	non_separate_query_with_argument (a_separate_argument: separate A): A
		do
			Result := Current
		end
		
	separate_query_without_argument: separate A
		do
			Result := Current
		end
		
	non_separate_query_without_argument: A
		do
			Result := Current
		end
		
	is_condition_satisfied: BOOLEAN
end
