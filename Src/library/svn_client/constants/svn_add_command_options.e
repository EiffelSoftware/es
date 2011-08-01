note
	description: "Constants for the Subversion add command options"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_ADD_COMMAND_OPTIONS

feature -- Option names

	targets: STRING_8 do Result := "--targets" end
	depth: STRING_8 do Result := "--depth" end
	quiet: STRING_8 do Result := "--quiet" end
	force: STRING_8 do Result := "--force" end
	no_ignore: STRING_8 do Result := "--no-ignore" end
	enable_auto_properties: STRING_8 do Result := "--auto-props" end
	disable_auto_properties: STRING_8 do Result := "--no-auto-props" end
	add_parents: STRING_8 do Result := "--parents" end

feature -- Option values

	depth_empty: STRING_8 do Result := "empty" end
	depth_files: STRING_8 do Result := "files" end
	depth_immediates: STRING_8 do Result := "immediates" end
	depth_infinity: STRING_8 do Result := "infinity" end


end
