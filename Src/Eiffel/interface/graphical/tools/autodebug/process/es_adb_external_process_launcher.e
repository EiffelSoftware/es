note
	description: "Summary description for {ES_ADB_TESTING_PROCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_EXTERNAL_PROCESS_LAUNCHER

inherit
	THREAD
		rename
			make as make_thread
		end

create
	make

feature{NONE} -- Initialization

	make (a_external_processes: DS_ARRAYED_LIST [ES_ADB_PROCESS]; a_buffer: ES_ADB_EXTERNAL_PROCESS_OUTPUT_BUFFER)
			-- Initialization.
		require
			a_external_processes /= Void
			a_buffer /= Void
		do
			make_thread

			processes := a_external_processes.twin
			buffer := a_buffer

			create mutex.make
			create condition_variable.make
		end

feature -- Access

feature{NONE} -- Implementation access

	processes: DS_ARRAYED_LIST [ES_ADB_PROCESS]
			-- Processes to be launched by current.

	current_process: ES_ADB_PROCESS
			-- Process that is currently running.

	buffer: ES_ADB_EXTERNAL_PROCESS_OUTPUT_BUFFER
			-- Buffer to collect outputs from `processes'.

	mutex: MUTEX
			-- Mutex for mutual exclusive access.

	condition_variable: CONDITION_VARIABLE
			-- Condition variable for coordinate process starts and ends.

feature -- Operation

	execute
			-- <Precursor>
		do
			from
			until
				processes.is_empty
			loop
				current_process := processes.first
				processes.remove_first

				buffer.wrap_up
				on_process_output ("%N>> Start: " + current_process.command_line + "%N")

				current_process.set_exit_agent (agent on_process_exit)
				current_process.set_terminate_agent (agent on_process_exit)
				current_process.set_output_agent (agent on_process_output)
				current_process.launch

				mutex.lock
				if current_process.is_running then
					condition_variable.wait (mutex)
				end

				buffer.wrap_up
				on_process_output ("%N>> END: " + current_process.command_line + "%N")

				mutex.unlock
			end
		end

	cancel
			--
		do
			if current_process /= Void then
				current_process.terminate
			end
			processes.wipe_out

				-- Signal the wait in `execute'.
			mutex.lock
			condition_variable.signal
			mutex.unlock
		end

	on_process_exit
			--
		local
		do
			buffer.wrap_up

			mutex.lock
			condition_variable.signal
			mutex.unlock
		end

	on_process_output (a_output: STRING)
			--
		local
		do
			buffer.store (a_output)
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
