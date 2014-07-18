note
	description: "Summary description for {ES_ADB_PROGRESS_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_PROGRESS_LOGGER

inherit
	ES_ADB_LOGGER
		redefine
			is_logging,
			on_test_case_generated,
			on_fixing_start,
			on_valid_fix_found,
			on_fixing_stop,
			on_fix_applied
		end

create
	default_create

feature -- Access

	log_file_name: STRING = "progress.log"
			-- <Precursor>

feature -- Status report

	is_logging: BOOLEAN
			-- <Precursor>
		do
			Result := Precursor and then not is_loading
		end

feature -- Action

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- <Precursor>
		do
			log ({AUT_INTERPRETER_PROXY}.Msg_tc_generated)
			log_line (a_test.location.out)
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
			log (Msg_fixing_started)
			log_line (a_fault.signature.id)
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_msg: STRING
		do
			create l_msg.make (256)
			l_msg.append ({AFX_PROXY_LOGGER}.msg_valid_fix_start + "%N")
			l_msg.append (a_fix.fix_summary + "%N")
			if attached {ES_ADB_FIX_AUTOMATIC} a_fix as lt_fix then
				l_msg.append (lt_fix.fix_text +"%N")
			end
			l_msg.append ({AFX_PROXY_LOGGER}.msg_valid_fix_end + "%N")
			ensured_log (l_msg)
		end

	on_fixing_stop
			-- <Precursor>
		do
		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_msg: STRING
		do
			create l_msg.make (256)
			l_msg.append (Msg_fix_applied)
			l_msg.append ("FaultID:" + a_fix.fault.signature.id + ";")
			l_msg.append ("FixID:" + a_fix.fix_id_string + ";%N")
			ensured_log (l_msg)
		end

feature -- Operatoin

	load_log
			-- Load and parse progress from `log_file'.
			-- Publish the events.
		local
			l_retried: BOOLEAN
			l_parser: ES_ADB_PROCESS_OUTPUT_PARSER
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_root_dir: PATH
		do
			if not l_retried then
				is_loading := True
				l_root_dir := info_center.config.working_directory.root_dir
				create l_file.make_with_path (l_root_dir.extended (log_file_name))
				if l_file.exists then
					l_file.open_read
					if l_file.is_open_read then
						create l_parser.make
						from
							l_file.start
						until
							l_file.end_of_file
						loop
							l_file.read_line

							l_line := l_file.last_string.twin
							l_line.append ("%N")

							l_parser.parse (l_line)
						end
						l_file.close
					end
				end
				is_loading := False
			end
		rescue
			is_loading := False
			retry
		end

feature{NONE} -- Status report

	is_loading: BOOLEAN
			-- Is current loading progress from `log_file'?

feature -- Constant

	Msg_fixing_started: STRING = "<[- Fixing started -]>"
	Msg_fix_applied: STRING = "<[- Fix applied -]>"

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
