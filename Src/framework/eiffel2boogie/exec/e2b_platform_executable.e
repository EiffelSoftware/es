note
	description: "Boogie executable for Windows."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_PLATFORM_EXECUTABLE

inherit

	E2B_EXECUTABLE

feature -- Basic operations

	run
			-- Run Boogie on `input'.
		do
			last_output.wipe_out
			generate_boogie_file
			launch_boogie
		end

feature {NONE} -- Implementation

	boogie_file_name: attached STRING
			-- File name used to generate Boogie file.
		deferred
		end

	boogie_executable: attached STRING
			-- Executable name to launch Boogie (including path if necessary).
		deferred
		ensure
			not Result.is_empty
		end

	generate_boogie_file
			-- Generate Boogie file from input.
		local
			l_output_file: KL_TEXT_OUTPUT_FILE
			l_time: TIME
		do
			create l_output_file.make (boogie_file_name)
			l_output_file.recursive_open_write
			if l_output_file.is_open_write then
				append_header (l_output_file)
				from
					input.boogie_files.start
				until
					input.boogie_files.after
				loop
					append_file_content (l_output_file, input.boogie_files.item)
					input.boogie_files.forth
				end
				from
					input.custom_content.start
				until
					input.custom_content.after
				loop
					l_output_file.put_string (input.custom_content.item)
					input.custom_content.forth
				end
				l_output_file.close
			else
					-- TODO: error handling
				check False end
			end
		end

	launch_boogie
			-- Launch Boogie on generated file.
		local
			l_ee: EXECUTION_ENVIRONMENT
			l_arguments: LINKED_LIST [STRING]
			l_process_factory: PROCESS_FACTORY
			l_process: PROCESS
		do
				-- Prepare command line arguments
			create l_arguments.make
			l_arguments.extend ("/trace")
			l_arguments.extend ("/printModel:4")
			l_arguments.extend (boogie_file_name)

				-- Launch Boogie
			create l_ee
			create l_process_factory
			l_process := l_process_factory.process_launcher (boogie_executable, l_arguments, l_ee.current_working_directory)

			l_process.redirect_output_to_agent (agent handle_boogie_output (?))
			l_process.redirect_error_to_same_as_output
			l_process.set_on_fail_launch_handler (agent handle_launch_failed (boogie_executable, l_arguments))
			l_process.launch
			l_process.wait_for_exit
		end

	handle_boogie_output (a_output: STRING)
			-- Handle output from Boogie.
		do
			last_output.append (a_output)
		end

	handle_launch_failed (a_executable: STRING; a_arguments: LINKED_LIST [STRING])
			-- Handle launch of Boogie failed.
		do
				-- TODO: error handling
			check False end
		end

	append_header (a_file: KL_TEXT_OUTPUT_FILE)
			-- Append header to `a_file'.
		require
			writable: a_file.is_open_write
		local
			l_date_time: DATE_TIME
		do
			create l_date_time.make_now
			a_file.put_string ("// Automatically generated (")
			a_file.put_string (l_date_time.out)
			a_file.put_string (")%N%N")
		end

	append_file_content (a_file: KL_TEXT_OUTPUT_FILE; a_file_name: STRING)
			-- Append content of `a_file_name' to `a_file'.
		require
			writable: a_file.is_open_write
		local
			l_input_file: KL_TEXT_INPUT_FILE
		do
			create l_input_file.make (a_file_name)
			l_input_file.open_read
			if l_input_file.is_open_read then
				l_input_file.read_string (l_input_file.count)
				a_file.put_string ("// File: ")
				a_file.put_string (a_file_name)
				a_file.put_new_line
				a_file.put_new_line
				a_file.put_string (l_input_file.last_string)
				a_file.put_new_line
			else
				a_file.put_string ("// Error: unable to open file ")
				a_file.put_string (a_file_name)
				a_file.put_new_line
				a_file.put_new_line
			end
		end

end
