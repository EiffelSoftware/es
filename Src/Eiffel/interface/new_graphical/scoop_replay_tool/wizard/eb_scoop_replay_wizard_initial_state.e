note
	description: "Initial State for the SCOOP record-replay wizard."
	author: "Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_REPLAY_WIZARD_INITIAL_STATE

inherit
	EB_WIZARD_INITIAL_STATE_WINDOW
		redefine
			display,
			proceed_with_current_info
		end

	EB_CONSTANTS
		export
			{NONE} all
		end

	EB_SCOOP_REPLAY_WIZARD_SHARED_INFORMATION
	export
		{NONE} all
	end

create
	make

feature -- basic Operations

	display
		do
			first_window.set_initial_state
			build
		end

	proceed_with_current_info
		do
			information.build_file_items
			if information.runs_field /= Void and then information.runs_field.count > 0 then
				proceed_with_new_state(create {EB_SCOOP_REPLAY_WIZARD_SELECT_STATE}.make (wizard_information))
			else
				proceed_with_new_state (create {EB_SCOOP_REPLAY_WIZARD_DIRECTORY_ERROR_STATE}.make (wizard_information))
			end
		end

	display_state_text
			-- Dispay the text for the current state.
		do
			title.set_text (Interface_names.wt_SCOOP_replay_wizard_welcome)
			message.set_text (Interface_names.wb_SCOOP_replay_wizard_welcome)
		end

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
