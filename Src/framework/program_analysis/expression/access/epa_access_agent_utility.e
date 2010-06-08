note
	description: "Summary description for {AFX_ACCESS_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_ACCESS_AGENT_UTILITY

inherit
	EPA_AGENT_UTILITY [EPA_ACCESS]

	SHARED_WORKBENCH

	EPA_CONTRACT_EXTRACTOR

feature -- Expression veto agents

	result_expression_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select result access
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := a_access.is_result
					end
		end

	current_expression_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select current access
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := a_access.is_current
					end
		end

	argument_expression_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select argument access
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := a_access.is_argument
					end
		end

	local_expression_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select local access
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := a_access.is_local
					end
		end

	feature_expression_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select feature access
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := a_access.is_feature
					end
		end

	feature_with_few_arguments_veto_agent (a_arg_count: INTEGER): FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select feature with no more than `a_arg_count' number of arguments
		do
			Result :=
				agent (a_access: EPA_ACCESS; a_args: INTEGER): BOOLEAN
					do
						Result := True
						if a_access.is_feature then
							if attached {EPA_ACCESS_FEATURE} a_access as l_feat then
								Result := l_feat.feature_.argument_count <= a_args
							end
						end
					end (?, a_arg_count)
		end

	feature_with_one_integer_argument_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select feature with a single integer argument
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := True
						if a_access.is_feature then
							if attached {EPA_ACCESS_FEATURE} a_access as l_feat then
								Result :=
									l_feat.feature_.argument_count = 1 and then
									l_feat.feature_.arguments.i_th (1).is_integer
							end
						end
					end
		end

	feature_not_from_any_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select feature not from class ANY
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := True
						if attached {EPA_ACCESS_FEATURE} a_access as l_feat then
							Result := l_feat.feature_.written_class.class_id /= system.any_class.compiled_representation.class_id
						end
					end
		end

	feature_not_obsolete_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select non-obsolete feature
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := True
						if attached {EPA_ACCESS_FEATURE} a_access as l_feat then
							Result := not l_feat.feature_.is_obsolete
						end
					end
		end

	nested_not_on_basic_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select nested access, but not on basic types.
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := True
						if attached {EPA_ACCESS_NESTED} a_access as l_nested then
							Result := not l_nested.left.type.is_basic
						end
					end
		end

	integer_expression_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select access of integer type
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := a_access.is_type_integer
					end
		end

	boolean_expression_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select access of boolean type
		do
			Result :=
				agent (a_access: EPA_ACCESS): BOOLEAN
					do
						Result := a_access.is_type_boolean
					end
		end

	feature_not_from_agent_class_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select accesses which are not froun agent related classes.
		do
			Result := agent (a_access: EPA_ACCESS): BOOLEAN
				local
					l_class_id: INTEGER
				do
					if attached {EPA_ACCESS_NESTED} a_access as l_nested then
						l_class_id := l_nested.left.context_class.class_id
						Result :=
							l_class_id /= system.function_class.compiled_representation.class_id and then
							l_class_id /= system.procedure_class.compiled_representation.class_id and then
							l_class_id /= system.predicate_class.compiled_representation.class_id and then
							l_class_id /= system.routine_class.compiled_representation.class_id

					else
						Result := True
					end
				end
		end

	feature_not_from_tuple_class_veto_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select accesses which are not froun TUPLE class.
		do
			Result := agent (a_access: EPA_ACCESS): BOOLEAN
				local
					l_class_id: INTEGER
				do
					if attached {EPA_ACCESS_NESTED} a_access as l_nested then
						l_class_id := l_nested.left.context_class.class_id
						Result :=
							l_class_id /= system.tuple_class.compiled_representation.class_id
					else
						Result := True
					end
				end
		end

	feature_without_precondition_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select features without precondition
		do
			Result := agent (a_access: EPA_ACCESS): BOOLEAN
				local
					l_feat: FEATURE_I
				do
					if attached {EPA_ACCESS_NESTED} a_access as l_nested then
						l_feat := l_nested.right.feature_
						Result := precondition_of_feature (l_feat, l_feat.written_class).is_empty
					end
				end
		end

	feature_exported_to_any_agent: FUNCTION [ANY, TUPLE [EPA_ACCESS], BOOLEAN]
			-- An agent to select features that are exported to {ANY}.
		do
			Result := agent (a_access: EPA_ACCESS): BOOLEAN
				local
					l_feat: FEATURE_I
				do
					if attached {EPA_ACCESS_NESTED} a_access as l_nested then
						l_feat := l_nested.right.feature_
						Result := l_feat.is_exported_for (system.any_class.compiled_representation)
					end
				end
		end

end
