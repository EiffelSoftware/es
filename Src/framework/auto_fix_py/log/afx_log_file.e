note
	description: "Summary description for {AFX_LOG_FILE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_LOG_FILE

inherit

	AFX_LOGGING_EVENT_OBSERVER_I

	AFX_LOG_FILE_CONSTANT_I

	KL_SHARED_STANDARD_FILES

	KL_SHARED_STREAMS

	SHARED_TEST_SERVICE

	ES_SHARED_PROMPT_PROVIDER

	EXCEPTIONS

	DATE_TIME
		undefine
		    is_equal,
		    out,
		    copy
		end

create

	make_standard, make_null

feature -- Initialization

	make_standard
			-- Create a new error handler using the standard error file for error and warning reporting
			-- and the standard output file for info and debug messages.
		do
			error_file := std.error
			warning_file := std.error
			info_file := std.output
			debug_file := std.output
		ensure
			error_file_set: error_file = std.error
			warning_file_set: warning_file = std.error
			info_file_set: info_file = std.output
			debug_file_set: debug_file = std.output
		end

	make_null
			-- Create a new error handler ignoring all error, warning, debug and info messages.
		do
			error_file := null_output_stream
			warning_file := null_output_stream
			info_file := null_output_stream
			debug_file := null_output_stream
		ensure
			error_file_set: error_file = null_output_stream
			warning_file_set: warning_file = null_output_stream
			info_file_set: info_file = null_output_stream
			debug_file_set: debug_file = null_output_stream
		end

feature -- Start/Finish logging

	config (a_conf: AFX_FIX_PROPOSER_CONF_I)
			-- config the error printer using `a_conf'
			-- TODO: really use `a_conf'
		do
			redirect_all_to_file (Void)
		end

	start_logging
			-- <Precursor>
		do
		    set_start_time_now
			is_logging := True
		end

	finish_logging
			-- <Precursor>
		local
		    l_files: ARRAYED_SET [ KI_TEXT_OUTPUT_STREAM]
		    l_file: KI_TEXT_OUTPUT_STREAM
		do
		    create l_files.make (4)
		    l_files.compare_references
		    if error_file /= Void then l_files.put (error_file) end
		    if warning_file /= Void then l_files.put (warning_file) end
		    if info_file /= Void then l_files.put (info_file) end
		    if debug_file /= Void then l_files.put (debug_file) end

		    from l_files.start
		    until l_files.after
		    loop
		        l_file := l_files.item
	            l_file.flush
		        if l_file /= std.error and then l_file /= std.output and then l_file.is_open_write then
		            l_file.close
		        end
		        l_files.forth
		    end

				-- reset file states
			make_null
		end

feature -- Entry logging

	log_error (an_error: AFX_LOG_ENTRY_ERROR)
			-- <Precursor>
		do
		    log_error_message (an_error.message)
		end

	log_warning (a_warning: AFX_LOG_ENTRY_WARNING)
			-- <Precursor>
		do
		    log_warning_message (a_warning.message)
		end

	log_info (an_info: AFX_LOG_ENTRY_INFO)
			-- <Precursor>
		do
		    log_info_message (an_info.message)
		end

	log_debug (a_debug: AFX_LOG_ENTRY_DEBUG)
			-- <Precursor>
		do
		    log_debug_message (a_debug.message)
		end

feature -- Message logging

	log_error_message (a_msg: STRING)
			-- report an error message
		do
		    log_message (error_file, a_msg, Error_message_type_char)
		    raise (a_msg)
		end

	log_warning_message (a_msg: STRING)
			-- report a warning message
		do
		    log_message (warning_file, a_msg, Warning_message_type_char)
		end

	log_info_message (a_msg: STRING)
		do
		    log_message (info_file, a_msg, Info_message_type_char)
		end

	log_debug_message (a_msg: STRING)
		do
		    log_message (debug_file, a_msg, Debug_info_message_type_char)
		end

feature -- Status reporting

	is_logging: BOOLEAN
			-- <Precrusor>

	is_logging_error: BOOLEAN
			-- <Precursor>
		do
		    Result := error_file /= null_output_stream
		end

	is_logging_warning: BOOLEAN
			-- <Precursor>
		do
		    Result := warning_file /= null_output_stream
		end

	is_logging_info: BOOLEAN
			-- <Precursor>
		do
		    Result := info_file /= null_output_stream
		end

	is_logging_debug: BOOLEAN
			-- <Precursor>
		do
		    Result := debug_file /= null_output_stream
		end

	is_benchmarking: BOOLEAN
			-- <Precursor>

