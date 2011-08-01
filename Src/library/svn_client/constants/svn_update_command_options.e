note
	description: "Constants for the Subversion update command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_UPDATE_COMMAND_OPTIONS

feature -- Option names

	revision: STRING_8 do Result := "--revision" end
	depth: STRING_8 do Result := "--depth" end
	quiet: STRING_8 do Result := "--quiet" end
	-- diff3-cmd ARG: use ARG as merge command
	force: STRING_8 do Result := "--force" end
	ignore_externals: STRING_8 do Result := "--ignore-externals" end
	changelist: STRING_8 do Result := "--changelist" end
	-- editor-cmd ARG: use ARG as external editor
	accept: STRING_8 do Result := "--accept" end

feature -- Option values

	accept_postpone: STRING_8 do Result :="postpone" end
	accept_base: STRING_8 do Result :="base" end
	accept_mine_conflict: STRING_8 do Result :="mine-conflict" end
	accept_theirs_conflict: STRING_8 do Result :="theirs-conflict" end
	accept_mine_full: STRING_8 do Result :="mine-full" end
	accept_theirs_full: STRING_8 do Result :="theirs-full" end

	depth_empty: STRING_8 do Result := "empty" end
	depth_files: STRING_8 do Result := "files" end
	depth_immediates: STRING_8 do Result := "immediates" end
	depth_infinity: STRING_8 do Result := "infinity" end

	head_revision: STRING_8 do Result := "HEAD" end
	base_revision: STRING_8 do Result := "BASE" end
	committed_revision: STRING_8 do Result := "COMMITTED" end
	previous_revision: STRING_8 do Result := "PREV" end

end
