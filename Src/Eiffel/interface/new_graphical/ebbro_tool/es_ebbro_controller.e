indexing
	description: "The glue between the GUI and the READER"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_CONTROLLER

create
	make

feature -- creation

	make is
			-- init controller
		local
			l_deserialization_handler: ES_EBBRO_DESERIALIZATION_HANDLER
			l_encode_facility: ES_EBBRO_ENCODE_FACILITY
		do
			init_actions

			create l_deserialization_handler.make (current)

			create l_encode_facility.make(current)

		end


feature -- establishment

	set_window(a_window:ES_EBBRO_TOOL_PANEL) is
			-- sets the main window
		require
			not_void: a_window /= void
		do
			ebbro_tool_panel := a_window
		end


feature -- action data

	open_file_data:TUPLE[STRING,STRING] -- (file_name,file_path)

	open_multiple_files_data:TUPLE[ARRAYED_LIST[STRING]] -- list of file_names

	object_decoded_data:TUPLE[ES_EBBRO_DISPLAYABLE]

	decoding_error_data:TUPLE[STRING] -- error msg

	information_data:TUPLE[STRING] -- information for user (usage, etc...)

	-----------TODO: clean up, implement
	encoding_object_data: TUPLE[ANY,INTEGER, STRING, STRING] -- the object to be serialized back to file. (object,format_id,filename, filepath)

	encoding_error_data: TUPLE[STRING] -- error message


feature -- actions

	open_file_actions: ACTION_SEQUENCE [like open_file_data]
			-- actions on opening a file

	open_multiple_files_actions: ACTION_SEQUENCE [like open_multiple_files_data]
			-- actions on opening multiple files

	object_decoded_actions:ACTION_SEQUENCE [like object_decoded_data ]
			-- actions on object decoded

	decoding_error_actions:ACTION_SEQUENCE [like decoding_error_data]
			-- actions for error

	information_actions:ACTION_SEQUENCE [like information_data ]
			-- actions for information

	encoding_object_actions: ACTION_SEQUENCE [like encoding_object_data]
			-- actions for encoding objects

	encoding_error_actions: ACTION_SEQUENCE[like encoding_error_data]




feature -- GUI

	ebbro_tool_panel:ES_EBBRO_TOOL_PANEL
			-- main window of application

feature {NONE} -- implementation

	init_actions is
			-- creates all actions sequences
		do
			create open_file_actions
			create open_multiple_files_actions
			create object_decoded_actions
			create decoding_error_actions
			create information_actions
			create encoding_object_actions
			create encoding_error_actions
		end

indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
