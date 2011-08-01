note
	description: "Constants for the Subversion merge command options"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_MERGE_COMMAND_OPTIONS

feature -- Option names

	revision: STRING_8 do Result := "--revision" end
	change_in_revision: STRING_8 do Result := "--change" end
	depth: STRING_8 do Result := "--depth" end
	force: STRING_8 do Result := "--force" end
	dry_run: STRING_8 do Result := "--dry-run" end
	-- diff3-cmd
	record_only: STRING_8 do Result := "--record_only" end
	-- extensions (only with external editor)
	ignore_ancestry: STRING_8 do Result := "--ignore-ancestry" end
	accept: STRING_8 do Result := "--accept" end
	reintegrate: STRING_8 do Result := "--reintegrate" end

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
