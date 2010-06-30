note
	description: "Utilities for process library, for example, process launching, result retrieval"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_PROCESS_UTILITY

feature -- Process

	output_from_program (a_command: STRING; a_working_directory: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
		do
			Result := output_from_program_with_input_file (a_command, a_working_directory, Void)
		end

	output_from_program_with_input_file (a_command: STRING; a_working_directory: detachable STRING; a_input_file: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
			-- If `a_input_file' is attached, redirect input to that file.
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
			l_buffer: STRING
		do
			create l_prc_factory
			l_prc := l_prc_factory.process_launcher_with_command_line (a_command, a_working_directory)
			l_prc.set_detached_console (False)
			l_prc.set_hidden (True)
			create Result.make (1024)
			l_prc.redirect_output_to_agent (agent Result.append ({STRING}?))
			if a_input_file /= Void then
				l_prc.redirect_input_to_file (a_input_file)
			end
			l_prc.launch
			if l_prc.launched then
				l_prc.wait_for_exit
			end
		end

end
