indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_DECISION_COVERAGE_LOG_ANALYZER

inherit
	SAT_FILE_ANALYZER

create
	make

feature{NONE} -- Initialization

	make (a_map_file: STRING; a_class_list: LINKED_LIST [STRING]) is
			-- Initialize Current.
		do
			create {LINKED_LIST [STRING]} sections_internal.make
			create decisions.make
			create feature_accesses.make
			create decision_table.make (500)
			create feature_access_table.make (500)
			initialize_sections
		end

feature -- Status report

	is_single_path_feature_enabled: BOOLEAN
			-- Should feature with no branches be considered?
			-- This depends on what you define as a branch.

feature -- Access

	decisions: DS_LINKED_LIST [SAT_DECISION_COVERAGE_RECORD]
			-- List of decision records

	feature_accesses: DS_LINKED_LIST [SAT_FEATURE_ACCESS_RECORD]
			-- List of feature access records

	decision_table: HASH_TABLE [DS_LINKED_LIST [SAT_DECISION_COVERAGE_RECORD], INTEGER]
			-- Table for `decisions'
			-- [List of decision record of the same slot, slot number]

	feature_access_table: HASH_TABLE [DS_LINKED_LIST [SAT_FEATURE_ACCESS_RECORD], INTEGER]
			-- Table for `feature_accesss'
			-- [List of feature access record of the same slot, slot number]

feature -- Setting

	set_is_single_path_feature_enabled (b: BOOLEAN) is
			-- Set `is_single_path_feature_enabled' with `b'.
		require
			not_registered: not is_registered
		do
			is_single_path_feature_enabled := b
			initialize_sections
		ensure
			is_single_path_feature_enabled_set: is_single_path_feature_enabled = b
		end

feature{SAT_INSTRUMENT_LOG_SEARCHER} -- Access

	sections: LIST [STRING] is
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.
		do
			Result := sections_internal
		ensure then
			good_result: Result = sections_internal
		end

feature{SAT_INSTRUMENT_LOG_SEARCHER} -- Basic operations

	process_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in section called `a_section_name'.
		local
			l_data: LIST [STRING]
			l_slot: INTEGER
			l_time: INTEGER
			l_decision_record: SAT_DECISION_COVERAGE_RECORD
			l_decision_list: DS_LINKED_LIST [SAT_DECISION_COVERAGE_RECORD]
			l_feature_record: SAT_FEATURE_ACCESS_RECORD
			l_feature_list: DS_LINKED_LIST [SAT_FEATURE_ACCESS_RECORD]
		do
				-- Read data from `a_record_line'.
			l_data := a_record_line.split (',')
			check l_data.count = 2 end
			l_slot := l_data.i_th (1).to_integer
			l_time := l_data.i_th (2).to_integer

				-- Store data.
			if a_section_name.is_equal (decision_section_name) then
					-- For decision coverage record.
				create l_decision_record.make_with_slot_and_time (l_slot, l_time)
				decisions.force_last (l_decision_record)

				l_decision_list := decision_table.item (l_slot)
				if l_decision_list = Void then
					create l_decision_list.make
					decision_table.extend (l_decision_list, l_slot)
				end
				l_decision_list.force_last (l_decision_record)
			elseif is_single_path_feature_enabled and then a_section_name.is_equal (feature_access_section_name) then
					-- For feature access coverage record.
				create l_feature_record.make_with_slot_and_time (l_slot, l_time)
				feature_accesses.force_last (l_feature_record)

				l_feature_list := feature_access_table.item (l_slot)
				if l_feature_list = Void then
					create l_feature_list.make
					feature_access_table.extend (l_feature_list, l_slot)
				end
				l_feature_list.force_last (l_feature_record)
			end
		end

	sections_internal: like sections
			-- Implementation of `sections'.

	initialize_sections is
			-- Initialize `sections'.
		do
			sections.wipe_out
			sections.extend (decision_section_name)
			if is_single_path_feature_enabled then
				sections.extend (feature_access_section_name)
			end
		end

	reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
			decisions.wipe_out
			decision_table.wipe_out
			feature_accesses.wipe_out
			feature_access_table.wipe_out
		end

feature{NONE} -- Implementation

	feature_access_section_name: STRING is "FAC"
			-- Name of feature access section in log file

	decision_section_name: STRING is "DCS"
			-- Name of decision section in log file

invariant
	decisions_attached: decisions /= Void
	feature_accesses_attached: feature_accesses /= Void

end
