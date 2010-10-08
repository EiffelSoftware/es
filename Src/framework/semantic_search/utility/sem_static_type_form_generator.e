note
	description: "Class to generate static type form"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_STATIC_TYPE_FORM_GENERATOR

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

	SEM_UTILITY

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create output.make
		end

feature -- Access

	output: ETR_AST_STRING_OUTPUT
			-- Output of current visitor

feature -- Basic operations

	generate (a_context: EPA_CONTEXT; a_expression: EPA_EXPRESSION; a_dynamic_type_table: HASH_TABLE [STRING, STRING])
			-- Generate static type form for `a_expression' in `a_context'.
			-- Make result available in `output'.
			-- `a_dynamic_type_table' is a table from variable names to their type names.
		do
			output.reset
			root_finder.search_expression (a_expression)
			check not root_finder.last_roots.is_empty end
			dynamic_type_table := a_dynamic_type_table

			if root_finder.last_roots.count = 1 then
				last_root_name := root_finder.last_roots.first
				last_root_type := a_context.variables.item (last_root_name)
				last_root_class := last_root_type.associated_class
				a_expression.ast.process (Current)
			else
					-- There are more than one root variables, the static type form
					-- is the same as the dyanmic type form.				
				output.append_string (expression_with_replacements (a_expression, dynamic_type_table, True))
			end
		end

feature{NONE} -- Implemenation

	dynamic_type_table: HASH_TABLE [STRING, STRING]
		-- Table from variable names to their dynamic type names

	last_root_name: STRING
			-- Name of the last found root variable

	last_root_type: TYPE_A
			-- Type of the last root variable

	last_root_class: CLASS_C
			-- Classof the last root variable

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
			l_feature: FEATURE_I
			l_types: like resolved_operand_types_with_feature
			i, c: INTEGER
		do
			if last_was_unqualified then
				process_access_name (l_as.access_name)
			else
				output.append_string (l_as.access_name)
			end

			last_was_unqualified := true
			if processing_needed (l_as.parameters,l_as,1) then
				l_feature := last_root_class.feature_named (l_as.access_name)
				l_types := resolved_operand_types_with_feature (l_feature, last_root_class, last_root_type)
				output.append_string (ti_Space + ti_l_parenthesis)
				from
					i := 1
					c := l_feature.argument_count
				until
					i > c
				loop
					output.append_string (curly_brace_surrounded_type (output_type_name (l_types.item (i).name)))
					if i < c then
						output.append_string (ti_comma)
						output.append_string (ti_space)
					end
					i := i + 1
				end
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
			if a_name ~ last_root_name then
				output.append_string (dynamic_type_table.item (a_name))
			end
		end

	last_was_unqualified: BOOLEAN
			-- Are we in an unqualified call?

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
		do
			to_implement ("Implement me. 8.10.2010 Jasonw")
		end

feature{NONE} -- Implementation

	root_finder: SEM_ROOT_VARIABLE_FINDER
			-- Root variable finder
		once
			create Result.make
		end

end
