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
			process_id_as,
			process_access_feat_as,
			process_current_as,
			process_result_as,
			process_nested_as,
			output
		end

	EPA_EXPRESSION_VISITOR

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create output.make
			create nested_level.make
		end

feature -- Basic operations

	ast_text (a_ast: AST_EIFFEL; a_replacements: like replacements): STRING
			-- Text of `a_ast' with `a_replacements'
		do
			output.reset
			replacements := a_replacements
			nested_level.wipe_out
			nested_level.extend (0)
			a_ast.process (Current)
			Result := output.string_representation.twin
		end

	expression_text (a_expr: EPA_EXPRESSION; a_replacements: like replacements): STRING
			-- Text of `a_expr' with `a_replacements'
		do
			output.reset
			nested_level.wipe_out
			nested_level.extend (0)
			replacements := a_replacements
			a_expr.process (Current)
			Result := output.string_representation.twin
		end

feature{NONE} -- Process

	process_access_name (a_name: STRING)
			-- Process accessed variable named `a_name'.
		do
			if attached {STRING} replacements.item (a_name.as_lower) as l_new_name then
				output.append_string (l_new_name)
			end
		end

	process_id_as (l_as: ID_AS)
		do
			process_access_name (l_as.name)
		end

	process_argument_list (l_as: EIFFEL_LIST [AST_EIFFEL]; separator: STRING_8; a_parent: AST_EIFFEL; a_branch: INTEGER_32)
			-- Process `l_as' and use `separator' for string output
			-- (from ETR_AST_STRUCTURE_PRINTER)
			-- (export status {NONE})
		local
			l_cursor: INTEGER_32
		do
			output.enter_child (l_as)
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				nested_level.extend (0)
				process_child (l_as.item, l_as, l_as.index)
				if attached separator and l_as.index /= l_as.count then
					output.append_string (separator)
				end
				nested_level.remove
				l_as.forth
			end
			l_as.go_i_th (l_cursor)
			output.exit_child
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			if nested_level.item <= 1 then
				output.append_string (l_as.access_name)
			end

			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (ti_Space+ti_l_parenthesis)
				process_child_list(l_as.parameters, ti_comma+ti_Space, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end
		end

	process_current_as (l_as: CURRENT_AS)
		do
			process_access_name (ti_current)
		end

	process_result_as (l_as: RESULT_AS)
		do
			process_access_name (ti_result)
		end

	process_nested_as (l_as: NESTED_AS)
		do
			check not nested_level.is_empty end
			nested_level.replace (nested_level.item + 1)
			process_child (l_as.target, l_as, 1)
			output.append_string (ti_dot)
			process_child (l_as.message, l_as, 2)
			check nested_level.item > 0 end
			nested_level.replace (nested_level.item - 1)
		end

feature{NONE} -- Implementation

	nested_level: LINKED_STACK [INTEGER]
			-- Stack to store nested levels

	replacements: HASH_TABLE [STRING, STRING]
			-- Table of expression replacements
			-- Key is the expression to be replaced, value is the new string.

	output: ETR_AST_STRING_OUTPUT
			-- Output of current visitor

feature{NONE} -- Process/expression

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

end
