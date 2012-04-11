indexing
	description: "Summary description for {DESERIALIZATION_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_DESERIALIZATION_HANDLER

inherit
	ES_EBBRO_PERSISTENCE_CONSTANTS

create
	make

feature -- Creation

	make (a_controller:ES_EBBRO_CONTROLLER) is
			-- creation feature
		require
			controller_not_void: a_controller /= Void
		do
			create binary_deserializer.make
			binary_deserializer.initialization (a_controller)
			create dadl_deserializer.make
			dadl_deserializer.initialization (a_controller)

			a_controller.open_file_actions.extend ( agent on_user_file_open(?,?))
			a_controller.open_multiple_files_actions.extend(agent on_multiple_file_open(?))

		end


feature -- Access

feature {NONE} -- Implementation

	binary_deserializer: ES_EBBRO_BINARY_DESERIALIZER
		-- deserializer for objects stored with the eiffel independent store mechanism

	dadl_deserializer: ES_EBBRO_DADL_DESERIALIZER
		-- deserializer for objects stored in DADL


	on_user_file_open(file_name,file_path:STRING) is
			-- user request to decode a object stored in file
		require
			not_void: file_name /= void and file_path /= void
		do
			if file_name.ends_with (dadl_file_ending) then
				dadl_deserializer.on_user_file_open (file_name, file_path)
			else
				binary_deserializer.on_user_file_open (file_name, file_path)
			end


		end

	on_multiple_file_open(a_list:ARRAYED_LIST[STRING]) is
			-- user request to open multiple files
		require
			not_void: a_list /= void
			valid: not a_list.is_empty
		do
			from
				a_list.start
			until
				a_list.after
			loop
				on_user_file_open (a_list.item, create {STRING}.make_empty)
				a_list.forth
			end
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
