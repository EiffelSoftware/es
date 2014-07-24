note
	description: "Summary description for {ES_ADB_RELAXED_TESTING_EXECUTOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_RELAXED_TESTING_PROCESS

inherit
	ES_ADB_PROCESS

create
	make

feature -- Operation

	make (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS; a_working_directory: STRING; a_output_buffer: ES_ADB_PROCESS_OUTPUT_BUFFER)
			-- Initialization.
		require
			a_feature /= Void
		local
			l_command_line: STRING
			l_max_length: INTEGER
		do
			feature_to_relax := a_feature
			l_command_line := command_line_for_relaxed_testing (a_feature)
			l_max_length := config.Max_session_length_for_relaxed_testing + config.Max_session_overhead_length
			set_should_output_be_parsed (False)
			set_should_output_be_logged (True)

			make_process (l_command_line, a_working_directory, l_max_length, a_output_buffer)
		end

feature -- Access

	feature_to_relax: EPA_FEATURE_WITH_CONTEXT_CLASS
			-- Feature to relax.

feature{NONE} -- Implementation

	command_line_for_relaxed_testing (a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS): STRING
			-- Command line string for generating relaxed tests for `a_feature'.
		require
			a_feature /= Void
		local
			l_seed: STRING
		do
			if config.should_use_fixed_seed_in_testing then
				l_seed := "-e " + config.fixed_seed.out
			else
				l_seed := ""
			end

			create Result.make_empty
			Result := "%"" + eve_path.out + "%" "
					+ "-project_path %"" + project_path_in_working_directory.out + "%" "
					+ "-config %"" + ecf_path_in_working_directory.out + "%" "
					+ "-target " + target_of_project + " "
					+ "-auto_test -i -f --agents none --integer-bounds -512,512 --state argumentless --serialization passing,failing --retrieve-serialization-online "
					+ "-t " + config.Max_session_length_for_relaxed_testing.out + " "
					+ l_seed + " "
					+ "--disable-feature-contracts " + a_feature.qualified_feature_name + " "
					+ "--5times " + a_feature.qualified_feature_name + " "
					+ "--output-test-case-online %"" + config.working_directory.relaxed_testing_result_dir.out + "%" "
					+ "--output-test-case-online-filter " + a_feature.qualified_feature_name + " "
					+ a_feature.context_class.name_in_upper
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
