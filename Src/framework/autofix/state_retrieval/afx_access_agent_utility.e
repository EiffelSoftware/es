note
	description: "Summary description for {AFX_ACCESS_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ACCESS_AGENT_UTILITY

inherit
	AUT_AGENT_UTILITY [AFX_ACCESS]

feature -- Expression veto agents

	result_expression_veto_agent: FUNCTION [ANY, TUPLE [AFX_ACCESS], BOOLEAN]
			-- An agent to select result access
		do
			Result :=
				agent (a_access: AFX_ACCESS): BOOLEAN
					do
						Result := a_access.is_result
					end
		end

	current_expression_veto_agent: FUNCTION [ANY, TUPLE [AFX_ACCESS], BOOLEAN]
			-- An agent to select current access
		do
			Result :=
				agent (a_access: AFX_ACCESS): BOOLEAN
					do
						Result := a_access.is_current
					end
		end

	local_expression_veto_agent: FUNCTION [ANY, TUPLE [AFX_ACCESS], BOOLEAN]
			-- An agent to select local access
		do
			Result :=
				agent (a_access: AFX_ACCESS): BOOLEAN
					do
						Result := a_access.is_local
					end
		end

	feature_expression_veto_agent: FUNCTION [ANY, TUPLE [AFX_ACCESS], BOOLEAN]
			-- An agent to select feature access
		do
			Result :=
				agent (a_access: AFX_ACCESS): BOOLEAN
					do
						Result := a_access.is_feature
					end
		end

	integer_expression_veto_agent: FUNCTION [ANY, TUPLE [AFX_ACCESS], BOOLEAN]
			-- An agent to select access of integer type
		do
			Result :=
				agent (a_access: AFX_ACCESS): BOOLEAN
					do
						Result := a_access.is_type_integer
					end
		end

	boolean_expression_veto_agent: FUNCTION [ANY, TUPLE [AFX_ACCESS], BOOLEAN]
			-- An agent to select access of boolean type
		do
			Result :=
				agent (a_access: AFX_ACCESS): BOOLEAN
					do
						Result := a_access.is_type_boolean
					end
		end

end
