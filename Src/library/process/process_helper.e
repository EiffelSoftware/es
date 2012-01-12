note
	description: "Some convenient APIs"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROCESS_HELPER

feature -- Process

	output_from_program (a_command: STRING; a_working_directory: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
		do
			Result := output_from_program_with_input_file_and_time_limit (a_command, a_working_directory, Void, 0)
		end

	output_from_program_with_input_file (a_command: STRING; a_working_directory: detachable STRING; a_input_file: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
			-- If `a_input_file' is attached, redirect input to that file.
		do
			Result := output_from_program_with_input_file_and_time_limit (a_command, a_working_directory, a_input_file, 0)
		end

	output_from_program_with_input_file_and_time_limit (a_command: STRING; a_working_directory: detachable STRING; a_input_file: detachable STRING; a_time_limit: INTEGER): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory', with time limit.
			-- Note: You may need to prune the final new line character.
			-- If `a_input_file' is attached, redirect input to that file.
			-- Returns empty string if the execution could not finish within time limit.
		require
			time_limit_big_enough: a_time_limit >= 0
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
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
				if a_time_limit > 0 then
					l_prc.wait_for_exit_with_timeout (a_time_limit)
				else
					l_prc.wait_for_exit
				end
			end
			if l_prc.is_last_wait_timeout then
				create Result.make_empty
			end
		end

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
