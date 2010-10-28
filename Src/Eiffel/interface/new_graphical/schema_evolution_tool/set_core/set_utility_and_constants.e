note
	description: "Utility features and constants"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SET_UTILITY_AND_CONSTANTS

inherit
	SHARED_WORKBENCH
		export
			{NONE} all
		end
	SHARED_EIFFEL_PARSER
		export
			{NONE} all
		end

feature -- Constants

	separator: STRING
			-- Platform-independent directory separator.
		local
			a :ANY
		do
			create a
			Result := a.operating_environment.directory_separator.out
		end

	Release_dir_prefix: STRING = "release_"
			-- Prefix of the release dir name.

	Schema_evolution_handlers_dir: STRING = "schema evolution handlers"
			-- Schema evolution handlers dir name.

	Schema_evolution_handler_suffix: STRING = "_SCHEMA_EVOLUTION_HANDLER"
			-- Suffix of the schema evolution handler class name.

	Filter_Root_Dir: STRING = "filter"
			-- Filter dir name.

	Filtered_class: STRING = "FILTERED_CLASS"
			-- Name of the base class for filtering. The application class to be filtered inherits from it.

	Filter_suffix: STRING = "_FILTER"
			-- Suffix of the filter class name. The application class name is the prefix.

	Filter_class: STRING = "CUSTOM_SERIALIZATION_FILTER"
			-- Name of the base class for filter customization. The specific application class filter inherits from it.

	Project_manager_class: STRING = "SCHEMA_EVOLUTION_PROJECT_MANAGER"
			-- Name of the schema evolution project manager class.

	Schema_evolution_handler_class: STRING = "SCHEMA_EVOLUTION_HANDLER"
			-- Name of the schema evolution handler class. NOTE: this is used by CODE_GENERATOR (check)

	Conversion_functions_class: STRING = "SCHEMA_EVOLUTION_DEFAULT_CONVERSION_FUNCTIONS"
			-- The name of the class containing the predefined conversion functions. NOTE: this is used by CODE_GENERATOR (check)

	Config_file: STRING = "config.cfg"
			-- Project configuration file name.

	Class_versions_info_file: STRING = "class_version_information.cfg"
			-- Class versions information configuration file name.

	feature -- Access

	last_release: INTEGER_64
			--  Time of last release
		local
			file: PLAIN_TEXT_FILE
			last_release_time: STRING_32
		do
			create file.make (current_dir + separator + config_file)
			if file.exists and file.is_readable then
				file.open_read
				file.start
				file.read_line
				file.read_line
				last_release_time := file.last_string
				file.close
			end
			if last_release_time.is_integer_64 then
				Result := last_release_time.to_integer_64
			end
		end

	class_version (name: STRING; repo_ver: INTEGER): INTEGER
			--  Version of class `name' in repository `repo_ver'.
		local
			versions: SET_CLASSES_VERSIONS_MANAGER
		do
			create versions.make_list
			Result := versions.get_version (name, repo_ver)
		end

	repo_dir: STRING
			-- Repository dir as read from the config file.
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make (current_dir + separator + config_file)
			if file.exists and file.is_readable then
				file.open_read
				file.start
				file.read_line
				Result := file.last_string
				file.close
			end
		end

	relative_repo_dir: STRING
			-- Repository dir name with path stripped.
		local
			temp_index: INTEGER
		do
			Result := repo_dir
			temp_index :=  Result.last_index_of (separator.item (1), Result.count)
			Result := Result.substring (temp_index + 1, Result.count)
		end

	current_dir: STRING
			-- Current root directory.
		do
			Result := workbench.project_location.location
		end

	attributes_from_file (file: PLAIN_TEXT_FILE): DS_HASH_TABLE [STRING, STRING]
			-- Read all the attributes of a class from an eiffel source file and return them in a hash table.
		local
			content: STRING
		do
			content := ""
			file.open_read
			from file.start until file.after loop
				file.read_line
				content := content + file.last_string + "%N"
			end
		--	Changed in new Escher
			eiffel_parser.parse_from_ascii_string (content, Void)
			Result := attributes_from_ast (eiffel_parser.root_node)
		end
-- TODO: check if the following is useful.
--	parent_versioned_class (e_code: STRING): STRING is
			-- The name of the parent versioned class. NOTE: not used by the project. Check where it is used
