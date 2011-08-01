note
	description: "Constants for the Subversion status command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_STATUS_COMMAND_OPTIONS

feature -- Option names

	show_updates: STRING_8 do Result := "--show-updates" end
	verbose: STRING_8 do Result := "--verbose" end
	depth: STRING_8 do Result := "--depth" end
	quiet: STRING_8 do Result := "--quiet" end
	no_ignore: STRING_8 do Result := "--no-ignore" end
	-- incremental is not needed since the output is already concatenated
	-- there's no supported parser for the --xml option yet
	ignore_externals: STRING_8 do Result := "--ignore-externals" end
	changelist: STRING_8 do Result := "--changelist" end

feature -- Option values

	depth_empty: STRING_8 do Result := "empty" end
	depth_files: STRING_8 do Result := "files" end
	depth_immediates: STRING_8 do Result := "immediates" end
	depth_infinity: STRING_8 do Result := "infinity" end

end
