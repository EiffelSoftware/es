indexing
	description: "Summary description for {EWB_SAT_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_SAT_ANALYZER

inherit
	EWB_CMD
		redefine
			check_arguments_and_execute
		end

	KL_SHARED_FILE_SYSTEM

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_directory: STRING; a_session_length: INTEGER; a_output_directory: STRING) is
		require
			a_directory_attached: a_directory /= Void
		do
			directory := a_directory.twin
			session_length := a_session_length
			output_directory := a_output_directory.twin
		ensure
			directory_set: directory /= Void and then directory.is_equal (a_directory)
		end

feature -- Properties

	directory: STRING
			-- Directory where result files are stored

	session_length: INTEGER
			-- Length of session, in form of "180", "60"

	output_directory: STRING
			-- Directory to store output

	name: STRING is
		do
			Result := "SATS Analyzer"
		end

	help_message: STRING_GENERAL is
		do
			Result := "SATS Analyzer"
		end

	abbreviation: CHARACTER is
		do
			Result := 'y'
		end

feature -- Execution

	execute is
			-- Action performed when invoked from the
			-- command line.
		local
			l_files: like result_files
			l_file: TUPLE [a_class_name: STRING; a_session_index: INTEGER; a_path: STRING]
		do
			l_files := result_files
			from
				l_files.start
			until
				l_files.after
			loop
				l_file := l_files.item
				io.put_string (l_files.index.out + "/" + l_files.count.out + ": " + l_file.a_class_name + "%N")
				analyze_one_test_session (l_file.a_class_name, l_file.a_session_index, l_file.a_path)
				l_files.forth
			end
		end

	check_arguments_and_execute is
			-- Check the arguments and then perform then
			-- command line action.
		do
		end

	analyze_one_test_session (a_class_name: STRING; a_session_index: INTEGER; a_path: STRING) is
			-- Analyze one test session for class `a_class_name'.
			-- `a_session_index' is the index of the to be analyzed session,
			-- `a_path' is the path of "result.tar.gz" file.
		require
			a_class_name_attached: a_class_name /= Void
			a_session_index_positive: a_session_index > 0
			a_path_attached: a_path /= Void
		local
			l_output_dir: FILE_NAME
			l_new_result_file: FILE_NAME
			l_environ: EXECUTION_ENVIRONMENT
			l_current_dir: STRING
			l_result_loader: SAT_RESULT_LOADER
			l_file_searcher: SAT_FILE_SEARCHER
		do
			create l_environ
			l_current_dir := l_environ.current_working_directory

				-- Create the output directory to store result.
			create l_output_dir.make_from_string (output_directory)
			l_output_dir.extend (a_class_name)
			l_output_dir.extend (a_session_index.out)
			file_system.recursive_create_directory (l_output_dir)
			l_new_result_file := l_output_dir.twin
			l_new_result_file.set_file_name ("result.tar.gz")
			file_system.copy_file (a_path, l_new_result_file)

				-- Extract result file.
			l_environ.change_working_directory (l_output_dir)
			l_environ.system ("tar -xzvf result.tar.gz")

				-- Analyze result.
			create l_result_loader.make (l_output_dir, system, 0, session_length * 60, session_length)
			l_result_loader.load
			l_result_loader.generate_statistics

				-- Delete unnecessary files.
			file_system.delete_file ("proxy_log.txt")
			create l_file_searcher.make_with_pattern ("sat_.*\.log")
			l_file_searcher.locations.extend (l_output_dir)
			l_file_searcher.search
			from
				l_file_searcher.last_found_files.start
			until
				l_file_searcher.last_found_files.after
			loop
				file_system.delete_file (l_file_searcher.last_found_files.item)
				l_file_searcher.last_found_files.forth
			end

			l_environ.change_working_directory (l_current_dir)
		end

	result_files: LINKED_LIST [TUPLE [a_class_name: STRING; a_session_index: INTEGER; a_path: STRING]] is
			-- List of result files starting from `directory'
		local
			l_file_searcher: SAT_FILE_SEARCHER
			l_found_files: LIST [STRING]
			l_path: STRING
			l_index: INTEGER
			l_dir: STRING
			l_class_section: STRING
			l_class_name: STRING
			l_strs: LIST [STRING]
			l_session_index: STRING
			l_session_length: STRING
		do
			l_session_length := session_length.out + "m"
			create l_file_searcher.make_with_pattern ("result\.tar\.gz")
			l_file_searcher.set_is_search_recursive (True)
			l_file_searcher.locations.extend (directory)
			l_file_searcher.search
			create Result.make
			from
				l_found_files := l_file_searcher.last_found_files
				l_found_files.start
			until
				l_found_files.after
			loop
				l_path := l_found_files.item.mirrored
				l_index := l_path.index_of (Operating_environment.directory_separator, 1)
				l_dir := l_found_files.item.substring (1, l_path.count - l_index)
				l_class_section := l_found_files.item.substring (l_index + 1, l_path.count)

				l_index := l_class_section.substring_index_in_bounds (l_session_length, 1, l_class_section.count)
				l_class_name := l_class_section.substring (1, l_index - 2).mirrored
				l_class_section := l_class_section.substring (l_index, l_class_section.count)
				l_class_name := l_class_name.substring (1, l_class_name.index_of (Operating_environment.directory_separator, 1) - 1).mirrored
				l_strs := l_class_section.split ('_')
				l_session_index := l_strs.i_th (2)
				Result.extend ([l_class_name, l_session_index.to_integer, l_found_files.item.twin])
				l_found_files.forth
			end
		end

indexing
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
