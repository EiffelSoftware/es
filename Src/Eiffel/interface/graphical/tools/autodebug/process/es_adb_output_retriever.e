note
	description: "Summary description for {ES_ADB_TESTING_RESULT_PARSER_THREAD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_OUTPUT_RETRIEVER

inherit
	ES_ADB_ROTA_TASK
		redefine
			start
		end

create
	make

feature{NONE} -- Initialization

	make (a_task: ES_ADB_PROCESS_SEQUENCE)
			-- Initialization.
		require
			a_task /= Void
		do
			task := a_task
			output_buffer := task.output_buffer
			output_buffer.set_active (True)
			should_terminate := False
			create on_start_actions
			create on_terminate_actions
			create output_parser.make
		end

feature -- Access

	task: ES_ADB_PROCESS_SEQUENCE
			-- Task whose output needs forwarding.

	output_parser: ES_ADB_PROCESS_OUTPUT_PARSER
			-- Object to parse the output.

	should_terminate: BOOLEAN
			-- Should terminate forwarding?

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>
		do
			Result := not should_terminate and then (task.has_next_step or else not output_buffer.is_empty)
		end

feature

	terminate, cancel
			-- <Precursor>
		do
			task.cancel

			step	-- Forward the new output since last step.
			output_buffer.set_active (False)
			task.on_terminate_actions.prune (agent on_terminate_actions.call (Void))

			should_terminate := True
		end

	start
			-- <Precursor>
		do
			Precursor
			task.on_terminate_actions.extend (agent on_terminate_actions.call (Void))
			task.start
		end

	step
			-- <Precursor>
		local
			l_lines: DS_LIST [STRING]
			l_cursor: DS_LIST_CURSOR [STRING]
		do
			l_lines := output_buffer.retrieve_and_clear
			from
				l_cursor := l_lines.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				info_center.on_output (l_cursor.item)
				if task.should_output_be_parsed then
					output_parser.parse (l_cursor.item)
				end
				l_cursor.forth
			end
		end

note
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
