note
	description: "Summary description for {E2B_CUSTOM_ANY_CALL_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_ANY_CALL_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

	E2B_CUSTOM_NESTED_HANDLER

	SHARED_WORKBENCH

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := a_feature.feature_name_32 ~ "generating_type" or
				a_feature.feature_name_32 ~ "old_"
		end

	is_handling_nested (a_nested: NESTED_B): BOOLEAN
			-- <Precursor>
		do
			if
				not a_nested.target.type.is_like and then
				a_nested.target.type.base_class /= Void and then
				(a_nested.target.type.base_class.name_in_upper ~ "TYPE")
			then
				if attached {FEATURE_B} a_nested.message as f then
					Result := f.feature_name.same_string ("default")
				end
			end
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			handle_routine_call (a_translator, a_feature, a_parameters)
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			handle_routine_call (a_translator, a_feature, a_parameters)
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

feature -- Implementation

	handle_routine_call (a_translator: E2B_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			if l_name.same_string ("generating_type") then
				a_translator.set_last_expression (factory.function_call ("type_of", << a_translator.current_target >>, types.type))
			elseif l_name.same_string ("old_") then
				a_translator.set_last_expression (factory.old_ (a_translator.current_target))
			elseif l_name.same_string ("default") then
				a_translator.set_last_expression (a_translator.current_target.type.default_value)
			else
				check False end
			end
		end

	handle_nested (a_translator: E2B_EXPRESSION_TRANSLATOR; a_nested: NESTED_B)
			-- Handle `a_nested'.
		local
			l_type: CL_TYPE_A
		do
			a_translator.set_last_expression (factory.void_)
			if attached {ACCESS_EXPR_B} a_nested.target as x then
				if attached {TYPE_EXPR_B} x.expr as t then
					l_type := a_translator.class_type_in_current_context (t.type_data.generics.first)
					a_translator.set_last_expression (types.for_class_type (l_type).default_value)
				end
			end
		end

end
