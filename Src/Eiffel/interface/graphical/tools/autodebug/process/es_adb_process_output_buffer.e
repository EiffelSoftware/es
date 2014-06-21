note
	description: "Summary description for {ES_ADB_EXTERNAL_PROCESS_OUTPUT_BUFFER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_PROCESS_OUTPUT_BUFFER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization
		do
			create guard.make
			create buffer_storage.make_equal
			set_active (False)
		end

feature -- Access

	buffer_storage: DS_LINKED_LIST [STRING]
			-- Buffer storage.

	is_active: BOOLEAN assign set_active
			-- Is current actively storing the output?

	guard: MUTEX
			-- Mutex to guard the access to `buffer_storage'.

feature{ES_ADB_OUTPUT_RETRIEVER} -- Set status

	set_active (a_flag: BOOLEAN)
		do
			is_active := a_flag
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is current empty?
		do
			guard.lock
			Result := buffer_storage.is_empty
			guard.unlock
		end

feature -- Input/output

	store (a_output: STRING)
			-- Store `a_output' into current.
			-- `a_output' may contain multiple lines of text,
			-- and the text is stored into `buffer_storage' line by line.
		require
			a_output /= Void
		do
			guard.lock
			if is_active then
				buffer_storage.force_last (a_output)
			end
			guard.unlock
		end

	wipe_out
			-- Wipe out the existing output.
		do
			guard.lock
			buffer_storage.wipe_out
			guard.unlock
		end

	retrieve_and_clear: DS_LIST [STRING]
			-- Return the list of all the lines currently in `buffer_storage',
			-- and then clear all existing lines.
		do
			guard.lock
			Result := buffer_storage
			create buffer_storage.make_equal
			guard.unlock
		ensure
			Result /= Void
		end

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
