note
	description: "Summary description for {E2B_CUSTOM_OWNERSHIP_HANDLER}."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CUSTOM_OWNERSHIP_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

	SHARED_WORKBENCH

feature -- Status report

	is_handling_call (a_target_type: TYPE_A; a_feature: FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result :=
				a_feature.written_in = system.any_id and then
				feature_names.has (a_feature.feature_name)
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
		do
			l_name := a_feature.feature_name
			a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
		end

	feature_names: ARRAY [STRING]
			-- List of feature names.
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

end
