note
	description: "Summary description for {AFX_INTEGRAL_EXPRESSION_COMBINATION_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_INTEGRAL_EXPRESSION_COMBINATION_STRATEGY

feature -- Basic operation

	combinations_with_indexes (a_class: CLASS_C; a_feature: FEATURE_I; a_integrals: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]; a_combinations: LINKED_LIST [EPA_HASH_SET [STRING]])
					: DS_LINEAR[TUPLE [op1: STRING; op2: STRING; idx: INTEGER]]
			-- Combinations of integral expressions with indexes.
			-- `a_integrals': Dictionary mapping the texts of integral expressions to their breakpoint indexes.
			-- `a_combinations': List of all possible combinations between integral expressions.
			-- Result: Possible integral expression combinations w.r.t. current strategy,
			--		with the breakpoint index where the relation(s) should be monitored.
		require
			combinations_not_empty: not a_combinations.is_empty
			integrals_not_empty: not a_integrals.is_empty
		deferred
		end

end
