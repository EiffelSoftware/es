note
	description: "Constants for the Subversion copy command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_COPY_COMMAND_OPTIONS

feature -- Option names

	revision: STRING_8 do Result := "--revision" end
	quiet: STRING_8 do Result := "--quiet" end
	message: STRING_8 do Result := "--message" end
	file: STRING_8 do Result := "--file" end
	force_log: STRING_8 do Result := "--force-log" end
	external_editor: STRING_8 do Result := "--editor-cmd" end
	encoding: STRING_8 do Result := "--encoding" end
	with_revision_property: STRING_8 do Result := "with-revprop" end
	add_parents: STRING_8 do Result := "--parents" end
	ignore_externals: STRING_8 do Result := "--ignore-externals" end

feature -- Option values

	head_revision: STRING_8 do Result := "HEAD" end
	base_revision: STRING_8 do Result := "BASE" end
	committed_revision: STRING_8 do Result := "COMMITTED" end
	previous_revision: STRING_8 do Result := "PREV" end

end
