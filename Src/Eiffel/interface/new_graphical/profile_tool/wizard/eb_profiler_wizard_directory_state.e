note
	description: "State to select directory for scoop profile."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_PROFILER_WIZARD_DIRECTORY_STATE

inherit
	EB_WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			update_state_information,
			proceed_with_current_info,
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
		do
			create directory_field.make (Current)
			directory_field.enable_directory_browse_button
			directory_field.set_text (information.scoop_profile_path.out)
			directory_field.set_starting_directory (information.scoop_profile_path.out)
			directory_field.generate

				-- Link
			choice_box.extend (directory_field.widget)
			choice_box.disable_item_expand (choice_box.last)
			choice_box.extend (create {EV_CELL})
		end

	proceed_with_current_info
			-- Proceed with current info.
		local
			next_state: EB_WIZARD_STATE_WINDOW
		do
			if information.directory_name /= Void then
				next_state := create {EB_PROFILER_WIZARD_RUNS_STATE}.make (wizard_information)
			else
				next_state := create {EB_PROFILER_WIZARD_DIRECTORY_ERROR_STATE}.make (wizard_information)
			end

			proceed_with_new_state (next_state)
		end

	update_state_information
			-- Check User Entries.
		do
			Precursor
			if is_supplied_directory_valid then
				information.set_directory_name (create {DIRECTORY_NAME}.make_from_string (directory_field.text))
			end
		end

feature {NONE} -- Implementation

	display_state_text
			-- Display state text.
		do
			title.set_text (interface_names.wt_Profile_Directory)
			subtitle.set_text (interface_names.ws_Profile_Directory)
			message.set_text (interface_names.wb_Profile_Directory)
		end

	is_supplied_directory_valid: BOOLEAN
			-- Does supplied directory contain scoop profile data?
		local
			l_name: STRING
			l_directory: DIRECTORY
		do
			l_name := directory_field.text
			if l_name.is_empty then
				Result := False
			else
				create l_directory.make (l_name)
				Result := l_directory.exists and then l_directory.is_readable
			end
		end

	directory_field: EB_WIZARD_SMART_TEXT_FIELD
			-- Directory browse field

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