feature -- Access

	error_file: KI_TEXT_OUTPUT_STREAM
			-- file to log errors

	warning_file: KI_TEXT_OUTPUT_STREAM
			-- file to log warnings

	info_file: KI_TEXT_OUTPUT_STREAM
			-- file to log info

	debug_file: KI_TEXT_OUTPUT_STREAM
			-- file to log debug info

	start_time: TIME
			-- Time when logging was started

feature -- Status change

	enable_error_logging (a_state: BOOLEAN)
			-- <Precursor>
		do
		    -- do nothing. Level of logging can only be set before the log file is connected to the event
		end

	enable_warning_logging (a_state: BOOLEAN)
			-- <Precursor>
		do
		    -- do nothing. Level of logging can only be set before the log file is connected to the event
		end

	enable_info_logging (a_state: BOOLEAN)
			-- <Precursor>
		do
		    -- do nothing. Level of logging can only be set before the log file is connected to the event
		end

	enable_debug_logging (a_state: BOOLEAN)
			-- <Precursor>
		do
		    -- do nothing. Level of logging can only be set before the log file is connected to the event
		end

	enable_benchmarking (a_state: BOOLEAN)
			-- <Precursor>
		do
		    is_benchmarking := a_state
		end

feature -- redirect output

	set_error_file (a_file: like error_file) is
			-- Set `error_file' to `a_file'.
		require
			a_file_open_write: a_file.is_open_write
		do
			error_file := a_file
		ensure
			error_file_set: error_file = a_file
		end

	set_error_standard is
			-- Set `error_file' to standard error file.
		do
			error_file := std.error
		ensure
			error_file_set: error_file = std.error
		end

	set_error_null is
			-- Set `error_file' to null output stream,
			-- i.e. error messages will be ignored.
		do
			error_file := null_output_stream
		ensure
			error_file_set: error_file = null_output_stream
		end

	set_warning_file (a_file: like warning_file) is
			-- Set `warning_file' to `a_file'.
		require
			a_file_open_write: a_file.is_open_write
		do
			warning_file := a_file
		ensure
			warning_file_set: warning_file = a_file
		end

	set_warning_standard is
			-- Set `warning_file' to standard error file.
		do
			warning_file := std.error
		ensure
			warning_file_set: warning_file = std.error
		end

	set_warning_null is
			-- Set `warning_file' to null output stream,
			-- i.e. warning messages will be ignored.
		do
			warning_file := null_output_stream
		ensure
			warning_file_set: warning_file = null_output_stream
		end

	set_info_file (a_file: like info_file) is
			-- Set `info_file' to `a_file'.
		require
			a_file_open_write: a_file.is_open_write
		do
			info_file := a_file
		ensure
			info_file_set: info_file = a_file
		end

	set_info_standard is
			-- Set `info_file' to standard output file.
		do
			info_file := std.output
		ensure
			info_file_set: info_file = std.output
		end

	set_info_null is
			-- Set `info_file' to null output stream,
			-- i.e. info messages will be ignored.
		do
			info_file := null_output_stream
		ensure
			info_file_set: info_file = null_output_stream
		end

	set_debug_file (a_file: like debug_file) is
			-- Set `debug_file' to `a_file'.
		require
			a_file_open_write: a_file.is_open_write
		do
			debug_file := a_file
		ensure
			debug_file_set: debug_file = a_file
		end

	set_debug_standard is
			-- Set `debug_file' to standard output file.
		do
			debug_file := std.output
		ensure
			debug_file_set: debug_file = std.output
		end

	set_debug_null is
			-- Set `debug_file' to null output stream,
			-- i.e. debug messages will be ignored.
		do
			debug_file := null_output_stream
		ensure
			debug_file_set: debug_file = null_output_stream
		end

