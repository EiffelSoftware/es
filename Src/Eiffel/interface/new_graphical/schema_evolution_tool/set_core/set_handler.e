note
	description: "Encapsulates actions of the schema evolution handler IDE"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SET_HANDLER

	create
		make

feature{NONE} -- Status

	version1_dir, version2_dir: DIRECTORY
		-- The two versions dirs.
	version1, version2: INTEGER
		-- The two versions dir numbers.
	const: SET_UTILITY_AND_CONSTANTS
		-- Utilities and constants.
	code_generator: SET_CODE_GENERATOR
		-- Code generator.

feature -- Creation

	make
			-- Create utilities and code generator
		do
			create const
			create code_generator.make
		end

feature -- Setters

	set_version1_int (v1: INTEGER)
			-- Set version1.
		require
			version_allowed: v1 > 0
		do
			version1 := v1
			create version1_dir.make (const.repo_dir + const.separator + const.Release_dir_prefix + v1.out)
		end

	set_version2_int (v2: INTEGER)
			-- Set version2.
		require
			version_allowed: v2 > 0
		do
			version2 := v2
			create version2_dir.make (const.repo_dir + const.separator + const.Release_dir_prefix + v2.out)
		end

feature -- Schema evolution handler

	schema_evolution_handler: TUPLE [DS_ARRAYED_LIST [STRING], DS_HASH_TABLE [STRING, STRING]]
			-- patch the 2 root dir
		local
			process: DS_HASH_TABLE [STRING, STRING]
			msg: DS_ARRAYED_LIST [STRING]
		do
			create process.make_default
			version1_dir.open_read
			version2_dir.open_read
			msg := create_schema_evolution_handler (version1_dir, version2_dir, process)
			Result := [msg, process]
		end

feature {NONE} -- Recursive implementation

	create_schema_evolution_handler (v1_dir, v2_dir: DIRECTORY; process: DS_HASH_TABLE[STRING,STRING]): DS_ARRAYED_LIST[STRING]
			-- browse all the files in v1_dir and compare
		local
			string: STRING
				--iteration item
			next_v1_dir,next_v2_dir: DIRECTORY
				--next dir
			v1_file, v2_file: PLAIN_TEXT_FILE
				--the 2 files
			v1, v2: INTEGER
				--the 2 version
			e_file: BOOLEAN
				--if is an e file

			field_v1,field_v2: DS_HASH_TABLE[STRING,STRING]
		do
			create Result.make_default
			from
				v1_dir.start
				v1_dir.readentry
			until
				v1_dir.lastentry = Void
			loop
				string := v1_dir.lastentry
					--iteration file o dir
				e_file := string.substring (string.count-1, string.count).is_equal (".e")
					--check if it is a `.e' file
				if not string.is_equal ("..") and not string.is_equal (".") and not string.is_equal (const.Schema_evolution_handlers_dir) and not string.is_equal (const.Filter_Root_Dir) then
					create next_v1_dir.make (v1_dir.name + const.separator + string)
						--creation of the next sub dir
					if next_v1_dir.exists then
							--if the sub dir exist (the iteration item is a folder)
						next_v1_dir.open_read
						if v2_dir/=Void then
							create next_v2_dir.make (v2_dir.name + const.separator + string)
								--creation of the v2 sub dir
						end
						if next_v2_dir /= Void and then next_v2_dir.exists then
							Result.append_last (create_schema_evolution_handler (next_v1_dir,next_v2_dir, process))
								--recursive call
						else
							Result.append_last (create_schema_evolution_handler (next_v1_dir, void, process))
						end
					elseif e_file then
							--if is a .e file
						create v1_file.make (v1_dir.name + const.separator + string)
						create v2_file.make (v2_dir.name + const.separator + string)
							--creation of the 2 files
						if not v2_file.exists then
							--create patch for a new file
							--TODO: IMPLEMENT THE MECHANISM
						else
							string.to_upper
							string.remove_tail (2)
							--string:=string.substring (0, string.count-2)
							--print(string+"%N")
							v1 := const.class_version (string,version1)
							v2 := const.class_version (string,version2)
							field_v1 := const.attributes_from_file (v1_file)
							field_v2 := const.attributes_from_file (v2_file)
							if v1 /= v2 then
								Result.append_last (create_schema_evolution_handler_file (v1, v2, string, process, field_v1, field_v2))
									--and create the patch
							end
						end
					end
				end
				v1_dir.readentry
			end
			v1_dir.close
			v2_dir.close
		end

	create_schema_evolution_handler_file (v1,v2: INTEGER; class_name: STRING; process: DS_HASH_TABLE[STRING,STRING]; v1_file,v2_file: DS_HASH_TABLE[STRING,STRING]): DS_ARRAYED_LIST[STRING]
			-- Create the concrete schema evolution handler from v1 to v2
		local
			schema_evolution_handler_dir: DIRECTORY
			schema_evolution_handler_file, schema_evolution_handler_class: PLAIN_TEXT_FILE
			name, code: STRING
			message: STRING
			file_manager: SET_FILE_MANAGER
			msg: SET_STATUS_MESSAGES
			source_code_input: STRING
		do
			create Result.make_default
			create msg
			name := class_name.split ('.').i_th (1)
				--remove the extension
			create schema_evolution_handler_dir.make (const.current_dir + const.separator + const.Schema_evolution_handlers_dir)
				--project dir containing the schema evolution handlers
			if not schema_evolution_handler_dir.exists then
				schema_evolution_handler_dir.create_dir
				Result.put_last (msg.main_handler_dir_creation (schema_evolution_handler_dir.name))
			end
			schema_evolution_handler_dir.open_read
			create 	schema_evolution_handler_file.make (schema_evolution_handler_dir.name + const.separator + const.Project_manager_class.as_lower + ".e")
				--the main schema evolution handler file
			if not 	schema_evolution_handler_file.exists then
					schema_evolution_handler_file.create_read_write
					schema_evolution_handler_file.close
				source_code_input := ""
			else
				create file_manager.make
				source_code_input := file_manager.read_plain_text_file (schema_evolution_handler_file)
			end

			create schema_evolution_handler_class.make (schema_evolution_handler_dir.name + const.separator + name.as_lower + const.Schema_evolution_handler_suffix.as_lower + ".e")
				--the current schema evolution handler class

			message := "File %"" + schema_evolution_handler_class.name + "%""
				-- informative message

			if schema_evolution_handler_class.exists then
					--if the root class shema evolution handler exists
				create file_manager.make
				-- TODO: check if the following line of code can be removed
				--code_generator.update_class_handler_code(class_patch,v1,v2,name,v1_file,v2_file)
				code := code_generator.update_class_handler_code (file_manager.read_plain_text_file (schema_evolution_handler_class), v1, v2,v1_file,v2_file)
				message := message + " updated"
					--update the file
			else
				print("input%N" + source_code_input + "%N----------%N")
				code := code_generator.class_handler_code (v1, v2,name, v1_file, v2_file)
				schema_evolution_handler_file.open_write
				schema_evolution_handler_file.put_string (code_generator.update_main_handler_code (source_code_input, name.as_upper))
				schema_evolution_handler_file.close
				message := message + " created"
			end
			schema_evolution_handler_class.create_read_write
			schema_evolution_handler_class.put_string (code)
			schema_evolution_handler_class.close
			process.force_last (code_generator.converter_messages, name)
			message := message + " with the schema evolution handler from the class version "+ v1.out + " to the class version " + v2.out
			schema_evolution_handler_dir.close
			Result.put_last (message)
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
