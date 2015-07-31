note
	description: "Type operations."
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
			{ANY} last_type, set_is_checking_postcondition, is_checking_postcondition, set_is_inherited, set_is_checking_precondition, is_checking_precondition
			{ANY} is_valid
		redefine
			set_routine_ids,
			match_list_of_class,
			process_there_exists_as,
			process_for_all_as,
			process_un_old_as
		end

	SHARED_AST_CONTEXT
		rename
			context as ast_context
		export
			{NONE} all
		end

	ETR_SHARED_TOOLS

	ETR_SHARED_PARSERS
		rename
			error_handler as etr_error_handler
		export
			{ANY} parsing_helper
		end

	ETR_SHARED_LOGGER

create
	make

feature {NONE} -- Creation

	make
			-- Initialize type checker
		do
			-- Create interal type checkers
			create type_a_checker
			create inherited_type_a_checker
			create type_a_generator
			create byte_anchor
			context := ast_context
		end

feature -- Output

	print_type (a_type: TYPE_A; a_context: ETR_CONTEXT): STRING
			-- Prints `a_type' so it's parsable
		require
			type_non_void: a_type /= void
			valid_type: a_type.is_valid
			context_set: a_context /= void
		local
			l_gen_count: INTEGER
			l_index: INTEGER
			l_class_context: ETR_CLASS_CONTEXT
			l_feat_context: ETR_FEATURE_CONTEXT
		do
			if attached {ETR_FEATURE_CONTEXT}a_context as l_ft then
				l_feat_context := l_ft
				l_class_context := l_ft.class_context
			elseif attached {ETR_CLASS_CONTEXT}a_context as l_cls then
				l_class_context := l_cls
			end

			create Result.make_empty

			-- print attachment marks
			if a_type.has_attached_mark then
				Result.append_character ('!')
			elseif a_type.has_detachable_mark then
				Result.append_character ('?')
			end

			-- print keywords
			if attached {CL_TYPE_A}a_type as l_cl_type then
				if l_cl_type.has_expanded_mark then
					Result.append ({SHARED_TEXT_ITEMS}.ti_expanded_keyword)
					Result.append_character (' ')
				elseif l_cl_type.has_reference_mark then
					Result.append ({SHARED_TEXT_ITEMS}.ti_reference_keyword)
					Result.append_character (' ')
				elseif l_cl_type.has_separate_mark then
					Result.append ({SHARED_TEXT_ITEMS}.ti_separate_keyword)
					Result.append_character (' ')
				end
			end

			if a_type.is_formal then
				if attached {FORMAL_A}a_type as l_formal then
					if l_class_context /= void then
						Result.append(l_class_context.written_class.generics[l_formal.position].formal.name.name)
					else
						etr_error_handler.add_error (Current, "print_type", "Cannot print FORMAL_A without a class context.")
					end
				end
			elseif a_type.is_like_current then
				Result.append("like Current")
			elseif a_type.is_like_argument then
				if attached {LIKE_ARGUMENT}a_type as l_like_arg then
					if l_feat_context /= void then
						Result.append("like "+l_feat_context.arguments[l_like_arg.position].name)
					else
						etr_error_handler.add_error (Current, "print_type", "Cannot print LIKE_ARGUMENT without a feature context.")
					end
				end
			elseif a_type.is_like then
				if attached {LIKE_FEATURE}a_type as l_like_feat then
					Result.append("like "+l_like_feat.feature_name)
				end
			elseif a_type.is_named_tuple then
				if attached {NAMED_TUPLE_TYPE_A}a_type as l_named_tt then
					Result.append (l_named_tt.associated_class.name_in_upper)

					l_gen_count := l_named_tt.generics.count

					if l_gen_count>0 then
						Result.append("[")
					end

					from
						l_index := l_named_tt.generics.lower
					until
						l_index > l_named_tt.generics.upper
					loop
						Result.append (l_named_tt.label_name (l_index)+": ")
						Result.append (print_type(l_named_tt.generics[l_index],a_context))
						if l_index /= l_gen_count then
							Result.append("; ")
						end

						l_index := l_index + 1
					end

					if l_gen_count>0 then
						Result.append("]")
					end
				end
			elseif a_type.has_generics then
				if attached {GEN_TYPE_A}a_type as l_gen then
					Result.append (l_gen.associated_class.name_in_upper)

					-- recursively print generics
					l_gen_count := l_gen.generics.count

					if l_gen_count>0 then
						Result.append("[")
					end

					from
						l_index := 1
					until
						l_index > l_gen_count
					loop
						Result.append (print_type(l_gen.generics[l_index],a_context))
						if l_index /= l_gen_count then
							Result.append(",")
						end
						l_index := l_index+1
					end

					if l_gen_count>0 then
						Result.append("]")
					end
				end
			elseif attached {CL_TYPE_A}a_type as l_cl_t then
				Result.append (l_cl_t.associated_class.name_in_upper)
			else
				Result := a_type.dump -- can't handle, just use debug-dump
				logger.log_warning("{ETR_TYPE_CHCKER}.print_type: Using default dump ("+Result+")")
			end
		end

feature -- Type evaluation

	written_type_from_type_as (a_type: TYPE_AS; a_feature: FEATURE_I; a_class: detachable CLASS_C; ): TYPE_A
			-- Returns the type of `a_type' as it was written in the context of `a_feature' seen from `a_class'
		require
			type_non_void: a_type /= void
			context_set: a_feature /= void
			conforms: attached a_class implies a_class.inherits_from (a_feature.written_class)
		local
			l_generated_type, l_resolved_type: TYPE_A
		do
			l_generated_type := type_a_generator.evaluate_type (a_type, a_feature.written_class)
			type_a_checker.init_for_checking (a_feature, a_feature.written_class, void, void)
			l_resolved_type := type_a_checker.solved(l_generated_type, void)

			if attached a_class and then a_feature.written_class.class_id /= a_class.class_id then
				Result := l_resolved_type.evaluated_type_in_descendant (a_feature.written_class, a_class, a_feature)
			else
				Result := l_resolved_type
			end
		end

	explicit_type_from_type_as (a_type: TYPE_AS; a_written_class: CLASS_C; a_feature: FEATURE_I): TYPE_A
			-- Returns the explicit type of `a_type' in `a_context'
		require
			type_non_void: a_type /= void
			context_set: a_written_class /= void and a_feature /= void
		local
			l_written_type: TYPE_A
		do
			l_written_type := written_type_from_type_as(a_type, a_feature, a_written_class)
			Result := l_written_type.actual_type

			if not Result.is_explicit then
				-- recurse
				Result := explicit_type (Result, a_written_class, a_feature)
			end
		ensure
			is_explicit: Result.is_explicit
			has_associated_class: Result.associated_class /= void or Result.is_none
		end

	explicit_type (a_type: TYPE_A; a_context_class: CLASS_C; a_feature: FEATURE_I): TYPE_A
			-- Returns the explicit type of `a_type' in `a_context_class' and `a_feature'
		require
			type_non_void: a_type /= void
			non_void: a_context_class /= void
		local
			l_index: INTEGER
			l_retried: BOOLEAN
			l_type: TYPE_A
		do
			if not l_retried then
				if a_type.is_none then
					Result := a_type
				else
					Result := a_type.actual_type.instantiation_in (a_context_class.constraint_actual_type, a_context_class.class_id)
					if Result /= Void then
						Result := actual_type_from_formal_type (Result, a_context_class)
					end
					if Result.is_loose then
						if a_feature.written_class.class_id /= a_context_class.class_id then
							set_is_inherited (True)
						end
						error_handler.wipe_out
						context.initialize (a_context_class, a_context_class.actual_type)
						context.set_written_class (a_feature.written_class)
						type_a_checker.init_for_checking (a_feature, a_context_class, Void, error_handler)
						inherited_type_a_checker.init_for_checking (a_feature, a_feature.written_class, Void, error_handler)
						set_current_feature (a_feature)
						if is_inherited then
								-- Perform simple check that TYPE_A is valid, `l_type' should not be
								-- Void after this call since it was not Void when checking the parent
								-- class
							l_type := inherited_type_a_checker.solved (a_type, Void)
							check l_type_not_void: l_type /= Void end
							l_type := l_type.evaluated_type_in_descendant (context.written_class,
											context.current_class, current_feature)
							l_type := actual_type_from_formal_type (l_type, a_feature.written_class)
						else
								-- Perform simple check that TYPE_A is valid.
							l_type := type_a_checker.check_and_solved (a_type, Void)
							l_type := actual_type_from_formal_type (l_type, a_context_class)
						end
						if not error_handler.has_error then
							last_type := l_type
						else
							last_type := Void
						end
						Result := last_type
					end
				end
			end
		ensure
			is_explicit: Result.is_explicit
			has_associated_class: Result.associated_class /= void or Result.is_none
		rescue
			Result := Void
			l_retried := True
			retry
		end

	local_info (a_class: CLASS_C; a_feature: FEATURE_I): HASH_TABLE [LOCAL_INFO, INTEGER]
			-- Local information for `a_feature' in `a_class'.
		local
			l_status: BOOLEAN
		do
			l_status := ast_context.is_ignoring_export
			ast_context.set_is_ignoring_export (True)
			ast_context.initialize (a_class, a_class.actual_type)
			ast_context.set_current_feature (a_feature)
			ast_context.set_written_class (a_feature.written_class)
			init (ast_context)
			current_feature := a_feature
			if a_class.class_id /= a_feature.written_class.class_id then
				set_is_inherited (True)
			end
			if a_feature.is_routine then
				if a_feature.body /= Void then
					if attached {ROUTINE_AS} a_feature.body.body.as_routine as l_routine then
						if l_routine.locals /= Void then
							type_a_checker.init_for_checking (a_feature, a_class, Void, error_handler)
							inherited_type_a_checker.init_for_checking (a_feature, a_feature.written_class, Void, error_handler)
							context.locals.wipe_out
							check_locals (l_routine)
							Result := context.locals
						end
					end
				end
			end
			if Result = Void then
				create Result.make (0)
			end
			ast_context.set_is_ignoring_export (l_status)
		end

