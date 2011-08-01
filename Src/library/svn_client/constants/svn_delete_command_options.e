note
	description: "Constants for the Subversion delete command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_DELETE_COMMAND_OPTIONS

feature -- Option names

	targets: STRING_8 do Result := "--targets" end
	force: STRING_8 do Result := "--force" end
	quiet: STRING_8 do Result := "--quiet" end
	message: STRING_8 do Result := "--message" end
	file: STRING_8 do Result := "--file" end
	force_log: STRING_8 do Result := "--force-log" end
	external_editor: STRING_8 do Result := "--editor-cmd" end
	encoding: STRING_8 do Result := "--encoding" end
	with_revision_property: STRING_8 do Result := "with-revprop" end
	keep_local_path: STRING_8 do Result := "--keep-local" end

end
