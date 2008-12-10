indexing
	description: "Summary description for {SAT_AGENT_BASED_FILE_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_AGENT_BASED_FILE_ANALYZER

inherit
	SAT_FILE_ANALYZER

create
	make

feature{NONE} -- Initialization

	make (a_processing_action: like processing_action; a_reset_action: like reset_action; a_sections: like sections) is
			-- Initialize.
		require
			a_processing_action_attached: a_processing_action /= Void
			a_reset_action_attached: a_reset_action /= void
			a_sections_attached: a_sections /= Void
		do
			processing_action := a_processing_action
			reset_action := a_reset_action
			section_names := a_sections.twin
		ensure
			processing_action_set: processing_action = a_processing_action
			reset_action_set: reset_action = a_reset_action
			section_names_set: section_names.is_equal (a_sections)
		end

feature{SAT_FILE_LOADER} -- Access

	sections: LIST [STRING] is
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.
		do
			Result := section_names
		ensure then
			good_result: Result = section_names
		end

feature{SAT_FILE_LOADER} -- Basic operations

	process_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		do
			processing_action.call ([a_section_name, a_record_line])
		end

	reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
			reset_action.call ([])
		end

feature -- Access

	processing_action: PROCEDURE [ANY, TUPLE [section_name: STRING; data: STRING]]
			-- Processor to process `data' in section named `section_name'

	reset_action: PROCEDURE [ANY, TUPLE]
			-- Action to reset current analyzer

	section_names: LIST [STRING]
			-- List of section names that current analyzer can process

invariant
	process_action_attached: processing_action /= Void
	reset_action_attached: reset_action /= Void
	section_names_attached: section_names /= Void

end
