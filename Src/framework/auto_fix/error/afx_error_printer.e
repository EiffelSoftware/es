note
	description: "Modified from {UT_ERROR_HANDLER}"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_ERROR_PRINTER

inherit
	AFX_ERROR_HANDLER_I

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
			-- Create a new error handler using the standard
			-- error file for error and warning reporting
			-- and the standard output file for info messages.
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
			-- Create a new error handler ignoring
			-- all error, warning and info messages.
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

feature -- Operation

	config (a_conf: AFX_FIX_PROPOSER_CONF_I)
			-- config the error printer using `a_conf'
			-- TODO: really use `a_conf'
		do
			enable_benchmarking
			redirect_all_to_file (Void)
		end

	start_logging
			-- start logging information
		do
		    set_start_time_now
		    is_logging := True
		    report_info_message ("Fix proposer started at " + start_time.out)
		end

	redirect_all_to_file (a_name: detachable STRING)
			-- redirect the output of the error printer to
			-- a file at the default location on disk, and with default file name
		local
		    l_test_suite: TEST_SUITE_S
			l_project_directory: PROJECT_DIRECTORY
			l_log_directory_name: DIRECTORY_NAME
			l_log_file_name: FILE_NAME
		    l_file: detachable KL_TEXT_OUTPUT_FILE
		    l_error_msg: STRING
		do
		    is_last_redirection_successful := False
		    create l_error_msg.make_empty

			if a_name /= Void then
    		    create l_log_file_name.make
    		    if l_log_file_name.is_file_name_valid (a_name) then
    		        l_log_file_name.make_from_string (a_name)
    		    else
    		        l_error_msg.append_string ("Invalid log file name!%N")
    		        l_log_file_name := Void
    			end
    		end

			if l_log_file_name = Void then
    			l_test_suite := test_suite.service
    			l_project_directory := l_test_suite.eiffel_project.project_directory
    			l_log_directory_name := l_project_directory.testing_results_path.twin
    			l_log_directory_name.extend ("auto_fix")

    			create l_log_file_name.make_from_string (l_log_directory_name)
    			l_log_file_name.set_file_name ("auto_fix")
    			l_log_file_name.add_extension ("log")
			end

			if l_log_file_name /= Void then
    			create l_file.make (l_log_file_name)
    			l_file.recursive_open_write
    			if l_file.is_open_write then
    				set_error_file (l_file)
    				set_info_file (l_file)
    				set_warning_file (l_file)
    				set_debug_file (l_file)

    				l_error_msg.append_string ("Logging into file: " + l_log_file_name)
    				is_last_redirection_successful := True
    			end
    		end

    		if not is_last_redirection_successful then
    		    l_error_msg.append_string ("Logging into std.out and std.error.")
    		end

    		check not l_error_msg.is_empty end
    		prompts.show_info_prompt (l_error_msg, Void, Void)

		end

	close
			-- close all open output files
		local
		    l_files: DS_ARRAYED_LIST [ KI_TEXT_OUTPUT_STREAM]
		    l_file: KI_TEXT_OUTPUT_STREAM
		do
		    create l_files.make (4)
		    if error_file /= Void and then not l_files.has (error_file) then l_files.force_last (error_file) end
		    if warning_file /= Void and then not l_files.has (warning_file) then l_files.force_last (warning_file) end
		    if info_file /= Void and then not l_files.has (info_file) then l_files.force_last (info_file) end
		    if debug_file /= Void and then not l_files.has (debug_file) then l_files.force_last (debug_file) end

		    from l_files.start
		    until l_files.after
		    loop
		        l_file := l_files.item_for_iteration
		        if l_file /~ std.error and then l_file /~ std.output and then l_file.is_open_write then
		            l_file.flush
		            l_file.close
		        end
		    end
		end

