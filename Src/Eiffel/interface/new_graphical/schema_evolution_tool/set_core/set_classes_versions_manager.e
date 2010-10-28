note
	description:
		"Associates the class name with a release and a version.%
		%The information is read in the config file."
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.2009"

class
	SET_CLASSES_VERSIONS_MANAGER

inherit
	DS_HASH_TABLE [DS_HASH_TABLE [INTEGER,STRING],INTEGER]
		export
			{NONE} all
		redefine
			out
		end
create
	make_list

feature{NONE} -- Utility object

	const: SET_UTILITY_AND_CONSTANTS

feature -- Creation

	make_list
			-- Creation from config file.
		do
			make_default
			create const
			read_file
		end


feature -- Status report

	get_version (s: STRING; version: INTEGER): INTEGER
			-- The version of class `s' from repository in version `version'.
		local
			tmp: DS_HASH_TABLE[INTEGER,STRING]
			name: STRING
		do
			name:=s.out

			if has (version) then
				tmp:=item (version)
				if not tmp.has (name)  then
					tmp.force(1,name)
				end
			else
				create tmp.make_default
				tmp.force (1,name)

				force(tmp,version)
			end
			-- if the table does not have the value, add automatically version 1
			Result:=tmp.item (name)
		end

feature -- Basic operations

	increment_version (s: STRING; v: INTEGER)
			-- increment the version number
		local
			tmp: DS_HASH_TABLE [INTEGER,STRING]
			name: STRING
		do
			name := s.out
			if has (v) then
				tmp := item (v)
				if tmp.has (name)  then
					tmp.replace (tmp.item (name) + 1,name)
				end
			end
		end

	add_version (s: STRING; v_repo, v_class: INTEGER)
			-- add class `s' of version `v_class', in version `v_repo' of repository
		local
			tmp: DS_HASH_TABLE[INTEGER,STRING]
			name: STRING
		do
			name:=s.out
			if has(v_repo) then
				tmp:=item(v_repo)
			else
				create tmp.make_default
				force(tmp,v_repo)
			end
			tmp.force (v_class, name)
		end

	close is
			-- Write the class versions info file. TODO: think about changing the name
		local
			file: PLAIN_TEXT_FILE
			file_manager: SET_FILE_MANAGER
		do
			create file_manager.make
			file_manager.update_config_file
			create file.make (const.current_dir + const.separator + const.Class_versions_info_file)
			if file.exists then
				file.open_write
				file.put_string (out)
				file.close
			end
		end

feature {NONE} --implementation

	read_file
			-- read the config path an fill the list
		local
			file: PLAIN_TEXT_FILE
				--file to read
			line: STRING
				--current read line
			split: LIST[STRING]
				--splitted line
			table: DS_HASH_TABLE[INTEGER,STRING]
				--temporary hash table
			release_ver: INTEGER
				--last release read
		do
			line := ""
			create file.make (const.current_dir+const.separator+const.class_versions_info_file)
			if file.exists then
				file.open_read
				create table.make_default
				from  file.start until file.after loop
					file.read_line
					line.copy (file.last_string)
					if not line.is_empty then
						split:=line.split (',')
						if split.count/=2 then --the line contains the release number
							if release_ver/=0 and table /=Void then --all the var are good
								force (table, release_ver)
							end
							create table.make_default
							release_ver:=line.to_integer
								--reinitialize the table and read the release version for the following attributes
						else
						table.force (split.i_th (2).to_integer, split.i_th (1))
							--add the information to the temporany table, the class name and the version
						end
					end
				end
				if release_ver /= 0 and table /= Void then
					force (table, release_ver)
					--add last info
				end
				file.close
			else -- the file does not exist
				file.create_read_write
				file.close
			end
		end

feature -- String representation

	out: STRING
			-- A string representation of the class, essentially to be written in the file.
		local
			i: INTEGER
			table: DS_HASH_TABLE[INTEGER,STRING]
		do
			Result := ""
			from i := 1 until i > count loop
				Result := Result + key_storage_item (i).out + "%N"
				table := item_storage_item (i)
				from table.start until table.after loop
					Result := Result + table.key_for_iteration + "," + table.item_for_iteration.out + "%N"
					--separate the key from the item using a `,'
					table.forth
				end
				i := i + 1
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
