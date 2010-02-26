note
	description: "Summary description for {EPA_TYPE_BASED_FEATURE_FINDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TYPE_BASED_FEATURE_FINDER

inherit
	EPA_FEATURE_FINDER

	EPA_AGENT_UTILITY [FEATURE_I]

feature -- Access

	feature_selection_agent: FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]
			-- Agent to select a feature,
			-- If this return returns True with a given feature, that feature is selected, otherwise,
			-- that feature is ignored.
		do
		end

	type: EPA_TYPE_A_WITH_CONTEXT
			-- Type upon which features are selected

feature -- Basic operations

	find (a_class: CLASS_C)
			-- Find features in `a_class' which satisfies `feature_selection_agent',
			-- make result available in `last_found_features'.
			-- Create a new instance of `last_found_features'.
		local
			l: ANY
		do
			l := anded_agents (<<agent is_feature_with_return_type (?, a_class, type), agent is_feature_query>>)
		end

feature -- Status report

	is_feature_with_return_type (a_feature: FEATURE_I; a_class: CLASS_C; a_type: EPA_TYPE_A_WITH_CONTEXT): BOOLEAN
			-- Does `a_feature' in `a_class' has return type `a_type'?
		do

		end

	is_feature_with_argument_type (a_feature: FEATURE_I; a_class: CLASS_C; a_type: EPA_TYPE_A_WITH_CONTEXT): BOOLEAN
			-- Does `a_feature' in `a_class' has argument with type `a_type'?
		do
		end

	is_feature_query (a_feature: FEATURE_I): BOOLEAN
			-- Is `a_feature' a query?
		do
			Result := not a_feature.type.is_void
		end

	is_feature_command (a_feature: FEATURE_I): BOOLEAN
			-- Is `a_feature' a command?
		do
			Result := not is_feature_query (a_feature)
		end

end
