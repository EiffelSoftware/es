note
	description: "Command to generate ARFF files from ssql files"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_ARFF_GENERATION_CMD

create
	make

feature{NONE} -- Initialization

	make (a_config: like config)
			-- Initialize Current.
		do
			config := a_config
		end

feature -- Access

	config: CI_CONFIG
			-- Configuration of current contract inference session


feature -- Basic operations

	execute
			-- Execute Current command.
		local
			l_generator: SEM_ARFF_GENERATOR
			l_file_searcher: EPA_FILE_SEARCHER
			l_file_pattern: STRING
			l_ssql_files: DS_LINKED_LIST [STRING]
			l_ssql_loader: SEMQ_QUERYABLE_LOADER
			l_file_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
		do
				-- Search for all ssql files.
			create l_ssql_files.make
			if config.should_generate_arff_for_transitions then
				l_file_pattern := "tran.+\.ssql"
			else
				l_file_pattern := "objt.+\.ssql"
			end
			create l_file_searcher.make_with_pattern (l_file_pattern)
			l_file_searcher.file_found_actions.extend (
				agent (a_path: STRING;  a_dir: STRING; a_list: DS_LINKED_LIST [STRING])
					do
						a_list.force_last (a_path)
					end (?, ?, l_ssql_files))

				-- Set input location to look for .ssql files.
			if config.input_location /= Void then
				l_file_searcher.search (config.input_location)
			else
				l_file_searcher.search (config.ssql_directory)
			end

				-- Iterate through all found ssql files and put them
				-- into ARFF relation.
			if config.should_generate_arff_for_transitions then
				create l_generator.make_for_feature_transition
			else
				create l_generator.make_for_objects
			end

			from
				l_ssql_files.start
			until
				l_ssql_files.after
			loop
				create l_ssql_loader
				l_ssql_loader.load (l_ssql_files.item_for_iteration)
				l_generator.extend_queryable (l_ssql_loader.last_queryable, l_ssql_loader.last_meta)
				l_ssql_files.forth
			end

				-- Generate output ARFF file.
			if config.output_location /= Void then
				create l_file_path.make_from_string (config.output_location)
			else
				create l_file_path.make_from_string (config.data_directory)
			end
			l_file_path.set_file_name (config.class_name + "__" + config.feature_name_for_test_cases.first + ".arff")

			create l_file.make_create_read_write (l_file_path)
			l_generator.generate_maximal_arff (config.class_name + "__" + config.feature_name_for_test_cases.first, l_file)
			l_file.close
		end

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
