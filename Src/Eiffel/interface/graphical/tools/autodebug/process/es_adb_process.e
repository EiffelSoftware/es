note
	description: "Summary description for {ES_ADB_TESTING_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_PROCESS

inherit
	ES_ADB_ROTA_TASK
		redefine
			start
		end

	ES_ADB_TOOL_HELPER

feature{NONE} -- Initialization

	make_process (a_cmd_line: STRING; a_working_directory: STRING; a_timeout: INTEGER; a_output_buffer: ES_ADB_PROCESS_OUTPUT_BUFFER)
			-- Initialization.
		require
			a_cmd_line /= Void
			a_timeout > 0
		do
			command_line := a_cmd_line.twin
			working_directory := a_working_directory
			timeout := a_timeout
			output_buffer := a_output_buffer
			create on_start_actions
			create on_terminate_actions

			set_has_next_step (True)
			set_has_started (False)
			set_has_run_out_of_time (False)
		end

feature -- Access

	command_line: STRING
			-- Command line to launch the process.

	working_directory: STRING
			-- Directory to run the process in.

	timeout: INTEGER
			-- Cutoff time for testing.

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	has_started: BOOLEAN
			-- Has current been started, i.e. launching was attempted?

	is_launched: BOOLEAN
			-- Is `working_process' launched?
		do
			Result := working_process /= Void and then working_process.launched
		end

	is_running: BOOLEAN
			-- Is `working_process' running?
		do
			Result := working_process /= Void and then working_process.is_running
		end

	should_output_be_parsed: BOOLEAN assign set_should_output_be_parsed
			-- Should the output from `command_line' be parsed?

	should_output_be_logged: BOOLEAN assign set_should_output_be_logged
			-- Should the output from `command_line' be logged?

	has_run_out_of_time: BOOLEAN
			-- Has the last run out of time?

feature -- Setter

	set_has_next_step (a_flag: BOOLEAN)
		do
			has_next_step := a_flag
			if not has_next_step then
				wrap_up
			end
		end

	set_has_started (a_flag: BOOLEAN)
		do
			has_started := a_flag
		end

	set_should_output_be_parsed (a_flag: BOOLEAN)
		do
			should_output_be_parsed := a_flag
		end

	set_should_output_be_logged (a_flag: BOOLEAN)
		do
			should_output_be_logged := a_flag
		end

	set_has_run_out_of_time (a_flag: BOOLEAN)
		do
			has_run_out_of_time := a_flag
		end

feature -- Operation

	start
			-- <Precursor>
		do
			Precursor

			on_output ("%N>> Starting process: " + command_line + "%N")
			launch
			set_has_started (True)
			on_terminate_actions.extend (agent timer.set_should_terminate (True))
		end

	step
			-- <Precursor>
		do
			if not has_started then
				start
			end
			if not is_running and then (output_buffer = Void or else output_buffer.is_empty) then
					-- Process has terminated and no more output to be forwarded.
					-- So we stop the current subtask.
				if is_launched then
					on_output ("%N>> Process exited: " + command_line + "%N")
				else
					on_output ("%N>> Failed to launch process: " + command_line + "%N")
				end
				set_has_next_step (False)
			end
		end

	cancel
			-- <Precursor>
		local
		do
			timer.set_should_terminate (True)
			if is_running then
				working_process.terminate_tree
			end
			on_output ("%N>> Process killed: " + command_line + "%N")

			if output_buffer /= Void then
				output_buffer.wipe_out
			end
			set_has_next_step (False)
		end

feature{NONE} -- Implementation

	launch
			-- Launch process.
		local
			l_prc_factory: PROCESS_FACTORY
		do
			create l_prc_factory
			working_process := l_prc_factory.process_launcher_with_command_line (command_line, working_directory)
			working_process.enable_launch_in_new_process_group
			working_process.set_detached_console (False)
			working_process.set_hidden (True)
			working_process.set_buffer_size (4096)
			working_process.redirect_input_to_stream
			working_process.redirect_output_to_agent (agent on_output)
			working_process.redirect_error_to_same_as_output
			working_process.launch
			check working_process.launched end

			create timer.make_with_action (timeout * 60 * 1000, False, agent on_timeout)
			timer.start
		end

feature -- Event handler

	on_output (a_str: STRING)
			-- Action to perform when process generates a new output `a_str'.
		do
			if output_buffer /= Void then
				output_buffer.store (a_str)
			end
		end

	on_timeout
			-- Action to perform when process runs out of time.
		do
			timer.set_should_terminate (True)
			has_run_out_of_time := True
			cancel
		end

feature{NONE} -- Access

	working_process: PROCESS
			-- Working process object.

	timer: EPA_THREAD_BASED_TIMER
			-- Timer to terminate the process when time is out.


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
