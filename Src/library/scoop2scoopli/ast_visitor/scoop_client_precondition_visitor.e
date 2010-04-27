note
	description: "[
					Roundtrip visitor to analyze preconditions. Differentiate between separate and non-separate precondition.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_PRECONDITION_VISITOR

inherit
	SCOOP_CLIENT_ASSERTION_EXPR_VISITOR
		rename
			analyze_assertion_list as analyze_precondition
		redefine
			analyze_precondition,
			evaluate_current_assertion
		end

create
	make,
	make_with_default_context

feature -- Access

	analyze_precondition (a_precondition: ASSERT_LIST_AS; a_formal_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Analyze each assertion in 'a_precondition' one by one using 'a_formal_arguments' and store the result in 'preconditions'.
		do
			Precursor (a_precondition, a_formal_arguments)
			create preconditions.make
			if attached {REQUIRE_AS} a_precondition as l_require_as then
				last_index := l_require_as.require_keyword_index
			end
			safe_process (a_precondition)
		ensure then
			a_precondition_is_analyzed: preconditions /= void
		end

	preconditions: SCOOP_CLIENT_PRECONDITIONS
		-- The analyzed precondition.

feature {NONE} -- Implementation

	evaluate_current_assertion
			-- Do the differentiation.
		do
			if current_assertion.is_containing_separate_calls then
				-- assertion contains separate calls.
				preconditions.wait_conditions.extend (current_assertion)
			else
				-- assertion contains no separate call
				preconditions.non_separate_preconditions.extend (current_assertion)
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

end -- class SCOOP_CLIENT_PRECONDITION_VISITOR
