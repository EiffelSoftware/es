indexing
	description: "Summary description for {JS_JSTAR_RUNNER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_JSTAR_RUNNER

inherit
	KL_SHARED_FILE_SYSTEM
	export {NONE} all end

	SHARED_WORKBENCH
	export {NONE} all end

	JS_HELPER_ROUTINES
	export {NONE} all end
	
create
	default_create

feature

	run (jimple_code: STRING; specs: STRING; logic_file_name: STRING; abs_file_name: STRING)
		local
			l_jimple_code_file_name: STRING
			l_specs_file_name: STRING
			l_jstar_output_file_name: STRING

			l_process_factory: PROCESS_FACTORY
			l_arguments: ARRAYED_LIST [STRING]
			l_process: PROCESS
		do
			l_jimple_code_file_name := file_system.pathname (directory, "jstar_jimple_code")
			l_specs_file_name := file_system.pathname (directory, "jstar_specs")
			l_jstar_output_file_name := file_system.pathname (directory, "jstar_output")
			write_file (l_jimple_code_file_name, jimple_code)
			write_file (l_specs_file_name, specs)

			create l_process_factory
			create l_arguments.make_from_array (<<"-l", logic_file_name, "-a", abs_file_name, "-s", l_specs_file_name, "-f", l_jimple_code_file_name>>)
			l_process := l_process_factory.process_launcher ("jstar", l_arguments, directory)
			l_process.redirect_output_to_agent (agent set_output)
			l_process.redirect_error_to_same_as_output
			l_process.set_on_fail_launch_handler (agent failed_jstar_launch)
			l_process.launch
			l_process.wait_for_exit
		end

	output: STRING

feature {NONE} -- Implementation

	set_output (o: STRING)
		do
			output := o
		end

	failed_jstar_launch
		do
			error ("Could not execute jstar - make sure its in your PATH")
		end

	write_file (name: STRING; contents: STRING)
		local
			l_output_file: KL_TEXT_OUTPUT_FILE
		do
			create l_output_file.make (name)
			l_output_file.open_write
			l_output_file.put_string (contents)
			l_output_file.close
		end

	directory: STRING
			-- The directory where the jStar input and output files will be written
		do
			Result := system.eiffel_project.project_directory.target_path
		end

end
