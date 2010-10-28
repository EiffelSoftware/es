note
	description: "Utility class used to release the project files."
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.2009"

class
	SET_RELEASER

	create make

feature {NONE}

	const: SET_UTILITY_AND_CONSTANTS
			-- Utilities

feature -- Creation

	make
			-- Default creation.
		do
			create const
		end

feature -- Basic operations

	release: DS_ARRAYED_LIST[STRING]
					-- Release of all classes.
		local
			repo_dir, current_dir: DIRECTORY
					-- The two dirs between which a release will happen.
			release_number: INTEGER
					-- The release version number.
			versions: SET_CLASSES_VERSIONS_MANAGER
					-- All the existing class versions.
			messages: SET_STATUS_MESSAGES
					-- Informational messages.
		do
			create Result.make_default
			create messages
			if const.repo_dir /= Void then
				create repo_dir.make (const.repo_dir + const.separator + const.Schema_evolution_handlers_dir)
				if not repo_dir.exists then
					repo_dir.create_dir
					Result.put_last( messages. repo_handlers_dir_creation (repo_dir.name))
				end
				release_number := const.releases_count
				create repo_dir.make (const.repo_dir + const.separator + const.Release_dir_prefix + release_number.out)
				repo_dir.create_dir
					-- Creation of the current repo dir.
				create current_dir.make_open_read (const.current_dir)
					-- Project dir.
				create versions.make_list
					-- Read all the versions.
				copy_all(current_dir, repo_dir, versions, release_number)
					-- Copy all the appropriate files from the current dir to the repo dir.
				versions.close
					-- Close the file and write the versions information file.
				Result.put_last (messages.release (const.repo_dir + const.separator + const.Release_dir_prefix + release_number.out))
					-- Print a nice message in the status window.
			end
		end

	release_schema_evolution_handler: DS_ARRAYED_LIST [STRING]
				-- Release the schema evolution handlers.
		local
			repo_dir, current_dir: DIRECTORY
					-- The two dirs between which a release will take place.
			repo_path, current_path: STRING
					-- The two paths to the repository and to teh current dir.
			versions: SET_CLASSES_VERSIONS_MANAGER
					-- All the existing class versions.
			msg: SET_STATUS_MESSAGES
		do
			create Result.make_default
			create msg
			repo_path := const.repo_dir + const.separator + const.Schema_evolution_handlers_dir
				-- Read the path
			current_path := const.current_dir + const.separator + const.Schema_evolution_handlers_dir
				-- Read the current dir
			create current_dir.make (current_path)
				-- Project dir
			if not current_dir.exists then
				current_dir.create_dir
				Result.put_last (msg.main_handler_dir_creation (current_dir.name))
			end
			current_dir.open_read
			if current_dir.exists then
				create repo_dir.make (repo_path)
					--create the repo dir
				if not repo_dir.exists then
					repo_dir.create_dir
					Result.put_last (msg. repo_handlers_dir_creation (repo_dir.name))
				end
				repo_dir.open_read
				-- TODO: check the following dead code for removal.
				--create versions.make_list (const)
					--read all the versions
				copy_all(current_dir,repo_dir, versions,-2)
					--copy all the files
				--versions.close
				Result.put_last (msg.handler_released(repo_path))
				-- Print a nice message in the status window.
			else
				Result.put_last (msg.handler_folder_not_found)
				-- Print a nice message in the status window.
			end
		end

