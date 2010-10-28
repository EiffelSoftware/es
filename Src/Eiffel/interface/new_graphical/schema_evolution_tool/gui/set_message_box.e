note
	description: "The message box where all the messages are displayed."
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SET_MESSAGE_BOX
		inherit
			EV_TEXT
		export
		 	{NONE} all
		 end

	create
		make

feature -- Status

	messages: SET_STATUS_MESSAGES

feature -- Creation

	make
			-- Create window.
		do
			default_create
			disable_edit
			enable_word_wrapping
			create messages
		end

feature -- Operation on messages.

	print_message (txt: STRING)
			-- Print a single text message.
		do
			append_text ("* " + txt + "%N")
		end

	print_messages (msgs: DS_ARRAYED_LIST[STRING])
			-- Print more messages.
		do
			from msgs.start until msgs.after loop
				print_message (msgs.item_for_iteration)
				msgs.forth
			end

		end

	print_release (release_path: STRING)
			-- Print the release message.
		do
			print_message (messages.release (release_path))
		end

	print_handlers_dir_creation (name: STRING)
			-- Print the message for the creation of the handlers dir. NOTE: this is not used
		do
			print_message (messages.main_handler_dir_creation (name))
		end

	print_repo_handlers_dir_creation (name:STRING)
			-- Print the message for the creation of the handlers dir in the repo. NOTE: this is not used
		do
			print_message (messages. repo_handlers_dir_creation (name))
		end

	print_handler_released (path:STRING)
			-- Print the message for the handler release.
		do
			print_message (messages.handler_released (path))
		end

	print_handler_folder_not_found
			-- Print the message for when the handlers folder has not been found.
		do
			print_message (messages.handler_folder_not_found)
		end

	print_main_handler_created (path: STRING)
			-- Print the message for when the handler class has been created.
		do
			print_message (messages.main_handler_created(path))
		end

	print_config_file_not_found
			-- Print the message for when the configuration file has not been found.
		do
			print_message (messages.config_file_not_found)
		end

	print_main_filter_dir_created (name: STRING)
			-- Print the message for when the filter dir has been created.
		do
			print_message (messages.main_filter_dir_created(name))
		end

	print_not_enough_releases
			-- Print the message for when there are not enough releases to create a schema evolution handler.
		do
			print_message (messages.not_enough_releases)
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
