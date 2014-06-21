note
	description: "Summary description for {ES_ADB_WORKING_DIRECTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_ADB_WORKING_DIRECTORY

inherit
	ES_ADB_TOOL_HELPER

create
	make

feature{NONE} -- Initialization

	make (a_root_dir: PATH)
			-- Initialization.
		do
			root_dir := a_root_dir.twin
		end

feature -- Access

	root_dir: PATH
			-- Root of the working directory.

feature -- Query

	testing_result_dir: PATH
			-- Path to the directory for testing results.
		do
			if testing_result_dir_internal = Void then
				initialize
			end
			Result := testing_result_dir_internal
		end

	testing_result_dir_for_fault (a_fault: ES_ADB_FAULT): PATH
			-- Path to the directory for testing results related with `a_fault'.
		require
			a_fault /= VOid
		do
			Result := testing_result_dir.extended (a_fault.signature.class_under_test).extended (a_fault.signature.feature_under_test)
		end

	tested_class_timestamps_path: PATH
			-- Path to the file of timestamps for the tested classes.
		do
			if tested_class_timestamps_path_internal = Void then
				initialize
			end
			Result := tested_class_timestamps_path_internal
		end

	relaxed_testing_result_dir: PATH
			-- Path to the directory of relaxed testing results.
		do
			if relaxed_testing_result_dir_internal = Void then
				initialize
			end
			Result := relaxed_testing_result_dir_internal
		end

	fixing_result_dir: PATH
			-- Path to the directory for fixing results.
		do
			if fixing_result_dir_internal = Void then
				initialize
			end
			Result := fixing_result_dir_internal
		end

	fixing_result_file_path (a_fault: ES_ADB_FAULT): PATH
			-- Path to the fixing result file for `a_fault'.
		require
			a_fault /= Void
		do
			Result := fixing_result_dir.extended (a_fault.signature.id + ".afx")
		end

	temp_dir: PATH
			-- Path to the directory for temporary files.
		do
			if temp_dir_internal = Void then
				initialize
			end
			Result := temp_dir_internal
		end

	original_file_path (a_copied_file_path: PATH): PATH
			-- Path to the origian file, given the path to its copy in current.
		require
			a_copied_file_path /= Void
		local
			l_copied_path_str, l_original_path_str, l_root_path_str, l_project_path_str: STRING
		do
			l_copied_path_str := a_copied_file_path.out
			l_root_path_str := temp_dir.out
			l_original_path_str := l_copied_path_str.twin
			if l_copied_path_str.starts_with (l_root_path_str) then
				l_project_path_str := project_path.out
				l_original_path_str.replace_substring_all (l_root_path_str, l_project_path_str)
			end
			create Result.make_from_string (l_original_path_str)
		end

feature -- Operation

	initialize
			-- Initialize the structure of the directory.
		local
			l_dir: DIRECTORY
		do
			testing_result_dir_internal := root_dir.extended ("testing")
			tested_class_timestamps_path_internal := testing_result_dir.extended ("timestamps.log")
			relaxed_testing_result_dir_internal := root_dir.extended ("relaxed_testing")
			fixing_result_dir_internal := root_dir.extended ("fixing")
			temp_dir_internal := root_dir.extended ("temp")

			create l_dir.make_with_path (testing_result_dir_internal)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end

			create l_dir.make_with_path (relaxed_testing_result_dir_internal)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end

			create l_dir.make_with_path (fixing_result_dir_internal)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end

			create l_dir.make_with_path (temp_dir_internal)
			if l_dir.exists then
				l_dir.recursive_create_dir
			end
		end

	clear
			-- Clear the content in Current.
		local
			l_dir: DIRECTORY
		do
			create l_dir.make_with_path (root_dir)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end
			l_dir.recursive_delete
		end

feature{NONE} -- Cache

	testing_result_dir_internal: like testing_result_dir
	tested_class_timestamps_path_internal: like tested_class_timestamps_path
	relaxed_testing_result_dir_internal: like relaxed_testing_result_dir
	fixing_result_dir_internal: like fixing_result_dir
	temp_dir_internal: like temp_dir

;note
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
