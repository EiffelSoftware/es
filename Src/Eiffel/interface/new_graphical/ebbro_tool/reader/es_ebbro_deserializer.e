indexing
	description: "A deserializer which deserializes objects."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_EBBRO_DESERIALIZER

inherit
	ES_EBBRO_PERSISTENCE_CONSTANTS

feature -- init

	initialization(a_controller:ES_EBBRO_CONTROLLER) is
			-- establishes set up with controller and registers for actions
		require
			not_void: a_controller /= void
		do
			controller := a_controller
			--controller.open_file_actions.extend ( agent on_user_file_open(?, ?))
		end

feature -- Access

	last_decoded_object:ES_EBBRO_DISPLAYABLE
			-- object which was decoded

feature -- Status report

	has_error:BOOLEAN
			-- error occurred

	error_message:STRING
			-- error message

	has_information:BOOLEAN
			-- information, wrong usage etc.

	info_message:STRING
			-- message which indicates further notice to user

feature -- controller

	controller:ES_EBBRO_CONTROLLER
			-- controller who is connection to gui

feature -- Basic operations


	retrieve_object(a_medium:IO_MEDIUM) is
			-- retrieve an object and store it in last decoded object.
		require
			not_void: a_medium /= void
		deferred
		end

	clean_up is
			-- clean up for next decoding of object
		do
			has_error := false
			has_information := false
			error_message := void
			info_message := void
		end

feature -- actions

	on_user_file_open(file_name,file_path:STRING) is
			-- user request to decode a object stored in file
		require
			not_void: file_name /= void and file_path /= void
		deferred
		end

	on_object_decoded is
			-- object decoded
		require
			not_void: last_decoded_object /= void
		do
			controller.object_decoded_actions.call ([last_decoded_object])
		end

	on_decode_error is
			-- error while decoding object
		require
			error: has_error
			not_void: error_message /= void
		do
			controller.decoding_error_actions.call([error_message])
		end

	on_information is
			-- decode facility has information for user - event to display it
		require
			info: has_information
			not_void: info_message /= void
		do
			controller.information_actions.call ([info_message])
		end




feature {NONE} -- Implementation constants

	default_error_string:STRING is "Error while trying to decode object...%NMake sure you selected a file which contains a supported object type."


;indexing
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
