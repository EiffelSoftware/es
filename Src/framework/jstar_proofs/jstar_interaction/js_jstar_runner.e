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
		do
			create l_process_factory
			create l_arguments.make_from_array (<<"-l", logic_file_name, "-a", abs_file_name, "-s", specs_file_name, "-f", jimple_code_file_name>>)
			l_process := l_process_factory.process_launcher ("jstar", l_arguments, working_directory)
			l_process.redirect_output_to_file (output_file_name)
			l_process.redirect_error_to_same_as_output
			l_process.set_on_fail_launch_handler (agent failed_jstar_launch)
			l_process.launch
			l_process.wait_for_exit
		end

feature {NONE} -- Implementation

	failed_jstar_launch
		do
			error ("Could not execute jstar - make sure it's in your PATH")
		end

end
