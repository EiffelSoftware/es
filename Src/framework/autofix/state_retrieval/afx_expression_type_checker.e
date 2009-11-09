note
	description: "Summary description for {AFX_EXPRESSION_TYPE_CHECKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EXPRESSION_TYPE_CHECKER

inherit
	REFACTORING_HELPER

	AST_FEATURE_CHECKER_GENERATOR
		export
			{ANY} last_type
		end

	SHARED_AST_CONTEXT
		rename
			context as ast_context
		end

feature -- Type checking

	check_expression (a_expr_as: EXPR_AS; a_context_class: CLASS_C; a_feature: FEATURE_I) is
			-- Type check `a_expr_as' in the context of `a_feature'.
			-- Store type of `a_expr_as' in `last_type'.
		do
			init (ast_context)
			ast_context.set_is_ignoring_export (True)
			ast_context.initialize (a_context_class, a_context_class.actual_type, a_context_class.feature_table)
			expression_or_instruction_type_check_and_code (a_feature, a_expr_as)
		end

feature{NONE} -- Implementation

	expression_or_instruction_type_check_and_code (a_feature: FEATURE_I; an_ast: AST_EIFFEL)
			-- Type check `an_ast' in the context of `a_feature'.			
		require
			an_ast_not_void: an_ast /= Void
		local
			l_cl, l_wc: CLASS_C
			l_ft: FEATURE_TABLE
			l_ctx: AST_CONTEXT
			l_error_level: like error_level
		do
			fixme ("Routine taken from debugger related classes.")
			reset
			is_byte_node_enabled := True
			current_feature := a_feature

			l_cl := context.current_class
			l_error_level := error_level
			if current_feature /= Void then
				l_wc := current_feature.written_class
				if l_wc /= l_cl then
						--| The context's feature is an inherited feature
						--| thus we need to first process in the ancestor to set specific
						--| data (after resolving in ancestor's context .. such as formal..)
						--| then reprocess in current class, note `is_inherited' is set to True
						--| to avoid recomputing (and lost) data computed in first processing.
					l_ft := context.current_feature_table
					l_ctx := context.twin
					context.initialize (l_wc, l_wc.actual_type, l_ft)
					context.init_attribute_scopes
					context.init_local_scopes
					type_a_checker.init_for_checking (a_feature, l_wc, Void, error_handler)
					an_ast.process (Current)
					reset
					set_is_inherited (True)
					context.restore (l_ctx)
				end
				context.init_attribute_scopes
				context.init_local_scopes
				type_a_checker.init_for_checking (a_feature, l_cl, Void, error_handler)
			end
			if l_error_level = error_level then
				an_ast.process (Current)
			end
		end

end
