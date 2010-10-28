note
	description: "File reader/witer"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SET_FILE_MANAGER
		create
			make

feature{NONE} --  Status

	const: SET_UTILITY_AND_CONSTANTS
	code_generator: SET_CODE_GENERATOR

feature -- Creation

	make is
			-- Create the code generator and utilities
		do
			create code_generator.make
			create const
		end

feature -- Utility

	create_config_file (path: STRING)
			-- Create the config file.
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make (const.current_dir + const.separator + const.config_file)
			if not file.exists then
				file.create_read_write
				file.put_string (path + "%N0")
				file.close
			end
		end

	generate_filter_file (dirs: TUPLE [DIRECTORY, DIRECTORY]; default_fields_value: DS_HASH_TABLE [STRING, STRING]) is
			-- Create the filter file and update the class to be filtered
		local
			dir, root_dir,filter_dir: DIRECTORY
			file_name, code: STRING
			filter_file, current_file: PLAIN_TEXT_FILE
		do
			root_dir ?= dirs[1]
			dir ?= dirs[2]
			file_name := ""
			file_name.copy (dir.name)
			file_name.replace_substring_all (root_dir.name+const.separator, "")
			file_name.remove_tail (2)
			print("name:" + file_name + "%N")
			create filter_dir.make (root_dir.name + const.separator + const.filter_root_dir)
			if not filter_dir.exists then
				filter_dir.create_dir
			end
			create filter_file.make (filter_dir.name + const.separator + file_name + const.Filter_suffix.as_lower + ".e")
			if not filter_file.exists then
				filter_file.create_read_write
				create current_file.make (dir.name)
				code := code_generator.add_inheritance_clause_from_filtered_class (read_plain_text_file (current_file), file_name.as_upper)
				current_file.open_write
				current_file.put_string (code)
				current_file.close
			else
				filter_file.open_write
			end
			code := code_generator.filter_code (file_name.as_upper, default_fields_value)
			filter_file.put_string (code)
			filter_file.close
		end

	update_config_file
			-- Update the config file with the last release time
		local
			last_release_time: INTEGER_64
			date: DATE_TIME
			file: PLAIN_TEXT_FILE
			repo_path: STRING
		do
			create date.make_now_utc
			last_release_time := date.definite_duration (create {DATE_TIME}.make (1970, 1, 1, 0,0,0)).seconds_count
			create file.make (const.current_dir + const.separator + const.config_file)
			file.open_read
			file.start
			file.read_line
			repo_path := file.last_string
			file.close
			file.open_write
			file.put_string (repo_path + "%N" + last_release_time.out)
			file.close
		end

	read_plain_text_file (file: PLAIN_TEXT_FILE): STRING
			-- Read a file and return the content as a string
		do
			file.open_read
			Result:=""
			from file.start until file.after loop
				file.read_line
				Result:=Result+file.last_string+"%N"
			end
			file.close
		end

invariant
	-- Insert invariant here
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
