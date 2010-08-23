note
	description: "Boogie executable running as a separate process."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_PLATFORM_EXECUTABLE

inherit

	E2B_EXECUTABLE

	DISPOSABLE

feature -- Access

	last_output: detachable STRING
			-- <Precursor>
		do
			if attached internal_last_output then
				Result := internal_last_output
			else
				if attached process as l_process and then not l_process.is_running then
					internal_last_output := outputs.item (l_process.id)
					clear_output (l_process.id)
					Result := internal_last_output
				end
			end
		end

feature -- Status report

	is_running: BOOLEAN
			-- <Precursor>
		do
			if attached process as l_process then
				Result := l_process.is_running
			end
		end

feature -- Basic operations

	run
			-- <Precursor>
		do
			if attached process as l_process then
				clear_output (l_process.id)
			end

			generate_boogie_file
			launch_boogie (True)
			internal_last_output := outputs.item (process.id)
			clear_output (process.id)
			process := Void
		end

	run_asynchronous
			-- <Precursor>
		do
			if attached process as l_process then
				clear_output (l_process.id)
			end

			internal_last_output := Void
			generate_boogie_file
			launch_boogie (False)
		end

	cancel
			-- <Precursor>
		local
			l_id: INTEGER
		do
			if attached process as l_process then
				l_id := l_process.id
				if l_process.is_running then
					l_process.terminate_tree
					l_process.wait_for_exit_with_timeout (1000)
					process := Void
				end
			end
			if l_id > 0 then
				clear_output (l_id)
			end
		end

feature -- Removal

	dispose
			-- <Precursor>
		local
			l_retry: BOOLEAN
		do
			if not l_retry and not is_disposed and not is_in_final_collect then
				if attached process as l_process then
					if attached outputs as l_outputs then
						l_outputs.remove (l_process.id)
					end
				end
			end
			is_disposed := True
		rescue
			l_retry := True
			retry
		end

feature {NONE} -- Implementation

	is_disposed: BOOLEAN
			-- Is object already disposed?

	internal_last_output: detachable STRING
			-- Last generated output.

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

	process: detachable PROCESS
			-- Process running Boogie.

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
				l_output_file.put_string ("// Custom content")
				l_output_file.put_new_line
				l_output_file.put_new_line
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

	launch_boogie (a_wait_for_exit: BOOLEAN)
			-- Launch Boogie on generated file.
		local
			l_ee: EXECUTION_ENVIRONMENT
			l_arguments: LINKED_LIST [STRING]
			l_process_factory: PROCESS_FACTORY
		do
				-- Prepare command line arguments
			create l_arguments.make
			l_arguments.extend ("/trace")
			l_arguments.extend ("/printModel:4")
			l_arguments.extend (boogie_file_name)

				-- Launch Boogie
			create l_ee
			create l_process_factory
			process := l_process_factory.process_launcher (boogie_executable, l_arguments, l_ee.current_working_directory)
			check not outputs.has_key (process.id) end

			process.enable_launch_in_new_process_group
			process.redirect_output_to_agent (agent append_output (?, process))
			process.redirect_error_to_same_as_output
			process.set_on_fail_launch_handler (agent handle_launch_failed (boogie_executable, l_arguments))
			process.launch
			if a_wait_for_exit then
				process.wait_for_exit
			end
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

feature {NONE} -- Output capture

	outputs: HASH_TABLE [STRING, INTEGER]
			-- Output indexed by process id.
		note
			once_status: global
		once
			create Result.make (10)
		end

	append_output (a_text: STRING; a_process: PROCESS)
			-- Append `a_text' to output of process with id `a_process_id'.
		local
			l_new_string: STRING
		do
			if outputs.has_key (a_process.id) then
				outputs.item (a_process.id).append (a_text)
			else
				create l_new_string.make (1024)
				l_new_string.append (a_text)
				outputs.put (l_new_string, a_process.id)
			end
		end

	clear_output (a_process_id: INTEGER)
			-- Clear output generated by process with id `a_process_id'.
		do
			outputs.remove (a_process_id)
		end

end
