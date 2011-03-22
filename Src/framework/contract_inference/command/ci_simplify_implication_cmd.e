note
	description: "Class to simplify inferred implications"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_SIMPLIFY_IMPLICATION_CMD

inherit
	EPA_STRING_UTILITY

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
			l_file_searcher: EPA_FILE_SEARCHER
		do
			create files.make (100)
			files.compare_objects

				-- Search for implication files and put them into `files'.
			create l_file_searcher.make_with_pattern (".+__implications.txt$")
			l_file_searcher.set_is_dir_matched (False)
			l_file_searcher.set_is_search_recursive (True)
			l_file_searcher.file_found_actions.extend (agent on_implication_file_found)
			l_file_searcher.search (config.input_location)

				-- Process `files' and simplify implications stored in
				-- every implication files.
			process_files
		end

feature{NONE} -- Implication

	files: HASH_TABLE [STRING, STRING]
		-- List of implication files that are found.
		-- Keys are CLASS_NAME.feature_name, values are the file path.

feature{NONE} -- Implication

	process_files
			-- Process `files' and simplify implications stored in every file,
			-- store results in `config'.`output_location'.
		local
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_parts: LIST [STRING]
			l_file: PLAIN_TEXT_FILE
			l_implications: LINKED_LIST [EPA_EXPRESSION]
			l_expr: EPA_AST_EXPRESSION
			l_line: STRING
		do
			across files as l_files loop
				l_parts := l_files.key.split ('.')
				l_class := first_class_starts_with_name (l_parts.first)
				l_feature := l_class.feature_named (l_parts.last)
				create l_implications.make
				create l_file.make_open_read (l_files.item)
				from
					l_file.read_line
				until
					l_file.after
				loop
					l_line := l_file.last_string.twin
					l_line.remove_head (l_line.index_of (':', 1) + 1)
					create l_expr.make_with_text (l_class, l_feature, l_line, l_class)
					if l_expr.type /= Void then
						l_implications.extend (l_expr)
					end
					l_file.read_line
				end
				l_file.close
				process_implications (l_implications, l_class, l_feature)
			end
		end

	process_implications (a_implications: LINKED_LIST [EPA_EXPRESSION]; a_class: CLASS_C; a_feature: FEATURE_I)
			-- Simplify `a_implications' inferred for `a_feature' in `a_class' and store result in `config'.`output_location'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_append ("/home/jasonw/tmp/implications.txt")
			across a_implications as l_imps loop
				io.put_string (class_name_dot_feature_name (a_class, a_feature) + " : " + l_imps.item.text + "%N")
				l_file.put_string (class_name_dot_feature_name (a_class, a_feature) + " : " + l_imps.item.text + "%N")
			end
			l_file.close
		end

	on_implication_file_found (a_path: STRING; a_file_name: STRING)
			-- Action to be performed when an implication file `a_path' is found.
			-- Put that file into `files'.
		local
			l_name: STRING
			l_parts: LIST [STRING]
			l_class_name: STRING
			l_feature_name: STRING
			l_class: CLASS_C
			l_feature: FEATURE_I
		do
			l_name := a_file_name.twin
			l_name.remove_tail (("__implications.txt").count)
			l_parts := string_slices (l_name, "__")
			if l_parts.count = 2 then
				l_class_name := l_parts.first
				l_feature_name := l_parts.last
				l_class := first_class_starts_with_name (l_class_name)
				if l_class /= Void then
					l_feature := l_class.feature_named (l_feature_name)
					if l_feature /= Void then
						files.force (a_path, class_name_dot_feature_name (l_class, l_feature))
					end
				end
			end
		end


note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
