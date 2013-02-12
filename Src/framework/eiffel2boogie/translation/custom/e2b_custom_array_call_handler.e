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
		local
			l_array_type: STRING
			l_fname: STRING
		do
			l_array_type := array_type_string (a_translator.current_target_type)
			l_array_type := "ARRAY"
			if array_procedures.has (a_feature.feature_name) then
				l_fname := l_array_type + "." + a_feature.feature_name
				a_translator.process_builtin_routine_call (a_feature, a_parameters, l_fname)
			elseif array_functions.has (a_feature.feature_name) then
				l_fname := "fun." + l_array_type + "." + a_feature.feature_name
				a_translator.process_builtin_function_call (a_feature, a_parameters, l_fname)
			else
				check False end
			end
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_array_type: STRING
			l_fname: STRING
		do
			l_array_type := array_type_string (a_translator.current_target_type)
			l_array_type := "ARRAY"
			if array_functions.has (a_feature.feature_name) then
				l_fname := "fun." + l_array_type + "." + a_feature.feature_name
				a_translator.process_builtin_routine_call (a_feature, a_parameters, l_fname)
			else
				check False end
			end
		end

	array_type_string (a_array_type: TYPE_A): STRING
		local
			l_type: TYPE_A
		do
			check a_array_type.base_class.name_in_upper.same_string ("ARRAY") end
			check a_array_type.has_generics end
			check a_array_type.generics.count = 1 end
			l_type := a_array_type.generics.item (1).deep_actual_type
			if l_type.is_boolean then
				Result := "ARRAY#bool#"
			elseif l_type.is_integer or l_type.is_natural then
				Result := "ARRAY#int#"
			elseif l_type.is_real_32 or l_type.is_real_64 then
				Result := "ARRAY#real#"
			else
				Result := "ARRAY#ref#"
			end
		end

	array_procedures: ARRAY [STRING]
			-- List of builtin array procedures.
		once
			Result := <<
				"make",
				"item",
				"put",
				"subarray"
			>>
			Result.compare_objects
		end

	array_functions: ARRAY [STRING]
			-- List of builtin array functions.
		once
			Result := <<
				"item",
				"has",
				"count",
				"subarray"
			>>
			Result.compare_objects
		end

end
