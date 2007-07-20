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
			out, out_short, type_name, make
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

	out_short: STRING is
			-- redefine
		do
			Result := project
			Result.append (" " + name)
			Result.append (" " + version)
			Result.append (": " + description)
			Result.replace_substring_all ("\r", "")
			Result.replace_substring_all ("\n", " ")
		end

	out: STRING is
			-- redefine
		do
			Result := Precursor
		end

invariant
	name_not_void: name /= Void
	version_not_void: version /= Void
	description_not_void: description /= Void
end
