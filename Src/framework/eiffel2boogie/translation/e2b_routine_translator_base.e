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
			l_type_translator: E2B_TYPE_TRANSLATOR
			l_pre: IV_PRECONDITION
		do
			current_boogie_procedure.add_argument (a_name, a_boogie_type)
			create l_type_translator
			l_type_translator.generate_argument_property (create {IV_ENTITY}.make (a_name, a_boogie_type), a_type)
			if attached l_type_translator.last_property then
				create l_pre.make (l_type_translator.last_property)
				l_pre.set_free
				l_pre.set_assertion_type ("type property for argument " + a_name)
				current_boogie_procedure.add_contract (l_pre)
			end
		end

	add_result_with_property
			-- Add result to current procedure.
		local
			l_type: TYPE_A
			l_iv_type: IV_TYPE
			l_type_translator: E2B_TYPE_TRANSLATOR
		do
			if current_feature.has_return_value then
				l_type := current_feature.type.deep_actual_type.instantiated_in (current_type)
				l_iv_type := types.for_type_a (l_type)
				create l_type_translator
				l_type_translator.generate_argument_property (create {IV_ENTITY}.make ("Result", l_iv_type), l_type)
				translation_pool.add_type (l_type)
				current_boogie_procedure.add_result_with_property (
					"Result",
					l_iv_type,
					l_type_translator.last_property)
			end
		end

