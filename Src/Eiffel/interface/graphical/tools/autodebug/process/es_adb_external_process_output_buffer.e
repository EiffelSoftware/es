note
	description: "Summary description for {ES_ADB_EXTERNAL_PROCESS_OUTPUT_BUFFER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_EXTERNAL_PROCESS_OUTPUT_BUFFER

create
	make

feature{NONE} -- Initialization

	make
			-- Initialization
		do
			create guard.make
			create buffer_storage.make_equal (1024)
			pending_line := ""
		end

feature -- Access

	buffer_storage: DS_ARRAYED_LIST [STRING]
			-- Buffer storage.

	guard: MUTEX
			-- Mutex to guard the access to `buffer_storage'.

feature -- Input/output

	store (a_output: STRING)
			-- Store `a_output' into current.
			-- `a_output' may contain multiple lines of text,
			-- and the text is stored into `buffer_storage' line by line.
		require
			a_output /= Void
		local
			l_lines: LIST [STRING]
			l_whole_lines: STRING
			l_cursor: INDEXABLE_ITERATION_CURSOR [STRING]
			l_EOL_position: INTEGER
		do
			-- TODO: finer-grained locking
			guard.lock

			if a_output.has ('%N') then
					-- At least one line is complete now.

					-- Prepend `pending_line', store the comleted lines,
					-- and save the new pending line into `pending_line'.
				l_whole_lines := pending_line + a_output
				l_EOL_position := l_whole_lines.last_index_of ('%N', l_whole_lines.count)
				pending_line := l_whole_lines.substring (l_EOL_position + 1, l_whole_lines.count)
				l_whole_lines := l_whole_lines.substring (1, l_EOL_position - 1)
				l_whole_lines.prune_all ('%R')

					-- Store the output line-by-line.
				l_lines := l_whole_lines.split ('%N')
				l_lines.do_all (agent buffer_storage.force_last)
			else
					-- Line not complete yet.
				pending_line.append (a_output)
			end

			guard.unlock
		end

	wrap_up
			-- Wrap up the existing output for `retrieve_and_clear'.
		do
			guard.lock

			if not pending_line.is_empty then
				buffer_storage.force_last (pending_line)
				pending_line := ""
			end

			guard.unlock
		end

	retrieve_and_clear: DS_LIST [STRING]
			-- Return the list of all the lines currently in `buffer_storage',
			-- and then clear all existing lines.
		do
			guard.lock

			Result := buffer_storage.twin
			buffer_storage.wipe_out

			guard.unlock
		ensure
			Result /= Void
		end

feature{NONE} -- Internal access

	pending_line: STRING
			-- Output line that is not finished yet.

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
