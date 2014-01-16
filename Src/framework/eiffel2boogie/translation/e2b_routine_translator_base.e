note
	description: "[
		Base class for routine translators.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_ROUTINE_TRANSLATOR_BASE

inherit

	E2B_FEATURE_TRANSLATOR

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Access

	current_feature: FEATURE_I
			-- Currently translated feature.

	current_type: TYPE_A
			-- Type of currently translated feature.

	current_boogie_procedure: detachable IV_PROCEDURE
			-- Currently generated Boogie procedure (if any).

feature -- Element change

	set_context (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Set context of current translation.
		do
			current_feature := a_feature
			if a_type.is_attached then
				current_type := a_type
			else
				current_type := a_type.as_attached_type
			end
		ensure
			current_feature_set: current_feature = a_feature
			current_type_set: current_type.same_as (a_type.as_attached_type)
		end

	set_up_boogie_procedure (a_boogie_name: STRING)
			-- Set up `current_boogie_procedure'.
		do
			current_boogie_procedure := boogie_universe.procedure_named (a_boogie_name)
			if not attached current_boogie_procedure then
				create current_boogie_procedure.make (a_boogie_name)
				boogie_universe.add_declaration (current_boogie_procedure)
			end
		ensure
			current_boogie_procedure_set: attached current_boogie_procedure
			current_boogie_procedure_named: current_boogie_procedure.name ~ a_boogie_name
			current_boogie_procedure_added: boogie_universe.procedure_named (a_boogie_name) = current_boogie_procedure
		end

feature -- Helper functions: arguments and result

	arguments_of (a_feature: FEATURE_I; a_context: TYPE_A): ARRAYED_LIST [TUPLE [name: STRING; type: TYPE_A; boogie_type: IV_TYPE]]
			-- List of feature arguments of `a_feature'.
		require
			a_feature_attached: attached a_feature
			a_context_attached: attached a_context
		local
			i: INTEGER
			l_type: TYPE_A
		do
			create Result.make (a_feature.argument_count)
			from i := 1 until i > a_feature.argument_count loop
				l_type := a_feature.arguments.i_th (i).deep_actual_type.instantiated_in (a_context)
				Result.extend([
					a_feature.arguments.item_name (i),
					l_type,
					types.for_type_a (l_type)
				])
				i := i + 1
			end
		end

	arguments_of_current_feature: like arguments_of
			-- List of arguments of `current_feature'.
		require
			current_feature_set: attached current_feature
			current_type_set: attached current_type
		do
			Result := arguments_of (current_feature, current_type)
		end

	add_argument_with_property (a_name: STRING; a_type: TYPE_A; a_boogie_type: IV_TYPE)
			-- Add argument and property to current procedure.
		require
			current_procedure_set: attached current_boogie_procedure
		local
			l_pre: IV_PRECONDITION
		do
			current_boogie_procedure.add_argument (a_name, a_boogie_type)
			create l_pre.make (type_property (factory.entity (a_name, a_boogie_type), a_type))
			l_pre.set_free
			l_pre.node_info.set_attribute ("info", "type property for argument " + a_name)
			current_boogie_procedure.add_contract (l_pre)
			translation_pool.add_type (a_type.deep_actual_type.instantiated_in (current_type))
		end

	add_result_with_property
			-- Add result to current procedure.
		local
			l_type: TYPE_A
			l_iv_type: IV_TYPE
		do
			if current_feature.has_return_value then
				l_type := current_feature.type.deep_actual_type.instantiated_in (current_type)
				l_iv_type := types.for_type_a (l_type)
				translation_pool.add_type (l_type)
				current_boogie_procedure.add_result_with_property (
					"Result",
					l_iv_type,
					type_property (factory.entity ("Result", l_iv_type), l_type))
			end
		end

	type_property (a_arg: IV_EXPRESSION; a_type: TYPE_A): IV_EXPRESSION
			-- Type property about `a_arg' of `a_type'.
		do
			if attached {FORMAL_A} a_type as f then
				Result := types.type_property (f.constraint (current_type.base_class), factory.global_heap, a_arg)
			else
				Result := types.type_property (a_type, factory.global_heap, a_arg)
			end
		end

feature -- Helper functions: contracts

	contracts_of (a_feature: FEATURE_I; a_type: TYPE_A): TUPLE [pre, post, modifies, reads, decreases: LIST [ASSERT_B]; pre_origin, post_origin: LIST [CLASS_C]]
			-- Contracts for feature `a_feature' of type `a_type' separated into preconditions, postconiditons, modify clauses, read clauses, and decreases clauses;
			-- For pre and postconditions, also their origin type is recorded.
		local
			l_pre, l_post, l_modifies, l_reads, l_decreases: LINKED_LIST [ASSERT_B]
			l_pre_origin, l_post_origin: LINKED_LIST [CLASS_C]
			l_class: CLASS_C
			l_name: STRING_32
		do
			create l_pre.make
			create l_post.make
			create l_modifies.make
			create l_reads.make
			create l_decreases.make
			create l_pre_origin.make
			create l_post_origin.make

			helper.set_up_byte_context (a_feature, a_type)
			if attached Context.byte_code as l_byte_code then
					-- Process pre/post-conditions
				l_class := a_feature.written_class
				if l_byte_code.precondition /= Void then
					across l_byte_code.precondition as p loop
						l_pre.extend (p.item)
						l_pre_origin.extend (l_class)
					end
				end
				if l_byte_code.postcondition /= Void then
					across l_byte_code.postcondition as p loop
						l_post.extend (p.item)
						l_post_origin.extend (l_class)
					end
				end
				if a_feature.assert_id_set /= Void and not a_type.is_basic then
						-- Feature has inherited assertions
					l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
					across Context.inherited_assertion.precondition_list as i loop
						l_class := Context.inherited_assertion.precondition_types [i.target_index].type.base_class
						across i.item as p loop
							l_pre.extend (p.item)
							l_pre_origin.extend (l_class)
						end
					end
					across Context.inherited_assertion.postcondition_list as i loop
						l_class := Context.inherited_assertion.postcondition_types [i.target_index].type.base_class
						across i.item as p loop
							l_post.extend (p.item)
							l_post_origin.extend (l_class)
						end
					end
				end
			end
			from
				l_pre.start
				l_pre_origin.start
			until
				l_pre.after
			loop
				if helper.is_clause_reads (l_pre.item) then
					l_reads.extend (l_pre.item)
					l_pre.remove
					l_pre_origin.remove
				elseif helper.is_clause_modify (l_pre.item) then
					l_modifies.extend (l_pre.item)
					l_pre.remove
					l_pre_origin.remove
				elseif helper.is_clause_decreases (l_pre.item) then
					l_decreases.extend (l_pre.item)
					l_pre.remove
					l_pre_origin.remove
				else
					l_pre.forth
					l_pre_origin.forth
				end
			end
			from
				l_post.start
			until
				l_post.after
			loop
				if helper.is_clause_reads (l_post.item) then
					helper.add_semantic_warning (a_feature, messages.invalid_context_for_special_predicate ("Read"), l_post.item.line_number)
					l_post.remove
					l_post_origin.remove
				elseif helper.is_clause_modify (l_post.item) then
					helper.add_semantic_warning (a_feature, messages.invalid_context_for_special_predicate ("Modify"), l_post.item.line_number)
					l_post.remove
					l_post_origin.remove
				elseif helper.is_clause_decreases (l_post.item) then
					helper.add_semantic_warning (a_feature, messages.invalid_context_for_special_predicate ("Decrease"), l_post.item.line_number)
					l_post.remove
					l_post_origin.remove
				else
					l_post.forth
					l_post_origin.forth
				end
			end
			Result := [l_pre, l_post, l_modifies, l_reads, l_decreases, l_pre_origin, l_post_origin]
		ensure
			pre_same_count: Result.pre.count = Result.pre_origin.count
			post_same_count: Result.post.count = Result.post_origin.count
		end

	contracts_of_current_feature: like contracts_of
			-- Contracts for `current_feature'.
		do
			Result := contracts_of (current_feature, current_type)
		end

	pre_post_expressions_of (a_feature: FEATURE_I; a_type: TYPE_A; a_mapping: E2B_ENTITY_MAPPING): TUPLE [pre: IV_EXPRESSION; post: IV_EXPRESSION]
			-- Contracts for feature `a_feature' of type `a_type' as expressions.
		local
			l_contracts: like contracts_of
			l_pre: IV_EXPRESSION
			l_post: IV_EXPRESSION
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			l_contracts := contracts_of (a_feature, a_type)

			create l_translator.make
			l_translator.set_context (a_feature, a_type)
			l_translator.copy_entity_mapping (a_mapping)

			l_pre := factory.true_
			across l_contracts.pre as c loop
				l_translator.set_origin_class (l_contracts.pre_origin [c.target_index])
				c.item.process (l_translator)
				l_pre := factory.and_clean (l_pre, l_translator.last_expression)
			end
			l_post := factory.true_
			across l_contracts.post as c loop
				l_translator.set_origin_class (l_contracts.post_origin [c.target_index])
				c.item.process (l_translator)
				l_post := factory.and_clean (l_post, l_translator.last_expression)
			end
			Result := [l_pre, l_post]
		end

	modifies_expressions_of (a_clauses: LIST [ASSERT_B]; a_translator: E2B_EXPRESSION_TRANSLATOR): TUPLE [fully_modified: LIST [IV_EXPRESSION]; part_modified: LIST [TUPLE [fields: LIST [IV_ENTITY]; objects: LIST [IV_EXPRESSION]]]]
			-- List of fully modified and partially modified objects extracted from modifies clauses `a_clauses'.
		local
			l_fully_modified: LINKED_LIST [IV_EXPRESSION]
			l_part_modified: LINKED_LIST [TUPLE [LINKED_LIST [IV_ENTITY], LINKED_LIST [IV_EXPRESSION]]]
			l_fieldnames: LINKED_LIST [STRING_32]
			l_fields: LINKED_LIST [IV_ENTITY]
			l_objects_type: like translate_contained_expressions
			l_name: STRING_32
			l_type: TYPE_A
			l_feature, l_to_set: FEATURE_I
			l_boogie_type: IV_TYPE
			l_field: IV_ENTITY
		do
			create l_fully_modified.make
			create l_part_modified.make

			across
				a_clauses as i
			loop
				if attached {FEATURE_B} i.item.expr as l_call then
					l_name := names_heap.item_32 (l_call.feature_name_id)
					if l_name ~ "modify" then
						l_objects_type := translate_contained_expressions (l_call.parameters.i_th (1).expression, a_translator, True)
						l_fully_modified.append (l_objects_type.expressions)
					elseif l_name ~ "modify_field" then
						l_objects_type := translate_contained_expressions (l_call.parameters.i_th (2).expression, a_translator, True)

						if l_objects_type.expressions.first = Void then
							-- Empty set
							l_fully_modified.append (l_objects_type.expressions)
						else
							l_type := l_objects_type.type
							if l_type.is_like_current then
								l_type := current_type
							else
								l_type := l_type.deep_actual_type
							end

							create l_fieldnames.make
							if attached {STRING_B} l_call.parameters.i_th (1).expression as l_string then
								l_fieldnames.extend (l_string.value)
							elseif attached {TUPLE_CONST_B} l_call.parameters.i_th (1).expression as l_tuple then
								across l_tuple.expressions as j loop
									if attached {STRING_B} j.item as l_string then
										l_fieldnames.extend (l_string.value)
									else
										helper.add_semantic_error (current_feature, messages.first_argument_string_or_tuple, i.item.line_number)
									end
								end
							else
								helper.add_semantic_error (current_feature, messages.first_argument_string_or_tuple, i.item.line_number)
							end

							create l_fields.make
							l_fields.compare_objects
							across l_fieldnames as f loop
								l_field := (create {E2B_CUSTOM_OWNERSHIP_HANDLER}).field_from_string (f.item, l_type, current_feature, i.item.line_number)
								if attached l_field then
									l_fields.extend (l_field)
								end
							end

							l_part_modified.extend ([l_fields, l_objects_type.expressions])
						end
					else
						check internal_error: False end
					end
				else
					check internal_error: False end
				end
			end

			Result := [l_fully_modified, l_part_modified]
		end

	frame_definition (a_mods: like modifies_expressions_of; a_lhs: IV_EXPRESSION): IV_FORALL
			-- Expression that claims that `a_lhs' is the frame encoded in `a_mods'
			-- (forall o, f :: a_lhs[o, f] <==> is_partially_modifiable[o, f] || is_fully_modifiable[o])
		local
			l_expr, l_disjunct, l_o_conjunct, l_f_conjunct: IV_EXPRESSION
			l_type_var: IV_VAR_TYPE
			l_o, l_f: IV_ENTITY
			l_access: IV_MAP_ACCESS
		do
			create l_type_var.make_fresh
			create l_o.make ("$o", types.ref)
			create l_f.make ("$f", types.field (l_type_var))
			create l_access.make (a_lhs, << l_o, l_f >>)
			l_expr := factory.false_

				-- Axiom rhs: a big disjunction
				-- First go over partially modifiable objects
			across a_mods.part_modified as restiction loop
				l_o_conjunct := Void
				l_f_conjunct := Void
				across restiction.item.objects as o loop
					if o.item = Void then
						l_disjunct := factory.false_
					elseif o.item.type ~ types.ref then
						l_disjunct := factory.equal (l_o, o.item)
					else
						check o.item.type ~ types.set (types.ref) end
						l_disjunct := factory.map_access (o.item, << l_o >>)
					end
					if l_o_conjunct = Void then
						l_o_conjunct := l_disjunct
					else
						l_o_conjunct := factory.or_ (l_o_conjunct, l_disjunct)
					end
				end
				across restiction.item.fields as f loop
					l_disjunct := factory.equal (l_f, f.item)
					if l_f_conjunct = Void then
						l_f_conjunct := l_disjunct
					else
						l_f_conjunct := factory.or_ (l_f_conjunct, l_disjunct)
					end
				end
				if l_f_conjunct = Void then
						-- There was some validty error
					check not autoproof_errors.is_empty end
				else
					l_expr := factory.or_clean (l_expr, factory.and_ (l_o_conjunct, l_f_conjunct))
				end
			end
				-- Then go over fully modifiable objects
			across a_mods.fully_modified as o loop
				if o.item = Void then
					l_disjunct := factory.false_
				elseif o.item.type ~ types.ref then
					l_disjunct := factory.equal (l_o, o.item)
				else
					check o.item.type ~ types.set (types.ref) end
					l_disjunct := factory.map_access (o.item, << l_o >>)
				end
				l_expr := factory.or_clean (l_expr, l_disjunct)
			end
				-- Finally create the quantifier				
			create Result.make (factory.equiv (l_access, l_expr))
			Result.add_type_variable (l_type_var.name)
			Result.add_bound_variable (l_o.name, l_o.type)
			Result.add_bound_variable (l_f.name, l_f.type)
			Result.add_trigger (l_access)
		end

	decreases_expressions_of (a_clauses: LIST [ASSERT_B]; a_translator: E2B_EXPRESSION_TRANSLATOR): LIST [IV_EXPRESSION]
			-- List of variants extracted from decreases clauses `a_clauses'.
		do
			create {LINKED_LIST [IV_EXPRESSION]} Result.make
			across
				a_clauses as i
			loop
				if attached {FEATURE_B} i.item.expr as l_call then
					Result.append (translate_contained_expressions (l_call.parameters.i_th (1).expression, a_translator, False).expressions)
				else
					check internal_error: False end
				end
			end
		end

	translate_contained_expressions (a_expr: EXPR_B; a_translator: E2B_EXPRESSION_TRANSLATOR; convert_to_set: BOOLEAN): TUPLE [expressions: LINKED_LIST [IV_EXPRESSION]; type: TYPE_A]
			-- Translate expressions in `a_expr' using `a_translator'; if `convert_to_set', convert all expressions of logical types to sets.
		local
			l_expr_list: LINKED_LIST [EXPR_B]
			l_expressions: LINKED_LIST [IV_EXPRESSION]
			l_type: TYPE_A
		do
			create l_expr_list.make
			if attached {TUPLE_CONST_B} a_expr as l_tuple then
				across l_tuple.expressions as i loop
					l_expr_list.extend (i.item)
				end
				if l_tuple.expressions.is_empty then
					l_expr_list.extend (Void)
				end
			else
				l_expr_list.extend (a_expr)
			end
			create l_expressions.make
			across l_expr_list as k loop
				if k.item = Void then
					l_expressions.extend (Void)
				elseif convert_to_set and helper.is_class_logical (k.item.type.instantiated_in (a_translator.context_type).base_class) then
					a_translator.process_as_set (k.item, types.ref)
					l_expressions.extend (a_translator.last_expression)
					l_type := a_translator.last_set_content_type
				else
					k.item.process (a_translator)
					l_expressions.extend (a_translator.last_expression)
					l_type := k.item.type
				end
			end
			Result := [l_expressions, l_type]
		end

end
