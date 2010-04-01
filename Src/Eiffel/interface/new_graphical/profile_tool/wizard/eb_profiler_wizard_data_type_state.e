note
	description: "Summary description for {EB_PROFILER_WIZARD_DATA_TYPE_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_PROFILER_WIZARD_DATA_TYPE_STATE

inherit
	EB_WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			proceed_with_current_info,
			update_state_information,
			build
		end

	EB_PROFILER_WIZARD_SHARED_INFORMATION
		export
			{NONE} all
		end

	EB_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature -- Basic Operation

	build
			-- Build entries.
		local
			program_type_radio_box: EV_VERTICAL_BOX
		do
				-- Radio buttons
			create type_normal.make_with_text (interface_names.l_profile_data_traditional)
			create type_scoop.make_with_text (interface_names.l_profile_data_scoop)
			create program_type_radio_box
			program_type_radio_box.set_border_width (Default_border_size)
			program_type_radio_box.extend (type_normal)
			program_type_radio_box.extend (type_scoop)

				-- Link
			choice_box.extend (program_type_radio_box)
			choice_box.disable_item_expand (program_type_radio_box)
			choice_box.extend (create {EV_CELL})

				-- Update info
			if information.scoop_type then
				type_scoop.enable_select
			else
				type_normal.enable_select
			end
		end

	proceed_with_current_info
			-- Proceed with current info.
		local
			next_state: EB_WIZARD_STATE_WINDOW
		do
			if type_normal.is_selected then
				next_state := create {EB_PROFILER_WIZARD_FIRST_STATE}.make (wizard_information)
			else
				next_state := create {EB_PROFILER_WIZARD_DIRECTORY_STATE}.make (wizard_information)
			end

			proceed_with_new_state (next_state)
		end

	update_state_information
			-- Update state information.
		do
			if type_normal.is_selected then
				information.set_normal_type
			else
				information.set_scoop_type
			end
		end

feature {NONE} -- Implementation

	display_state_text
			-- Display state text.
		do
			title.set_text (interface_names.wt_Data_type)
			subtitle.set_text (interface_names.ws_Data_type)
			message.set_text (interface_names.wb_Data_type)
		end

	type_normal, type_scoop: EV_RADIO_BUTTON
			-- Normal and scoop data radio button

invariant
	True

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
