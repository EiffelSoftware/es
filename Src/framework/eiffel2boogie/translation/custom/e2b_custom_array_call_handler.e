note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_ARRAY_CALL_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := a_target_type.base_class.name_in_upper ~ "ARRAY"
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			if a_feature.feature_name ~ "make" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "ARRAY#int#.make")
			elseif a_feature.feature_name ~ "put" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "ARRAY#int#.put")
			elseif a_feature.feature_name ~ "item" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "ARRAY#int#.item")
			elseif a_feature.feature_name ~ "count" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "ARRAY#int#.count")
			elseif a_feature.feature_name ~ "has" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "ARRAY#int#.has")
			elseif a_feature.feature_name ~ "subarray" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "ARRAY#int#.subarray")
			end
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			if a_feature.feature_name ~ "make" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "fun.ARRAY#int#.make")
			elseif a_feature.feature_name ~ "put" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "fun.ARRAY#int#.put")
			elseif a_feature.feature_name ~ "item" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "ARRAY.$item")
			elseif a_feature.feature_name ~ "has" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "fun.ARRAY#int#.has")
			elseif a_feature.feature_name ~ "count" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "fun.ARRAY#int#.count")
			elseif a_feature.feature_name ~ "subarray" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "fun.ARRAY#int#.subarray")
			end
		end

end