--		do
--			eiffel_parser.parse_from_string (e_code)
--			Result := parent_class (eiffel_parser.root_node)
--		end

	copy_system_classes (i:INTEGER): DS_ARRAYED_LIST [DIRECTORY]
			-- Copy all classes in repository i. Return all the files and dirs in the repo.
			-- TODO: refactor to obey command-query separation
		local
			dir: DIRECTORY
		do
			create Result.make_default
			create dir.make_open_read (repo_dir + separator + Release_dir_prefix + i.out)
			copy_all (dir, Result)
		end

	releases_count: INTEGER
			-- The number of releases.
		local
			dir: DIRECTORY
		do
			create dir.make (repo_dir)
			Result := dir.linear_representation.count - 2
		end

	filtered_fields_defaults (dir: DIRECTORY; class_name: STRING): DS_HASH_TABLE[STRING,STRING]
			-- Read a filtered class and return the default fields values.
		require
			dir_exists: dir /= Void
			class_exists: class_name /= Void and then not class_name.is_empty
		local
			file: PLAIN_TEXT_FILE
			line: STRING
			split: LIST[STRING]
		do
			create Result.make_default
			create file.make (dir.name + separator + Filter_Root_Dir + separator + class_name.as_lower + Filter_suffix.as_lower + ".e")
			if file.exists then
				file.open_read
				from file.start until file.after loop
					file.read_line
					line:=file.last_string
					if line.has_substring ("add") then
						line.replace_substring_all ("add","")
						line.replace_substring_all (" ","")
						line.replace_substring_all ("%"","")
						line.replace_substring_all (")","")
						line.replace_substring_all ("(","")
						line.replace_substring_all ("%T","")
						split:=line.split (',')
						if(split.count=2) then
							Result.force (split.i_th (1),split.i_th (2))
						end
					end
				end
			end
		end

feature -- Boolean queries

	is_modified (file: PLAIN_TEXT_FILE): BOOLEAN
			-- Has the class name changed? TODO: FIX IT: it does not work!
		do
			Result := last_release < file.date
		end

feature {NONE} --implementation

	attributes_from_ast (ast: CLASS_AS): DS_HASH_TABLE [STRING, STRING]
			-- The attributes from the class AST are returned in a hash table (key is name and item is type).
		local
			tmp: BILINEAR [FEATURE_AS]
			feat: FEATURE_AS
			type: STRING
		do
			create Result.make_default
			tmp := ast.all_features
			from tmp.start until tmp.after loop
			feat := tmp.item_for_iteration
				if feat.is_attribute then
					type := feat.body.type.dump
					from feat.feature_names.start
					until feat.feature_names.after
					loop
						Result.force (type, feat.feature_names.item_for_iteration.visual_name_32)
						feat.feature_names.forth
					end
				end
				tmp.forth
			end
		end

-- TODO: check if the following is useful. In that case it has to be fixed

--	parent_class (ast: CLASS_AS): STRING is
			-- The parent class name, conforming with VERSIONED_CLASS.
--		local
--			parent: PARENT_LIST_AS
--			name: STRING
--			internal: INTERNAL
--		do
--			parent := ast.parents
--			create internal
--			Result := ""
--			from parent.start until parent.after loop
--				name := parent.item.type.class_name.name
--				print(name + "%N")
-- TODO: Check if the following dead code can be removed
				--if internal.type_conforms_to (internal.dynamic_type_from_string ("VERSIONED_CLASS"), internal.dynamic_type_from_string(name.as_upper)) then
				--	Result:=name
				--end
--				parent.forth
--			end
--		end

	copy_all (dir: DIRECTORY; res: DS_ARRAYED_LIST [DIRECTORY])
			-- Copy the content of the project in `dir' in the repository dir.
		local
			string: STRING
			next_dir: DIRECTORY
			e_file: BOOLEAN
		do
			from
				dir.start
				dir.readentry
			until
				dir.lastentry = Void
			loop
				string := dir.lastentry
				e_file := string.substring (string.count-1, string.count).is_equal (".e")
				--TODO: check/test if the following check needs to be the same as the one in SET_RELEASER.release
				if not string.is_equal ("..") and not string.is_equal (".")  and not string.is_equal("EIFGENs") and not string.is_equal (Schema_evolution_handlers_dir) and not string.is_equal (Filter_Root_Dir) then
					create next_dir.make (dir.name + separator + string)
					if next_dir.exists then
							--if the dir exist
						next_dir.open_read
						copy_all(next_dir,res)
					elseif e_file then
						--name := string.split ('.').i_th(1)
						res.force_last (next_dir)
					end
				end
				dir.readentry
			end
			dir.close
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