feature{NONE} -- Implementation

	set_start_time_now
			-- set start time to be now
		do
		    create start_time.make_now
		end

	duration_in_fine_seconds_str: STRING
			-- duration to now in milliseconds
		require
		    start_time_not_void: start_time /= Void
		local
		    l_now: TIME
		    l_fine_milli_seconds_count: INTEGER
		    l_count: INTEGER
		    l_str: STRING
		do
		    create l_now.make_now
		    l_fine_milli_seconds_count := (l_now.relative_duration (start_time).fine_seconds_count * 1000).truncated_to_integer
		    l_str := l_fine_milli_seconds_count.out
		    if l_str.count <= 10 then
			    create Result.make_filled (' ', 10 - l_str.count)
			else
			    create Result.make_empty
		    end
		    Result.append_string (l_str)
		ensure
		    result_valid: Result /= Void and then not Result.is_empty
		end

	log_message (a_file: like error_file; a_msg: STRING; a_type: CHARACTER)
			-- report the message to file, with possible prefix `a_type'
			-- if `a_msg' extends across multiple lines, appropriate indent should be inserted for lines other than the first
		require
		    msg_not_empty: not a_msg.is_empty
		local
		    l_prefix: STRING
		    l_indent: STRING
		    l_out: STRING
		    l_lines: LIST[STRING_8]
		    l_line_no: INTEGER
		do
		    if is_logging then
    				-- prepare the prefix
    		    create l_prefix.make_filled (a_type, 1)
    		    l_prefix.append_character (' ')
    		    if is_benchmarking then
    		        l_prefix.append_string ("[" + duration_in_fine_seconds_str + "] ")
    		    end
    		    create l_indent.make_filled (' ', l_prefix.count)

    			l_lines := a_msg.split ('%N')

    				-- first line
    			check l_lines.count >= 1 end
    		    l_prefix.append_string (l_lines[1]+"%N")

    		    	-- following lines
    			from l_line_no := 2
    			until l_line_no > l_lines.count
    			loop
    			    l_prefix.append (l_indent + l_lines.i_th (l_line_no) + "%N")
    			    l_line_no := l_line_no + 1
    			end

    			a_file.put_string (l_prefix)
    		    a_file.flush
    		end
		end

	redirect_all_to_file (a_name: detachable STRING)
			-- redirect the logging information to a file `a_name'
			-- If `a_name = Void', log into the file "...\project_directory\testing_results_path\auto_fix\auto_fix.log"
		local
		    l_test_suite: TEST_SUITE_S
			l_project_directory: PROJECT_DIRECTORY
			l_log_directory_name: DIRECTORY_NAME
			l_log_file_name: FILE_NAME
		    l_file: detachable KL_TEXT_OUTPUT_FILE
		    l_error_msg: STRING
		do
		    create l_error_msg.make_empty

			if a_name /= Void then
    		    create l_log_file_name.make_from_string (a_name)
    		    if not l_log_file_name.is_valid then
    		        l_log_file_name := Void
    		        l_error_msg.append_string ("Invalid log file name!%N")
    		    else
        			create l_file.make (l_log_file_name)
        			l_file.recursive_open_write
        			if not l_file.is_open_write then
        			    l_file := Void
        			    l_error_msg.append_string ("Error opening file to write: " + l_log_file_name + "%N")
        			end
    			end
    		end

				-- try default location, if opening specified file failed or no file specified.
			if l_file = Void then
    			l_test_suite := test_suite.service
    			l_project_directory := l_test_suite.eiffel_project.project_directory
    			l_log_directory_name := l_project_directory.testing_results_path.twin
    			l_log_directory_name.extend (Default_log_directory)

    			create l_log_file_name.make_from_string (l_log_directory_name)
    			l_log_file_name.set_file_name (Default_log_file_name)
    			l_log_file_name.add_extension (Default_log_file_extension)

    			create l_file.make (l_log_file_name)
    			l_file.recursive_open_write
    			if not l_file.is_open_write then
    			    l_file := Void
    			    l_error_msg.append_string ("Error opening default location to write: " + l_log_file_name + "%N")
				end
			end

				-- redirect output if opened successfully
			if l_file /= Void and then l_file.is_open_write then
    				set_error_file (l_file)
    				set_info_file (l_file)
    				set_warning_file (l_file)
    				set_debug_file (l_file)
			else
			    l_error_msg.append_string ("Logging file cannot be opened, AutoFix logging redirection failed.")
    		end

    		if not l_error_msg.is_empty then
	    		prompts.show_info_prompt (l_error_msg, Void, Void)
    		end
		end



note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
