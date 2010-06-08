indexing
	description: "Summary description for {JS_JSTAR_RUNNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_JSTAR_RUNNER

inherit
	JS_HELPER_ROUTINES
	export {NONE} all end

create
	default_create

feature

	run (working_directory: STRING; jimple_code_file_name: STRING; specs_file_name: STRING; logic_file_name: STRING; abs_file_name: STRING; output_file_name: STRING)
		local
			l_process_factory: PROCESS_FACTORY
			l_arguments: ARRAYED_LIST [STRING]
			l_process: PROCESS
			l_output_file_name: STRING
			l_executable_name: STRING
		do
			timed_out := False
			create l_process_factory
			create l_arguments.make_from_array (<<"-l", logic_file_name, "-a", abs_file_name, "-s", specs_file_name, "-f", jimple_code_file_name>>)
			l_executable_name := solved_path ("jstar")
--			l_process_factory.process_launcher_with_command_line ("", working_directory)
			l_process := l_process_factory.process_launcher (l_executable_name, l_arguments, working_directory)
			l_process.redirect_output_to_file (output_file_name)
			l_process.redirect_error_to_same_as_output
			l_process.set_on_fail_launch_handler (agent failed_jstar_launch)
			l_process.launch
			l_process.wait_for_exit_with_timeout (30 * 1000) -- Wait at most 30 seconds for jStar to finish
			if not l_process.is_last_wait_timeout then
				l_process.terminate
				l_process.wait_for_exit
				timed_out := True
			end
		end

	timed_out: BOOLEAN

feature {NONE} -- Implementation

	failed_jstar_launch
		do
			error ("Could not execute jstar - make sure it's in your PATH")
		end

end
