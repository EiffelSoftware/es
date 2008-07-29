indexing
	description: "Objects to analyze instrument log files"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SAT_FILE_ANALYZER

feature -- Status report

	is_section_contained (a_section_name: STRING): BOOLEAN is
			-- Is `a_section_name' contained in `sections'?
		require
			a_section_name_attached: a_section_name /= Void
		do
			Result := sections.there_exists (agent {STRING}.is_equal (a_section_name))
		end

feature{SAT_FILE_LOADER} -- Access

	sections: LIST [STRING] is
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.
		deferred
		ensure
			result_attached: Result /= Void
		end

feature{SAT_FILE_LOADER} -- Basic operations

	process_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		require
			a_record_line_attached: a_record_line /= Void
			not_a_record_line_is_empty: not a_record_line.is_empty
			a_section_name_interesting: is_section_contained (a_section_name)
		deferred
		end

	reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		deferred
		end

feature{NONE} -- Implementation

	line_sections (a_line: STRING; a_separator: CHARACTER): LIST [STRING] is
			-- Sections of line text `a_line' separated with `a_separator'
			-- All the operations will be done through a copy of `a_line', and that copy will be trimmed first.
		require
			a_line_attached: a_line /= Void
			not_a_line_is_empty: not a_line.is_empty
		local
			l_line: STRING
		do
			l_line := a_line.twin
			l_line.left_adjust
			l_line.right_adjust
			Result := l_line.split (a_separator)
		ensure
			result_attached: Result /= Void
		end

end
