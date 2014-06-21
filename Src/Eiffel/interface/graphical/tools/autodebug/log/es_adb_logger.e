note
	description: "Summary description for {ES_ADB_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_LOGGER

inherit
	ES_ADB_ACTIONS

	ES_ADB_SHARED_INFO_CENTER

feature -- Access

	log_file: PLAIN_TEXT_FILE
			-- Log file.

feature -- Status report

	is_logging: BOOLEAN
			-- Is current logging?
		do
			Result := log_file /= Void and then log_file.is_open_append
		end

feature -- Setter

	start_logging
			-- Initialize current with `a_dir'.
		local
			l_root_dir: PATH
		do
			l_root_dir := info_center.config.working_directory.root_dir
			create log_file.make_with_path (l_root_dir.extended (log_file_name))
			log_file.open_append
		end

	stop_logging
			-- Close `log_file'.
		do
			if is_logging then
				log_file.flush
				log_file.close
			end
			log_file := Void
		ensure
			not is_logging
		end

	clear_log
			-- Clear `log_file' from last logging.
		do
			stop_logging
			log_file.wipe_out
		end

feature -- Logging

	log (a_msg: STRING)
			-- Log `a_msg'.
		require
			a_msg /= Void
		do
			if is_logging then
				log_file.put_string (a_msg)
				log_file.flush
			end
		end

	log_line (a_msg: STRING)
			-- Log `a_msg' and start a new line.
		require
			a_msg /= Void
		do
			if is_logging then
				log_file.put_string (a_msg)
				log_file.put_character ('%N')
				log_file.flush
			end
		end

feature -- ADB Action

	on_project_loaded
			-- <Precursor>
		do
			start_logging
		end

	on_project_unloaded
			-- <Precursor>
		do
			stop_logging
		end

	on_compile_start
			-- <Precursor>
		do
		end

	on_compile_stop
			-- <Precursor>
		do
		end

	on_debugging_start
			-- <Precursor>
		do
		end

	on_debugging_stop
			-- <Precursor>
		do
		end

	on_testing_start
			-- <Precursor>
		do
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- <Precursor>
		do
		end

	on_testing_stop
			-- <Precursor>
		do
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_fixing_stop
			-- <Precursor>
		do
		end

	on_continuation_debugging_start
			-- <Precursor>
		do
		end

	on_continuation_debugging_stop
			-- <Precursor>
		do
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		do
		end

	on_output (a_line: STRING)
			-- <Precursor>
		do
		end

feature{NONE} -- Implementation

	log_file_name: STRING
			-- Name of the log file.
		deferred
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
