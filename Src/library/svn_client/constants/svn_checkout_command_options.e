note
	description: "Constants for the Subversion checkout command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CHECKOUT_COMMAND_OPTIONS

feature -- Option names

	revision: STRING_8 do Result := "--revision" end
  	depth: STRING_8 do Result := "--depth" end
	quiet: STRING_8 do Result := "--quiet" end
	force: STRING_8 do Result := "--force" end
	ignore_externals: STRING_8 do Result := "--ignore-externals" end

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
