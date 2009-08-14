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

	EXCEPTIONS

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

	redirect_to_default_file
			-- redirect the output of the error printer to
			-- a file at the default location on disk, and with default file name
		local
		    l_test_suite: TEST_SUITE_S
			l_project_directory: PROJECT_DIRECTORY
			l_log_directory_name: DIRECTORY_NAME
			l_log_file_name: FILE_NAME
		    l_file: detachable KL_TEXT_OUTPUT_FILE
		do
		    report_info_message ("Start redirecting error printer to default file...")
		    is_last_redirection_successful := False

			l_test_suite := test_suite.service
			l_project_directory := l_test_suite.eiffel_project.project_directory
			l_log_directory_name := l_project_directory.testing_results_path.twin
			l_log_directory_name.extend ("auto_fix")

			create l_log_file_name.make_from_string (l_log_directory_name)
			l_log_file_name.set_file_name ("auto_fix")
			l_log_file_name.add_extension ("log")

			create l_file.make (l_log_file_name)
			l_file.recursive_open_write
			if l_file.is_open_write then
				set_error_file (l_file)
				set_info_file (l_file)
				set_warning_file (l_file)
				set_debug_file (l_file)

				is_last_redirection_successful := True

				report_info_message ("Done. Error printer redirected to: " + l_log_file_name)
			else
			    report_error_message ("Failed to redirect error printer...")
			end
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

	start_time: DT_DATE_TIME
			-- Time when auto_fix processor was started

	duration_to_now: DT_DATE_TIME_DURATION
			-- time elapsed since the `start_time'
		require
		    start_time_not_void: start_time /= Void
		local
		    l_time_now: DT_DATE_TIME
		    l_system_clock: DT_SHARED_SYSTEM_CLOCK
		do
		    create l_system_clock
		    l_time_now := l_system_clock.system_clock.date_time_now
		    Result := l_time_now.duration (start_time)
		    Result.set_time_canonical
		ensure
		    Result_not_void: Result /= Void
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
		    error_file.put_line (a_msg)
		    error_file.flush
		end

	report_warning_message (a_msg: STRING)
			-- report a warning message
		do
		    warning_file.put_line (a_msg)
		    warning_file.flush
		end

	report_info_message (a_msg: STRING)
		do
		    info_file.put_line (a_msg)
		    info_file.flush
		end

	report_debug_info_message (a_msg: STRING)
		do
		    debug_file.put_line (a_msg)
		    debug_file.flush
		end


feature -- Pre-emptive error report

	raise_error (a_msg: STRING)
			-- error must be processed immediately, raise an exception
		do
		    raise (a_msg)
		end

feature -- Status report

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
