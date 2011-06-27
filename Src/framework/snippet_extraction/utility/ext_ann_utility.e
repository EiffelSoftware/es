note
	description: "Helper functions for creating annotationss."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_ANN_UTILITY

inherit
	REFACTORING_HELPER

feature {NONE} -- Annotation Handling

	collect_mentions_set (a_ast: AST_EIFFEL; a_context: EXT_VARIABLE_CONTEXT): LINKED_SET [STRING]
			-- Collect 'identifier' and 'identifier.feature_call' string representation of variables of interest used in `a_ast'.
		local
			l_identifier_usage_finder: EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE
		do
			create Result.make
			Result.compare_objects

			create l_identifier_usage_finder
			l_identifier_usage_finder.set_is_mode_disjoint (True)
			l_identifier_usage_finder.set_on_access_identifier (
				agent (l_as: ACCESS_AS; a_variable_context: EXT_VARIABLE_CONTEXT; a_variable_usage: LINKED_SET [STRING])
					do
						if a_variable_context.is_variable_of_interest (l_as.access_name_8) then
							a_variable_usage.force (l_as.access_name_8)
						end
					end (?, a_context, Result)
				)
			l_identifier_usage_finder.set_on_access_identifier_with_feature_call (
				agent (l_as: NESTED_AS; a_variable_context: EXT_VARIABLE_CONTEXT; a_variable_usage: LINKED_SET [STRING])
					do
						if a_variable_context.is_variable_of_interest (l_as.target.access_name_8) then
							if attached get_call_name (l_as.message) as l_call_name then
								a_variable_usage.force (l_as.target.access_name_8 + once "." + l_call_name)
							else
								a_variable_usage.force (l_as.target.access_name_8)
							end
						end
					end (?, a_context, Result)
				)

			a_ast.process (l_identifier_usage_finder)
		end

	get_call_name (a_as: CALL_AS): STRING
			-- Returns the feature name of a call.
		do
			fixme ("Re-check if all cases are handled.")
			-- CALL_AS
			----ACCESS_AS
			----CREATION_EXPR_AS
			----NESTED_AS
			----NESTED_EXPR_AS

			if attached {ACCESS_AS} a_as as l_as then
				Result := l_as.access_name_8
			elseif attached {NESTED_AS} a_as as l_as then
				Result := l_as.target.access_name_8
			end
		end

end
