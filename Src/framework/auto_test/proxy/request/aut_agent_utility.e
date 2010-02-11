note
	description: "Summary description for {AUT_AGENT_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_AGENT_UTILITY [G]

feature -- Access

	ored_agents (a_agents: ARRAY [FUNCTION [ANY, TUPLE [G], BOOLEAN]]): FUNCTION [ANY, TUPLE [G], BOOLEAN] is
			-- Agent to ored result of agents in `a_agents'
		require
			a_agents_attached: a_agents /= Void
		do
			Result := agent (a_item: G; a_agts: ARRAY [FUNCTION [ANY, TUPLE [G], BOOLEAN]]): BOOLEAN
				local
					i: INTEGER
				do
					from
						i := a_agts.lower
					until
						i > a_agts.upper or else Result
					loop
						Result := a_agts.item (i).item ([a_item])
						i := i + 1
					end

				end
				(?, a_agents)
		ensure
			result_attached: Result /= Void
		end

	anded_agents (a_agents: ARRAY [FUNCTION [ANY, TUPLE [G], BOOLEAN]]): FUNCTION [ANY, TUPLE [G], BOOLEAN] is
			-- Agent to anded result of agents in `a_agents'
		require
			a_agents_attached: a_agents /= Void
		do
			Result := agent (a_item: G; a_agts: ARRAY [FUNCTION [ANY, TUPLE [G], BOOLEAN]]): BOOLEAN
				local
					i: INTEGER
				do
					Result := True
					from
						i := a_agts.lower
					until
						i > a_agts.upper or not Result
					loop
						Result := a_agts.item (i).item ([a_item])
						i := i + 1
					end

				end
				(?, a_agents)
		ensure
			result_attached: Result /= Void
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
