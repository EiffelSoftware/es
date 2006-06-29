indexing
	description: "Objects that handle auto_test processes"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	AT_PROCESS

inherit
	EIFFEL_ENV
		export
			{NONE} all
		undefine
			default_create, copy
		end

	PLATFORM
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		undefine
			default_create, copy
		end

	SHARED_AUTO_TEST_PROJECT
		rename
			project as at_project
		end

create
	make_version, initialize

feature -- initialization

	make_version (version_program: STRING) is
			-- version creation procedure
			local
				version_proc_fct: PROCESS_FACTORY
				version_proc: PROCESS
			do
				create version_proc_fct
				if is_windows then
					version_proc := version_proc_fct.process_launcher_with_command_line (version_program, current_working_directory)
					version_proc.set_separate_console (True)
				else
					version_proc := version_proc_fct.process_launcher_with_command_line ("/bin/sh -c " + version_program, current_working_directory)
				end

				version_proc.enable_terminal_control
				version_proc.redirect_input_to_stream
				version_proc.redirect_error_to_same_as_output
				version_proc.redirect_output_to_agent (agent put_version_number (?))
				version_proc.set_hidden (True)
				version_proc.set_buffer_size (256)

				version_proc.launch

				if version_proc.launched then
					version_proc.wait_for_exit
					if version_proc.exit_code /= 0 then
						autotest_version := "[error: parameter not correct]"
					end
				else
					autotest_version := "[AutoTest was not found!]"
				end
			end

	initialize (a_program: STRING) is
			-- creation procedure
			do
				-- ADAPT THE WHOLE FEATURE TO WINDOWS!!!

				create proc_factory
				if is_windows then
					proc := proc_factory.process_launcher_with_command_line (a_program, current_working_directory)
					proc.set_hidden (True)
					proc.set_separate_console (False)
					proc.enable_terminal_control
				elseif is_unix then
					proc := proc_factory.process_launcher_with_command_line ("/bin/sh -c " + a_program, current_working_directory)
					proc.enable_terminal_control
				end

--D				proc.set_on_successful_launch_handler (agent io.put_string ("Execution succesfull!%N"))
--D				proc.set_on_fail_launch_handler (agent io.put_string ("Execution failed!%N"))
--D				proc.set_on_start_handler (agent io.put_string ("Execution started!%N"))

--				proc.set_on_terminate_handler (agent io.put_string ("Execution terminated!%N"))
				proc.set_abort_termination_when_failed (False)
				proc.set_on_terminate_handler (agent at_project.post_success (False))
--				proc.set_on_exit_handler (agent io.put_string ("Execution exited!%N"))
				proc.set_on_exit_handler (agent at_project.post_success (True))
				proc.set_hidden (True)
--				proc.redirect_output_to_agent (agent io.put_string (?))
				proc.redirect_output_to_agent (agent at_project.post_line (?))

--				proc.redirect_output_to_agent (agent write_out (?))
--				proc.set_buffer_size (32)   -- set a reasonable value!!!
			end


feature -- access

	autotest_version: STRING
			-- current auto test version number


feature {NONE} -- implementation

	proc_factory: PROCESS_FACTORY
			-- process factory

	proc: PROCESS
			-- the actual process


feature -- basic computation

	start is
			-- start the execution
			local
				ise_eiffel_path: STRING
				ise_eiffel_var: STRING
			do

				-- set the environment variable ISE_EIFFEL to what is given
				-- in the `settings dialog'
				ise_eiffel_var := "ISE_EIFFEL"
				ise_eiffel_path := get (ise_eiffel_var)
				put (at_project.ise_eiffel_path, ise_eiffel_var)
				-- end set environment variable

				proc.launch

				-- restore environment variable ISE_EIFFEL
				put (ise_eiffel_path, ise_eiffel_var)
				-- end restore environment variable

				-- INPORTANT!!!
				-- To let your (input/output) thread continue working (no locking)
				-- comment the following expression, so the caller does not have to wait!
--				proc.wait_for_exit

--				if proc.has_exited then
--					io.put_string ("Process has exited!%N")
--				end
			end

	wait_for_exit is
			-- wait, until the process is done
			do
				proc.wait_for_exit
			end

	put_version_number (a_string: STRING) is
			-- put the auto test version number into the auto test project instance
			local
				tmp_string: STRING
			do
				create tmp_string.make_empty
				tmp_string := a_string.substring (19, a_string.count)

				-- remove whitespace at both ends
				tmp_string.right_adjust
				tmp_string.left_adjust

				create autotest_version.make_from_string (tmp_string)
			end


indexing
	copyright:	"Copyright (c) 2006, The AECCS Team"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			The AECCS Team
			Website: https://eiffelsoftware.origo.ethz.ch/index.php/AutoTest_Integration
		]"

end -- class AT_PROCESS
