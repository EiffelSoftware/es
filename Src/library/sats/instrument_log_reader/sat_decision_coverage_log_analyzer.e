indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 74021 $"

class
	SAT_DECISION_COVERAGE_LOG_ANALYZER

inherit
	SAT_FILE_ANALYZER

	SAT_SHARED_NAMES

	SAT_RESULT_ANALYZER_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_test_session_start_time: INTEGER; a_instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER) is
			-- Initialize Current.
		require
			a_instrument_config_attached: a_instrument_config /= Void
		do
			instrument_config := a_instrument_config
			test_session_start_time := a_test_session_start_time
			branch_count := a_instrument_config.branch_count
			slot_count := a_instrument_config.slots.count
			create {LINKED_LIST [STRING]} sections_internal.make
--			create slot_visit_log.make
--			create decision_table.make (initial_storage_size)

			create test_case_start_record_table.make (initial_storage_size)
			create slot_frequency_table.make (0, slot_count - 1)
			create slot_first_coverage_time_table.make (0, slot_count - 1)
			initialize_sections
			set_analysis_time (0, -1)

			create branch_frequency_table.make (1, branch_count)
			create branch_first_coverage_time_table.make (1, branch_count)
			initialize_branch_tables
		end

	initialize_branch_tables is
			-- Initialize branch coverage related tables.
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > branch_count
			loop
				branch_first_coverage_time_table.put ([-1, -1], i)
				i := i + 1
			end
		end

	instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER
			-- Decision coverage instrument config

