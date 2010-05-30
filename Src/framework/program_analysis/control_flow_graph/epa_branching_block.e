note
	description: "Summary description for {EPA_SPLITTING_BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_BRANCHING_BLOCK

inherit
	EPA_BASIC_BLOCK
		redefine
			asts
		end

feature -- Access

	asts: ARRAYED_LIST [AST_EIFFEL]
			-- List of ASTs inside current block

	condition: EXPR_AS
			-- Condition on which execution branches
		deferred
		ensure
			result_attached: Result /= Void
		end

	true_successor: EPA_BASIC_BLOCK
			-- Successor which goes through if `condition' evaluates to True

	false_successor: EPA_BASIC_BLOCK
			-- Successor which goes through if `condition' evaluates to False		

invariant
	asts_valid: asts.count = 1 and then asts.first = condition

end
