note
	description: "Visitor for {EPA_EXPRESSION}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_EXPRESSION_VISITOR

feature -- Process

	process_ast_expression (a_expr: EPA_AST_EXPRESSION)
			-- Process `a_expr'.
		deferred
		end

	process_universal_quantified_expression (a_expr: EPA_UNIVERSAL_QUANTIFIED_EXPRESSION)
			-- Process `a_expr'.
		deferred
		end

	process_quantified_expression (a_expr: EPA_QUANTIFIED_EXPRESSION)
			-- Process `a_expr'.
		deferred
		end

end
