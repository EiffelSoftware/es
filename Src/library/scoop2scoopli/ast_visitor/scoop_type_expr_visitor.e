note
	description: "[
					Roundtrip visitor to evaluate type expressions, determine types.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_TYPE_EXPR_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_address_as,
			process_create_creation_expr_as,
			process_bang_creation_expr_as,
			process_result_as,
			process_current_as,
			process_precursor_as,
			process_access_feat_as,
			process_access_inv_as,
			process_static_access_as,
			process_access_assert_as,
			process_access_id_as,
			process_bin_lt_as,
			process_bin_le_as,
			process_bin_gt_as,
			process_bin_ge_as,
			process_bin_xor_as,
			process_bin_or_else_as,
			process_bin_or_as,
			process_bin_implies_as,
			process_bin_free_as,
			process_bin_eq_as,
			process_bin_tilde_as,
			process_bin_ne_as,
			process_bin_not_tilde_as,
			process_bin_and_then_as,
			process_bin_and_as,
			process_binary_as,
			process_string_as,
			process_verbatim_string_as,
			process_real_as,
			process_integer_as,
			process_char_as,
			process_typed_char_as,
			process_bool_as,
			process_object_test_as
		end

	SCOOP_WORKBENCH
	
	SHARED_STATELESS_VISITOR