feature -- Type checking

	check_transformable (a_transformable: ETR_TRANSFORMABLE)
			-- Type check `a_transformable' in its context
			-- Store type in `last_type'.
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
			has_context: not a_transformable.context.is_empty
			correct_factory: parsing_helper.is_using_compiler_factory
		do
			check_ast_type_at(a_transformable.target_node, a_transformable.context, a_transformable.path)
		end

	check_transformable_at (a_transformable: ETR_TRANSFORMABLE; a_path: AST_PATH)
			-- Type check `a_transformable' in its context at location `a_path'
			-- Store type in `last_type'.
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
			has_context: not a_transformable.context.is_empty
			correct_factory: parsing_helper.is_using_compiler_factory
			path_set_and_valid: a_path /= void and then a_path.is_valid
		do
			check_ast_type_at(a_transformable.target_node, a_transformable.context, a_path)
		end

	check_ast_type (an_ast: AST_EIFFEL; a_context: ETR_CONTEXT)
			-- Type check `an_ast' in `a_context'.
			-- Store type in `last_type'.
		require
			non_void: an_ast /= void and a_context /= void
			not_empty: not a_context.is_empty
			correct_factory: parsing_helper.is_using_compiler_factory
		do
			check_ast_type_at (an_ast, a_context, void)
		end

	check_ast_type_at (an_ast: AST_EIFFEL; a_context: ETR_CONTEXT; a_path: detachable AST_PATH)
			-- Type check `an_ast' in `a_context'.
			-- use `a_path' to determine a precise scope
		require
			non_void: an_ast /= void and a_context /= void
			not_empty: not a_context.is_empty
			valid: attached a_path implies a_path.is_valid
			correct_factory: parsing_helper.is_using_compiler_factory
		local
			l_ast_string: STRING
			l_feat: FEATURE_I
			l_parser: like etr_expr_parser
			l_status: BOOLEAN
		do
			-- reparse the ast as expression, so it can be type-checked correctly
			l_ast_string := ast_tools.ast_to_string(an_ast)
			l_parser := etr_expr_parser
			setup_formal_parameters (l_parser, a_context.context_class)
			l_parser.set_syntax_version (l_parser.provisional_syntax)
			l_parser.parse_from_utf8_string ("check "+l_ast_string, a_context.context_class)
			if l_parser.error_count > 0 then
				etr_error_handler.add_error (Current, "check_ast_type", "Cannot parse an_ast as EXPR_AS")
			else
				context.clear_all
				l_status := ast_context.is_ignoring_export
				ast_context.set_is_ignoring_export (True)
				ast_context.initialize (a_context.class_context.written_class, a_context.class_context.written_class.actual_type)
				ast_context.set_written_class (a_context.class_context.written_class)
				init (ast_context)
				if attached {ETR_FEATURE_CONTEXT}a_context as l_feat_context then
					l_feat := l_feat_context.written_feature
					initialize_object_test_locals (l_feat_context, a_path)
				end

				check_expr_type (a_context, l_parser.expression_node)
				ast_context.set_is_ignoring_export (l_status)
			end
		end

feature {NONE} -- Implementation

	set_routine_ids (ids: ID_SET; a: ID_SET_ACCESSOR)
			-- <precursor>
		do
			-- This feature would change the original class-ast in the system
		end

	initialize_object_test_locals (a_feature_context: ETR_FEATURE_CONTEXT; a_path: detachable AST_PATH)
			-- Init with object test locals from `a_feature_context'
		local
			l_local_info: LOCAL_INFO
			l_cur_local: ETR_OBJECT_TEST_LOCAL
			l_ot_id: ID_AS
		do
			if attached a_path then
				from
					a_feature_context.object_test_locals.start
				until
					a_feature_context.object_test_locals.after
				loop
					l_cur_local := a_feature_context.object_test_locals.item
					if l_cur_local.is_active_at (a_path) then
						create l_local_info
						l_local_info.set_type (l_cur_local.original_type)
						l_local_info.set_is_used (True)
						create l_ot_id.initialize(l_cur_local.name)
						context.add_object_test_local (l_local_info, l_ot_id)
						context.add_object_test_expression_scope (l_ot_id)
					end

					a_feature_context.object_test_locals.forth
				end
			end
		end

	initialize_locals (a_feature_context: ETR_FEATURE_CONTEXT)
			-- Adds the locals from `a_feature_context'
		local
			l_index: INTEGER
			l_local_info: LOCAL_INFO
			l_cur_local: ETR_TYPED_VAR
			l_name_id: INTEGER
		do
			if a_feature_context.has_locals then
				from
					l_index := a_feature_context.locals.lower
				until
					l_index > a_feature_context.locals.upper
				loop
					l_cur_local := a_feature_context.locals[l_index]
					create l_local_info
					l_local_info.set_type(l_cur_local.original_type)
					l_local_info.set_position (l_index)
					l_name_id := names_heap.id_of (l_cur_local.name)
					context.locals.put (l_local_info, l_name_id)
					l_index := l_index + 1
				end
			end
		end

	initialize_arguments (a_feature_context: ETR_FEATURE_CONTEXT)
			-- Adds the arguments from `a_feature_context'
		local
			l_index: INTEGER
			l_local_info: LOCAL_INFO
			l_cur_arg: ETR_TYPED_VAR
		do
			if a_feature_context.has_arguments then
				from
					l_index := a_feature_context.arguments.lower
				until
					l_index > a_feature_context.arguments.upper
				loop
					l_cur_arg := a_feature_context.arguments[l_index]
					create l_local_info
					l_local_info.set_type(l_cur_arg.original_type)
					l_local_info.set_position (l_index)
					context.locals.put (l_local_info, names_heap.id_of (l_cur_arg.name))
					l_index := l_index + 1
				end
			end
		end

	check_expr_type (a_context: ETR_CONTEXT; an_expr: EXPR_AS)
			-- Typechecks `an_expr' in `a_context'
		require
			correct_factory: parsing_helper.is_using_compiler_factory
		local
			l_class: CLASS_C
			l_feat: FEATURE_I
			l_error_level: like error_level
		do
			l_class := a_context.class_context.written_class
			error_handler.wipe_out
			reset
			is_byte_node_enabled := False
			l_error_level := error_level

			if attached {ETR_FEATURE_CONTEXT}a_context as l_feat_context then
				l_feat := l_feat_context.written_feature
				current_feature := l_feat
				context.set_current_feature (l_feat)

				initialize_locals(l_feat_context)
				initialize_arguments(l_feat_context)

				context.init_attribute_scopes
				context.init_local_scopes
				type_a_checker.init_for_checking (l_feat, l_class, Void, error_handler)
				inherited_type_a_checker.init_for_checking (l_feat, l_class, Void, Void)
			end

			if l_error_level = error_level then
				an_expr.process (Current)
			end
			if error_handler.error_list.count>0 then
				etr_error_handler.add_error (Current, "check_expr_type", "Type checker returned error "+error_handler.error_list.last.generating_type)
			end
			error_handler.wipe_out
		end

	actual_type_from_formal_type (a_type: TYPE_A; a_context: CLASS_C): TYPE_A
			-- If `a_type' is formal, return its actual type in context of `a_context'
			-- otherwise return `a_type' itself.
		do
			if attached {FORMAL_A} a_type as l_formal then
				Result := l_formal.constrained_type (a_context)
			else
				Result := a_type
			end
			if Result.has_generics then
				Result := Result.associated_class.constraint_actual_type
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Type checking

	check_expression_type (a_expr: EXPR_AS; a_feature: FEATURE_I; a_context_class: CLASS_C; a_written_class: detachable CLASS_C)
			-- Check the type of `a_expr' written in `a_feature', viewd from `a_context_class'.
			-- When attached `a_written_class' is used, otherwise, `a_feature'.`written_class' is used to setup AST context.
			-- Make result available in `last_type'.
		local
			l_export: BOOLEAN
		do
			error_handler.wipe_out
			if not a_feature.is_invariant and then a_feature.feature_id >= 0 then
				context.set_locals (local_info (a_context_class, a_feature))
			end
			context.initialize (a_context_class, a_context_class.actual_type)
			context.set_current_feature (a_feature)
			if a_written_class /= Void then
				context.set_written_class (a_written_class)
			else
				context.set_written_class (a_feature.written_class)
			end
			l_export := context.is_ignoring_export
			context.set_is_ignoring_export (True)

			expression_type_check_and_code (a_feature, a_expr)
			context.set_is_ignoring_export (l_export)
			if error_handler.has_error then
				last_type := Void
			end
		end