feature -- Access

	error_file: KI_TEXT_OUTPUT_STREAM
			-- file to log errors

	warning_file: KI_TEXT_OUTPUT_STREAM
			-- file to log warnings

	info_file: KI_TEXT_OUTPUT_STREAM
			-- file to log info

	debug_file: KI_TEXT_OUTPUT_STREAM
			-- file to log debug info

	start_time: DATE_TIME
			-- Time when auto_fix processor was started

	duration_in_fine_seconds_str: STRING
			-- duration to now in milliseconds
		require
		    start_time_not_void: start_time /= Void
		local
		    l_now: DATE_TIME
		    l_fine_milli_seconds_count: INTEGER
		    l_count: INTEGER
		    l_str: STRING
		do
		    create l_now.make_now
		    l_fine_milli_seconds_count := (l_now.relative_duration (start_time).fine_seconds_count * 1000).truncated_to_integer
		    l_str := l_fine_milli_seconds_count.out
		    if l_count <= 10 then
			    create Result.make_filled (' ', 10 - l_str.count)
			else
			    create Result.make_empty
		    end
		    Result.append_string (l_str)
		ensure
		    result_valid: Result /= Void and then not Result.is_empty
		end

feature -- Error report

	report_error (an_error: AFX_ERROR)
			-- report an error
		do
		    report_error_message (an_error.out)
		end

	report_warning (a_warning: AFX_WARNING)
			-- report a warning
		do
		    report_warning_message (a_warning.out)
		end

	report_info (an_info: AFX_INFO)
			-- report an info
		do
		    report_info_message (an_info.out)
		end

	report_debug_info (a_debug_info: AFX_DEBUG_INFO)
			-- report a debug info
		do
		    report_debug_info_message (a_debug_info.out)
		end

feature -- Error message report

	report_error_message (a_msg: STRING)
			-- report an error message
		do
		    report_message_to_file (error_file, a_msg, Error_message_type_char)
		end

	report_warning_message (a_msg: STRING)
			-- report a warning message
		do
		    report_message_to_file (warning_file, a_msg, Warning_message_type_char)
		end

	report_info_message (a_msg: STRING)
		do
		    report_message_to_file (info_file, a_msg, Info_message_type_char)
		end

	report_debug_info_message (a_msg: STRING)
		do
		    report_message_to_file (debug_file, a_msg, Debug_info_message_type_char)
		end

	report_message_to_file (a_file: like error_file; a_msg: STRING; a_type: CHARACTER)
			-- report the message to file, with possible prefix
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
    			    l_prefix.append (l_indent + l_lines.item_for_iteration + "%N")
    			end

    			a_file.put_string (l_prefix)
    		    a_file.flush
    		end
		end

feature -- Pre-emptive error report

	raise_error (a_msg: STRING)
			-- error must be processed immediately, raise an exception
		do
		    raise (a_msg)
		end

feature -- Status report

	is_logging: BOOLEAN
			-- is error printer logging information?

	is_verbose: BOOLEAN
			-- Is `info_file' set to something other than
			-- the null output stream?
		do
			Result := info_file /= null_output_stream
		ensure
			definition: Result = (info_file /= null_output_stream)
		end

	is_debugging: BOOLEAN
			-- is `debug_file' set to something other than the null output stream?
		do
		    Result := debug_file /= null_output_stream
		ensure
		    definition: Result = (debug_file /= null_output_stream)
		end

	is_benchmarking: BOOLEAN
			-- should the execution time be logged for analysis?

	is_last_redirection_successful: BOOLEAN
			-- is last redirection successful

feature -- Setting

	set_start_time_now
			-- set start time to be now
		do
		    create start_time.make_now
		end

	enable_benchmarking
			-- start logging the execution time
		do
		    is_benchmarking := True
		end

	disable_benchmarking
			-- stop logging the execution time
		do
		    is_benchmarking := False
		end

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

feature -- Constants

	Error_message_type_char: CHARACTER = 'X'
			-- prefix for error messages

	Warning_message_type_char: CHARACTER = '!'
			-- prefix for warning messages

	Info_message_type_char: CHARACTER = 'i'
			-- prefix for info messages

	Debug_info_message_type_char: CHARACTER = '-'
			-- prefix for debug info messages

	Std_log_file_name: STRING = "std"

	Null_log_file_name: STRING = "null"

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