feature -- Helper functions: contracts

	contracts_of (a_feature: FEATURE_I; a_type: TYPE_A): TUPLE [pre, post, modifies, reads, decreases: LIST [ASSERT_B]]
			-- Contracts for feature `a_feature' of type `a_type'.
		local
			l_pre, l_post, l_modifies, l_reads, l_decreases: LINKED_LIST [ASSERT_B]
			l_name: STRING_32
		do
			create l_pre.make
			create l_post.make
			create l_modifies.make
			create l_reads.make
			create l_decreases.make

			helper.set_up_byte_context (a_feature, a_type)
			if attached Context.byte_code as l_byte_code then
					-- Process pre/post-conditions
				if l_byte_code.precondition /= Void then
					l_byte_code.precondition.do_all (agent l_pre.extend (?))
				end
				if l_byte_code.postcondition /= Void then
					l_byte_code.postcondition.do_all (agent l_post.extend (?))
				end
				if a_feature.assert_id_set /= Void and not a_type.is_basic then
						-- Feature has inherited assertions
					l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
					across Context.inherited_assertion.precondition_list as i loop
						i.item.do_all (agent l_pre.extend (?))
					end
					across Context.inherited_assertion.postcondition_list as i loop
						i.item.do_all (agent l_post.extend (?))
					end
				end
			end
			from
				l_pre.start
			until
				l_pre.after
			loop
				if attached {FEATURE_B} l_pre.item.expr as l_call then
					l_name := names_heap.item_32 (l_call.feature_name_id)
					if l_name  ~ "modify" or l_name ~ "modify_field" then
						l_modifies.extend (l_pre.item)
						l_pre.remove
					elseif l_name ~ "reads" then
						l_reads.extend (l_pre.item)
						l_pre.remove
					elseif l_name ~ "decreases" then
						l_decreases.extend (l_pre.item)
						l_pre.remove
					else
						l_pre.forth
					end
				else
					l_pre.forth
				end
			end
			from
				l_post.start
			until
				l_post.after
			loop
				if attached {FEATURE_B} l_post.item.expr as l_call then
					l_name := names_heap.item_32 (l_call.feature_name_id)
					if l_name  ~ "modify" or l_name ~ "modify_field" then
						l_modifies.extend (l_post.item)
						l_post.remove
					elseif l_name ~ "reads" then
						l_reads.extend (l_post.item)
						l_post.remove
					elseif l_name ~ "decreases" then
						l_decreases.extend (l_post.item)
						l_post.remove
					else
						l_post.forth
					end
				else
					l_post.forth
				end
			end
			Result := [l_pre, l_post, l_modifies, l_reads, l_decreases]
		end

	contracts_of_current_feature: like contracts_of
			-- Contracts for `current_feature'.
		do
			Result := contracts_of (current_feature, current_type)
		end

	contract_expressions_of (a_feature: FEATURE_I; a_type: TYPE_A; a_mapping: E2B_ENTITY_MAPPING): TUPLE [pre: IV_EXPRESSION; post: IV_EXPRESSION]
			-- Contracts for feature `a_feature' of type `a_type' as expressions.
		local
			l_contracts: like contracts_of
			l_pre: IV_EXPRESSION
			l_post: IV_EXPRESSION
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			l_contracts := contracts_of (a_feature, a_type)
			if l_contracts.pre.is_empty then
				l_pre := factory.true_
			else
				across l_contracts.pre as c loop
					create l_translator.make
					l_translator.set_context (a_feature, a_type)
					l_translator.copy_entity_mapping (a_mapping)
					c.item.process (l_translator)
					if attached l_pre then
						l_pre := factory.and_ (l_pre, l_translator.last_expression)
					else
						l_pre := l_translator.last_expression
					end
				end
			end
			if l_contracts.post.is_empty then
				l_post := factory.true_
			else
				across l_contracts.post as c loop
					create l_translator.make
					l_translator.set_context (a_feature, a_type)
					l_translator.copy_entity_mapping (a_mapping)
					c.item.process (l_translator)
					if attached l_post then
						l_post := factory.and_ (l_post, l_translator.last_expression)
					else
						l_post := l_translator.last_expression
					end
				end
			end
			Result := [l_pre, l_post]
		end

	modifies_expressions_of (a_feature: FEATURE_I; a_type: TYPE_A): TUPLE [modified_objects: LIST [IV_EXPRESSION]; field_restriction: LIST [TUPLE [fields: LIST [IV_ENTITY]; objects: LIST [IV_EXPRESSION]]]]
			-- Modifies expressions for feature `a_feature' of type `a_type'.
		local
			l_contracts: like contracts_of
			l_modified_objects: LINKED_LIST [IV_EXPRESSION]
			l_field_restrictions: LINKED_LIST [TUPLE [LINKED_LIST [IV_ENTITY], LINKED_LIST [IV_EXPRESSION]]]
			l_fieldnames: LINKED_LIST [STRING_32]
			l_fields: LINKED_LIST [IV_ENTITY]
			l_objects: LINKED_LIST [IV_EXPRESSION]
			l_name: STRING_32
			l_type: TYPE_A
			l_feature: FEATURE_I
			l_boogie_type: IV_TYPE
		do
			create l_modified_objects.make
			create l_field_restrictions.make
			l_contracts := contracts_of (a_feature, a_type)

			across
				l_contracts.modifies as i
			loop
				if attached {FEATURE_B} i.item.expr as l_call then
					l_name := names_heap.item_32 (l_call.feature_name_id)
					if l_name ~ "modify" then
						l_objects := translate_contained_expressions (l_call.parameters.i_th (1).expression)
						l_modified_objects.append (l_objects)
					elseif l_name ~ "modify_field" then
						l_objects := translate_contained_expressions (l_call.parameters.i_th (2).expression)
						l_modified_objects.append (l_objects)

						if attached {TUPLE_CONST_B} l_call.parameters.i_th (2).expression as l_tuple then
							l_type := l_tuple.expressions.first.type
						else
							l_type := l_call.parameters.i_th (2).expression.type
						end
						if l_type.is_like_current then
							l_type := current_type
						else
							l_type := l_type.deep_actual_type
						end
						if l_type.base_class.name_in_upper ~ "MML_SET" then
							l_type := l_type.generics.first
						end

						create l_fieldnames.make
						if attached {STRING_B} l_call.parameters.i_th (1).expression as l_string then
							l_fieldnames.extend (l_string.value)
						elseif attached {TUPLE_CONST_B} l_call.parameters.i_th (1).expression as l_tuple then
							across l_tuple.expressions as j loop
								if attached {STRING_B} j.item as l_string then
									l_fieldnames.extend (l_string.value)
								else
									helper.add_unsupported_error (Void, a_feature, "The tuple in the first argument of 'modify_field' needs to consist only of manifest strings.")
								end
							end
						else
							helper.add_unsupported_error (Void, a_feature, "First argument of 'modify_field' has to be a manifest string or a tuple of manifest strings.")
						end

						create l_fields.make
						across l_fieldnames as f loop
							l_feature := l_type.base_class.feature_named_32 (f.item)
							if l_feature = Void then
								if f.item ~ "closed" then
									l_name := "closed"
									l_boogie_type := types.bool
								else
									l_name := Void
									helper.add_unsupported_error (Void, a_feature, "Feature '" + f.item + "' mentioned in 'modify_field' does not exist in class '" + l_type.base_class.name_in_upper + "'")
								end
							else
								if l_feature.is_attribute then
									l_name := name_translator.boogie_name_for_feature (l_feature, l_type)
									l_boogie_type := types.for_type_a (l_feature.type)
									translation_pool.add_feature (l_feature, l_type)
								else
									l_name := Void
									helper.add_unsupported_error (Void, a_feature, "Feature '" + f.item + "' mentioned in 'modify_field' is not an attribute")
								end
							end
							if l_name /= Void then
								l_fields.extend (create {IV_ENTITY}.make (l_name, types.field (l_boogie_type)))
							end
						end

						l_field_restrictions.extend ([l_fields, l_objects])
					else
						check internal_error: False end
					end
				else
					check internal_error: False end
				end
			end

			Result := [l_modified_objects, l_field_restrictions]
		end

	translate_contained_expressions (a_expr: EXPR_B): LINKED_LIST [IV_EXPRESSION]
			-- Translate expressions in `a_expr'.
		local
			l_expr_list: LINKED_LIST [EXPR_B]
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
			create Result.make
			across l_expr_list as k loop
				if k.item = Void then
					Result.extend (Void)
				else
					Result.extend (translate_individual_expression (k.item))
				end
			end
		end

	translate_individual_expression (a_expr: EXPR_B): IV_EXPRESSION
		local
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
		do
			create l_translator.make
			l_translator.entity_mapping.set_heap (create {IV_ENTITY}.make ("heap", types.heap))
			l_translator.entity_mapping.set_current (create {IV_ENTITY}.make ("current", types.ref))
			l_translator.set_context (current_feature, current_type)
			a_expr.process (l_translator)
			Result := l_translator.last_expression
		end

end