feature {NONE} -- Type checking

	expression_type_check_and_code (a_feature: FEATURE_I; an_exp: EXPR_AS)
			-- Type check `an_exp' in the context of `a_feature'.
		require
			an_exp_not_void: an_exp /= Void
		local
			l_exp_call: EXPR_CALL_AS
			l_instr_as: INSTR_CALL_AS
			errlst: LIST [ERROR]
			errcur: CURSOR
			l_vkcn_error: VKCN
			l_has_vkcn_error: BOOLEAN
			l_error_level: NATURAL_32
		do
			l_error_level := error_level
			expression_or_instruction_type_check_and_code (a_feature, an_exp)
			if error_level /= l_error_level then
					--| Check if any VKCN error
				errlst := error_handler.error_list
				errcur := errlst.cursor
				from
					errlst.start
					l_has_vkcn_error := False
				until
					errlst.after or l_has_vkcn_error
				loop
					l_vkcn_error ?= errlst.item
					l_has_vkcn_error := l_vkcn_error /= Void
					errlst.forth
				end
				errlst.go_to (errcur)

					--| If any VKCN .. then let's try to check it as an instruction
				if l_has_vkcn_error then
					l_exp_call ?= an_exp
					if l_exp_call /= Void then
						error_handler.wipe_out
						create l_instr_as.initialize (l_exp_call.call)
						expression_or_instruction_type_check_and_code (a_feature, l_instr_as)
					end
				end
			end
		end

	expression_or_instruction_type_check_and_code (a_feature: FEATURE_I; an_ast: AST_EIFFEL)
			-- Type check `an_ast' in the context of `a_feature'.
		require
			an_ast_not_void: an_ast /= Void
		local
			l_cl, l_wc: CLASS_C
			l_ctx: AST_CONTEXT
			l_error_level: like error_level
		do
			reset
			is_byte_node_enabled := False
			current_feature := a_feature

			l_cl := context.current_class
			l_error_level := error_level
			if current_feature /= Void then
				fixme("Should we use the `written_class' from `current_feature' or `context'?  Sept. 9, 2011")