feature {NONE} --implementation

	copy_all (current_dir, repo_dir: DIRECTORY; versions: SET_CLASSES_VERSIONS_MANAGER; release_number: INTEGER)
			-- copy all the current_dir on the repo_dir
		local
			string, content: STRING
			next_dir,next_repo_dir: DIRECTORY
			repo_file, current_file: PLAIN_TEXT_FILE
		do
			from
				current_dir.start
				current_dir.readentry
			until
				current_dir.lastentry = Void
			loop
				string := current_dir.lastentry
				if not string.is_equal ("..") and not string.is_equal (".")  and not string.is_equal("EIFGENs")
				and not string.is_equal (const.Schema_evolution_handlers_dir) and not string.is_equal (const.config_file)
				and not string.is_equal (const.class_versions_info_file) and not string.is_equal (const.relative_repo_dir)
				then
					create next_dir.make (current_dir.name + const.separator + string)
					if next_dir.exists then
						next_dir.open_read
						create next_repo_dir.make (repo_dir.name + const.separator + string)
						next_repo_dir.create_dir
						copy_all(next_dir,next_repo_dir,versions, release_number)
					else -- it is a file
						create current_file.make (current_dir.name + const.separator + string)
						content := update_file_with_version (current_file, versions, release_number)
							--read the file
						create repo_file.make_open_write (repo_dir.name + const.separator + string)
						repo_file.put_string (content)
							--add the content to the new file
						repo_file.close
						--if not versioned then
								--if the current file is not versioned
							current_file.open_write
							current_file.put_string (content)
								--add the version
							current_file.close
						--end
					end
				end
				current_dir.readentry
			end
			current_dir.close
		end

	update_file_with_version (file: PLAIN_TEXT_FILE; versions: SET_CLASSES_VERSIONS_MANAGER; release_number: INTEGER): STRING
			-- Read `file' and insert the correct version.
		local
			is_version_written, is_versioned_class, is_versioned_class_written, is_e_file, is_modified, has_stopped_parsing: BOOLEAN
			current_line,file_name,class_name: STRING
			class_version: INTEGER
			internal_helper: INTERNAL
			versioned_type, current_type: INTEGER
			last_end: INTEGER
		do
			is_version_written := false
			file_name := file.name
			is_e_file := file_name.substring (file_name.count - 1, file_name.count).is_equal (".e")
			class_name := file_name.substring (1,file_name.count - 2).split (const.separator.item (1)).last
			class_name.to_upper
			if is_e_file and release_number >= 0 then
				is_modified := const.is_modified (file)
			end
			Result := ""
			file.open_read
			create internal_helper
			is_versioned_class := false
			if is_e_file and release_number >= 0 then
				if is_modified then
					versions.increment_version (class_name, -1)
				end
				class_version := versions.get_version (class_name, -1)
				versions.add_version (class_name, release_number, class_version)
				is_versioned_class := class_version > 1 or not is_modified
			end
			is_versioned_class_written := is_versioned_class
			if is_e_file then
				versioned_type := internal_helper.dynamic_type_from_string ("VERSIONED_CLASS")
				current_type := internal_helper.dynamic_type_from_string (class_name.out)
			end
			if (versioned_type >= 0) and then (current_type >= 0) and then internal_helper.type_conforms_to(current_type,versioned_type) then
				is_versioned_class_written := true
			end
			from file.start until file.after loop
				file.read_line
				current_line := file.last_string
					--find the version
				if is_e_file and release_number >= 0 and is_modified then
					if current_line.has_substring ("inherit") and not is_versioned_class_written then
						is_versioned_class_written := true
						Result := Result + current_line + "%N" + "%TVERSIONED_CLASS%N%N"
						file.read_line
						current_line := file.last_string
					elseif (current_line.has_substring ("create") or current_line.has_substring ("feature"))
						and not is_versioned_class_written then
						is_versioned_class_written := true
						Result := Result + "inherit" +
								"%N%TVERSIONED_CLASS%N%N"
					end
					if not is_versioned_class and current_line.has_substring ("feature") and not is_version_written then
						is_version_written := true
						Result := Result + "feature -- Version implementation%N" +
							"%Tversion: INTEGER%N"+
							"%T%T%T-- The class version.%N" +
							"%T%Tdo%N" +
							"%T%T%TResult:=" + class_version.out + "%N" +
							"%T%Tend%N%N"
					end
					if is_versioned_class and current_line.has_substring ("version") and current_line.has_substring ("INTEGER") and not is_version_written then
						is_version_written := true
						has_stopped_parsing := false
						from until has_stopped_parsing loop
							if current_line.has_substring ("Result") then
								Result := Result + "%T%T%TResult:=" + class_version.out + "%N"
								has_stopped_parsing:=true
							else
								Result := Result + current_line + "%N"
							end
							file.read_line
							current_line := file.last_string
						end
					end
				end
				if current_line.has_substring ("end") then
					last_end := Result.count
				end
				Result := Result + current_line + "%N"
			end
			Result.remove_tail (1)
			file.close
			if is_e_file and is_versioned_class and (not is_version_written) and is_modified then
				current_line := "feature -- Version implementation%N" +
							"%Tversion: INTEGER%N" +
							"%T%T%T-- The class version.%N" +
							"%T%Tdo%N" +
							"%T%T%TResult:=" + class_version.out + "%N" +
							"%T%Tend%N"
				Result.insert_string (current_line, last_end)
			end
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
