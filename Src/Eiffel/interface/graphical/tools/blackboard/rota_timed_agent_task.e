note
	description: "A timed task executing an agent in each iteration."
	date: "$Date$"
	revision: "$Revision$"

class
	ROTA_TIMED_AGENT_TASK

inherit

	ROTA_TIMED_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_action: like action; a_sleep_time: like sleep_time)
			-- Initialize task.
		require
			a_action_not_void: a_action /= Void
		do
			action := a_action
			sleep_time := a_sleep_time
			start
		ensure
			action_set: action = a_action
			sleep_time_set: sleep_time = a_sleep_time
			has_next_step: has_next_step
		end

feature -- Access

	action: PROCEDURE [ANY, TUPLE []]
			-- Procedure which is executed in each iteration.

	sleep_time: NATURAL
			-- <Precursor>

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

feature -- Basic operations

	start
			-- Start task.
		do
			has_next_step := True
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {ROTA_S, ROTA_TASK_I, ROTA_TASK_COLLECTION_I} -- Implementation

	step
			-- <Precursor>
		do
			action.call ([])
		end

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
