note
	description: "State for selecting .sls file for replay."
	author: "Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_REPLAY_WIZARD_SELECT_STATE

inherit
	EB_WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			update_state_information,
			proceed_with_current_info,
			build
		end

	EB_SCOOP_REPLAY_WIZARD_SHARED_INFORMATION
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
			if information.runs_field /= Void then
				choice_box.extend (information.runs_field)
				choice_box.disable_item_expand (choice_box.last)
				choice_box.extend (create {EV_CELL})
			end

			create use_record_mode.make_with_text ("Use SCOOP Execution Recording")

			if information.is_record_mode then
				use_record_mode.enable_select
			else
				use_record_mode.disable_select
			end

			create record_check_box
			record_check_box.set_border_width (Default_border_size)
			record_check_box.extend (use_record_mode)

			choice_box.extend (record_check_box)
			choice_box.disable_item_expand (record_check_box)
			choice_box.extend (create {EV_CELL})
		end

	proceed_with_current_info
			-- Proceed with current info.
		local
			next_state: EB_WIZARD_STATE_WINDOW
		do
			if information.file_name = Void then
				next_state := create {EB_SCOOP_REPLAY_WIZARD_FILE_ERROR_STATE}.make (wizard_information)
			else
				next_state := create {EB_SCOOP_REPLAY_WIZARD_FINAL_STATE}.make (wizard_information)
			end

			proceed_with_new_state (next_state)
		end

	update_state_information
			-- Check User Entries.
		do
			Precursor
			if is_supplied_file_valid then
				if attached {DIRECTORY_NAME} information.runs_field.selected_item.data as t_name then
					information.set_file_name ( t_name )
				else
					information.set_file_name (Void)
				end
			else
				information.set_file_name (Void)
			end

			information.set_is_record_mode (use_record_mode.is_selected)
		end

feature {NONE} -- Implementation

	display_state_text
			-- Display state text.
		do
			title.set_text (interface_names.wt_SCOOP_replay_wizard_runs)
			subtitle.set_text (interface_names.ws_SCOOP_replay_wizard_runs)
			message.set_text (interface_names.wb_SCOOP_replay_wizard_runs)
		end

	is_supplied_file_valid: BOOLEAN
			-- Does supplied .sls file contain scoop record-replay data?
		local
			l_name: DIRECTORY_NAME
			l_file: RAW_FILE
		do
			if attached {DIRECTORY_NAME} information.runs_field.selected_item.data as t_name and then t_name /= Void then
				l_name := t_name
				create l_file.make (information.directory_name + operating_environment.directory_separator.out + l_name)
				if not l_file.exists then
					Result := False
				else
					l_file.open_read
					l_file.start
					l_file.read_word
					if l_file.last_string.is_equal ({SCOOP_LIBRARY_CONSTANTS}.REPLAY_file_header) then
						Result := True
					else
						Result := False
					end
					l_file.close
				end
			end
		end

feature
	record_check_box: EV_VERTICAL_BOX
	use_record_mode: EV_CHECK_BUTTON
		-- Check button Use SCOOP execution recording mode while replay?

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
