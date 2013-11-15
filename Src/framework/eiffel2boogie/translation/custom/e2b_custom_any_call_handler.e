note
	description: "Summary description for {E2B_CUSTOM_ANY_CALL_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_ANY_CALL_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := a_feature.feature_name_32 ~ "generating_type"
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

feature -- Implementation

	handle_routine_call (a_translator: E2B_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			if l_name.same_string ("generating_type") then
				a_translator.set_last_expression (factory.function_call ("type_of", << a_translator.current_target >>, types.type))
			else
				check False end
			end
		end

end
