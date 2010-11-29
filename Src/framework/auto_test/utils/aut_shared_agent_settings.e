note
	description: "Objects having access to the singleton agent_settings."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SHARED_AGENT_SETTINGS

create
	make

feature {AUT_SHARED_AGENT_SETTINGS} -- Initialisation

	make
			-- Do nothing
		do
		ensure
			no_agents_unset: execute_no_agent_features = False
			only_agents_unset: execute_only_agent_features = False
		end

feature -- Singleton

	agent_settings: AUT_SHARED_AGENT_SETTINGS
			-- Create the singleton and return it
		once
			create Result.make
		ensure
			not_void: Result /= Void
		end

feature {AUT_SHARED_AGENT_SETTINGS} -- Access

	execute_no_agent_features: BOOLEAN
			-- Should features with agent arguments not be processed?

	execute_only_agent_features: BOOLEAN
			-- Should only features with agent arguments be processed?

feature {AUT_SHARED_AGENT_SETTINGS} -- Change

	toggle_no_agents
			-- Toggle the `execute_no_agent_features' attribute
		require
			not_both: not execute_no_agent_features implies not execute_only_agent_features
		do
			execute_no_agent_features := not execute_no_agent_features
		ensure
			toggled: execute_no_agent_features = not old execute_no_agent_features
		end

	toggle_only_agents
			--Toggle the `execute_only_agent_features' attribute
		require
			not_both: not execute_only_agent_features implies not execute_no_agent_features
		do
			execute_only_agent_features := not execute_only_agent_features
		ensure
			toggled: execute_only_agent_features = not old execute_only_agent_features
		end

invariant
	not_both: not (execute_no_agent_features and execute_only_agent_features)

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
