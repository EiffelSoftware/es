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
		local
			l_name: STRING
		do
			l_name := a_feature.written_class.name_in_upper + "." + a_feature.feature_name
			Result := mapping.has (l_name)
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
			left_is_set_or_seq: a_left.type.is_set or a_left.type.is_seq
			right_is_set_or_seq: a_right.type.is_set or a_right.type.is_seq
		local
			l_left, l_right: IV_EXPRESSION
		do
			if a_left.type.is_set or a_right.type.is_set then
					-- At least one set is involved
				if a_left.type.is_set then
					l_left := a_left
				elseif a_left.type.is_seq then
					l_left := factory.function_call ("Seq#Range", << a_left >>, a_right.type)
				end
				if a_right.type.is_set then
					l_right := a_right
				else
					l_right := factory.function_call ("Seq#Range", << a_right >>, a_left.type)
				end

				if a_operator ~ "==" then
					a_translator.set_last_expression (factory.function_call ("Set#Equal", << l_left, l_right >>, types.bool))
				elseif a_operator ~ "!=" then
					a_translator.set_last_expression (factory.not_ (factory.function_call ("Set#Equal", << l_left, l_right >>, types.bool)))
				end
			else
					-- Two sequences
				if a_operator ~ "==" then
					a_translator.set_last_expression (factory.function_call ("Seq#Equal", << a_left, a_right >>, types.bool))
				elseif a_operator ~ "!=" then
					a_translator.set_last_expression (factory.not_ (factory.function_call ("Seq#Equal", << a_left, a_right >>, types.bool)))
				end
			end

		end

feature {NONE} -- Implementation

	handle_routine_call (a_translator: E2B_EXPRESSION_TRANSLATOR; a_feature: FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_target: IV_EXPRESSION
			l_param: IV_EXPRESSION
			l_expr: IV_EXPRESSION
		do
			l_name := a_feature.written_class.name_in_upper + "." + a_feature.feature_name
			check mapping.has (l_name) end

			a_translator.process_parameters (a_parameters)
			l_expr := mapping.item (l_name).item ([a_translator.current_target, a_translator.last_parameters])
			a_translator.set_last_expression (l_expr)
		end

	mapping: STRING_TABLE [FUNCTION [ANY, TUPLE [IV_EXPRESSION, LIST [IV_EXPRESSION]], IV_EXPRESSION]]
			-- Mapping
		once
			create Result.make (50)

			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Empty", << >>, types.bool)
					end,
				"MML_SET.default_create")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Item", <<a_target>>, types.generic)
					end,
				"MML_SET.any_item")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := create {IV_MAP_ACCESS}.make (a_target, a_params.first)
					end,
				"MML_SET.has")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Equal", <<a_target, "Set#Empty()">>, types.bool)
					end,
				"MML_SET.is_empty")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Subset", <<a_target, a_params.first>>, types.bool)
					end,
				"MML_SET.is_subset_of")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Subset", <<a_params.first, a_target>>, types.bool)
					end,
				"MML_SET.is_superset_of")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Disjoint", <<a_target, a_params.first>>, types.bool)
					end,
				"MML_SET.is_disjoint")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#UnionOne", <<a_target, a_params.first>>, a_target.type)
					end,
				"MML_SET.extended")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call (
							"Set#Difference",
							<<
								a_target,
								factory.function_call ("Set#Singleton", <<a_params.first>>, a_target.type)
							>>,
							a_target.type)
					end,
				"MML_SET.removed")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Union", <<a_target, a_params.first>>, a_target.type)
					end,
				"MML_SET.union")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Intersection", <<a_target, a_params.first>>, a_target.type)
					end,
				"MML_SET.intersection")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Difference", <<a_target, a_params.first>>, a_target.type)
					end,
				"MML_SET.difference")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Set#Empty", << >>, types.set (types.ref))
					end,
				"MML_SET.empty_set")


			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Empty", << >>, types.bool)
					end,
				"MML_SEQUENCE.default_create")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Singleton", << a_params.first >>, types.bool)
					end,
				"MML_SEQUENCE.singleton")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Contains", << a_target, a_params.first >>, types.bool)
					end,
				"MML_SEQUENCE.has")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Equal", << a_target, "Seq#Empty()" >>, types.bool)
					end,
				"MML_SEQUENCE.is_empty")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Index", << a_target, a_params.first >>, types.generic)
					end,
				"MML_SEQUENCE.item")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Domain", << a_target >>, types.set (types.int))
					end,
				"MML_SEQUENCE.domain")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Range", << a_target >>, types.set (types.generic))
					end,
				"MML_SEQUENCE.range")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Length", << a_target >>, types.int)
					end,
				"MML_SEQUENCE.count")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Prefix", << a_target, a_params.first >>, types.bool)
					end,
				"MML_SEQUENCE.is_prefix_of")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Index", << a_target, factory.int_value (1) >>, types.generic)
					end,
				"MML_SEQUENCE.first")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Index", << a_target, factory.function_call ("Seq#Length", << a_target >>, types.int) >>, types.generic)
					end,
				"MML_SEQUENCE.last")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Drop", << a_target, factory.int_value (1) >>, a_target.type)
					end,
				"MML_SEQUENCE.but_first")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Take", << a_target, factory.minus_one (factory.function_call ("Seq#Length", << a_target >>, types.int)) >>, a_target.type)
					end,
				"MML_SEQUENCE.but_last")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Take", << a_target, a_params.first >>, a_target.type)
					end,
				"MML_SEQUENCE.front")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Drop", << a_target, factory.minus_one (a_params.first) >>, a_target.type)
					end,
				"MML_SEQUENCE.tail")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Drop", <<
								factory.function_call ("Seq#Take", << a_target, a_params [2] >>, a_target.type),
								factory.minus_one (a_params [1])
							>>, a_target.type)
					end,
				"MML_SEQUENCE.interval")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Append", <<
								factory.function_call ("Seq#Take", << a_target, factory.minus_one (a_params.first) >>, a_target.type),
								factory.function_call ("Seq#Drop", << a_target, a_params.first >>, a_target.type)
							>>, a_target.type)
					end,
				"MML_SEQUENCE.removed_at")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Build", << a_target, a_params.first >>, a_target.type)
					end,
				"MML_SEQUENCE.extended")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Append", <<
								factory.function_call ("Seq#Build", <<
									factory.function_call ("Seq#Take", << a_target, factory.minus_one (a_params.first) >>, a_target.type),
									a_params [2]
								>>, a_target.type),
								factory.function_call ("Seq#Drop", << a_target, factory.minus_one (a_params.first) >>, a_target.type)
							>>, a_target.type)
					end,
				"MML_SEQUENCE.extended_at")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Append", <<
								factory.function_call ("Seq#Singleton", << a_params.first >>, a_target.type),
								a_target
							>>, a_target.type)
					end,
				"MML_SEQUENCE.prepended")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Append", <<a_target, a_params.first >>, types.seq (types.generic))
					end,
				"MML_SEQUENCE.concatenation")
			Result.extend (
				agent (a_target: IV_EXPRESSION; a_params: LIST [IV_EXPRESSION]): IV_EXPRESSION
					do
						Result := factory.function_call ("Seq#Update", <<a_target, a_params [1], a_params [2]>>, a_target.type)
					end,
				"MML_SEQUENCE.replaced_at")
		end


end
