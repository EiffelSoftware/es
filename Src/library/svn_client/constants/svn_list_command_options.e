note
	description: "Constants for the Subversion list command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_LIST_COMMAND_OPTIONS

feature -- Option names

	revision: STRING_8 do Result := "--revision" end
	recursive: STRING_8 do Result := "--recursive" end
	verbose: STRING_8 do Result := "--verbose" end
	depth: STRING_8 do Result := "--depth" end
	-- incremental is not needed since the output is already concatenated
	-- there's no supported parser for the --xml option yet

feature -- Option values

	depth_empty: STRING_8 do Result := "empty" end
	depth_files: STRING_8 do Result := "files" end
	depth_immediates: STRING_8 do Result := "immediates" end
	depth_infinity: STRING_8 do Result := "infinity" end

	head_revision: STRING_8 do Result := "HEAD" end
	base_revision: STRING_8 do Result := "BASE" end
	committed_revision: STRING_8 do Result := "COMMITTED" end
	previous_revision: STRING_8 do Result := "PREV" end

end
