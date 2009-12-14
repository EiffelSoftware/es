note
	description: "Summary description for {AFX_ANY_STRUCTURE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ANY_STRUCTURE_ANALYZER

inherit
	AFX_EXPRESSION_STRUCTURE_ANALYZER

feature -- Basic operations

	analyze (a_expression: AFX_EXPRESSION)
			-- Analyze the structure of `a_expression', set `is_matched' to True if
			-- the structure of `a_expression' matches current analyzer.
			-- This analyzer will match any expression.
		do
			is_matched := True
		end

feature -- Visitor

	process (a_visitor: AFX_EXPRESSION_STRUCTURE_ANALYZER_VISITOR)
			-- Process Current with `a_visitor'.
		do
			a_visitor.process_any_structure_analyzer (Current)
		end


end
