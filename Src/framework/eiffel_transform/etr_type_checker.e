note
	description: "Computes the type of expressions. Based on AFX_EXPRESSION_TYPE_CHECKER"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TYPE_CHECKER

inherit
	REFACTORING_HELPER
		export
			{NONE} all
		end
	AST_FEATURE_CHECKER_GENERATOR
		export
			{NONE} all
			{ANY} last_type
		end
	SHARED_AST_CONTEXT
		rename
			context as ast_context
		export
			{NONE} all
		end
	ETR_ERROR_HANDLER
	ETR_SHARED
		rename
			basic_operators as etr_basic_ops
		export
			{NONE} all
		end

feature -- Type checking

	check_transformable (a_transformable: ETR_TRANSFORMABLE)
			-- Type check `a_transformable' in its context
			-- Store type in `last_type'.
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
		do
			reset_errors

			if attached {ETR_FEATURE_CONTEXT}a_transformable.context as l_context then
				check_ast_type(a_transformable.target_node, l_context)
			else
				add_error("check_transformable: No feature context")
			end
		end

	check_expr_type (an_expr: EXPR_AS; a_context: ETR_FEATURE_CONTEXT)
			-- Type check `an_expr' in the context of `a_feature'.
			-- Store type of `a_expr_as' in `last_type'.
		require
			non_void: an_expr /= void and a_context /= void
		do
			init (ast_context)
			ast_context.set_is_ignoring_export (True)
			ast_context.initialize (a_context.class_context.written_class, a_context.class_context.written_class.actual_type, a_context.class_context.written_class.feature_table)
			expression_or_instruction_type_check_and_code (a_context.original_written_feature, an_expr)
		end

	check_ast_type (an_ast: AST_EIFFEL; a_context: ETR_FEATURE_CONTEXT)
			-- Type check `an_ast' in the context of `a_feature'.
			-- Store type of `a_expr_as' in `last_type'.
		require
			non_void: an_ast /= void and a_context /= void
		local
			l_expr: EXPR_AS
			l_expr_trans: ETR_TRANSFORMABLE
			l_ast_string: STRING
		do
			reset_errors

			-- reparse the ast as expression, so it can be type-checked correctly
			l_ast_string := ast_to_string(an_ast)
			etr_expr_parser.parse_from_string("check "+l_ast_string,void)
			if etr_expr_parser.error_count > 0 then
				add_error("check_ast_type: Cannot parse an_ast as EXPR_AS")
			else
				l_expr := etr_expr_parser.expression_node

				init (ast_context)
				ast_context.set_is_ignoring_export (True)
				ast_context.initialize (a_context.class_context.written_class, a_context.class_context.written_class.actual_type, a_context.class_context.written_class.feature_table)
				expression_or_instruction_type_check_and_code (a_context.original_written_feature, l_expr)
			end
		end

feature {NONE} -- Implementation

	expression_or_instruction_type_check_and_code (a_feature: FEATURE_I; an_ast: AST_EIFFEL)
			-- Type check `an_ast' in the context of `a_feature'		
		require
			an_ast_not_void: an_ast /= Void
		local
			l_current_class, l_written_class: CLASS_C
			l_context: AST_CONTEXT
			l_error_level: like error_level
		do
			error_handler.wipe_out
			fixme ("Routine adapted from debugger related classes. 22.11.2009 Jason")
			reset
			current_feature := a_feature

			l_current_class := context.current_class
			l_error_level := error_level
			if attached current_feature then
				-- Setup local variables.
				context.locals.wipe_out
				if a_feature.is_routine then
					if attached {ROUTINE_AS} a_feature.body.body.as_routine as l_routine then
						if l_routine.locals /= Void then
							context.set_current_feature (a_feature)
							context.set_written_class (a_feature.written_class)
							-- bustefan: init type_a_checker to check locals
							type_a_checker.init_for_checking (current_feature, l_current_class, void, error_handler)
							check_locals (l_routine)
						end
					end
				end

				l_written_class := current_feature.written_class
				if l_written_class /= l_current_class then
					l_context := context.twin
					context.initialize (l_written_class, l_written_class.actual_type, context.current_feature_table)
					context.init_attribute_scopes
					context.init_local_scopes
					type_a_checker.init_for_checking (a_feature, l_written_class, Void, error_handler)
					inherited_type_a_checker.init_for_checking (a_feature, l_written_class, Void, Void)

					an_ast.process (Current)
					reset
					set_is_inherited (True)
					context.restore (l_context)
				end
				context.init_attribute_scopes
				context.init_local_scopes
				type_a_checker.init_for_checking (a_feature, l_current_class, Void, error_handler)
				inherited_type_a_checker.init_for_checking (a_feature, l_written_class, Void, Void)
			end
			if l_error_level = error_level then
				an_ast.process (Current)
			end
			if error_handler.error_list.count>0 then
				add_error("expression_or_instruction_type_check_and_code: Type checker returned error "+error_handler.error_list.last.generating_type)
			end
			error_handler.wipe_out
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