--				l_wc := current_feature.written_class
				l_wc := context.written_class
				if l_wc /= l_cl then
						--| The context's feature is an inherited feature
						--| thus we need to first process in the ancestor to set specific
						--| data (after resolving in ancestor's context .. such as formal..)
						--| then reprocess in current class, note `is_inherited' is set to True
						--| to avoid recomputing (and lost) data computed in first processing.
					l_ctx := context.twin
--					expression_context := l_ctx
					context.initialize (l_wc, l_wc.actual_type)
					context.init_attribute_scopes
					context.init_local_scopes
					type_a_checker.init_for_checking (a_feature, l_wc, Void, error_handler)
					an_ast.process (Current)
					reset
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

	match_list_of_class (a_class_id: INTEGER): LEAF_AS_LIST
			-- Match list object for class id `a_class_id'
		do
		end

feature -- Quantification

	process_there_exists_as (a_as: THERE_EXISTS_AS)
			-- Process `a_as'.
		do
				-- We assume that the existential quantification is type correct
				-- and always set `last_type' to boolean_type.
				-- The reason is the we cannot type check the quantification variables
				-- inside the expression. (We can, but it needs to setup extra local variables)
				-- 15.11.2010 Jasonw			
			last_type := boolean_type
		end

	process_for_all_as (a_as: FOR_ALL_AS)
			-- Process `a_as'.
		do
				-- We assume that the existential quantification is type correct
				-- and always set `last_type' to boolean_type.
				-- The reason is the we cannot type check the quantification variables
				-- inside the expression. (We can, but it needs to setup extra local variables)
				-- 15.11.2010 Jasonw			
			last_type := boolean_type
		end

	process_un_old_as (l_as: UN_OLD_AS)
		local
			b: BOOLEAN
		do
			b := is_checking_postcondition
			if not b then
				set_is_checking_postcondition (True)
			end
			Precursor (l_as)
			if not b then
				set_is_checking_postcondition (b)
			end
		end

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
