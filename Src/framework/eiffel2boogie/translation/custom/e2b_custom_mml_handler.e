note
	description: "Summary description for {E2B_CUSTOM_MML_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_MML_HANDLER

inherit
	E2B_CUSTOM_CALL_HANDLER

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := a_feature.written_class.name ~ "MML_SET"
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_target: IV_EXPRESSION
			l_param: IV_EXPRESSION
		do
			l_name := a_feature.feature_name
			if l_name ~ "has" then
				l_target := a_translator.current_target
				a_translator.process_parameters (a_parameters)
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (create {IV_MAP_ACCESS}.make (l_target, l_param))
			else
					-- cannot happen
				check False end
			end
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_target: IV_EXPRESSION
			l_param: IV_EXPRESSION
		do
			l_name := a_feature.feature_name
			if l_name ~ "has" then
				l_target := a_translator.current_target
				a_translator.process_parameters (a_parameters)
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (create {IV_MAP_ACCESS}.make (l_target, l_param))
			else
					-- cannot happen
				check False end
			end
		end

end
