note
	description: "Summary description for {AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER

inherit
	AFX_EXPRESSION_STRUCTURE_ANALYZER

	REFACTORING_HELPER

feature -- Basic operations

	analyze (a_expression: AFX_EXPRESSION)
			-- Analyze the structure of `a_expression', set `is_matched' to True if
			-- the structure of `a_expression' matches current analyzer.
			-- Only matched a linearly constrained expression
		do
			fixme ("Not supported for the moment. 14.12.2009 Jasonw")
			is_matched := False
		end
end
