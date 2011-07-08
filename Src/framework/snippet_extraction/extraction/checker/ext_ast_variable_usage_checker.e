note
	description: "Performs checks on an AST with respect to a given set of variable names."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_AST_VARIABLE_USAGE_CHECKER

inherit
	EXT_CHECKER

create
	make_from_variables

feature -- Initialization

	make_from_variables (a_variables: like variables)
		require
			attached a_variables
		do
			variables := a_variables

				-- Default agent.
			check_function := agent check_is_ast_using_variables
		end

feature -- Access

	passed_check: BOOLEAN
			-- The evaluation of the last iteration by this checker.

feature -- Basic Operations

	check_ast (a_ast: AST_EIFFEL)
			-- Checks if `a_ast' conforms to the specified checks and
			-- and makes the result of the check available in `passed_check'.
		do
			check_function.call([a_ast])
			passed_check := check_function.last_result
		end

feature {NONE} -- Implementation

	variables: DS_HASH_SET [STRING]

	check_function: FUNCTION [ANY, TUPLE [a_ast: AST_EIFFEL], BOOLEAN]
		assign set_check_function
			-- Callback to be executed within `check_ast'.

feature -- Agents / Check Functions

	set_check_function (a_agent: like check_function)
			-- Sets `check_function' to `a_agent'.
		do
			check_function := a_agent
		end

	check_is_ast_using_variables (a_ast: AST_EIFFEL): BOOLEAN
			-- AST iterator processing `a_ast' answering if any of `a_variables' is used in that AST.
		local
			l_access_as_list: LINKED_LIST [ACCESS_AS]
			l_variable_usage_finder: EPA_IDENTIFIER_USAGE_CALLBACK_ITERATOR
		do
			create l_access_as_list.make
			create l_variable_usage_finder
			l_variable_usage_finder.set_is_mode_disjoint (False)
			l_variable_usage_finder.set_on_access_identifier (agent l_access_as_list.force)

			a_ast.process (l_variable_usage_finder)

				-- Check 'SOME'
			Result := across l_access_as_list as l_cursor some variables.has (l_cursor.item.access_name_8) end
		end

	check_is_ast_using_no_other_variables (a_ast: AST_EIFFEL): BOOLEAN
			-- AST iterator processing `a_ast' answering if no other than `a_variables' are used in that AST.
		local
			l_access_as_list: LINKED_LIST [ACCESS_AS]
			l_variable_usage_finder: EPA_IDENTIFIER_USAGE_CALLBACK_ITERATOR
		do
			create l_access_as_list.make
			create l_variable_usage_finder
			l_variable_usage_finder.set_is_mode_disjoint (False)
			l_variable_usage_finder.set_on_access_identifier (agent l_access_as_list.force)

			a_ast.process (l_variable_usage_finder)

				-- Check 'ALL'
			Result := across l_access_as_list as l_cursor all variables.has (l_cursor.item.access_name_8) end
		end
end
