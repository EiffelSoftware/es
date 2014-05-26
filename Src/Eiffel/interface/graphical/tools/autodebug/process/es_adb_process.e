note
	description: "Summary description for {ES_ADB_PROCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_PROCESS

inherit

	ES_ADB_SHARED_INFO_CENTER

create
	make

feature{NONE} -- Initialization

	make (a_cmd_line: STRING; a_working_directory: STRING; a_timeout: INTEGER)
			-- Initialization.
		require
			a_cmd_line /= Void
			a_timeout > 0
		do
			command_line := a_cmd_line.twin
			if a_working_directory = Void then
				working_directory := Void
			else
				working_directory := a_working_directory.twin
			end
			timeout := a_timeout

			create timer.make (agent on_timeout)
			timer.set_timeout ((config.max_session_length_for_testing + 5) * 60)
			has_run_out_of_time := False
		end

feature -- Access

	command_line: STRING
			-- Command line to launch the process.

	working_directory: STRING
			-- Directory to run the process in.

	timeout: INTEGER
			-- Cutoff time for testing.

	output_agent: PROCEDURE [ANY, TUPLE[STRING]]
			-- Agent to handle the process output.

	exit_agent: PROCEDURE [ANY, TUPLE]
			-- Action to take upon process exit.

	terminate_agent: PROCEDURE [ANY, TUPLE]
			-- Action to take upon process terminate.

feature -- Operation

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
			working_process.redirect_input_to_stream
			working_process.redirect_output_to_agent (agent on_output)
			working_process.redirect_error_to_same_as_output
			working_process.set_on_exit_handler (agent on_exit)
			working_process.set_on_terminate_handler (agent on_terminate)

			timer.start
			working_process.launch
			check working_process.launched end
		end

	terminate
			-- Terminate process.
		do
			if is_running then
				working_process.terminate_tree
			end
		end

feature -- Status report

	has_run_out_of_time: BOOLEAN
			-- Has the last run out of time?

	is_running: BOOLEAN
			-- Is process running?
		do
			Result := working_process /= Void and then working_process.is_running
		end

feature -- Set

	set_output_agent (a_agent: like output_agent)
		require
			a_agent /= Void
		do
			output_agent := a_agent
		end

	set_exit_agent (a_agent: like exit_agent)
		require
			a_agent /= Void
		do
			exit_agent := a_agent
		end

	set_terminate_agent (a_agent: like terminate_agent)
		require
			a_agent /= Void
		do
			terminate_agent := a_agent
		end

feature -- Event handler

	on_output (a_str: STRING)
			-- Action to perform when process generates a new output `a_str'.
		do
			if output_agent /= Void then
				output_agent.call ([a_str])
			end
		end

	on_timeout
			-- Action to perform when process runs out of time.
		do
			has_run_out_of_time := True
			terminate
		end

	on_exit
			-- Action to perform when process exits.
		do
			timer.reset_timer

			if exit_agent /= Void then
				exit_agent.call
			end
		end

	on_terminate
			-- Action to perform when process terminates.
		do
			timer.reset_timer

			if terminate_agent /= Void then
				terminate_agent.call
			end
		end

feature{NONE} -- Implementation

	working_process: PROCESS
			-- Working process object.

	timer: AFX_TIMER_THREAD
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
