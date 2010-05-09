note
	description: "Class to replace variables in an expression with special format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_TRANSITION_EXPRESSION_REWRITER

inherit
	ETR_AST_STRUCTURE_PRINTER
		export{NONE}
			all
		redefine
			process_like_id_as,
			process_instr_call_as,
			process_id_as,
			process_expr_call_as,
			process_creation_as,
			process_access_feat_as,
			process_nested_as,
			process_nested_expr_as,
			output
		end

	EPA_EXPRESSION_VISITOR

	EPA_EXPRESSION_VALUE_VISITOR

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create output.make
		end

feature -- Basic operations

	ast_text (a_ast: AST_EIFFEL; a_replacements: like replacements): STRING
			-- Text of `a_ast' with `a_replacements'
		do
			output.reset
			replacements := a_replacements
			last_was_unqualified := true
			a_ast.process (Current)
			Result := output.string_representation.twin
		end

	expression_text (a_expr: EPA_EXPRESSION; a_replacements: like replacements): STRING
			-- Text of `a_expr' with `a_replacements'
		do
			output.reset
			replacements := a_replacements
			last_was_unqualified := true
			a_expr.process (Current)
			Result := output.string_representation.twin
		end

	expression_value_text (a_expr_value: EPA_EXPRESSION_VALUE; a_replacements: like replacements): STRING
			-- Text of `a_expr_value' with `a_replacements'
		do
			output.reset
			replacements := a_replacements
			last_was_unqualified := true

			a_expr_value.process (Current)
			Result := output.string_representation.twin
		end

feature {AST_EIFFEL} -- Processing

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			last_was_unqualified := true
			Precursor (l_as)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			last_was_unqualified := true
			Precursor(l_as)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			last_was_unqualified := true
			Precursor(l_as)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			last_was_unqualified := true
			output.append_string (ti_create_keyword+ti_Space)

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string(ti_l_curly)
				process_child (l_as.type, l_as, 2)
				output.append_string(ti_r_curly+ti_Space)
			end
			process(l_as.target, l_as, 1)
			last_was_unqualified := false
			if processing_needed (l_as.call, l_as, 3) then
				output.append_string (ti_dot)
				process_child (l_as.call, l_as, 3)
			end
			output.append_string(ti_New_line)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_changed_arguments: ETR_CT_CHANGED_NAME_TYPE
		do
			if last_was_unqualified then
				process_access_name (l_as.access_name)
			else
				output.append_string (l_as.access_name)
			end

			last_was_unqualified := true
			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (ti_Space+ti_l_parenthesis)
				process_child_list(l_as.parameters, ti_comma+ti_Space, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end
		end

	process_id_as (l_as: ID_AS)
		do
			if last_was_unqualified then
				process_access_name (l_as.name)
			else
				output.append_string (l_as.name)
			end
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			if attached {BRACKET_AS}l_as.target then
				process_child(l_as.target, l_as, 1)
			else
				output.append_string (ti_l_parenthesis)
				process_child(l_as.target, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end

			output.append_string (ti_dot)
			last_was_unqualified := false
			process_child(l_as.message, l_as, 2)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			if not last_was_unqualified then
				process_child (l_as.target, l_as, 1)
				output.append_string (ti_dot)
				process_child (l_as.message, l_as, 2)
			else
				process_child (l_as.target, l_as, 1)
				last_was_unqualified := false
				output.append_string (ti_dot)
				process_child (l_as.message, l_as, 2)
				last_was_unqualified := true
			end
		end

feature {NONE} -- Implementation

	process_access_name (a_name: STRING)
			-- Process accessed variable named `a_name'.
		do
			if attached {STRING} replacements.item (a_name.as_lower) as l_new_name then
				output.append_string (l_new_name)
			end
		end

	last_was_unqualified: BOOLEAN
			-- Are we in an unqualified call?

	replacements: HASH_TABLE [STRING, STRING]
			-- Table of expression replacements
			-- Key is the expression to be replaced, value is the new string.

	output: ETR_AST_STRING_OUTPUT
			-- Output of current visitor

feature {NONE} -- Process/expression

	process_ast_expression (a_expr: EPA_AST_EXPRESSION)
			-- Process `a_expr'.
		do
			if attached{AST_EIFFEL} a_expr.ast as l_ast then
				l_ast.process (Current)
			end
		end

	process_universal_quantified_expression (a_expr: EPA_UNIVERSAL_QUANTIFIED_EXPRESSION)
			-- Process `a_expr'.
		do
			process_quantified_expression (a_expr)
		end

	process_quantified_expression (a_expr: EPA_QUANTIFIED_EXPRESSION)
			-- Process `a_expr'.
		local
			l_str: STRING
		do
			safe_process (a_expr.ast)
			l_str := a_expr.text_with_predicate (output.string_representation)
			output.reset
			output.append_string (l_str)
		end

feature{NONE} -- Process equationn values

feature -- Process

	process_boolean_value (a_value: EPA_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
			output.append_string (a_value.item.out)
		end

	process_random_boolean_value (a_value: EPA_RANDOM_BOOLEAN_VALUE)
			-- Process `a_value'.
		do
			output.append_string (a_value.item.out)
		end

	process_integer_value (a_value: EPA_INTEGER_VALUE)
			-- Process `a_value'.
		do
			output.append_string (a_value.item.out)
		end

	process_random_integer_value (a_value: EPA_RANDOM_INTEGER_VALUE)
			-- Process `a_value'.
		do
			output.append_string (a_value.item.out)
		end

	process_nonsensical_value (a_value: EPA_NONSENSICAL_VALUE)
			-- Process `a_value'.
		do
			output.append_string (a_value.item.out)
		end

	process_void_value (a_value: EPA_VOID_VALUE)
			-- Process `a_value'.
		do
			output.append_string (ti_void)
		end

	process_any_value (a_value: EPA_ANY_VALUE)
			-- Process `a_value'.
		do
			check should_not_be_here: False end
		end

	process_reference_value (a_value: EPA_REFERENCE_VALUE)
			-- Process `a_value'.
		do
			check should_not_be_here: False end
		end

	process_ast_expression_value (a_value: EPA_AST_EXPRESSION_VALUE)
			-- Process `a_value'.
		do
			a_value.item.process (Current)
		end

	process_string_value (a_value: EPA_STRING_VALUE)
			-- Process `a_value'
		do
			output.append_string (once "%"")
			output.append_string (a_value.string_value)
			output.append_string (once "%"")
		end

end
