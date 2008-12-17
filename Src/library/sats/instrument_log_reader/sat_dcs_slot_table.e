indexing
    description: "Summary description for {SAT_DCS_SLOT_TABLE}."
    author: ""
    date: "$Date$"
    revision: "$Revision$"

class
    SAT_DCS_SLOT_TABLE

inherit
	SAT_SHARED_NAMES

	SAT_INSTRUMENT_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_map_file: STRING; a_coverage_file: STRING) is
			-- Load slot mapping file `a_map_file' into Current able.
		require
			a_map_file_attached: a_map_file /= Void
		do
			create slot_table.make (20)
			create slot_coverage_table.make (0, 4000)
			load_map (a_map_file)
			load_coverage_log (a_coverage_file)
		end

feature -- Status report

	has_feature (a_class_name: STRING; a_feature_name: STRING): BOOLEAN is
			-- Is slot information for `a_class_name'.`a_feature_name' appear?
		local
			l_feat_table: HASH_TABLE [ARRAY [INTEGER], STRING]
		do
			l_feat_table := slot_table.item (a_class_name)
			if l_feat_table /= Void then
				Result := l_feat_table.item (a_feature_name) /= Void
			end
		end

feature -- Access

    global_slot_index (a_class: STRING; a_feature: STRING; a_local_slot_index: INTEGER): INTEGER is
            -- Global 0-based slot index for the 0-based `a_local_slot_index'-th local slot in `class'.`a_feature'
            -- `a_feature' is the a feature name written in `a_class'.
        require
            a_class_attached: a_class /= Void
            a_feature_attached: a_feature /= Void
            a_local_slot_index_non_negative: a_local_slot_index >= 0
        do
        	Result := slot_table.item (a_class).item (a_feature).item (a_local_slot_index)
		ensure
			result_non_negative: Result >= 0
        end

       visited_times (a_global_slot_index: INTEGER): INTEGER is
       		-- Visited times for `a_global_slot_index'
       		do
       			Result := slot_coverage_table.item (a_global_slot_index)
       		end

feature{NONE} -- Loading

	load_coverage_log (a_coverage_file: STRING) is
			-- Load slot coverage log from `a_coverage_file' into `slot_coverage_table'.
		local
			l_file: PLAIN_TEXT_FILE
			l_sections: LIST [STRING]
			l_slot_table: like slot_coverage_table
			l_slot_index: INTEGER
			l_visited_times: INTEGER
		do
			create l_file.make (a_coverage_file)
			if l_file.exists and then l_file.is_readable then
				create l_file.make_open_read (a_coverage_file)
				l_slot_table := slot_coverage_table
				from
					l_file.read_line
					l_file.read_line
				until
					l_file.after
				loop
					l_sections := l_file.last_string.split ('%T')
					l_slot_index := l_sections.i_th (1).to_integer
					l_visited_times := l_sections.i_th (2).to_integer
					l_slot_table.force (l_visited_times, l_slot_index)
					l_file.read_line
				end
				l_file.close
			end
		end

	load_map (a_map_file: STRING) is
			-- Load instrument config from `a_map_file' into `slot_table'.
		require
			a_map_file_attached: a_map_file /= Void
		local
			l_analyzer: SAT_AGENT_BASED_FILE_ANALYZER
			l_sections: LINKED_LIST [STRING]
			l_file_loader: SAT_FILE_LOADER
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make (a_map_file)
			if l_file.exists and then l_file.is_readable then
				create l_sections.make
				l_sections.extend (dcs_section_name)
				create l_analyzer.make (agent process_dcs_record, agent process_reset, l_sections)

				create l_file_loader.make
				l_file_loader.set_is_single_line_mode (True)
				l_file_loader.register_analyzer (l_analyzer)
				l_file_loader.load_file (a_map_file)
			end
		end

	process_dcs_record (a_section_name: STRING; a_line: STRING) is
			-- Process when a config `a_line' in section `a_section_name' is parsed.
		require
			a_section_name_attached :a_section_name /= Void
			a_line_attached: a_line /= Void
		local
			l_properties: HASH_TABLE [STRING, STRING]
			l_class_name: STRING
			l_feature_name: STRING
			l_local_slot_index: INTEGER
			l_global_slot_index: INTEGER
			l_locations: LIST [STRING]
			l_feat_table: HASH_TABLE [ARRAY [INTEGER], STRING]
			l_slot_table: like slot_table
			l_local_slots: ARRAY [INTEGER]
		do
			l_slot_table := slot_table

			l_properties := property_table (a_line.split ('%T'))
			l_locations := l_properties.item (location_name).split ('.')
			l_class_name := l_locations.i_th (1).as_upper
			l_feature_name := l_locations.i_th (2).as_lower

			l_local_slot_index := l_properties.item (local_slot_id_name).to_integer
			l_global_slot_index := l_properties.item (slot_id_name).to_integer

			l_feat_table := l_slot_table.item (l_class_name)
			if l_feat_table = Void then
				create l_feat_table.make (20)
				l_slot_table.force (l_feat_table, l_class_name)
			end

			l_local_slots := l_feat_table.item (l_feature_name)
			if l_local_slots = Void then
				create l_local_slots.make (0, 5)
				l_feat_table.force (l_local_slots, l_feature_name)
			end
			l_local_slots.force (l_global_slot_index, l_local_slot_index)
		end

	process_reset is
			-- Reset.
		do
		end

feature{NONE} -- Implementation

    slot_table: HASH_TABLE [HASH_TABLE [ARRAY [INTEGER], STRING], STRING]
            -- Table to store slot information
            -- Key of outer hash table is class name,
            -- Key of inner hash table is feature name,
            -- The index of the integer array is 0-based local slots, and the value of the integer array
            -- is the global slot index for the given class.feature.local_slot_index.
            -- This table represents the function: CLASS X FEATURE X LOCAL_SLOT_INDEX -> GLOBAL_SLOT_INDEX

    slot_coverage_table: ARRAY [INTEGER]
    		-- Table to record slot coverage
    		-- Index is 0-based global slot number,
    		-- value is the number of times that the slot is covered.

invariant
	slot_table_attached: slot_table /= Void
	slot_coverage_table_attached: slot_coverage_table /= Void

end
