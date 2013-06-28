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
		do
			handle_routine_call (a_translator, a_feature, a_parameters)
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		do
			handle_routine_call (a_translator, a_feature, a_parameters)
		end

	handle_binary (a_translator: E2B_EXPRESSION_TRANSLATOR; a_left, a_right: IV_EXPRESSION; a_operator: STRING)
			-- Handle built-in (non alias) binary expression where `a_left' is a set.
		require
			is_set: a_left.type.is_set
		do
			if a_operator ~ "==" then
				check a_right.type.is_set end
				a_translator.set_last_expression (factory.function_call ("Set#Equal", << a_left, a_right >>, types.bool))
			elseif a_operator ~ "!=" then
				check a_right.type.is_set end
				a_translator.set_last_expression (factory.not_ (factory.function_call ("Set#Equal", << a_left, a_right >>, types.bool)))
			end

		end

feature {NONE} -- Implementation

	handle_routine_call (a_translator: E2B_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_target: IV_EXPRESSION
			l_param: IV_EXPRESSION
		do
			l_name := a_feature.feature_name
			l_target := a_translator.current_target
			a_translator.process_parameters (a_parameters)
			if l_name ~ "has" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (create {IV_MAP_ACCESS}.make (l_target, l_param))
			elseif l_name ~ "is_empty" then
				a_translator.set_last_expression (factory.function_call ("Set#Equal", <<l_target, "Set#Empty()">>, types.bool))
			elseif l_name ~ "is_subset_of" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#Subset", <<l_target, l_param>>, types.bool))
			elseif l_name ~ "is_superset_of" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#Subset", <<l_param, l_target>>, types.bool))
			elseif l_name ~ "is_disjoint" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#Disjoint", <<l_target, l_param>>, types.bool))
			elseif l_name ~ "extended" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#UnionOne", <<l_target, l_param>>, l_target.type))
			elseif l_name ~ "removed" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#Difference",
					<<l_target, factory.function_call ("Set#Singleton", <<l_param>>, l_target.type)>>, l_target.type))
			elseif l_name ~ "union" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#Union", <<l_target, l_param>>, l_target.type))
			elseif l_name ~ "intersection" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#Intersection", <<l_target, l_param>>, l_target.type))
			elseif l_name ~ "difference" then
				l_param := a_translator.last_parameters.first
				a_translator.set_last_expression (factory.function_call ("Set#Difference", <<l_target, l_param>>, l_target.type))
			else
					-- cannot happen
				check False end
			end
		end

end
