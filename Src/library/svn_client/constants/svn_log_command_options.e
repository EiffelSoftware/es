note
	description: "Constants for the Subversion log command options."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_LOG_COMMAND_OPTIONS

feature -- Option names

	revision: STRING_8 do Result := "--revision" end
	quiet: STRING_8 do Result := "--quiet" end
	verbose: STRING_8 do Result := "--verbose" end
	use_merge_history: STRING_8 do Result := "--use-merge-history" end
	change_in_revision: STRING_8 do Result := "--change" end
	targets: STRING_8 do Result := "--targets" end
	stop_on_copy: STRING_8 do Result := "--stop-on-copy" end
	limit_entries: STRING_8 do Result := "--limit" end
	with_all_revision_properties: STRING_8 do Result := "--with-all-revprops" end
	with_no_revision_properties: STRING_8 do Result := "--with-no-revprops" end
	with_revision_property: STRING_8 do Result := "with-revprop" end

feature -- Option values

	head_revision: STRING_8 do Result := "HEAD" end
	base_revision: STRING_8 do Result := "BASE" end
	committed_revision: STRING_8 do Result := "COMMITTED" end
	previous_revision: STRING_8 do Result := "PREV" end

end
