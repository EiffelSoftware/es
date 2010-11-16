note
	description: "Expression printer to output inferred contracts in a more readable format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_EXPRESSION_PRINTER

inherit
	EPA_EXPRESSION_VISITOR

	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_nested_as
		end

	EPA_UTILITY

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize.
		do
			create internal_output.make
			make_with_output (internal_output)
		end

feature -- Access

	printed_expression (a_expression: EPA_EXPRESSION): STRING
			-- Printed `a_expression'
		do
			internal_output.reset
			a_expression.process (Current)
			Result := internal_output.string_representation
		end

feature{NONE} -- Process

	process_ast_expression (a_expr: EPA_AST_EXPRESSION)
			-- Process `a_expr'.
		do
			a_expr.ast.process (Current)
		end

	process_universal_quantified_expression (a_expr: EPA_UNIVERSAL_QUANTIFIED_EXPRESSION)
			-- Process `a_expr'.
		do
			process_quantified_expression (a_expr)
		end

	process_existential_quantified_expression (a_expr: EPA_EXISTENTIAL_QUANTIFIED_EXPRESSION)
			-- Process `a_expr'.
		do
			process_quantified_expression (a_expr)
		end

	process_quantified_expression (a_expr: EPA_QUANTIFIED_EXPRESSION)
			-- Process `a_expr'.
		do
			internal_output.append_string (text_from_ast (a_expr.ast))
		end

feature{NONE} -- Process

	process_nested_as (l_as: NESTED_AS)
		do
			if attached{CURRENT_AS} l_as.target then
			else
				process_child (l_as.target, l_as, 1)
				output.append_string (ti_dot)
			end
			process_child (l_as.message, l_as, 2)
		end

feature{NONE} -- Implementation

	internal_output: ETR_AST_STRING_OUTPUT
			-- Internal output

end
