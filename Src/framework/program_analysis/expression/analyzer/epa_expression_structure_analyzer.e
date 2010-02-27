note
	description: "Summary description for {AFX_EXPRESSION_FORMAT_DECIDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_STRUCTURE_ANALYZER

inherit
	EPA_UTILITY

feature -- Status report

	is_matched: BOOLEAN
			-- Does the structure of the last analyzed expression match current analyzer?

feature -- Basic operations

	analyze (a_expression: EPA_EXPRESSION)
			-- Analyze the structure of `a_expression', set `is_matched' to True if
			-- the structure of `a_expression' matches current analyzer.
			-- Here is a list of possible structure of `a_expression':
			-- 1. ABQ  (ABQ is the set of argumentless boolean queries, possibly with negations)
			-- 2. ABQ -> ABQ
			-- 3. linear constrained
		deferred
		end

feature -- Visitor

	process (a_visitor: EPA_EXPRESSION_STRUCTURE_ANALYZER_VISITOR)
			-- Process Current with `a_visitor'.
		deferred
		end

end
