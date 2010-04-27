note
	description: "[
					Roundtrip visitor to analyze postconditions. Differentiate between immediate postcondition, non-separate postcondition, and separate postcondition.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_POSTCONDITION_VISITOR

inherit
	SCOOP_CLIENT_ASSERTION_EXPR_VISITOR
		rename
			analyze_assertion_list as analyze_postcondition
		redefine
			analyze_postcondition,
			evaluate_current_assertion,
			update_current_level_with_call
		end

create
	make,
	make_with_default_context

feature -- Access

	analyze_postcondition (a_postcondition: ASSERT_LIST_AS; a_formal_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Analyze each assertion in 'a_postcondition' one by one using 'a_formal_arguments' and store the result in 'postconditions'.
		do
			Precursor (a_postcondition, a_formal_arguments)
			create postconditions.make
			if attached {ENSURE_AS} a_postcondition as l_ensure_as then
				last_index := l_ensure_as.ensure_keyword_index
			end
			safe_process (a_postcondition)
		ensure then
			a_postcondition_is_analyzed: postconditions /= void
		end

	postconditions: SCOOP_CLIENT_POSTCONDITIONS
		-- The analyzed postcondition.

feature {NONE} -- Implementation

	evaluate_current_assertion
			-- Do the differentatiation.
		do
			if current_assertion.is_containing_old_or_result then
				-- The current assertion contains an old or a result keyword.
				postconditions.immediate_postconditions.extend (current_assertion)
			elseif current_assertion.is_containing_non_separate_calls then
				-- The current assertion contains non-separate calls.
				postconditions.non_separate_postconditions.extend (current_assertion)
			elseif current_assertion.is_containing_separate_calls then
				-- The current assertion contains only separate calls..
				postconditions.separate_postconditions.extend (current_assertion)
			else
				-- The current assertion contains only literals.
				postconditions.non_separate_postconditions.extend (current_assertion)
			end
		end

	update_current_level_with_call (l_as: CALL_AS)
			-- Analyze 'l_as'. If the call is an access to a formal argument then count the number of times the formal argument appears in the current assertion.
		do
			Precursor (l_as)

			-- Check whether the call is an access to a separate formal argument.
			if
				not previous_level_exists and then
				attached {ACCESS_AS} l_as as l_access_as and then
				formal_arguments.is_separate_argument (l_access_as.access_name)
			then
				-- The call is an access to a separate formal argument.
				feature_object.arguments.count_separate_argument (l_access_as.access_name)
			end
		end

note
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

end -- class SCOOP_CLIENT_POSTCONDITION_VISITOR
