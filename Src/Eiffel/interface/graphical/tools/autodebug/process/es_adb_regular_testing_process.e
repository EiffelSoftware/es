note
	description: "Summary description for {ES_ADB_REGULAR_TESTING_EXECUTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_REGULAR_TESTING_PROCESS

inherit
	ES_ADB_PROCESS

create
	make

feature -- Operation

	make (a_classes: DS_HASH_SET [CLASS_C]; a_working_directory: STRING; a_output_buffer: ES_ADB_PROCESS_OUTPUT_BUFFER)
			-- Initialization.
		require
			a_classes /= Void and then not a_classes.is_empty
		local
			l_command_line: STRING
			l_max_length: INTEGER
		do
			classes := a_classes.twin
			l_command_line := command_line_for_testing_classes (a_classes)
			l_max_length := config.max_session_length_for_testing + config.Max_session_overhead_length
			set_should_output_be_parsed (True)
			set_should_output_be_logged (True)

			make_process (l_command_line, a_working_directory, l_max_length, a_output_buffer)

			on_start_actions.extend (agent info_center.start_logging_class_timestamps (info_center.config))
			on_start_actions.extend (agent info_center.on_testing_start)
			on_terminate_actions.extend (agent info_center.stop_logging_class_timestamps)
			on_terminate_actions.extend (agent info_center.on_testing_stop)
		end

feature -- Access

	classes: DS_HASH_SET [CLASS_C]
			-- Classes tested.

feature{NONE} -- Implementation

	command_line_for_testing_classes (a_classes: DS_HASH_SET [CLASS_C]): STRING
			-- Command line string for testing `a_classes'.
		require
			a_classes /= Void and then not a_classes.is_empty
		local
			l_seed: STRING
			l_cursor: DS_HASH_SET_CURSOR [CLASS_C]
		do
			if config.should_use_fixed_seed_in_testing then
				l_seed := "-seed " + config.fixed_seed.out
			else
				l_seed := ""
			end

			create Result.make_empty
			Result := "%"" + eve_path.out + "%" "
					+ "-project_path %"" + project_path_in_working_directory.out + "%" "
					+ "-config %"" + ecf_path_in_working_directory.out + "%" "
					+ "-target " + target_of_project + " "
					+ "-auto_test -i -f --agents none --integer-bounds -512,512 --state argumentless --serialization passing,failing --retrieve-serialization-online "
					+ "-t " + config.max_session_length_for_testing.out + " "
					+ l_seed + " "
					+ "--output-test-case-online %"" + config.working_directory.testing_result_dir.out + "%" ";

			from
				l_cursor := a_classes.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append (" " + l_cursor.item.name_in_upper)
				l_cursor.forth
			end
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
