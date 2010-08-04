note
	description: "[
					Roundtrip visitor to evaluate the type of expressions and to resolve types.
					
					Terminology:
					- The object test context maps names of object test locals to object tests.
					- The inline agent context maps inline agent entity names to their types.
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
			process_bracket_as,
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
			process_void_as,
			process_object_test_as,
			process_inline_agent_creation_as,
			process_agent_routine_creation_as
		end

	SCOOP_WORKBENCH

	SHARED_STATELESS_VISITOR

	SHARED_TYPES

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Expression and call evaluation access
	evaluate_expression_type_in_workbench (
		a_expression: EXPR_AS;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_expression' in the context given by the class and the feature indicated in the workbench, 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_expression_is_valid: a_expression /= Void
			workbench_is_valid: class_c /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
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
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	evaluate_expression_type_in_class_and_feature (
		a_expression: EXPR_AS;
		a_context_class: CLASS_C;
		a_context_feature: FEATURE_I;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_expression' in the context 'a_context_class', 'a_context_feature', 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_expression_is_valid: a_expression /= Void
			a_context_class_is_valid: a_context_class /= Void
			a_context_feature_is_valid: a_context_feature /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
		do
			object_test_context := a_object_test_context
			inline_agent_context := a_inline_agent_context
			context_feature := a_context_feature
			expression_type := implicit_generic_derivation(a_context_class)
			evaluate_expression_type (a_expression)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	evaluate_expression_type_in_class (
		a_expression: EXPR_AS;
		a_context_class: CLASS_C;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_expression' in the context 'a_context_class', 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_expression_is_valid: a_expression /= Void
			a_context_class_is_valid: a_context_class /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
		do
			object_test_context := a_object_test_context
			inline_agent_context := a_inline_agent_context
			context_feature := Void
			expression_type := implicit_generic_derivation(a_context_class)
			evaluate_expression_type (a_expression)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	evaluate_expression_type_in_type (
		a_expression: EXPR_AS;
		a_context_type: TYPE_A;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_expression' in the context 'a_context_type', 'a_context_feature', 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_expression_is_valid: a_expression /= Void
			a_context_type_is_valid: a_context_type /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
		do
			object_test_context := a_object_test_context
			inline_agent_context := a_inline_agent_context
			context_feature := Void
			expression_type := a_context_type
			evaluate_expression_type (a_expression)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	evaluate_call_type_in_workbench (
		a_call: CALL_AS;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_call' in the context given by the class and the feature indicated in the workbench, 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_call_is_valid: a_call /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_workbench (l_call_expression, a_object_test_context, a_inline_agent_context)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	evaluate_call_type_in_class_and_feature (
		a_call: CALL_AS;
		a_context_class: CLASS_C;
		a_context_feature: FEATURE_I;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_call' in the context 'a_context_class', 'a_context_feature', 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_call_is_valid: a_call /= Void
			a_context_class_is_valid: a_context_class /= Void
			a_context_feature_is_valid: a_context_feature /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_class_and_feature (l_call_expression, a_context_class, a_context_feature, a_object_test_context, a_inline_agent_context)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	evaluate_call_type_in_class (
		a_call: CALL_AS;
		a_context_class: CLASS_C;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_call' in the context 'a_context_class', 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_call_is_valid: a_call /= Void
			a_context_class_is_valid: a_context_class /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_class (l_call_expression, a_context_class, a_object_test_context, a_inline_agent_context)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	evaluate_call_type_in_type (
		a_call: CALL_AS;
		a_context_type: TYPE_A;
		a_object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING];
		a_inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
	)
			-- Evaluate the type of 'a_call' in the context 'a_context_type', 'a_context_feature', 'a_object_test_context', and 'a_inline_agent_context'.
			-- Indicate the result in 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update'.
		require
			a_call_is_valid: a_call /= Void
			a_context_type_is_valid: a_context_type /= Void
			a_object_test_context_is_valid: a_object_test_context /= Void
			a_inline_agent_context_is_valid: a_inline_agent_context /= Void
		local
			l_call_expression: EXPR_CALL_AS
		do
			create l_call_expression.initialize (a_call)
			evaluate_expression_type_in_type (l_call_expression, a_context_type, a_object_test_context, a_inline_agent_context)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	is_query: BOOLEAN
		-- Is the evaluated expression a query?

	is_expression_separate: BOOLEAN
		-- Is the evaluated expression separate?

	expression_type: TYPE_A
		-- The type of the evaluated expression.

	object_test_context_update: HASH_TABLE[OBJECT_TEST_AS, STRING]
		-- The object test locals encoutered during the evaluation of the expression.

feature -- Type resolution access
	resolve_type_in_workbench (a_type: TYPE_AS)
			-- Resolve 'a_type' in the context given by the class and the feature from the workbench.
			-- Indicate the result in 'resolved_type' and 'is_resolved_type_based_on_formal'.
		require
			a_type_is_valid: a_type /= Void
			workbench_is_valid: class_c /= Void
		local
			l_resolved_type: like resolved_type_in_context_feature_and_expression_type
		do
			if feature_as /= Void then
				context_feature := class_c.feature_table.item (feature_as.feature_name.name)
				expression_type := implicit_generic_derivation(class_c)
				l_resolved_type := resolved_type_in_context_feature_and_expression_type (a_type)
				resolved_type := l_resolved_type.resolved_type
				is_resolved_type_based_on_formal_generic_parameter := l_resolved_type.is_resolved_type_based_on_formal_generic_parameter
			else
				context_feature := Void
				expression_type := implicit_generic_derivation(class_c)
				l_resolved_type := resolved_type_in_expression_type (a_type)
				resolved_type := l_resolved_type.resolved_type
				is_resolved_type_based_on_formal_generic_parameter := l_resolved_type.is_resolved_type_based_on_formal_generic_parameter
			end
		ensure
			result_is_valid: resolved_type /= Void and (is_resolved_type_based_on_formal_generic_parameter or not is_resolved_type_based_on_formal_generic_parameter)
		end

	resolve_type_in_class_and_feature (a_type: TYPE_AS; a_context_class: CLASS_C; a_context_feature: FEATURE_I)
			-- Resolve 'a_type' in the context given by 'a_context_class' and 'a_context_feature'.
			-- Indicate the result in 'resolved_type' and 'is_resolved_type_based_on_formal'.
		require
			a_type_is_valid: a_type /= Void
			a_context_class_is_valid: a_context_class /= Void
			a_context_feature_is_valid: a_context_feature /= Void
		local
			l_resolved_type: like resolved_type_in_context_feature_and_expression_type
		do
			context_feature := a_context_feature
			expression_type := implicit_generic_derivation(a_context_class)
			l_resolved_type := resolved_type_in_context_feature_and_expression_type (a_type)
			resolved_type := l_resolved_type.resolved_type
			is_resolved_type_based_on_formal_generic_parameter := l_resolved_type.is_resolved_type_based_on_formal_generic_parameter
		ensure
			result_is_valid: resolved_type /= Void and (is_resolved_type_based_on_formal_generic_parameter or not is_resolved_type_based_on_formal_generic_parameter)
		end

	resolve_type_in_class (a_type: TYPE_AS; a_context_class: CLASS_C)
			-- Resolve 'a_type' in the context given by 'a_context_class'.
			-- Indicate the result in 'resolved_type' and 'is_resolved_type_based_on_formal'.
		require
			a_type_is_valid: a_type /= Void
			a_context_class_is_valid: a_context_class /= Void
		local
			l_resolved_type: like resolved_type_in_context_feature_and_expression_type
		do
			context_feature := Void
			expression_type := implicit_generic_derivation(a_context_class)
			l_resolved_type := resolved_type_in_expression_type (a_type)
			resolved_type := l_resolved_type.resolved_type
			is_resolved_type_based_on_formal_generic_parameter := l_resolved_type.is_resolved_type_based_on_formal_generic_parameter
		ensure
			result_is_valid: resolved_type /= Void and (is_resolved_type_based_on_formal_generic_parameter or not is_resolved_type_based_on_formal_generic_parameter)
		end

	resolve_type_in_type (a_type: TYPE_AS; a_context_type: TYPE_A)
			-- Resolve 'a_type' in the context given by 'a_context_type'.
			-- Indicate the result in 'resolved_type' and 'is_resolved_type_based_on_formal'.
		require
			a_type_is_valid: a_type /= Void
			a_context_type_is_valid: a_context_type /= Void
		local
			l_resolved_type: like resolved_type_in_context_feature_and_expression_type
		do
			context_feature := Void
			expression_type := a_context_type
			l_resolved_type := resolved_type_in_expression_type (a_type)
			resolved_type := l_resolved_type.resolved_type
			is_resolved_type_based_on_formal_generic_parameter := l_resolved_type.is_resolved_type_based_on_formal_generic_parameter
		ensure
			result_is_valid: resolved_type /= Void and (is_resolved_type_based_on_formal_generic_parameter or not is_resolved_type_based_on_formal_generic_parameter)
		end

	resolved_type: TYPE_A
		-- The resolved type.

	is_resolved_type_based_on_formal_generic_parameter: BOOLEAN
		-- Is the resolved type based on a formal generic parameter?

feature {NONE} -- Expression and call evaluation implementation
	evaluate_expression_type (a_expression: EXPR_AS)
			-- Evaluate the type of 'a_expression' in the context given by 'expression_type'.
			-- Indicate the result in 'expression_type'.
		require
			a_expression_is_valid: a_expression /= Void
			expression_type_is_valid: expression_type /= Void
		do
			is_query := False
			is_expression_separate := False
			create object_test_context_update.make (10)
			safe_process (a_expression)
		ensure
			result_is_valid: is_query implies (expression_type /= Void and object_test_context_update /= Void)
		end

	implicit_generic_derivation (a_class: CLASS_C): TYPE_A
			-- The implicit generation derivation of 'a_class'.
			-- If 'a_class' is not generic then the implicit generic derivation is the class type.
			-- If 'a_class' is generic then the implicit generic derivation is the generic derivation of 'a_class' where each formal generic parameter is replaced with either the constraint if available or the supertype of the type system.
		require
			a_class_is_valid: a_class /= Void
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
		ensure
			result_is_valid: Result /= Void
		end

	context_feature: FEATURE_I
		--	The feature context.

	object_test_context: HASH_TABLE[OBJECT_TEST_AS, STRING]
		-- The object test context.

	inline_agent_context: HASH_TABLE[TYPE_AS, STRING]
		-- The inline agent context.

	update_interface (a_found_type: TYPE_A)
			-- Update 'is_query', 'is_expression_separate', and 'expression_type' with 'a_found_type' based on 'expression_type'.
			-- The object test context update remains unchanged.
			-- The result type combiner is used to determine the separateness of the expression up until 'a_found_type'.
		require
			expression_type_is_valid: expression_type /= Void
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
		ensure
			interface_is_updated:
				(a_found_type = Void implies not is_query) and
				(a_found_type /= Void implies is_query) and
				(is_query implies expression_type /= Void) and
				(not is_query implies expression_type = Void) and
				(object_test_context_update.count = old object_test_context_update.count)
		end

	update_interface_with_object_test_context_update (a_found_type: TYPE_A; a_object_test_context_update: OBJECT_TEST_AS)
			-- Update 'is_query', 'is_expression_separate', 'expression_type', and 'object_test_context_update' with 'a_found_type' based on 'expression_type'.
			-- The result type combiner is used to determine the separateness of the expression up until 'a_found_type'.
		require
			expression_type_is_valid: expression_type /= Void
			a_object_test_context_update_is_valid: a_object_test_context_update /= Void
		do
			update_interface (a_found_type)
			if a_object_test_context_update.name /= Void then
				object_test_context_update.put (a_object_test_context_update, a_object_test_context_update.name.name)
			end
		ensure
			interface_is_updated:
				(a_found_type = Void implies not is_query) and
				(a_found_type /= Void implies is_query) and
				(is_query implies expression_type /= Void) and
				(not is_query implies expression_type = Void) and
				(object_test_context_update.count /= old object_test_context_update.count)
		end

	type_of_qualified_query (a_name: STRING): TYPE_A
			-- The type of a qualified call with name 'a_name' on a target of type 'expression_type', if it can be found. The void reference otherwise.
		require
			a_name_is_valid: a_name /= Void
			expression_type_is_valid: expression_type /= Void
		local
			i: INTEGER
			l_found_type: TYPE_A
		do
			l_found_type := Void

			-- Try to resolve the call using the feature table.
			if expression_type.associated_class.feature_table.has (a_name) then
				l_found_type := expression_type.associated_class.feature_table.item (a_name).type
			elseif expression_type.associated_class.feature_table.is_mangled_alias_name (a_name) then
				l_found_type := expression_type.associated_class.feature_table.alias_item (a_name).type
			end

			-- Try to resolve the call as a tuple field.
			if l_found_type = Void and attached {NAMED_TUPLE_TYPE_A} expression_type as l_expression_type_as_named_tuple then
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

			-- Evaluate the result.
			if l_found_type /= Void then
				Result := l_found_type.instantiated_in (expression_type).deep_actual_type
			else
				Result := Void
			end
		end

	type_of_unqualified_query (a_name: STRING): TYPE_A
			-- The type of an unqualified call with name 'a_name' in the context of 'expression_type' and 'context_feature' if it can be found. The void reference otherwise.
		require
			a_name_is_valid: a_name /= Void
			expression_type_is_valid: expression_type /= Void
		local
			i, j: INTEGER
			l_locals: EIFFEL_LIST [TYPE_DEC_AS]
			l_locals_group: TYPE_DEC_AS
			l_formal_arguments_group: TYPE_DEC_AS
			l_formal_arguments: EIFFEL_LIST [TYPE_DEC_AS]
			l_type_expr_visitor: like Current
		do
			Result := Void

			-- Try to resolve the call on an entity of the context feature, if available.
			if context_feature /= Void then
				-- Note: The local type can not be anchored on another local type and the formal argument type can not be anchored on a local type.
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
								Result := resolved_type_in_context_feature_and_expression_type (l_formal_arguments_group.type).resolved_type
							end
							j := j + 1
						end
						i := i + 1
					end
				end

				if Result = Void and attached {ROUTINE_AS} context_feature.body.body.content as l_routine and then l_routine.locals /= Void then
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
								Result := resolved_type_in_context_feature_and_expression_type (l_locals_group.type).resolved_type
							end
							j := j + 1
						end
						i := i + 1
					end
				end
			end

			-- Try to resolve the call on a target in the object test context. Note that the object test context update does not matter for unqualified calls. The object test context update only matters for qualified calls.
			if Result = Void and object_test_context.has (a_name) then
				if object_test_context.item (a_name).type /= Void then
					Result := resolved_type_in_context_feature_and_expression_type (object_test_context.item (a_name).type).resolved_type
				else
					l_type_expr_visitor := scoop_visitor_factory.new_type_expr_visitor
					l_type_expr_visitor.evaluate_expression_type_in_workbench (object_test_context.item (a_name).expression, object_test_context, inline_agent_context)
					Result := l_type_expr_visitor.expression_type
				end
			end

			-- Try to resolve the call on a target in the inline agent context.
			if Result = Void and inline_agent_context.has (a_name) then
				Result := resolved_type_in_context_feature_and_expression_type (inline_agent_context.item (a_name)).resolved_type
			end

			-- Try to resolve the call on a target of type 'expression_type'.
			if Result = Void then
				if expression_type.associated_class.feature_table.has (a_name) then
					Result := expression_type.associated_class.feature_table.item (a_name).type.instantiated_in (expression_type).deep_actual_type
				elseif expression_type.associated_class.feature_table.is_mangled_alias_name (a_name) then
					Result := expression_type.associated_class.feature_table.alias_item (a_name).type.instantiated_in (expression_type).deep_actual_type
				end
			end
		end

feature {NONE} -- Type resolution implementation
	resolved_type_in_context_feature_and_expression_type (a_type: TYPE_AS): TUPLE[resolved_type: TYPE_A; is_resolved_type_based_on_formal_generic_parameter: BOOLEAN]
			-- The resolved version of 'a_type' in the context given by 'expression_type' and 'context_feature'.
		require
			a_type_is_valid: a_type /= Void
			expression_type_is_valid: expression_type /= Void
			context_feature_is_valid: context_feature /= Void
		local
			l_resolved_type: TYPE_A
		do
			type_a_checker.init_for_checking (context_feature, expression_type.associated_class, Void, Void)
			l_resolved_type := type_a_checker.solved (
				type_a_generator.evaluate_type (a_type, expression_type.associated_class),
				a_type
			).deep_actual_type.instantiated_in (expression_type).deep_actual_type

			Result := [
				l_resolved_type,
				is_type_based_on_formal_generic_parameter (a_type)
			]
		ensure
			result_is_valid: Result /= Void
		end

	resolved_type_in_expression_type (a_type: TYPE_AS): like resolved_type_in_context_feature_and_expression_type
			-- The resolved version of 'a_type' in the context given by 'expression_type'.
		require
			a_type_is_valid: a_type /= Void
			expression_type_is_valid: expression_type /= Void
		local
			l_resolved_type: TYPE_A
		do
			-- As a context feature we use the default create feauture from 'ANY' because it is empty.
			type_a_checker.init_for_checking (system.any_class.compiled_class.default_create_feature, expression_type.associated_class, Void, Void)
			l_resolved_type := type_a_checker.solved (
				type_a_generator.evaluate_type (a_type, expression_type.associated_class),
				a_type
			).deep_actual_type.instantiated_in(expression_type).deep_actual_type

			Result := [
				l_resolved_type,
				is_type_based_on_formal_generic_parameter (a_type)
			]
		ensure
			result_is_valid: Result /= Void
		end

	is_type_based_on_formal_generic_parameter (a_type: TYPE_AS): BOOLEAN
			-- Is 'a_type' based on a formal generic parameter?
		local
			l_current_type: TYPE_AS
			l_current_class: CLASS_C
			l_current_feature: FEATURE_I
			l_result_found: BOOLEAN
			l_formal_arguments_group: TYPE_DEC_AS
			l_formal_arguments: EIFFEL_LIST [TYPE_DEC_AS]
			i, j: INTEGER
		do
			-- If 'a_type' is anchored then find the deanchored type and check whether it is a formal generic parameter.
			-- If 'a_type' is not anchored then check whether it is a formal generic parameter.
			from
				-- Start with 'a_type' as a current type and the context given by 'expression_type' and 'context_feature'.
				l_current_type := a_type
				l_current_class := expression_type.associated_class
				l_current_feature := context_feature
				l_result_found := false
			until
				l_result_found
			loop
				-- Check the nature of the current type.
				if attached {FORMAL_AS} l_current_type then
					-- The current type is a formal generic parameter.
					Result := true
					l_result_found := true
				elseif attached {LIKE_ID_AS} l_current_type as l_anchored_type then
					-- The current type is a anchored type.
					-- Find the deanchored form of the type. It could be an anchored type again.

					-- Check the feature table of the current class to find the anchor.
					if l_current_class.feature_table.has (l_anchored_type.anchor.name) then
						l_current_type := l_current_class.feature_table.item (l_anchored_type.anchor.name).body.body.type
						l_current_class := l_current_class.feature_table.item (l_anchored_type.anchor.name).written_class
						l_current_feature := void
					elseif l_current_class.feature_table.is_mangled_alias_name (l_anchored_type.anchor.name) then
						l_current_type := l_current_class.feature_table.alias_item (l_anchored_type.anchor.name).body.body.type
						l_current_class := l_current_class.feature_table.alias_item (l_anchored_type.anchor.name).written_class
						l_current_feature := void
					-- Check the current feature, if it exists, to find the anchor.
					elseif l_current_feature /= void then
						-- Note: The local type can not be anchored on another local type and the formal argument type can not be anchored on a local type.
						from
							l_formal_arguments := l_current_feature.body.body.arguments
							i := 1
						until
							i > l_formal_arguments.count
						loop
							l_formal_arguments_group := l_formal_arguments.i_th (i)
							from
								j := 1
							until
								j > l_formal_arguments_group.id_list.count
							loop
								if l_formal_arguments_group.item_name (j).is_equal (l_anchored_type.anchor.name) then
									l_current_type := l_formal_arguments_group.type
									l_current_class := l_current_class
									l_current_feature := l_current_feature
								end
								j := j + 1
							end
							i := i + 1
						end
					else
						-- This case shouldn't occur.
						check false end
					end
				elseif attached {LIKE_CUR_AS} l_current_type then
					-- The current type is anchored to the current object.
					Result := false
					l_result_found := true
				else
					-- The current type is not anchored and not a formal generic parameter.
					Result := false
					l_result_found := true
				end
			end
		end

feature {NONE} -- Expression evaluation visits
	process_inline_agent_creation_as  (l_as: INLINE_AGENT_CREATION_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface (
				derived_agent_type (l_as.target, l_as.body, l_as.operands)
			)
		end


	process_agent_routine_creation_as (l_as: AGENT_ROUTINE_CREATION_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface (
				derived_agent_type (
					l_as.target,
					system.classes.at (l_as.class_id).feature_table.item (l_as.feature_name.name).body.body,
					l_as.operands
				)
			)
		end

	derived_agent_type (a_target: OPERAND_AS; a_body: BODY_AS; a_operands: EIFFEL_LIST[OPERAND_AS]): TYPE_A
			-- The type of an agent with 'a_target', 'a_body', and 'a_operands'. For inline agents, 'a_target' can be void. For inline agents, the target is always the current object. `a_operands' can be void, all arguments are open.
		local
			i, j, k: INTEGER
			l_base_type: TYPE_AS
			l_open_types: GENERIC_CLASS_TYPE_AS
			l_open_types_tuple_parameters: TYPE_LIST_AS
			l_is_agent_a_query: BOOLEAN
			l_is_agent_a_function: BOOLEAN
			l_result_type: TYPE_AS
			l_agent_type_actual_generics: TYPE_LIST_AS
			l_agent_type: GENERIC_CLASS_TYPE_AS
		do
			-- Evaluate the base type of the routine.
			l_base_type := create {CLASS_TYPE_AS}.initialize (create {ID_AS}.initialize (system.any_class.name))

			-- Evaluate the open types of the routine.
			create l_open_types_tuple_parameters.make (0)
			-- Add the target type to the open types tuple parameters, if the target is open.
			if a_target /= void and then a_target.is_open then
				l_open_types_tuple_parameters.extend (a_target.class_type)
			end
			-- Add the open argument types to the open types tuple parameters.
			from
				i := 1
				k := 1
			until
				i > a_body.arguments.count
			loop
				from
					j := 1
				until
					j > a_body.arguments.i_th (i).id_list.count
				loop
					if a_operands = void or else a_operands.i_th (k).is_open then
						l_open_types_tuple_parameters.extend (a_body.arguments.i_th (i).type)
					end
					k := k + 1
					j := j + 1
				end
				i := i + 1
			end
			create l_open_types.initialize (
				create {ID_AS}.initialize (system.tuple_class.name),
				l_open_types_tuple_parameters
			)

			-- Evaluate the result type of the routine, if it is a function.
			if
				a_body.type /= Void
			then
				l_is_agent_a_query := true

				if not type_a_generator.evaluate_type (a_body.type, expression_type.associated_class)
					.same_as (system.boolean_class.compiled_class.actual_type)
				then
					l_is_agent_a_function := true
					l_result_type := a_body.type
				else
					l_is_agent_a_function := false
					l_result_type := void
				end
			else
				l_is_agent_a_query := false
				l_is_agent_a_function := false
				l_result_type := void
			end

			-- Create the inline agent type actual generics.
			if l_is_agent_a_query then
				if l_is_agent_a_function then
					create l_agent_type_actual_generics.make (0)
					l_agent_type_actual_generics.extend (l_base_type)
					l_agent_type_actual_generics.extend (l_open_types)
					l_agent_type_actual_generics.extend (l_result_type)
				else
					create l_agent_type_actual_generics.make (0)
					l_agent_type_actual_generics.extend (l_base_type)
					l_agent_type_actual_generics.extend (l_open_types)
				end
			else
				create l_agent_type_actual_generics.make (0)
				l_agent_type_actual_generics.extend (l_base_type)
				l_agent_type_actual_generics.extend (l_open_types)
			end

			-- Create the inline agent type.
			if l_is_agent_a_query then
				if l_is_agent_a_function then
					 create l_agent_type.initialize (
					 	create {ID_AS}.initialize (system.function_class.name),
					 	l_agent_type_actual_generics
					 )
				else
					 create l_agent_type.initialize (
					 	create {ID_AS}.initialize (system.predicate_class.name),
					 	l_agent_type_actual_generics
					 )
				end
			else
				 create l_agent_type.initialize (
				 	create {ID_AS}.initialize (system.procedure_class.name),
				 	l_agent_type_actual_generics
				 )
			end

			-- Resolve the type.
			if context_feature /= Void then
				Result := resolved_type_in_context_feature_and_expression_type (l_agent_type).resolved_type
			else
				Result := resolved_type_in_expression_type (l_agent_type).resolved_type
			end
		end

	process_bracket_as (l_as: BRACKET_AS)
			-- Update the interface with 'l_as'.
		do
			-- For bracket expressions we can ignore the operands as we are only interested in the type of the bracket operand.
			safe_process (l_as.target)
			update_interface(type_of_qualified_query({SYNTAX_STRINGS}.bracket_str))
		end

	process_address_as (l_as: ADDRESS_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface (create {CL_TYPE_A}.make (system.pointer_class.compiled_representation.class_id))
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
			-- Update the interface with 'l_as'.
		local
			l_found_type: TYPE_A
		do
			if context_feature /= Void then
				l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.type).resolved_type
			else
				l_found_type := resolved_type_in_expression_type (l_as.type).resolved_type
			end
			update_interface (l_found_type)
		end

	process_bang_creation_expr_as (l_as: BANG_CREATION_EXPR_AS)
			-- Update the interface with 'l_as'.
		local
			l_found_type: TYPE_A
		do
			if context_feature /= Void then
				l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.type).resolved_type
			else
				l_found_type := resolved_type_in_expression_type (l_as.type).resolved_type
			end
			update_interface (l_found_type)
		end

	process_bin_lt_as (l_as: BIN_LT_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_le_as (l_as: BIN_LE_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_gt_as (l_as: BIN_GT_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_ge_as (l_as: BIN_GE_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_xor_as (l_as: BIN_XOR_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_or_else_as (l_as: BIN_OR_ELSE_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_or_as (l_as: BIN_OR_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_implies_as (l_as: BIN_IMPLIES_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_free_as (l_as: BIN_FREE_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_eq_as (l_as: BIN_EQ_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface (create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_bin_tilde_as (l_as: BIN_TILDE_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface (create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_bin_not_tilde_as (l_as: BIN_NOT_TILDE_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface (create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_bin_ne_as (l_as: BIN_NE_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface (create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_binary_as (l_as: BINARY_AS)
			-- Update the interface with 'l_as'.
		do
			safe_process (l_as.left)

			update_interface(type_of_qualified_query(l_as.infix_function_name))
		end

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_bin_and_as (l_as: BIN_AND_AS)
			-- Update the interface with 'l_as'.
		do
			process_binary_as (l_as)
		end

	process_string_as (l_as: STRING_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(create {CL_TYPE_A}.make (system.string_32_class.compiled_representation.class_id))
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(create {CL_TYPE_A}.make (system.string_32_class.compiled_representation.class_id))
		end

	process_real_as (l_as: REAL_AS)
			-- Update the interface with 'l_as'.
		local
			l_found_type: TYPE_A
		do
			if l_as.constant_type /= Void then
				if context_feature /= Void then
					l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.constant_type).resolved_type
				else
					l_found_type := resolved_type_in_expression_type (l_as.constant_type).resolved_type
				end
			else
				l_found_type := create {CL_TYPE_A}.make (system.real_64_class.compiled_representation.class_id)
			end
			update_interface (l_found_type)
		end

	process_integer_as (l_as: INTEGER_AS)
			-- Update the interface with 'l_as'.
		local
			l_found_type: TYPE_A
		do
			if l_as.has_constant_type then
				if context_feature /= Void then
					l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.constant_type).resolved_type
				else
					l_found_type := resolved_type_in_expression_type (l_as.constant_type).resolved_type
				end
			else
				l_found_type := create {CL_TYPE_A}.make (system.integer_64_class.compiled_representation.class_id)
			end
			update_interface (l_found_type)
		end

	process_char_as (l_as: CHAR_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(create {CL_TYPE_A}.make (system.character_32_class.compiled_representation.class_id))
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS)
			-- Update the interface with 'l_as'.
		local
			l_found_type: TYPE_A
		do
			if l_as.type /= Void then
				if context_feature /= Void then
					l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.type).resolved_type
				else
					l_found_type := resolved_type_in_expression_type (l_as.type).resolved_type
				end
			else
				l_found_type := create {CL_TYPE_A}.make (system.character_32_class.compiled_representation.class_id)
			end
			update_interface (l_found_type)
		end

	process_bool_as (l_as: BOOL_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id))
		end

	process_void_as (l_as: VOID_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(none_type)
		end

feature {NONE} -- Call evaluation visits
	process_result_as (l_as: RESULT_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(context_feature.type.instantiated_in (expression_type).deep_actual_type)
		end

	process_current_as (l_as: CURRENT_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(expression_type)
		end

	process_precursor_as (l_as: PRECURSOR_AS)
			-- Update the interface with 'l_as'.
		local
			l_parents_classes: FIXED_LIST[CLASS_C]
			l_precursor_feature: FEATURE_I
			l_precursor_class: CLASS_C
			i: INTEGER
		do
			-- Find the precursor feature and take its result type.
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

			-- Update the interface with the result type.
			update_interface(l_precursor_feature.type.instantiation_in (expression_type, l_precursor_class.class_id))
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(type_of_qualified_query(l_as.feature_name.name))
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(type_of_unqualified_query(l_as.feature_name.name))
		end

	process_static_access_as (l_as: STATIC_ACCESS_AS)
			-- Update the interface with 'l_as'.
		local
			l_found_type: TYPE_A
		do
			if context_feature /= Void then
				l_found_type := resolved_type_in_context_feature_and_expression_type (l_as.class_type).resolved_type
			else
				l_found_type := resolved_type_in_expression_type (l_as.class_type).resolved_type
			end
			update_interface (l_found_type)
			safe_process(create {ACCESS_FEAT_AS}.initialize (l_as.feature_name, l_as.internal_parameters))
		end

	process_access_inv_as (l_as: ACCESS_INV_AS)
		do
			update_interface(type_of_unqualified_query(l_as.feature_name.name))
		end

	process_access_id_as (l_as: ACCESS_ID_AS)
			-- Update the interface with 'l_as'.
		do
			update_interface(type_of_unqualified_query(l_as.feature_name.name))
		end

feature {NONE} -- Object test context update handling visits

	process_object_test_as (l_as: OBJECT_TEST_AS)
			-- Update the interface with 'l_as'. This includes the object test context update.
		do
			update_interface_with_object_test_context_update (create {CL_TYPE_A}.make (system.boolean_class.compiled_representation.class_id), l_as)
		end

note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_TYPE_EXPR_VISITOR
