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
			Result := a_target_type.is_numeric
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
			l_fname: STRING
		do
			l_name := a_feature.feature_name
			if l_name.same_string ("truncated_to_integer") then
				l_fname := "real_to_integer_32"
			elseif l_name.same_string ("truncated_to_integer_64") then
				l_fname := "real_to_integer_64"
			elseif l_name.same_string ("to_natural_8") or l_name.same_string ("as_natural_8") then
				l_fname := "int_to_natural_8"
			elseif l_name.same_string ("to_natural_16") or l_name.same_string ("as_natural_16") then
				l_fname := "int_to_natural_16"
			elseif l_name.same_string ("to_natural_32") or l_name.same_string ("as_natural_32") then
				l_fname := "int_to_natural_32"
			elseif l_name.same_string ("to_natural_64") or l_name.same_string ("as_natural_64") then
				l_fname := "int_to_natural_64"
			elseif l_name.same_string ("to_integer_8") or l_name.same_string ("as_integer_8") then
				l_fname := "int_to_integer_8"
			elseif l_name.same_string ("to_integer_16") or l_name.same_string ("as_integer_16") then
				l_fname := "int_to_integer_16"
			elseif l_name.same_string ("to_integer_32") or l_name.same_string ("as_integer_32") then
				l_fname := "int_to_integer_32"
			elseif l_name.same_string ("to_integer_64") or l_name.same_string ("as_integer_64") then
				l_fname := "int_to_integer_64"
			else
				l_fname := Void
			end
			if l_fname /= Void then
				a_translator.set_last_expression (factory.function_call (l_fname, << a_translator.current_target >>, types.generic_type))
			else
				a_translator.process_routine_call (a_feature, a_parameters)
			end
		end

end
