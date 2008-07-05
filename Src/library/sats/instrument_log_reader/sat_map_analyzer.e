indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_MAP_ANALYZER

inherit
	SAT_FILE_ANALYZER

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize Current.
		do
			create classes.make (50)
		end

feature -- Access

	classes: DS_HASH_SET [STRING]
			-- Names of classes that included in the last analyzed map file, in upper case

feature{SAT_INSTRUMENT_LOG_SEARCHER} -- Access

	sections: LIST [STRING] is
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.
		once
			create {LINKED_LIST [STRING]} Result.make
			Result.extend ("DCS")
			Result.extend ("FAC")
		end

feature{SAT_INSTRUMENT_LOG_SEARCHER} -- Basic operations

	process_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		do
		end

	reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
			classes.wipe_out
		end

feature{NONE} -- Implementation

	action_table: HASH_TABLE [PROCEDURE [ANY, TUPLE [a_line: STRING]], STRING]
			-- Table for actions to process different kinds of sections.

invariant
	classes_attached: classes /= Void
	action_table_attached: action_table /= Void

end
