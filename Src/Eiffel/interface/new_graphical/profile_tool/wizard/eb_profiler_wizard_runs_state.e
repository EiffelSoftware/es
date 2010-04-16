note
	description: "State to select between different profiler runs."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_PROFILER_WIZARD_RUNS_STATE

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
		local
			l_item: EV_LIST_ITEM
			l_directory: DIRECTORY
		do
			create runs_field
			runs_field.disable_edit
			from
				create l_directory.make_open_read (information.directory_name.out)
				l_directory.start
				l_directory.readentry
			until
				l_directory.lastentry = Void
			loop
				if l_directory.lastentry.is_integer then
					create l_item.make_with_text ((create {DATE_TIME}.make_from_epoch (l_directory.lastentry.to_integer)).out)
					l_item.set_data (create {DIRECTORY_NAME}.make_from_string (information.directory_name.out + operating_environment.directory_separator.out + l_directory.lastentry))
					runs_field.extend (l_item)
				elseif not l_directory.lastentry.starts_with (".") then
					create l_item.make_with_text (l_directory.lastentry)
					l_item.set_data (create {DIRECTORY_NAME}.make_from_string (information.directory_name.out + operating_environment.directory_separator.out + l_directory.lastentry))
					runs_field.extend (l_item)
				end
				l_directory.readentry
			end
			l_directory.close

				-- Link
			choice_box.extend (runs_field)
			choice_box.disable_item_expand (choice_box.last)
			choice_box.extend (create {EV_CELL})
		end

	proceed_with_current_info
			-- Proceed with current info.
		local
			next_state: EB_WIZARD_STATE_WINDOW
		do
			if information.loader /= Void then
				next_state := create {EB_PROFILER_WIZARD_OPTIONS_STATE}.make (wizard_information)
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
				information.set_loader (loader)
			end
		end

feature {NONE} -- Implementation

	display_state_text
			-- Display state text.
		do
			title.set_text (interface_names.wt_Profile_runs)
			subtitle.set_text (interface_names.ws_Profile_runs)
			message.set_text (interface_names.wb_Profile_runs)
		end

	is_supplied_directory_valid: BOOLEAN
			-- Does supplied directory contain scoop profile data?
		local
			l_name: DIRECTORY_NAME
			l_directory: DIRECTORY
		do
			if attached {DIRECTORY_NAME} runs_field.selected_item.data as t_name then
				l_name := t_name
				if l_name.is_empty then
					Result := False
				else
					create l_directory.make (l_name.out)
					if l_directory.exists and then l_directory.is_readable then
						-- Check for profile files
						create loader.make_with_directory (l_directory)
						Result := loader.min /= Void
					end
				end
			end
		end

	runs_field: EV_COMBO_BOX
			-- Runs select field

	loader: SCOOP_PROFILER_DEFAULT_LOADER
			-- Reference to the loader

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
