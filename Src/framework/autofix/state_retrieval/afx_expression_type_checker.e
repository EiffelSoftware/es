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

	check_expression (a_expr_as: EXPR_AS; a_context_class: CLASS_C; a_feature: FEATURE_I; a_in_postcondition: BOOLEAN) is
			-- Type check `a_expr_as' in the context of `a_feature'.
			-- Store type of `a_expr_as' in `last_type'.
			-- `a_in_postcondition' indicates if `an_ast' in in postcondition.	
		do
			init (ast_context)
			ast_context.set_is_ignoring_export (True)
			ast_context.initialize (a_context_class, a_context_class.actual_type, a_context_class.feature_table)
			expression_or_instruction_type_check_and_code (a_feature, a_expr_as, a_in_postcondition)
		end

	local_info (a_class: CLASS_C; a_feature: FEATURE_I): HASH_TABLE [LOCAL_INFO, INTEGER]
			-- Local information for `a_feature' in `a_class'.
		do
			init (ast_context)
			ast_context.set_is_ignoring_export (True)
			ast_context.initialize (a_class, a_class.actual_type, a_class.feature_table)
			ast_context.set_current_feature (a_feature)
			ast_context.set_written_class (a_feature.written_class)
			current_feature := a_feature
			if a_feature.is_routine then
				if attached {ROUTINE_AS} a_feature.body.body.as_routine as l_routine then
					if l_routine.locals /= Void then
						type_a_checker.init_for_checking (a_feature, a_class, Void, error_handler)
						context.locals.wipe_out
						check_locals (l_routine)
						Result := context.locals
					end
				end
			end
			if Result = Void then
				create Result.make (0)
			end
		end

feature{NONE} -- Implementation

	expression_or_instruction_type_check_and_code (a_feature: FEATURE_I; an_ast: AST_EIFFEL; a_in_postcondition: BOOLEAN)
			-- Type check `an_ast' in the context of `a_feature'.	
			-- `a_in_postcondition' indicates if `an_ast' in in postcondition.		
		require
			an_ast_not_void: an_ast /= Void
		local
			l_cl, l_wc: CLASS_C
			l_ft: FEATURE_TABLE
			l_ctx: AST_CONTEXT
			l_error_level: like error_level
		do
			error_handler.wipe_out
			fixme ("Routine adapted from debugger related classes. 22.11.2009 Jason")
			reset
			if a_in_postcondition then
				set_is_checking_postcondition (True)
			end
			is_byte_node_enabled := True
			current_feature := a_feature

			l_cl := context.current_class
			l_error_level := error_level
			if current_feature /= Void then
					-- Setup local variables.
				context.locals.wipe_out
				if a_feature.is_routine then
					if attached {ROUTINE_AS} a_feature.body.body.as_routine as l_routine then
						if l_routine.locals /= Void then
							context.set_current_feature (a_feature)
							context.set_written_class (a_feature.written_class)
							check_locals (l_routine)
						end
					end
				end

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
					inherited_type_a_checker.init_for_checking (a_feature, l_wc, Void, Void)

					an_ast.process (Current)
					reset
					if a_in_postcondition then
						set_is_checking_postcondition (True)
					end
					set_is_inherited (True)
					context.restore (l_ctx)
				end
				context.init_attribute_scopes
				context.init_local_scopes
				type_a_checker.init_for_checking (a_feature, l_cl, Void, error_handler)
				inherited_type_a_checker.init_for_checking (a_feature, l_wc, Void, Void)
			end
			if l_error_level = error_level then
				an_ast.process (Current)
			end
			check error_handler.error_list.count = 0 end
			error_handler.wipe_out
		end

end
