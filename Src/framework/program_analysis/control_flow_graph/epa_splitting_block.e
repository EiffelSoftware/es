note
	description: "Summary description for {EPA_SPLITTING_BLOCK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_SPLITTING_BLOCK

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

	predecessors: ARRAYED_LIST [EPA_BASIC_BLOCK]
			-- Predecessor blocks
		do
		end

	successors: ARRAYED_LIST [EPA_BASIC_BLOCK]
			-- Successor blocks
		do
		end

	true_successor: EPA_BASIC_BLOCK
			-- Successor which goes through if `condition' evaluates to True

	false_successor: EPA_BASIC_BLOCK
			-- Successor which goes through if `condition' evaluates to False		

invariant
	asts_valid: asts.count = 1 and then asts.first = condition
	successors_valid: successors.count = 0 and then successors.has (true_successor) and then successors.has (false_successor)

end
