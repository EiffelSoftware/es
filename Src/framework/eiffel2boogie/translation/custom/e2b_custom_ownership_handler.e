note
	description: "Summary description for {E2B_CUSTOM_OWNERSHIP_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_OWNERSHIP_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

	E2B_CUSTOM_NESTED_HANDLER

	SHARED_WORKBENCH

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := (a_feature.written_in = system.any_id and
				(builtin_any_functions.has (a_feature.feature_name) or
				builtin_any_procedures.has (a_feature.feature_name) or
				ghost_access.has (a_feature.feature_name) or
				ghost_setter.has (a_feature.feature_name)))
		end

	is_handling_nested (a_nested: NESTED_B): BOOLEAN
			-- Is this handler handling the call?
		do
			if
				not a_nested.target.type.is_like and then
				a_nested.target.type.base_class /= Void and then
				(a_nested.target.type.base_class.class_id = system.tuple_id or a_nested.target.type.base_class.class_id = system.array_id)
			then
				if attached {FEATURE_B} a_nested.message as f then
					Result := f.feature_name.same_string ("to_mml_set")
				end
			end
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_assign: IV_ASSIGNMENT
			l_call: IV_PROCEDURE_CALL
			l_type: IV_TYPE
		do
			l_name := a_feature.feature_name
			if builtin_any_functions.has (l_name) then
				a_translator.process_builtin_function_call (a_feature, a_parameters, l_name)
			elseif builtin_any_procedures.has (l_name) then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
			elseif ghost_access.has (l_name) then
				if l_name ~ "owner" then
					l_type := types.ref
				else
					l_type := types.set (types.ref)
				end
				a_translator.set_last_expression (factory.heap_access (a_translator.entity_mapping.heap.name, a_translator.current_target, l_name, l_type))
			elseif ghost_setter.has (l_name) then
				l_name := l_name.substring (5, l_name.count)
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "xyz")
				l_call ?= a_translator.side_effect.last
				a_translator.side_effect.finish
				a_translator.side_effect.remove	-- last side effect is actual call, here to non-existing "xyz"
				a_translator.set_last_expression (Void)
				a_translator.side_effect.extend (factory.procedure_call ("update_heap", << a_translator.current_target, l_name, l_call.arguments.i_th (2)>>))
			else
				check false end
			end
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_type: IV_TYPE
			l_tag_filters: LIST [STRING]
		do
			l_name := a_feature.feature_name
			if builtin_any_functions.has (l_name) then
				if l_name ~ "inv_without" then
					l_tag_filters := extract_tags (a_parameters)
					if l_tag_filters.is_empty then
						a_translator.process_builtin_routine_call (a_feature, a_parameters, "user_inv")
					else
						translation_pool.add_filtered_invariant_function (a_translator.current_target_type, Void, l_tag_filters)
						a_translator.set_last_expression (
							factory.function_call (
								name_translator.boogie_name_for_filtered_invariant_function (a_translator.current_target_type, Void, l_tag_filters),
								<< a_translator.entity_mapping.heap, a_translator.current_target >>, types.bool))
					end
				elseif l_name ~ "inv_only" then
					l_tag_filters := extract_tags (a_parameters)
					translation_pool.add_filtered_invariant_function (a_translator.current_target_type, l_tag_filters, Void)
					a_translator.set_last_expression (
						factory.function_call (
							name_translator.boogie_name_for_filtered_invariant_function (a_translator.current_target_type, l_tag_filters, Void),
							<< a_translator.entity_mapping.heap, a_translator.current_target >>, types.bool))
				elseif l_name ~ "inv" then
					a_translator.process_builtin_routine_call (a_feature, a_parameters, "user_inv")
				else
					a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
				end
			elseif ghost_access.has (l_name) then
				if l_name ~ "owner" then
					l_type := types.ref
				else
					l_type := types.set (types.ref)
				end
				a_translator.set_last_expression (factory.heap_access (a_translator.entity_mapping.heap.name, a_translator.current_target, l_name, l_type))
			else
					-- cannot happen
				check False end
			end
		end

	handle_nested_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_nested: NESTED_B)
			-- <Precursor>
		do
			handle_nested (a_translator, a_nested)
		end

	handle_nested_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_nested: NESTED_B)
			-- <Precursor>
		do
			handle_nested (a_translator, a_nested)
		end

	handle_nested (a_translator: E2B_EXPRESSION_TRANSLATOR; a_nested: NESTED_B)
			-- Handle `a_nested'.
		local
			l_tuple: TUPLE_CONST_B
			l_array: ARRAY_CONST_B
			l_exprs: LINKED_LIST [IV_EXPRESSION]
			l_expr: IV_EXPRESSION
			l_elem_type: IV_TYPE
		do
			if attached {ACCESS_EXPR_B} a_nested.target as x then
				l_tuple ?= x.expr
				l_array ?= x.expr
			end
			check l_tuple /= Void or l_array /= Void end
			create l_exprs.make
			if l_tuple /= Void then
				across l_tuple.expressions as i loop
					i.item.process (a_translator)
					l_exprs.extend (a_translator.last_expression)
					if l_elem_type = Void then
						l_elem_type := a_translator.last_expression.type
					elseif l_elem_type /= a_translator.last_expression.type then
						-- TODO: signal an error
					end
				end
			else
				check l_array /= Void end
				across l_array.expressions as i loop
					i.item.process (a_translator)
					l_exprs.extend (a_translator.last_expression)
					if l_elem_type = Void then
						l_elem_type := a_translator.last_expression.type
					elseif l_elem_type /= a_translator.last_expression.type then
						-- TODO: signal an error
					end
				end
			end
			if l_exprs.is_empty then
				-- TODO: how to determine elem type here?
				a_translator.set_last_expression (
					factory.function_call ("Set#Empty", Void, types.set (types.ref)))
			else
				from
					l_exprs.start
					l_expr := factory.function_call ("Set#Singleton", << l_exprs.item >>, types.set (l_elem_type))
					l_exprs.forth
				until
					l_exprs.after
				loop
					l_expr := factory.function_call (
						"Set#UnionOne",
						<< l_expr, l_exprs.item >>,
						types.set (l_elem_type))
					l_exprs.forth
				end
				a_translator.set_last_expression (l_expr)
			end
		end

	builtin_any_functions: ARRAY [STRING]
			-- List of builtin function names.
		once
			Result := <<
				"is_wrapped",
				"is_free",
				"is_open",
				"is_closed",
				"inv",
				"inv_without",
				"inv_only"
			>>
			Result.compare_objects
		end

	builtin_any_procedures: ARRAY [STRING]
			-- List of builtin procedure names.
		once
			Result := <<
				"wrap",
				"wrap_all",
				"unwrap",
				"unwrap_all"
			>>
			Result.compare_objects
		end

	ghost_access: ARRAY [STRING]
			-- List of feature names.
		once
			Result := <<
				"owner",
				"owns",
				"subjects",
				"observers"
			>>
			Result.compare_objects
		end

	ghost_setter: ARRAY [STRING]
			-- List of feature names.
		once
			Result := <<
				"set_owner",
				"set_owns",
				"set_subjects",
				"set_observers"
			>>
			Result.compare_objects
		end

	extract_tags (a_parameters: BYTE_LIST [PARAMETER_B]): LIST [STRING]
		do
			check a_parameters.count = 1 end
			create {LINKED_LIST [STRING]} Result.make
			Result.compare_objects
			if attached {STRING_B} a_parameters.first.expression as l_string then
				Result.extend (l_string.value)
			elseif attached {TUPLE_CONST_B} a_parameters.first.expression as l_tuple then
				across l_tuple.expressions as i loop
					if attached {STRING_B} i.item as l_string then
						Result.extend (l_string.value)
					else
						check False end
					end
				end
			else
				check False end
			end
		end

end