feature -- Expression and Call Evaluation Access
	evaluate_expression_type_in_workbench (a_expression: EXPR_AS; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		do
			object_test_context := a_object_test_context
			inline_agent_context := a_inline_agent_context
			if feature_as /= Void then
				context_feature := class_c.feature_table.item (feature_as.feature_name.name)
			else
				context_feature := Void
			end
			expression_type := implicit_generic_derivation(class_c)
			evaluate_expression_type(a_expression)
		end

	evaluate_expression_type_in_class_and_feature (a_expression: EXPR_AS; a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		require
			a_expression_not_void: a_expression /= Void
			a_context_class_not_void: a_context_class /= Void
			a_context_feature_not_void: a_context_feature /= Void
			a_object_test_context /= Void
		do
			object_test_context := a_object_test_context
			inline_agent_context := a_inline_agent_context
			context_feature := a_context_feature
			expression_type := implicit_generic_derivation(a_context_class)
			evaluate_expression_type (a_expression)
		end

	evaluate_expression_type_in_class (a_expression: EXPR_AS; a_context_class: CLASS_C; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		require
			a_expression /= Void
			a_context_class /= Void
		do
			object_test_context := a_object_test_context
			inline_agent_context := a_inline_agent_context
			context_feature := Void
			expression_type := implicit_generic_derivation(a_context_class)
			evaluate_expression_type (a_expression)
		end

	evaluate_expression_type_in_type (a_expression: EXPR_AS; a_context_type: TYPE_A; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		require
			a_expression /= Void
			a_context_type /= Void
			a_object_test_context /= Void
		do
			object_test_context := a_object_test_context
			inline_agent_context := a_inline_agent_context
			context_feature := Void
			expression_type := a_context_type
			evaluate_expression_type (a_expression)
		end

	evaluate_call_type_in_workbench (a_call: CALL_AS; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		require
			-- a_call is a query
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_workbench(l_call_expression, a_object_test_context, a_inline_agent_context)
		end

	evaluate_call_type_in_class_and_feature (a_call: CALL_AS; a_context_class: CLASS_C; a_context_feature: FEATURE_I; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_class_and_feature(l_call_expression, a_context_class, a_context_feature, a_object_test_context, a_inline_agent_context)
		end

	evaluate_call_type_in_class (a_call: CALL_AS; a_context_class: CLASS_C; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_class(l_call_expression, a_context_class, a_object_test_context, a_inline_agent_context)
		end

	evaluate_call_type_in_type (a_call: CALL_AS; a_context_type: TYPE_A; a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]; a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING])
		require
			a_call /= Void
			a_context_type /= Void
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_type(l_call_expression, a_context_type, a_object_test_context, a_inline_agent_context)
		end

	is_query: BOOLEAN

	is_expression_separate: BOOLEAN
		-- separate state of last evaluated type

	expression_type: TYPE_A

	object_test_context_update: HASH_TABLE[OBJECT_TEST_AS, STRING]

feature -- Type Resolution Access
	resolve_type_in_workbench (a_type: TYPE_AS)
		require
			a_type /= Void
			class_c /= Void
		do
			if feature_as /= Void then
				context_feature := class_c.feature_table.item (feature_as.feature_name.name)
				expression_type := implicit_generic_derivation(class_c)
				resolved_type := resolved_type_in_context_feature_and_expression_type (a_type)
			else
				context_feature := Void
				expression_type := implicit_generic_derivation(class_c)
				resolved_type := resolved_type_in_expression_type (a_type)
			end
		end

	resolve_type_in_class_and_feature (a_type: TYPE_AS; a_context_class: CLASS_C; a_context_feature: FEATURE_I)
		require
			a_type /= Void
			a_context_class /= Void
			a_context_feature /= Void
		do
			context_feature := a_context_feature
			expression_type := implicit_generic_derivation(a_context_class)
			resolved_type := resolved_type_in_context_feature_and_expression_type (a_type)
		end

	resolve_type_in_class (a_type: TYPE_AS; a_context_class: CLASS_C)
		require
			a_type /= Void
			a_context_class /= Void
		do
			context_feature := Void
			expression_type := implicit_generic_derivation(a_context_class)
			resolved_type := resolved_type_in_expression_type (a_type)
		end

	resolve_type_in_type (a_type: TYPE_AS; a_context_type: TYPE_A)
		do
			context_feature := Void
			expression_type := a_context_type
			resolved_type := resolved_type_in_expression_type (a_type)
		end

	resolved_type: TYPE_A

feature {NONE} -- Expression and Call Evaluation Implementation
	evaluate_expression_type (a_expression: EXPR_AS)
			-- Given a EXPR_AS node, get the is_separate information of the evaluated expression
		require
			a_expression_not_void: a_expression /= Void
			expression_type /= Void
		do
			is_query := False
			is_expression_separate := False
			create object_test_context_update.make (10)
			safe_process (a_expression)
		end

	implicit_generic_derivation (a_class: CLASS_C): TYPE_A
		require
			a_class /= Void
		local
			i: INTEGER
			l_generated_actual_generics: ARRAY [TYPE_A]
		do
			if a_class.is_generic then
				from
					create l_generated_actual_generics.make (1, a_class.generics.count)
					i := 1
				until
					i > a_class.generics.count
				loop
					if a_class.generics.i_th (i).has_constraint then
						l_generated_actual_generics.put (
							type_a_generator.evaluate_type (
								a_class.generics.i_th (i).constraint.type,
								a_class
							),
							i
						)
					else
						l_generated_actual_generics.put (create {CL_TYPE_A}.make (system.any_class.compiled_representation.class_id), i)
					end
					i := i + 1
				end
				-- TODO: Instantiate all formal parameters. Assumption: no separateness
				create {GEN_TYPE_A} Result.make (a_class.class_id, l_generated_actual_generics)
			else
				create {CL_TYPE_A} Result.make (a_class.class_id)
			end
		end

	context_feature: FEATURE_I
	object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]
	inline_agent_context: HASH_TABLE[TYPE_AS, STRING]

	update_interface (a_found_type: TYPE_A)
		do
			if a_found_type /= Void then
				is_query := True
				expression_type := a_found_type

				if a_found_type.is_expanded then
					is_expression_separate := False
				else
					if not is_expression_separate and expression_type.is_separate then
						is_expression_separate := True
					end
				end
			else
				is_query := False
				expression_type := Void
				is_expression_separate := False
			end
		end

	update_interface_with_object_test_context_update (a_found_type: TYPE_A; a_object_test_context_update: OBJECT_TEST_AS)
		require
			a_object_test_context_update /= Void
		do
			update_interface (a_found_type)
			if a_object_test_context_update.name /= Void then
				object_test_context_update.put (a_object_test_context_update, a_object_test_context_update.name.name)
			end
		end

	type_of_qualified_query (a_name: STRING): TYPE_A
		require
			a_name /= Void
			expression_type /= Void
		local
			i: INTEGER
			l_found_type: TYPE_A
		do
			l_found_type := Void

			if expression_type.associated_class.feature_table.has (a_name) then
				l_found_type := expression_type.associated_class.feature_table.item (a_name).type
			elseif expression_type.associated_class.feature_table.is_mangled_alias_name (a_name) then
				l_found_type := expression_type.associated_class.feature_table.alias_item (a_name).type
			end

			if l_found_type = Void and {l_expression_type_as_named_tuple: NAMED_TUPLE_TYPE_A} expression_type then
				from
					i := 1
				until
					i > l_expression_type_as_named_tuple.generics.count
				loop
					if l_expression_type_as_named_tuple.label_name (i).is_equal (a_name) then
						l_found_type := l_expression_type_as_named_tuple.generics.item (i).instantiated_in (expression_type).deep_actual_type
					end
					i := i + 1
				end
			end

			if l_found_type /= Void then
				Result := l_found_type.instantiated_in (expression_type).deep_actual_type
			else
				Result := Void
			end
		end

	type_of_unqualified_query (a_name: STRING): TYPE_A
			-- the local type can not be anchored on another local type
			-- the formal argument type can not be anchored on a local
		require
			a_name /= Void
			expression_type /= Void
		local
			i, j: INTEGER
			l_locals: EIFFEL_LIST [TYPE_DEC_AS]
			l_locals_group: TYPE_DEC_AS
			l_formal_arguments_group: TYPE_DEC_AS
			l_formal_arguments: EIFFEL_LIST [TYPE_DEC_AS]
			l_type_expr_visitor: like Current
		do
			Result := Void
			if context_feature /= Void then
				if context_feature.body.body.arguments /= Void then
					from
						l_formal_arguments := context_feature.body.body.arguments
						i := 1
					until
						i > l_formal_arguments.count or Result /= Void
					loop
						l_formal_arguments_group := l_formal_arguments.i_th (i)
						from
							j := 1
						until
							j > l_formal_arguments_group.id_list.count or Result /= Void
						loop
							if l_formal_arguments_group.item_name (j).is_equal (a_name) then
								Result := resolved_type_in_context_feature_and_expression_type (l_formal_arguments_group.type)
							end
							j := j + 1
						end
						i := i + 1
					end
				end

				if Result = Void and {l_routine: ROUTINE_AS} context_feature.body.body.content and then l_routine.locals /= Void then
					from
						l_locals := l_routine.locals;
						i := 1
					until
						i > l_locals.count or Result /= Void
					loop
						l_locals_group := l_locals.i_th (i)
						from
							j := 1
						until
							j > l_locals_group.id_list.count or Result /= Void
						loop
							if l_locals_group.item_name (j).is_equal (a_name) then
								Result := resolved_type_in_context_feature_and_expression_type (l_locals_group.type)
							end
							j := j + 1
						end
						i := i + 1
					end
				end
			end

			if Result = Void and object_test_context.has (a_name) then
				if object_test_context.item (a_name).type /= Void then
					Result := resolved_type_in_context_feature_and_expression_type (object_test_context.item (a_name).type)
				else
					l_type_expr_visitor := scoop_visitor_factory.new_type_expr_visitor
					l_type_expr_visitor.evaluate_expression_type_in_workbench (object_test_context.item (a_name).expression, object_test_context, inline_agent_context)
					Result := l_type_expr_visitor.expression_type
				end
			end

			if Result = Void and inline_agent_context.has (a_name) then
				Result := resolved_type_in_context_feature_and_expression_type (inline_agent_context.item (a_name))
			end

			if Result = Void then
				if expression_type.associated_class.feature_table.has (a_name) then
					Result := expression_type.associated_class.feature_table.item (a_name).type.instantiated_in (expression_type).deep_actual_type
				elseif expression_type.associated_class.feature_table.is_mangled_alias_name (a_name) then
					Result := expression_type.associated_class.feature_table.alias_item (a_name).type.instantiated_in (expression_type).deep_actual_type
				end
			end
		end

feature {NONE} -- Type Resolution Implementation
	resolved_type_in_context_feature_and_expression_type (a_type: TYPE_AS): TYPE_A
		require
			a_type /= Void
			expression_type /= Void
		do
			type_a_checker.init_for_checking (context_feature, expression_type.associated_class, Void, Void)
			Result := type_a_checker.solved (
				type_a_generator.evaluate_type (a_type, expression_type.associated_class),
				a_type
			).instantiated_in(expression_type).deep_actual_type
		end

	resolved_type_in_expression_type (a_type: TYPE_AS): TYPE_A
		require
			a_type /= Void
			expression_type /= Void
		do
			Result :=
				type_a_generator.evaluate_type (
					a_type,
					expression_type.associated_class
				).instantiated_in(expression_type).deep_actual_type
		end

feature {NONE} -- Expression evaluation visits
	process_address_as (l_as: ADDRESS_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.pointer_class.compiled_representation.class_id))
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
		local
			l_found_type: TYPE_A
		do
			if context_feature /= Void then
				l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.type)
			else
				l_found_type := resolved_type_in_expression_type (l_as.type)
			end
			update_interface (l_found_type)
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
		local
			l_found_type: TYPE_A
		do
			if context_feature /= Void then
				l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.type)
			else
				l_found_type := resolved_type_in_expression_type (l_as.type)
			end
			update_interface (l_found_type)
		end

	process_bin_lt_as (l_as: BIN_LT_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_le_as (l_as: BIN_LE_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_gt_as (l_as: BIN_GT_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_ge_as (l_as: BIN_GE_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_xor_as (l_as: BIN_XOR_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_or_as (l_as: BIN_OR_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_free_as (l_as: BIN_FREE_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_binary_as (l_as: BINARY_AS)
		do
			safe_process(l_as.left)

			update_interface(type_of_qualified_query(l_as.infix_function_name))
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			process_binary_as (l_as)
		end

	process_bin_and_as (l_as: BIN_AND_AS)
		do
			process_binary_as (l_as)
		end

	process_string_as (l_as: STRING_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.string_32_class.compiled_representation.class_id))
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.string_32_class.compiled_representation.class_id))
		end

	process_real_as (l_as: REAL_AS)
		local
			l_found_type: TYPE_A
		do
			if l_as.constant_type /= Void then
				if context_feature /= Void then
					l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.constant_type)
				else
					l_found_type := resolved_type_in_expression_type (l_as.constant_type)
				end
			else
				l_found_type := create {CL_TYPE_A}.make (system.real_64_class.compiled_representation.class_id)
			end
			update_interface (l_found_type)
		end

	process_integer_as (l_as: INTEGER_AS)
		local
			l_found_type: TYPE_A
		do
			if l_as.has_constant_type then
				if context_feature /= Void then
					l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.constant_type)
				else
					l_found_type := resolved_type_in_expression_type (l_as.constant_type)
				end
			else
				l_found_type := create {CL_TYPE_A}.make (system.integer_64_class.compiled_representation.class_id)
			end
			update_interface (l_found_type)
		end

	process_char_as (l_as: CHAR_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.character_32_class.compiled_representation.class_id))
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
		local
			l_found_type: TYPE_A
		do
			if l_as.type /= Void then
				if context_feature /= Void then
					l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.type)
				else
					l_found_type := resolved_type_in_expression_type (l_as.type)
				end
			else
				l_found_type := create {CL_TYPE_A}.make (system.character_32_class.compiled_representation.class_id)
			end
			update_interface (l_found_type)
		end

	process_bool_as (l_as: BOOL_AS)
		do
			update_interface(create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

feature {NONE} -- Call evaluation visits
	process_result_as (l_as: RESULT_AS)
		do
			update_interface(context_feature.type.instantiated_in (expression_type).deep_actual_type)
		end

	process_current_as (l_as: CURRENT_AS)
		do
			update_interface(expression_type)
		end

	process_precursor_as (l_as: PRECURSOR_AS)
		local
			l_parents_classes: FIXED_LIST[CLASS_C]
			l_precursor_feature: FEATURE_I
			l_precursor_class: CLASS_C
			i: INTEGER
		do
			l_parents_classes := expression_type.associated_class.parents_classes
			if l_as.parent_base_class /= Void then
				from
					i := 1
				until
					i > l_parents_classes.count or else l_parents_classes.i_th (i).name.is_equal (l_as.parent_base_class.class_name.name)
				loop
					i := i + 1
				end
				if i <= l_parents_classes.count then
					l_precursor_class := l_parents_classes.i_th (i)
					l_precursor_feature := l_precursor_class.feature_table.feature_of_rout_id_set (context_feature.rout_id_set)
				end
			else
				from
					i := 1
					l_precursor_feature := Void
				until
					i > l_parents_classes.count or l_precursor_feature /= Void
				loop
					l_precursor_class := l_parents_classes.i_th (i)
					l_precursor_feature := l_precursor_class.feature_table.feature_of_rout_id_set (context_feature.rout_id_set)
					i := i + 1
				end
			end

			check l_precursor_class /= Void end
			check l_precursor_feature /= Void end

			update_interface(l_precursor_feature.type.instantiation_in (expression_type, l_precursor_class.class_id))
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		do
			update_interface(type_of_qualified_query(l_as.feature_name.name))
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
		do
			update_interface(type_of_unqualified_query(l_as.feature_name.name))
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
		local
			l_found_type: TYPE_A
		do
			if context_feature /= Void then
				l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.class_type)
			else
				l_found_type := resolved_type_in_expression_type (l_as.class_type)
			end
			update_interface (l_found_type)
			safe_process(create {ACCESS_FEAT_AS}.initialize (l_as.feature_name, l_as.internal_parameters))
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			update_interface(type_of_unqualified_query(l_as.feature_name.name))
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
		do
			-- in Eiffel feature names, locals and object test locals must be distinct
			update_interface(type_of_unqualified_query(l_as.feature_name.name))
		end

feature {NONE} -- Object test context update handling visits

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			update_interface_with_object_test_context_update (create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id), l_as)
		end

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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

end -- class SCOOP_TYPE_EXPR_VISITOR
