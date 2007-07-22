indexing
	description: "Origo release workitem"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_RELEASE_WORKITEM

inherit
	EB_ORIGO_WORKITEM
		redefine
			out, type_name, make, label_text, text_field_text
		end

create
	make

feature -- Initialisation

	make is
			-- create commit workitem
		do
			precursor
			type := Workitem_type_release
			name := ""
			version := ""
			description := ""
			create files.make_default
			files.set_key_equality_tester (create {KL_STRING_EQUALITY_TESTER})
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Release"
		end

	name: STRING
			-- release name

	version: STRING
			-- version

	description: STRING
			-- release description

	files: DS_HASH_TABLE[DS_LINKED_LIST[STRING], STRING]
			-- file list (list of filenames as value and platform as key)

feature -- Element change

	set_name (a_name: like name) is
			-- set `name'
		require
			not_void: a_name /= Void
		do
			name := a_name.out
		end

	set_version (a_version: like version) is
			-- set `version'
		require
			not_void: a_version /= Void
		do
			version := a_version.out
		end

	set_description (a_description: like description) is
			-- set `description'
		require
			not_void: a_description /= Void
		do
			description := a_description.out
		end

feature -- Output		

	out: STRING is
			-- redefine
		do
			Result := project
			Result.append (" " + name)
			Result.append (" " + version)
			Result.append (": " + description)
			Result.replace_substring_all ("\r", "")
			Result.replace_substring_all ("\n", " ")
		end

	label_text: STRING is
			-- redefine
		do
			Result := precursor + "%N%N"
			Result.append ("Release Name: " + name + "%N")
			Result.append ("Program Version: " + version + "%N")
			Result.append ("%NDescription and Files:")
		end

	text_field_text: STRING is
			-- redefine
		local
			file_list: DS_LINKED_LIST [STRING]
		do
			Result := description.out + "%N%N%N"
			Result.append ("Files:%N")

			from
				files.start
			until
				files.after
			loop
				Result.append ("%N" + files.key_for_iteration + ":%N")
				file_list := files.item_for_iteration

				from
					file_list.start
				until
					file_list.after
				loop
					Result.append (file_list.item_for_iteration + "%N")
					file_list.forth
				end

				files.forth
			end
		end

invariant
	name_not_void: name /= Void
	version_not_void: version /= Void
	description_not_void: description /= Void
	files_not_void: files /= Void
end
