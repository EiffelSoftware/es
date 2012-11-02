note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_INTEGER_CALL_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
		end

end
