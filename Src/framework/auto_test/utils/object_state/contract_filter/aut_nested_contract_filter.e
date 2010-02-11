note
	description: "Summary description for {AUT_NESTED_CONTRACT_FILTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_NESTED_CONTRACT_FILTER

inherit
	AUT_CONTRACT_FILTER

	AST_ITERATOR
		redefine
			process_nested_as
		end

feature -- Status report

	is_assertion_satisfied (a_assertion: AUT_ASSERTION; a_context_class: CLASS_C): BOOLEAN is
			-- Is `a_assertion' valid in `a_context_class'?
			-- An assertion is valid if is suitable to generate proof obligation from it.
		do
			is_last_assertion_satisfied := False
			a_assertion.tag.process (Current)
			Result := is_last_assertion_satisfied
			if Result and then on_simple_assertion_found_agent /= Void then
				on_simple_assertion_found_agent.call ([a_assertion])
			end
		end

feature -- Access

	on_simple_assertion_found_agent: PROCEDURE [ANY, TUPLE [AUT_ASSERTION]]
			-- Agent to be performed if an assertion satisfying the criterion defined in Current is found.

feature -- Setting

	set_on_simple_assertion_found_agent (a_agent: like on_simple_assertion_found_agent) is
			-- Set `on_simple_assertion_found_agent' with `a_agent'.
		do
			on_simple_assertion_found_agent := a_agent
		ensure
			on_simple_assertion_found_agent_set: on_simple_assertion_found_agent = a_agent
		end

feature{NONE} -- Implementation

	is_last_assertion_satisfied: BOOLEAN
			-- Does last analyzed assertion satisfy the Current criterion?

feature{NONE} -- Process

	process_nested_as (l_as: NESTED_AS)
		do
			is_last_assertion_satisfied := True
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
