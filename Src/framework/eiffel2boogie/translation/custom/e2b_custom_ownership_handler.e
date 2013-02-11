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
			Result := a_feature.written_in = system.any_id and
				(builtin_any_features.has (a_feature.feature_name) or
				set_access.has (a_feature.feature_name) or
				set_setter.has (a_feature.feature_name))
		end

	is_handling_nested (a_nested: NESTED_B): BOOLEAN
			-- Is this handler handling the call?
		do
			if
				not a_nested.target.type.is_like and then
				a_nested.target.type.base_class /= Void and then
				a_nested.target.type.base_class.class_id = system.tuple_id
			then
				if attached {FEATURE_B} a_nested.message as f then
					Result := f.feature_name.same_string ("to_ownership_set")
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
		do
			l_name := a_feature.feature_name
			if builtin_any_features.has (l_name) then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
			elseif set_access.has (l_name) then
				a_translator.set_last_expression (factory.heap_current_access (a_translator.entity_mapping, l_name, types.set (types.ref)))
			else
				check set_setter.has (l_name) end
				l_name := l_name.substring (5, l_name.count)
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "xyz")
				l_call ?= a_translator.side_effect.last
				a_translator.side_effect.finish
				a_translator.side_effect.remove
				create l_assign.make (
					factory.heap_current_access (a_translator.entity_mapping, l_name, types.set (types.ref)),
					l_call.arguments.i_th (2))
				a_translator.set_last_expression (Void)
				a_translator.side_effect.extend (l_assign)
			end
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			if builtin_any_features.has (l_name) then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
			elseif set_access.has (l_name) then
				a_translator.set_last_expression (factory.heap_current_access (a_translator.entity_mapping, l_name, types.set (types.ref)))
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
			l_exprs: LINKED_LIST [IV_EXPRESSION]
			l_expr: IV_EXPRESSION
		do
			if attached {ACCESS_EXPR_B} a_nested.target as x then
				l_tuple ?= x.expr
			end
			check l_tuple /= Void end
			create l_exprs.make
			across l_tuple.expressions as i loop
				i.item.process (a_translator)
				l_exprs.extend (a_translator.last_expression)
			end
			if l_exprs.is_empty then
				a_translator.set_last_expression (
					factory.function_call ("Set#Empty", Void, types.set (types.ref)))
			else
				from
					l_exprs.start
					l_expr := factory.function_call ("Set#Singleton", << l_exprs.item >>, types.set (types.ref))
					l_exprs.forth
				until
					l_exprs.after
				loop
					l_expr := factory.function_call (
						"Set#UnionOne",
						<< l_expr, l_exprs.item >>,
						types.set (types.ref))
					l_exprs.forth
				end
				a_translator.set_last_expression (l_expr)
			end
		end

	builtin_any_features: ARRAY [STRING]
			-- List of builtin names.
		once
			Result := <<
				"wrap",
				"multi_wrap",
				"unwrap",
				"is_wrapped",
				"is_free",
				"is_open"
			>>
			Result.compare_objects
		end

	set_access: ARRAY [STRING]
			-- List of feature names.
		once
			Result := <<
				"owner",
				"owns",
				"depends",
				"dependents"
			>>
			Result.compare_objects
		end

	set_setter: ARRAY [STRING]
			-- List of feature names.
		once
			Result := <<
				"set_owner",
				"set_owns",
				"set_depends",
				"set_dependents"
			>>
			Result.compare_objects
		end

end
