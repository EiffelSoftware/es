indexing
	description: "Summary description for {SAT_DCS_INSTRUMENT_CONFIG_LOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_DCS_INSTRUMENT_CONFIG_LOADER

inherit
	SAT_FILE_ANALYZER

	SAT_SHARED_NAMES

	SAT_INSTRUMENT_UTILITY

create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize Current.
		do
			create {ARRAYED_LIST [STRING]} sections.make(1)
			sections.extend (dcs_section_name)
			sections.extend (setting_section_name)
			create branches.make (0, 2000)
			reset
		end

feature -- Access

	slots: LIST [SAT_DCS_INSTRUMENT_ITEM]
			-- List of slots of current config

	branches: ARRAY [ARRAYED_LIST [INTEGER]]
			-- Branches that are to be covered when a slot is covered.
			-- Index of outer array is 0-based slot index, the value for that slot index is
			-- a list of branch IDs that are to be covered when that slot is covered.

	branch_count: INTEGER
			-- Number of branches
			-- Branches include feature entry branch, rescue clause entry branch and
			-- True/False branch for each of the real branching instructions.

feature -- Loading

	load (a_file_path: STRING) is
			-- Load Current from `a_file_path'.
		require
			a_file_path_attached: a_file_path /= Void
			not_a_file_path_is_empty: not a_file_path.is_empty
		local
			l_file_loader: SAT_FILE_LOADER
		do
			create l_file_loader.make
			l_file_loader.set_is_single_line_mode (True)
			l_file_loader.register_analyzer (Current)
			l_file_loader.load_file (a_file_path)
		end

feature{SAT_FILE_LOADER} -- Access

	sections: LIST [STRING]
			-- List of name of sections that Current analyzer is interested in.
			-- Only data in sections contained in this list will be passed to Current analyzer.
			-- Section names are case-sensitive.

feature{SAT_FILE_LOADER} -- Basic operations

	process_record (a_section_name: STRING; a_record_line: STRING) is
			-- Process record line text in `a_record_line'.
			-- This record line is in one of the section defined in `sections'.
		local
			l_parts: LIST [STRING]
			l_location: LIST [STRING]
			l_class_name: STRING
			l_feature_name: STRING
			l_table: HASH_TABLE [STRING, STRING]
			l_global_index: INTEGER
			l_local_index: INTEGER
			l_slot: SAT_DCS_INSTRUMENT_ITEM
			l_branches: LIST [STRING]
			l_branch_indexes: ARRAYED_LIST [INTEGER]
		do
			if a_section_name.is_equal (dcs_section_name) then
					-- `a_record_line' is for a single decision coverage slot.

					-- Analyze slot information from `a_record_line'.
				l_table := property_table (a_record_line.split ('%T'))
				l_location := l_table.item (location_name).split ('.')
				l_class_name := l_location.i_th (1)
				l_feature_name := l_location.i_th (2)
				l_global_index := l_table.item (slot_id_name).to_integer
				l_local_index := l_table.item (local_slot_id_name).to_integer

					-- Analyze branch ID set.
				l_branches := l_table.item (dcs_branch_id_set).split (',')
				create l_branch_indexes.make (l_branches.count)
				from
					l_branches.start
				until
					l_branches.after
				loop
					l_branch_indexes.extend (l_branches.item.to_integer)
					l_branches.forth
				end

					-- Store slot information into Current config.
				create l_slot.make (l_class_name, l_feature_name, l_global_index, l_local_index, l_branch_indexes)
				branches.force (l_branch_indexes, l_global_index)
				slots.extend (l_slot)
			else
					-- `a_record_line' is a summary of decision coverage.
				l_table := property_table (a_record_line.split ('%T'))
				branch_count := l_table.item (dcs_branch_count_name).to_integer
			end
		end

	reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
			create {LINKED_LIST [SAT_DCS_INSTRUMENT_ITEM]} slots.make
			branches.clear_all
		ensure then
			slots_is_empty: slots.is_empty
		end

invariant
	sections_valid: sections /= Void and then not sections.is_empty
	slots_attached: slots /= void
	branches_attached: branches /= Void

end