feature -- Analysis time zone

	analysis_start_time: INTEGER
			-- Start time in second related to the start time of current proxy_log
			-- indicating whether the analysis of faults should be done.
			-- For example, if [`analysis_start_time', `analyzsis_end_time'] is [5, 10],
			-- only the log between 5th~10th second are going to be analyzed.

	analysis_end_time: INTEGER
			-- End time in second related to the start time of current proxy_log
			-- indicating whether the analysis of faults should be done.
			-- If negative, the analysis will be done until the end of the log file.

	set_analysis_time (a_start_time: INTEGER; a_end_time: INTEGER) is
			-- Set `analysis_start_time' with `a_start_time' and
			-- `analysis_end_time' with `a_end_time'.
		require
			a_start_time_non_negative: a_start_time >= 0
			a_end_time_valid: a_end_time>=0 implies a_end_time >= a_start_time
		do
			analysis_start_time := a_start_time
			analysis_end_time := a_end_time
		ensure
			analysis_start_time_set: analysis_start_time = a_start_time
			analysis_end_time_set: analysis_end_time = a_end_time
		end

feature -- Access

	test_session_start_time: INTEGER
			-- Test session start time

--	slot_visit_log: DS_LINKED_LIST [SAT_DECISION_COVERAGE_RECORD]
--			-- List of decision coverage instrumentation log record.

	slot_frequency_table: ARRAY [INTEGER]
			-- Table of slot coverage frequency
			-- Index of the array is 0-based slot index
			-- Value for an index is the number of times that the slot is covered.

	slot_first_coverage_time_table: ARRAY [SAT_DECISION_COVERAGE_RECORD]
			-- Table of records showing when a slot is being covered for the first time
			-- Index of the array is 0-based slot index
			-- Value for the index is the record showing when that slot is being covered.

	test_case_start_record_table: HASH_TABLE [SAT_DECISION_COVERAGE_RECORD, INTEGER]
			-- Table of the first records of every test case
			-- [Decision coverage record, test case index]

--	decision_table: HASH_TABLE [DS_LINKED_LIST [SAT_DECISION_COVERAGE_RECORD], INTEGER]
--			-- Table for `slot_visit_log'
--			-- [List of decision record of the same slot, slot number]

	first_slot: SAT_DECISION_COVERAGE_RECORD
			-- First loaded slot record

	last_slot: SAT_DECISION_COVERAGE_RECORD
			-- Last loaded slot record

	first_slot_visit_time: INTEGER is
			-- Time in second of first visited slot
			-- If there is no slot visit, return 0.
		require
			first_slot_attached: first_slot /= Void
		do
			Result := first_slot.time
		end

	last_slot_visit_time: INTEGER is
			-- Time in second of last visited slot
			-- If there is no slot visit, return 0.
		require
			last_slot_attached: last_slot /= Void
		do
			Result := last_slot.time
		end

	covered_branches (a_instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER): LIST [INTEGER] is
			-- List of index of branches that have been covered.
		local
			l_table: like branch_frequency_table
			i: INTEGER
		do
			l_table := branch_frequency_table
			create {ARRAYED_LIST [INTEGER]} Result.make (l_table.count)
			from
				i := l_table.lower
			until
				i > l_table.upper
			loop
				if l_table.item (i) > 0 then
					Result.extend (i)
				end
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

	branch_frequency_table: ARRAY [INTEGER]
			-- Table for number of covered times for each branch.
			-- Index of the returned array is branch index.
			-- value of the array is the number of time that a branch is covered.

--	branch_frequency_table (a_instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER): ARRAY [INTEGER] is
--			-- Table for number of covered times for each branch.
--			-- Index of the returned array is branch index.
--			-- value of the array is the number of time that a branch is covered.
--			-- `a_instrument_config' provides branch information.
--		require
--			a_instrument_config_attached: a_instrument_config /= Void
--		local
--			l_cur: DS_LIST_CURSOR [SAT_DECISION_COVERAGE_RECORD]
--			l_covered_branches: LIST [INTEGER]
--			l_branches: ARRAY [ARRAYED_LIST [INTEGER]]
--		do
--			if branch_frequency_table_internal = Void then
--				create branch_frequency_table_internal.make (1, a_instrument_config.branch_count)
--				l_branches := a_instrument_config.branches
--				from
--					l_cur := slot_visit_log.new_cursor
--					l_cur.start
--				until
--					l_cur.after
--				loop
--					l_covered_branches := l_branches.item (l_cur.item.slot)
--					from
--						l_covered_branches.start
--					until
--						l_covered_branches.after
--					loop
--						branch_frequency_table_internal.put (branch_frequency_table_internal.item (l_covered_branches.item) + 1, l_covered_branches.item)
--						l_covered_branches.forth
--					end
--					l_cur.forth
--				end
--			end
--			Result := branch_frequency_table_internal
--		ensure
--			result_attached: Result /= Void
--			result_valid: Result.count = a_instrument_config.branch_count
--		end

	branch_first_coverage_time_table: ARRAY [TUPLE [first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]]
			-- Table of the first time when a branch is covered.
			-- Index of the returned array is branch index.
			-- value of the array is the time when that a branch is covered for the first time. -1 means that that branch is not covered.
			-- `first_visit_time' is the time in second when the branch is first visited, -1 means that the branch is not covered.
			-- `first_visit_test_case_index' is the index of the test case where the branch is covered for the first time. -1 means that the branch is not covered.

--	branch_first_coverage_time_table (a_instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER): ARRAY [INTEGER] is
--			-- Table of the first time when a branch is covered.
--			-- Index of the returned array is branch index.
--			-- value of the array is the time when that a branch is covered for the first time. -1 means that that branch is not covered.
--			-- `a_instrument_config' provides branch information.
--		require
--			a_instrument_config_attached: a_instrument_config /= Void
--		local
--			l_cur: DS_LIST_CURSOR [SAT_DECISION_COVERAGE_RECORD]
--			l_covered_branches: LIST [INTEGER]
--			l_branches: ARRAY [ARRAYED_LIST [INTEGER]]
--		do
--			if branch_first_coverage_time_table_internal = Void then
--				create branch_first_coverage_time_table_internal.make (1, a_instrument_config.branch_count)
--				initialize_array (branch_first_coverage_time_table_internal, -1)
--				l_branches := a_instrument_config.branches
--				from
--					l_cur := slot_visit_log.new_cursor
--					l_cur.start
--				until
--					l_cur.after
--				loop
--					l_covered_branches := l_branches.item (l_cur.item.slot)
--					from
--						l_covered_branches.start
--					until
--						l_covered_branches.after
--					loop
--						if
--							branch_first_coverage_time_table_internal.item (l_covered_branches.item) = -1 or else
--							branch_first_coverage_time_table_internal.item (l_covered_branches.item) > l_cur.item.time
--						then
--							branch_first_coverage_time_table_internal.put (l_cur.item.time, l_covered_branches.item)
--						end
--						l_covered_branches.forth
--					end
--					l_cur.forth
--				end

--			end
--			Result := branch_first_coverage_time_table_internal
--		ensure
--			result_attached: Result /= Void
--		end

	accumulated_branch_coverage_time_table (a_start_time: INTEGER; a_end_time: INTEGER; a_time_unit: INTEGER; a_instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER): ARRAY [INTEGER] is
			-- Table of branches that are covered over time.
			-- Index of the result array is time, value of the array is the number of branches that are covered until that time.
			-- `a_start_time' is the starting time related to `test_session_start_time',
			-- `a_end_time' is the end time related to `test_session_start_time'.
			-- `a_start_time' and `a_end_time' points are included in the result.
			-- `a_time_unit' is the unit of `a_start_time', `a_end_time' and the time index used in the result array.
			-- `a_time_unit' is in the unit of second. For example, if you want to see fault time table in minute time unit,
			-- the `a_time_unit' should be 60.
			-- `a_instrument_config' provides information about branches.
		require
			a_start_time_non_negative: a_start_time >= 0
			a_end_time_non_negative: a_end_time >= 0
			a_end_time_valid: a_end_time >= a_start_time
			a_time_unit_positive: a_time_unit > 0
			a_instrument_config_attached: a_instrument_config /= Void
		local
			l_time_point: INTEGER
			l_sorted_faults: like sorted_array
			i: INTEGER
			l_checkpoint: INTEGER
			l_fault_number: INTEGER
			l_time_table: ARRAY [INTEGER]
			l_branch_table: like branch_first_coverage_time_table
		do
			create l_time_table.make (1, branch_count)
			l_branch_table := branch_first_coverage_time_table
			from
				i := 1
			until
				i > branch_count
			loop
				l_time_table.put (l_branch_table.item (i).first_visit_time, i)
				i := i + 1
			end
			Result := accumulated_time_table (a_start_time, a_end_time, a_time_unit, l_time_table)
		ensure
			result_attached: Result /= Void
			result_valid: Result.lower = a_start_time and Result.upper = a_end_time
			result_increasing: is_array_increasing (Result, False)
		end

	branch_count: INTEGER
			-- Number of branches

	slot_count: INTEGER
			-- Number of slots

	branch_coverage_statistics: ARRAY [TUPLE [visited_times: INTEGER; first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]] is
			-- Statistics for branch coverage
			-- This array is 1-based, the index is branch id.
		local
			i: INTEGER
			l_frequency_tbl: like branch_frequency_table
			l_first_cover_tbl: like branch_first_coverage_time_table
		do
			create Result.make (1, branch_count)
			l_frequency_tbl := branch_frequency_table
			l_first_cover_tbl := branch_first_coverage_time_table

			from
				i := 1
			until
				i > branch_count
			loop
				Result.put (
					[l_frequency_tbl.item (i),								-- Covered times
					 l_first_cover_tbl.item (i).first_visit_time,			-- First cover time
					 l_first_cover_tbl.item (i).first_visit_test_case_index -- First cover test case index
					], i)
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

	slot_coverage_statistics: ARRAY [TUPLE [visited_times: INTEGER; first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]] is
			-- Statistics for slot coverage
			-- This array is 0-based, the index is slot id.
		local
			i: INTEGER
			l_frequency_tbl: like slot_frequency_table
			l_first_cover_tbl: like slot_first_coverage_time_table
			l_first_time: INTEGER
			l_first_test_case: INTEGER
		do
			create Result.make (0, slot_count - 1)
			l_frequency_tbl := slot_frequency_table
			l_first_cover_tbl := slot_first_coverage_time_table

			from
				i := 0
			until
				i = slot_count
			loop
				if l_first_cover_tbl.item (i) /= Void then
					l_first_time := l_first_cover_tbl.item (i).time
					l_first_test_case := l_first_cover_tbl.item (i).test_case_index
				else
					l_first_time := -1
					l_first_test_case := -1
				end
				Result.put (
					[l_frequency_tbl.item (i),			-- Covered times
					 l_first_time,						-- First cover time
					 l_first_test_case					-- First cover test case index
					], i)
				i := i + 1
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Operations

	load (a_directory_name: STRING) is
			-- Load all `sat_*.log" files in `a_directory_name' and make result
			-- available through `slot_visit_log', `slot_frequency_table', `slot_first_coverage_time_table'.
			-- Subdirectories are not searched.
		require
			a_directory_name_attached: a_directory_name /= Void
			not_a_directory_name_is_empty: not a_directory_name.is_empty
		local
			l_log_files: LIST [STRING]
		do
				-- Find log files in `a_directory_name'.
			l_log_files := sorted_log_file_names (a_directory_name)

				-- Load found log files into Current.
			create log_loader.make
			log_loader.register_analyzer (Current)
			log_loader.set_should_stop_loading (False)
			log_loader.load_files (l_log_files)
		end

	log_loader: SAT_FILE_LOADER
			-- Instrumentation log file loader

--	round_time_to_minute is
--			-- Round time in records in `slot_visit_log' to minute.
--		local
--			cur: DS_LIST_CURSOR [SAT_DECISION_COVERAGE_RECORD]
--			l_item: SAT_DECISION_COVERAGE_RECORD
--		do
--			cur := slot_visit_log.new_cursor
--			from
--				cur.start
--			until
--				cur.after
--			loop
--				l_item := cur.item
--				l_item.set_time (l_item.time // 60 + 1)
--				cur.forth
--			end
--		end

--	calculate_coverage_time_table is
--			--
--		local
--			l_met_dcs: DS_HASH_SET [INTEGER]
--			cur: DS_LIST_CURSOR [SAT_DECISION_COVERAGE_RECORD]
--			l_slot: INTEGER
--			l_time: INTEGER
--			l_met_dcs_count: INTEGER
--			i: INTEGER
--			l_last_coverage: INTEGER
--		do
--			create l_met_dcs.make (5000)
--			create coverage_time_table.make (0, 200)
--			cur := slot_visit_log.new_cursor
--			from
--				cur.start
--			until
--				cur.after
--			loop
--				l_slot := cur.item.slot
--				l_time := cur.item.time
--				if not l_met_dcs.has (l_slot) then
--					l_met_dcs_count := l_met_dcs_count + 1
--					l_met_dcs.force_last (l_slot)
--					if coverage_time_table.valid_index (l_time) then
--						coverage_time_table.put (l_met_dcs_count, l_time)
--					else
--						coverage_time_table.force (l_met_dcs_count, l_time)
--					end
--				end
--				cur.forth
--			end
--			from
--				i := coverage_time_table.lower
--			until
--				i > coverage_time_table.upper
--			loop
--				if coverage_time_table.item (i) = 0 then
--					coverage_time_table.put (l_last_coverage, i)
--				else
--					l_last_coverage := coverage_time_table.item (i)
--				end
--				i := i + 1
--			end
--			covered_slot_count := l_met_dcs_count
--		end

	covered_slot_count: INTEGER
			-- Number of covered slots

	coverage_time_table: ARRAY [INTEGER]

	coverage_test_case_table: ARRAY [INTEGER]
			-- Number of slots that are covered until now
			-- Index of the array is the number of test case performed so far

--	calculate_test_case_table is
--			--
--		local
--			l_met_dcs: DS_HASH_SET [INTEGER]
--			cur: DS_LIST_CURSOR [SAT_DECISION_COVERAGE_RECORD]
--			l_slot: INTEGER
--			l_met_dcs_count: INTEGER
--			l_test_case_count: INTEGER
--			i: INTEGER
--			l_last_coverage: INTEGER
--		do
--			create l_met_dcs.make (2000)
--			create coverage_test_case_table.make (0, 5000)
--			cur := slot_visit_log.new_cursor
--			from
--				cur.start
--			until
--				cur.after
--			loop
--				l_slot := cur.item.slot
--				l_test_case_count := cur.item.test_case_index
--				if not l_met_dcs.has (l_slot) then
--					l_met_dcs_count := l_met_dcs_count + 1
--					l_met_dcs.force_last (l_slot)
--					if coverage_test_case_table.valid_index (l_test_case_count) then
--						coverage_test_case_table.put (l_met_dcs_count, l_test_case_count)
--					else
--						coverage_test_case_table.force (l_met_dcs_count, l_test_case_count)
--					end
--				end
--				cur.forth
--			end
--			from
--				i := coverage_test_case_table.lower
--			until
--				i > coverage_test_case_table.upper
--			loop
--				if coverage_test_case_table.item (i) = 0 then
--					coverage_test_case_table.put (l_last_coverage, i)
--				else
--					l_last_coverage := coverage_test_case_table.item (i)
--				end
--				i := i + 1
--			end
--			covered_slot_count := l_met_dcs_count
--		end

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
			l_test_case_index: INTEGER
			l_decision_record: SAT_DECISION_COVERAGE_RECORD
			l_decision_list: DS_LINKED_LIST [SAT_DECISION_COVERAGE_RECORD]
			l_feature_record: SAT_FEATURE_ACCESS_RECORD
			l_feature_list: DS_LINKED_LIST [SAT_FEATURE_ACCESS_RECORD]
			l_frequency_table: like slot_frequency_table
			l_first_visit_table: like slot_first_coverage_time_table
		do
			l_frequency_table := slot_frequency_table
			l_first_visit_table := slot_first_coverage_time_table

				-- Read data from `a_record_line'.
			l_data := a_record_line.split (',')

			check l_data.count = 3 end
			l_slot := l_data.i_th (1).to_integer
			l_test_case_index := l_data.i_th (2).to_integer
			l_time := l_data.i_th (3).to_integer - test_session_start_time

			if l_time >= analysis_start_time then
				if analysis_end_time >= 0 then
					is_parse_ended := analysis_end_time <= l_time
				end
				if not is_parse_ended then
						-- Store data as decision coverage record.
					create l_decision_record.make_with_slot_and_time (l_slot, l_time)
					l_decision_record.set_test_case_index (l_test_case_index)
					if first_slot = Void then
						first_slot := l_decision_record
					end
					last_slot := l_decision_record

--					l_decision_list := decision_table.item (l_slot)
--					if l_decision_list = Void then
--						create l_decision_list.make
--						decision_table.extend (l_decision_list, l_slot)
--					end
--					l_decision_list.force_last (l_decision_record)

					if not test_case_start_record_table.has (l_test_case_index) then
						test_case_start_record_table.force (l_decision_record, l_test_case_index)
					end

						-- Update visit times for every slot.
					l_frequency_table.put (l_frequency_table.item (l_slot) + 1, l_slot)
					update_branch_frequency_table (l_slot)

						-- Update first visit time for every slot.
					if l_first_visit_table.item (l_slot) = Void or else l_first_visit_table.item (l_slot).time > l_time then
						l_first_visit_table.put (l_decision_record, l_slot)
					end
					update_branch_first_visit_table (l_slot, l_time, l_test_case_index)
				else
					log_loader.set_should_stop_loading (True)
				end
			end
		end

	update_branch_first_visit_table (a_slot_index: INTEGER; a_time: INTEGER; a_test_case_index: INTEGER) is
			-- update `branch_first_coverage_time_table'.
		local
			l_branches: LIST [INTEGER]
			l_branch_visit_table: like branch_first_coverage_time_table
			l_branch_id: INTEGER
			l_visit: TUPLE [first_visit_time: INTEGER; first_visit_text_case_index: INTEGER]
		do
			l_branch_visit_table := branch_first_coverage_time_table
			l_branches := instrument_config.branches.item (a_slot_index)
			from
				l_branches.start
			until
				l_branches.after
			loop
				l_branch_id := l_branches.item
				l_visit := l_branch_visit_table.item (l_branch_id)
				if l_visit.first_visit_time = -1 or else l_visit.first_visit_time > a_time then
					l_branch_visit_table.put ([a_time, a_test_case_index], l_branch_id)
				end
				l_branches.forth
			end
		end

	update_branch_frequency_table (a_slot_index: INTEGER) is
			-- Update `branch_frequency_table' with `a_slot_index'.
		local
			l_branches: LIST [INTEGER]
			l_branch_frequency_table: like branch_frequency_table
			l_branch_id: INTEGER
		do
			l_branches := instrument_config.branches.item (a_slot_index)
			l_branch_frequency_table := branch_frequency_table
			from
				l_branches.start
			until
				l_branches.after
			loop
				l_branch_id := l_branches.item
				l_branch_frequency_table.put (l_branch_frequency_table.item (l_branch_id) + 1, l_branch_id)
				l_branches.forth
			end
		end

	sections_internal: like sections
			-- Implementation of `sections'.

	initialize_sections is
			-- Initialize `sections'.
		do
			sections.wipe_out
			sections.extend (dcs_section_name)
		end

	reset is
			-- Reset Current analyzer and prepare it for a new analysis.
		do
--			slot_visit_log.wipe_out
--			decision_table.wipe_out
			test_case_start_record_table.wipe_out
			slot_frequency_table.clear_all
			slot_first_coverage_time_table.clear_all
		end

	sorted_log_file_names (a_directory_name: STRING): LINKED_LIST [STRING] is
			-- List of log file names in `a_directory_name' sorted by time in ascend order
			-- If no log file is found, return an empty list.
			-- Subdirectories of `a_directory_name' are not searched.
		require
			a_directory_name_attached: a_directory_name /= Void
			not_a_directory_name_is_empty: not a_directory_name.is_empty
		local
			l_file_searcher: SAT_FILE_SEARCHER
			l_time_list: DS_ARRAYED_LIST [INTEGER]
			l_file_table: HASH_TABLE [STRING, INTEGER]
			l_sorter: DS_QUICK_SORTER [INTEGER]
			l_index: INTEGER
			l_time: INTEGER
		do
				-- Search for log files in `a_directory_name'.
			create l_file_searcher.make_with_pattern ("sat_.*\.log")
			l_file_searcher.locations.extend (a_directory_name)
			l_file_searcher.search

				-- Sort found log files by time.
			create l_file_table.make (20)
			create l_time_list.make (10)
			from
				l_file_searcher.last_found_files.start
			until
				l_file_searcher.last_found_files.after
			loop
				l_index := l_file_searcher.last_found_files.item.substring_index ("sat_", 1)
				l_time := l_file_searcher.last_found_files.item.substring (l_index + 4, l_index + 4 + 9).to_integer
				l_file_table.force (l_file_searcher.last_found_files.item, l_time)
				l_time_list.force_last (l_time)
				l_file_searcher.last_found_files.forth
			end

			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [INTEGER]}.make (
				agent (a_int, b_int: INTEGER): BOOLEAN do Result := a_int < b_int end))
			l_sorter.sort (l_time_list)

				-- Store sorted log files in result.
			create Result.make
			from
				l_time_list.start
			until
				l_time_list.after
			loop
				Result.extend (l_file_table.item (l_time_list.item_for_iteration))
				l_time_list.forth
			end
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Implementation

	initial_storage_size: INTEGER is 5000
		-- Initialize size for storage data structure

	branch_frequency_table_internal: like branch_frequency_table
			-- Implementation of `branch_frequency_table'

	branch_first_coverage_time_table_internal: like branch_first_coverage_time_table
			-- Implementation of `branch_first_coverage_time_table'

	is_parse_ended: BOOLEAN
			-- Is log parsing ended due to analysis time zone?

invariant
--	decisions_attached: slot_visit_log /= Void

end
