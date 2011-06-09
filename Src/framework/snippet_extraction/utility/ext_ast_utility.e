note
	description: "Helper functions for snippet extraction AST processing."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_UTILITY

feature {NONE} -- Helper

	is_ast_eiffel_using_variable_of_interest (a_as: AST_EIFFEL; a_variable_context: EXT_VARIABLE_CONTEXT): BOOLEAN
			-- AST iterator processing `a_as' answering if a variable of interest is used in that AST.
		local
			l_variable_usage: LINKED_SET [STRING]
			l_variable_usage_finder: EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE
		do
				-- Set up callback to track variable usage in arguments.
			create l_variable_usage.make

			create l_variable_usage_finder
			l_variable_usage_finder.set_is_mode_disjoint (False)
			l_variable_usage_finder.set_on_access_identifier (
				agent (l_as: ACCESS_AS; a_variable_ctx: EXT_VARIABLE_CONTEXT; a_variable_usage: LINKED_SET [STRING])
					do
						if a_variable_ctx.is_variable_of_interest (l_as.access_name_8) then
							a_variable_usage.force (l_as.access_name_8)
						end
					end (?, a_variable_context, l_variable_usage)
			)

			a_as.process (l_variable_usage_finder)

			Result := not l_variable_usage.is_empty
		end

	is_expr_as_clean (a_as: EXPR_AS; a_variable_context: EXT_VARIABLE_CONTEXT): BOOLEAN
			-- AST iterator processing `a_as' answering if that expression can stay as it is.
		local
			l_variable_usage: LINKED_SET [STRING]
			l_variable_usage_finder: EXT_IDENTIFIER_USAGE_CALLBACK_SERVICE
		do
				-- Set up callback to track variable usage in arguments.
			create l_variable_usage.make

			create l_variable_usage_finder
			l_variable_usage_finder.set_is_mode_disjoint (False)
			l_variable_usage_finder.set_on_access_identifier (
				agent (l_as: ACCESS_AS; a_variable_ctx: EXT_VARIABLE_CONTEXT; a_variable_usage: LINKED_SET [STRING])
					do
						if not a_variable_ctx.is_variable_of_interest (l_as.access_name_8) then
							a_variable_usage.force (l_as.access_name_8)
						end
					end (?, a_variable_context, l_variable_usage)
			)

			a_as.process (l_variable_usage_finder)

			Result := l_variable_usage.is_empty
		end

end
