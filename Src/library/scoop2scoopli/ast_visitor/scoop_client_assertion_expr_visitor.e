note
	description: "[
					Roundtrip visitor to analyze assertions.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_CLIENT_ASSERTION_EXPR_VISITOR

inherit
	SCOOP_CLIENT_CONTEXT_AST_PRINTER
		redefine
			update_current_level_with_call,
			process_void_as,
			process_un_old_as,
			process_result_as,
			process_tagged_as,
			process_binary_as,
			process_create_creation_expr_as
		end

feature -- Access

	analyze_assertion_list (a_assertion_list: ASSERT_LIST_AS; a_formal_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Analyze each assertion in 'a_assertion_list' one by one using 'a_formal_arguments'. Store the result of each assertion in 'current_assertion', and then call 'evaluate_current_assertion' before the next assertion gets analyzed.
		require
			a_formal_arguments_is_valid: a_formal_arguments /= Void
		do
			formal_arguments := a_formal_arguments
		ensure
			formal_arguments_are_set: formal_arguments = a_formal_arguments
		end

	current_assertion: SCOOP_CLIENT_ASSERTION_OBJECT
			-- The current assertion.

feature {NONE} -- Implementation

	evaluate_current_assertion
			-- Evaluate the current assertion in 'current_assertion'.
		require
			current_assertion_is_valid: current_assertion /= void
		deferred
		end

	process_binary_as (l_as: BINARY_AS)
			-- Analyze 'l_as'.
			-- We need to override this because the precusor version reiterates over some expressions multiple times.
		do
			-- Process the left expression.
			safe_process (l_as.left)

			-- Process the right expression as an argument.
			add_levels_layer
			safe_process (l_as.right)
			remove_current_levels_layer
		end

	update_current_level_with_call (l_as: CALL_AS)
			-- Analyze 'l_as'. Remember whether the call is a call on a separate target or a non-separate target. If the call is an access to a separate formal argument then count the number of times the separate formal argument appears in the assertion list.
		do
			Precursor (l_as)

			-- Check whether the call is the first element of a call chain.
			if previous_level_exists then
				-- The call is not the first element of a call chain.
				-- Check whether the call is a call on a separate target.
				if previous_level.is_separate then
					-- The call is a call on a separate target.
					current_assertion.set_is_containing_separate_calls (True)
				else
					-- The call is a call on a non-separate target.
					current_assertion.set_is_containing_non_separate_calls (True)
				end
			else
				-- The call is the first element of a call chain.
				-- Check whether the call is a call on the current object, or an access to a separate formal argument.
				if
					{l_access_as: ACCESS_AS} l_as and then
					(
						class_c.feature_table.has (l_access_as.access_name) or
						class_c.feature_table.is_mangled_alias_name (l_access_as.access_name)
					)
				then
					-- The call is a call on the current object and thus it is a non-separate call.
					current_assertion.set_is_containing_non_separate_calls (True)
				elseif
					{l_access_as: ACCESS_AS} l_as and then
					formal_arguments.is_separate_argument (l_access_as.access_name)
				then
					-- The call is an access to a separate formal argument.
					current_assertion.count_separate_argument_occurrence (l_access_as.access_name)
				end
			end
		end

	process_void_as (l_as: VOID_AS)
			-- Analyze 'l_as'. Remember that there is a void keyword in the current assertion.
		do
			current_assertion.set_is_containing_void (True)
			Precursor(l_as)
		end

	process_un_old_as (l_as: UN_OLD_AS)
			-- Analyze 'l_as'. Remember that there is an old keyword in the current assertion.
		do
			current_assertion.set_is_containing_old_or_result (True)
			Precursor(l_as)
		end

	process_result_as (l_as: RESULT_AS)
			-- Analyze 'l_as'. Remember that there is a result keyword in the current assertion.
		do
			current_assertion.set_is_containing_old_or_result (True)
			Precursor(l_as)
		end

	process_tagged_as (l_as: TAGGED_AS)
			-- Analyse 'l_as', store the result in 'current_assertion', and call 'evaluate_current_assertion'.
		do
				-- create new assertion object - for each tagged_as one
			current_assertion := create {SCOOP_CLIENT_ASSERTION_OBJECT}.make

				-- set current tagged_as
			current_assertion.set_tagged_as(l_as)

				-- not interested in tag and colon symbol
			if l_as /= Void then
				last_index := l_as.colon_symbol_index
			end

				-- process only the expression
			safe_process (l_as.expr)

				-- evaluate the processed expression
			evaluate_current_assertion
		end

	process_create_creation_expr_as (l_as: CREATE_CREATION_EXPR_AS)
			-- Process `l_as'.
		do
			safe_process (l_as.create_keyword (match_list))
			safe_process (l_as.type)
			safe_process (l_as.call)
			update_current_level_with_call (l_as)
			if avoid_proxy_calls_in_call_chains then
				if current_level.type.is_separate then
					context.add_string ("." + {SCOOP_SYSTEM_CONSTANTS}.scoop_client_implementation)
					set_current_level_is_separate (false)
				end
			end

		end

	formal_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT
			-- The formal arguments.

;note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_CLIENT_ASSERTION_EXPR_VISITOR
