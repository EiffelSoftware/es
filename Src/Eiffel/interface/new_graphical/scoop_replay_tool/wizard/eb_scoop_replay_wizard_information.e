note
	description: "Information entered so far by the user in the SCOOP replay wizard"
	author: "Rusakov Andrey"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_REPLAY_WIZARD_INFORMATION

inherit
	EB_WIZARD_INFORMATION

	PROJECT_CONTEXT
		export
			{NONE} all
		end

	SYSTEM_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature  {NONE} -- Initialization

	make
		do
			directory_name := generation_path
		end

feature -- Access

	directory_name: STRING
		-- Path where record-replay ".sls" files located.

	file_name: STRING
		-- Name for selected record-replay file.

	runs_field: EV_COMBO_BOX
			-- Runs select field

	is_record_mode: BOOLEAN
		-- Is scoop execution recording mode turned on?

	set_file_name ( a_name: STRING )
			-- Set name for replay file.
		do
			file_name := a_name
		end

	set_is_record_mode (b: BOOLEAN)
			-- Activate record mode while replaying.
		do
			is_record_mode := b
		end

	build_file_items
			-- Read list of scoop replay files from default directory.
		local
			l_directory: DIRECTORY
			l_item: EV_LIST_ITEM
		do
			create l_directory.make ( directory_name )
			if l_directory.exists and then not l_directory.is_empty and then l_directory.is_readable then
				create runs_field
				runs_field.disable_edit
				l_directory.open_read
				from
					l_directory.start
					l_directory.readentry
				until
					l_directory.lastentry = Void
				loop
					if l_directory.lastentry.substring_index ("." + {SCOOP_LIBRARY_CONSTANTS}.REPLAY_file_extension, 1) = l_directory.lastentry.count - {SCOOP_LIBRARY_CONSTANTS}.REPLAY_file_extension.count then
						create l_item.make_with_text ( l_directory.lastentry )
						l_item.set_data (create {DIRECTORY_NAME}.make_from_string (l_directory.lastentry))
						runs_field.extend (l_item)
					end
					l_directory.readentry
				end
				l_directory.close
			end
		end

feature -- Implementation

	generation_path: STRING
			-- Generation path for logical schedule files.
		do
			Result := project_location.target_path + operating_environment.directory_separator.out +
						{SCOOP_LIBRARY_CONSTANTS}.REPLAY_directory_name
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
