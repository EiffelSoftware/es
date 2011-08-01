note
	description: "Constants for the Subversion commit command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_COMMIT_COMMAND_OPTIONS

feature -- Option names

	depth: STRING_8 do Result := "--depth" end
	quiet: STRING_8 do Result := "--quiet" end
	targets: STRING_8 do Result := "--targets" end
	no_unlock: STRING_8 do Result := "--no-unlock" end
	message: STRING_8 do Result := "--message" end
	file: STRING_8 do Result := "--file" end
	force_log: STRING_8 do Result := "--force-log" end
	external_editor: STRING_8 do Result := "--editor-cmd" end
	encoding: STRING_8 do Result := "--encoding" end
	with_revision_property: STRING_8 do Result := "with-revprop" end
	changelist: STRING_8 do Result := "--changelist" end
	keep_changelists: STRING_8 do Result := "--keep-changelists" end

feature -- Option values

	depth_empty: STRING_8 do Result := "empty" end
	depth_files: STRING_8 do Result := "files" end
	depth_immediates: STRING_8 do Result := "immediates" end
	depth_infinity: STRING_8 do Result := "infinity" end

end
