indexing
	description: "Summary description for {SAT_RESULT_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_RESULT_LOADER

create
	make

feature{NONE} -- Initialization

	make (a_directory: STRING; a_system: SYSTEM_I; a_start_time, a_end_time: INTEGER) is
			-- Initialize current to load result from `a_directory'.
		require
			a_directory_attached: a_directory /= Void
		do
			directory := a_directory.twin
			system := a_system
			start_time := a_start_time
			end_time := a_end_time
		end

	start_time: INTEGER
	end_time: INTEGER

feature -- Access

	system: SYSTEM_I
			-- System from which current result is generated

	directory: STRING
			-- Directory where log files are stored

	instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER
			-- Config for instrumenation

	instrument_log: SAT_DECISION_COVERAGE_LOG_ANALYZER
			-- Instrumentation log

	proxy_log: SAT_AUTO_TEST_LOG_PARSER
			-- Proxy log from AutoTest

feature -- Basic operations

	load is
			-- Load log result and make result available through
			-- `instrument_config', `instrument_log', `proxy_log'.
		do
			load_instrument_config
			load_proxy_log
			load_instrument_log
		end

	generate_statistics is
			-- Generate statistics of result into `a_output_file_name'.
		local
			l_file: PLAIN_TEXT_FILE
			l_covered_branches: LIST [INTEGER]
			l_branch_frequency_tbl: ARRAY [INTEGER]
			l_branch_first_time_tbl: ARRAY [INTEGER]
			l_file_name: FILE_NAME
		do
--			create l_file.make_create_read_write (a_output_file_name)

--			generate_summary (l_file)
--			generate_branch_coverage_table (l_file)
--			generate_slot_coverage_table (l_file)
--			generate_fault_fault_table (l_file)
--			generate_fault_coverage_time_table (l_file)
--			generate_fault_summary (l_file)

--			l_file.close

				-- Generate fault related results.
			create l_file_name.make_from_string (directory)
			l_file_name.set_file_name ("fault_description.txt")
			generate_fault_description (l_file_name)

			create l_file_name.make_from_string (directory)
			l_file_name.set_file_name ("faults.txt")
			generate_fault_statistics_result (l_file_name)

				-- Generate branch results.
			create l_file_name.make_from_string (directory)
			l_file_name.set_file_name ("branches.txt")
			generate_branch_statistics (l_file_name)

				-- Generate slot results.
			create l_file_name.make_from_string (directory)
			l_file_name.set_file_name ("slots.txt")
			generate_slot_statistics (l_file_name)
		end

feature{NONE} -- Implementation

	testing_time_in_minute: INTEGER is
			-- Testing time in minute
		do
			Result := (instrument_log.last_slot_visit_time - instrument_log.first_slot_visit_time) // 60 + 1
		ensure
			result_positive: Result > 0
		end

feature{NONE} -- Loading

	load_instrument_config is
			-- Load `instrument_config' from `directory'.
		local
			l_config_file: FILE_NAME
		do
			create l_config_file.make_from_string (directory)
			l_config_file.set_file_name ("sat_translator.txt")
			create instrument_config.make
			instrument_config.load (l_config_file)
		end

	load_proxy_log is
			-- Load `proxy_log' from `directory'.
		local
			l_log_file: FILE_NAME
		do
			create l_log_file.make_from_string (directory)
			l_log_file.set_file_name ("proxy_log.txt")
			create proxy_log.make (system, create {AUT_ERROR_HANDLER}.make (system))
			proxy_log.set_analyzsis_time (start_time, end_time)
			proxy_log.load_file (l_log_file)
		end

	load_instrument_log is
			-- Load `instrument_log' from `directory'.
		require
			proxy_log_attached: proxy_log /= Void
		do
			create instrument_log.make (proxy_log.test_session_start_time, instrument_config)
			instrument_log.load (directory)
		end

feature{NONE} -- Statistics generation

	generate_summary (a_file: PLAIN_TEXT_FILE) is
			-- Generate branch coverage information into `a_file'.
		require
			a_file_attached: a_file /= Void
			a_file_writable: a_file.writable
		local
			l_covered_branches: LIST [INTEGER]
		do
			l_covered_branches := instrument_log.covered_branches (instrument_config)
			a_file.put_string ("Summary%N")
			a_file.put_string ("Testing time=" + ((instrument_log.last_slot_visit_time - instrument_log.first_slot_visit_time) // 60 + 1).out + "m%N")
			a_file.put_string ("Found faults=" + proxy_log.faults.count.out + "%N")
			a_file.put_string ("Branches=" + instrument_config.branch_count.out + "%N")
			a_file.put_string ("Covered branches=" + l_covered_branches.count.out + "%N")
			a_file.put_string ("Covered percentage=" + ((l_covered_branches.count.to_real / instrument_config.branch_count) * 100).floor.out + "%N")
			a_file.put_string ("%N")
		end

	horizantal_line: STRING is "==================================================================%N"

	generate_branch_coverage_table (a_file: PLAIN_TEXT_FILE) is
			-- Generate branch coverage information into `a_file'.
		require
			a_file_attached: a_file /= Void
			a_file_writable: a_file.writable
		local
			l_branch_frequency_tbl: ARRAY [INTEGER]
			l_branch_first_time_tbl: ARRAY [TUPLE [first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]]
			i: INTEGER
			l_lower, l_upper: INTEGER
		do
			a_file.put_string (horizantal_line)
			l_branch_frequency_tbl := instrument_log.branch_frequency_table
			l_branch_first_time_tbl := instrument_log.branch_first_coverage_time_table

				-- Generate branch coverage table.
			a_file.put_string ("Branch coverage table%N")
			a_file.put_string ("Branch_id%TCovered_times%TFirst_covered_time%N")
			from
				l_lower := l_branch_first_time_tbl.lower
				l_upper := l_branch_first_time_tbl.upper
				i := l_lower
			until
				i > l_upper
			loop
				a_file.put_string (i.out)
				a_file.put_string ("%T")

				a_file.put_string (l_branch_frequency_tbl.item (i).out)
				a_file.put_string ("%T")

				a_file.put_string (l_branch_first_time_tbl.item (i).first_visit_time.out)
				a_file.put_string ("%N")
				i := i + 1
			end
			a_file.put_string ("%N")
		end

	generate_slot_coverage_table (a_file: PLAIN_TEXT_FILE) is
			-- Generate slot coverage information into `a_file'.
		require
			a_file_attached: a_file /= Void
			a_file_writable: a_file.writable
		local
			l_slot_frequency_tbl: ARRAY [INTEGER]
			l_slot_first_time_tbl: ARRAY [SAT_DECISION_COVERAGE_RECORD]
			i: INTEGER
			l_lower, l_upper: INTEGER
		do
			a_file.put_string (horizantal_line)
			l_slot_frequency_tbl := instrument_log.slot_frequency_table
			l_slot_first_time_tbl := instrument_log.slot_first_coverage_time_table

			l_slot_frequency_tbl := instrument_log.slot_frequency_table
			l_slot_first_time_tbl := instrument_log.slot_first_coverage_time_table

				-- Generate branch coverage table.
			a_file.put_string ("Slot coverage table%N")
			a_file.put_string ("Slot_id%TCovered_times%TFirst_covered_time%N")
			from
				l_lower := l_slot_first_time_tbl.lower
				l_upper := l_slot_first_time_tbl.upper
				i := l_lower
			until
				i > l_upper
			loop
				a_file.put_string (i.out)
				a_file.put_string ("%T")

				a_file.put_string (l_slot_frequency_tbl.item (i).out)
				a_file.put_string ("%T")
				if l_slot_first_time_tbl.item (i) /= Void then
					a_file.put_string (l_slot_first_time_tbl.item (i).time.out)
				else
					a_file.put_string ("-1")
				end

				a_file.put_string ("%N")
				i := i + 1
			end
			a_file.put_string ("%N")
		end

	generate_fault_statistics_result (a_file_name: STRING) is
			-- Generate fault statistics result in `a_file_name.
		require
			a_file_name_attached: a_file_name /= Void and then not a_file_name.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_faults: ARRAY [TUPLE [found_times: INTEGER; first_found_time: INTEGER; first_found_test_case_index: INTEGER; summary: STRING]]
			l_fault: TUPLE [found_times: INTEGER; first_found_time: INTEGER; first_found_test_case_index: INTEGER; summary: STRING]
			i: INTEGER
			count: INTEGER
		do
			create l_file.make_create_read_write (a_file_name)
			l_file.put_string ("Fault_id%TFrequency%TFirst_found_time%Tfirst_found_test_case%N")
			from
				l_faults := proxy_log.fault_statistics
				i := 1
				count := l_faults.count
			until
				i > count
			loop
				l_fault := l_faults.item (i)
				l_file.put_string (i.out + "%T") 									-- Fault index
				l_file.put_string (l_fault.found_times.out + "%T")					-- Found times
				l_file.put_string (l_fault.first_found_time.out + "%T")				-- First found time
				l_file.put_string (l_fault.first_found_test_case_index.out + "%N")	-- First found test case index
				i := i + 1
			end
			l_file.close
		end

	generate_fault_description (a_file_name: STRING) is
			-- Generate fault descriptions in `a_file_name'.
		require
			a_file_name_attached: a_file_name /= Void and then not a_file_name.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_faults: ARRAY [TUPLE [found_times: INTEGER; first_found_time: INTEGER; first_found_test_case_index: INTEGER; summary: STRING]]
			l_fault: TUPLE [found_times: INTEGER; first_found_time: INTEGER; first_found_test_case_index: INTEGER; summary: STRING]
			i: INTEGER
			count: INTEGER
		do
			create l_file.make_create_read_write (a_file_name)
			from
				l_faults := proxy_log.fault_statistics
				i := 1
				count := l_faults.count
			until
				i > count
			loop
				l_fault := l_faults.item (i)
				l_file.put_string (i.out + "%T") 									-- Fault index
				l_file.put_string (l_fault.summary + "%N")					-- Fault description
				i := i + 1
			end
			l_file.close
		end

	generate_branch_statistics (a_file_name: STRING) is
			-- Generate statistics for branch coverage in `a_file_name'.
		require
			a_file_name_attached: a_file_name /= Void and then not a_file_name.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			i: INTEGER
			count: INTEGER
			l_branches: ARRAY [TUPLE [visited_times: INTEGER; first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]]
			l_branch: TUPLE [visited_times: INTEGER; first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]
		do
			create l_file.make_create_read_write (a_file_name)
			l_file.put_string ("Branch_id%TVisited_times%TFirst_visit_time%TFirst_visit_test_case%N")
			from
				l_branches := instrument_log.branch_coverage_statistics
				i := 1
				count := l_branches.count
			until
				i > count
			loop
				l_branch := l_branches.item (i)
				l_file.put_string (i.out + "%T") 									-- Branch id
				l_file.put_string (l_branch.visited_times.out + "%T")				-- Visited times
				l_file.put_string (l_branch.first_visit_time.out + "%T")			-- First visited time
				l_file.put_string (l_branch.first_visit_test_case_index.out + "%N")	-- First visited test case index
				i := i + 1
			end
			l_file.close
		end

	generate_slot_statistics (a_file_name: STRING) is
			-- Generate statistics for slot coverage in `a_file_name'.
		require
			a_file_name_attached: a_file_name /= Void and then not a_file_name.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			i: INTEGER
			count: INTEGER
			l_slots: ARRAY [TUPLE [visited_times: INTEGER; first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]]
			l_slot: TUPLE [visited_times: INTEGER; first_visit_time: INTEGER; first_visit_test_case_index: INTEGER]
		do
			create l_file.make_create_read_write (a_file_name)
			l_file.put_string ("Slotid%TVisited_times%TFirst_visit_time%TFirst_visit_test_case%N")
			from
				l_slots := instrument_log.slot_coverage_statistics
				i := 0
				count := l_slots.count
			until
				i = count
			loop
				l_slot := l_slots.item (i)
				l_file.put_string (i.out + "%T") 									-- Slot id
				l_file.put_string (l_slot.visited_times.out + "%T")					-- Visited times
				l_file.put_string (l_slot.first_visit_time.out + "%T")				-- First visited time
				l_file.put_string (l_slot.first_visit_test_case_index.out + "%N")	-- First visited test case index
				i := i + 1
			end
			l_file.close
		end

	generate_fault_fault_table (a_file: PLAIN_TEXT_FILE) is
			-- Generate fault finding information into `a_file'.
		require
			a_file_attached: a_file /= Void
			a_file_writable: a_file.writable
		local
			l_fault_frequency_tbl: ARRAY [INTEGER]
			l_fault_first_time_tbl: ARRAY [TUPLE [first_found_time: INTEGER; first_found_test_case_index: INTEGER]]
			i: INTEGER
			l_lower, l_upper: INTEGER
		do
			l_fault_frequency_tbl := proxy_log.fault_frequency_table
			l_fault_first_time_tbl := proxy_log.fault_first_found_time_table

				-- Generate fault finding table.
			a_file.put_string (horizantal_line)
			a_file.put_string ("Fault table%N")
			a_file.put_string ("Fault_id%TFound_times%TFirst_found_time%N")
			from
				l_lower := l_fault_first_time_tbl.lower
				l_upper := l_fault_first_time_tbl.upper
				i := l_lower
			until
				i > l_upper
			loop
				a_file.put_string (i.out)
				a_file.put_string ("%T")

				a_file.put_string (l_fault_frequency_tbl.item (i).out)
				a_file.put_string ("%T")

				a_file.put_string (l_fault_first_time_tbl.item (i).first_found_time.out)
				a_file.put_string ("%N")
				i := i + 1
			end
			a_file.put_string ("%N")
		end

	generate_fault_coverage_time_table (a_file: PLAIN_TEXT_FILE) is
			-- Generate fault/coverage time information into `a_file'.
		require
			a_file_attached: a_file /= Void
			a_file_writable: a_file.writable
		local
			l_fault_time_table: ARRAY [INTEGER]
			l_branch_time_table: ARRAY [INTEGER]
			l_fault_number: INTEGER
			l_branch_number: INTEGER
			i: INTEGER
			l_lower, l_upper: INTEGER
		do
			l_fault_number := proxy_log.faults.count
			l_branch_number := instrument_config.branch_count
			l_fault_time_table := proxy_log.accumulated_fault_time_table (0, testing_time_in_minute, 60)
			l_branch_time_table := instrument_log.accumulated_branch_coverage_time_table (0, testing_time_in_minute, 60, instrument_config)

			a_file.put_string (horizantal_line)
			a_file.put_string ("Fault/coverage time table%N")
			a_file.put_string ("Time(m)%TFault_number%TFault_percentage%TCovered_branch_number%TCovered_branch_percentage%N")
			from
				l_lower := l_fault_time_table.lower
				l_upper := l_fault_time_table.upper
				i := l_lower
			until
				i > l_upper
			loop
				a_file.put_string (i.out + "%T")
				a_file.put_string (l_fault_time_table.item (i).out + "%T")
				if l_fault_number > 0 then
					a_file.put_string ((l_fault_time_table.item (i).to_real / l_fault_number * 100).floor.out + "%T")
				else
					a_file.put_string ("0%T")
				end
				a_file.put_string (l_branch_time_table.item (i).out + "%T")
				if l_branch_number > 0 then
					a_file.put_string ((l_branch_time_table.item (i).to_real / l_branch_number * 100).floor.out + "%N")
				else
					a_file.put_string ("0%T")
				end
				i := i + 1
			end
			a_file.put_string ("%N")
		end

	generate_fault_summary (a_file: PLAIN_TEXT_FILE) is
			-- Generate fault finding information into `a_file'.
		require
			a_file_attached: a_file /= Void
			a_file_writable: a_file.writable
		local
			i: INTEGER
			l_fault_index: INTEGER
		do
--			a_file.put_string (horizantal_line)
--			a_file.put_string ("Fault summary%N")
--			from
--				proxy_log.faults.start
--			until
--				proxy_log.faults.after
--			loop
--				l_fault_index := 0
--				from
--					proxy_log.fault_index_table.start
--				until
--					proxy_log.fault_index_table.after or else l_fault_index /= 0
--				loop
--					if proxy_log.fault_index_table.item_for_iteration.witness.is_same_bug (proxy_log.faults.item_for_iteration.witness) then
--						l_fault_index := proxy_log.fault_index_table.key_for_iteration
--					end
--					proxy_log.fault_index_table.forth
--				end
--				check l_fault_index /= 0 end
--				a_file.put_string (l_fault_index.out + "%T")
--				a_file.put_string (proxy_log.test_case_result_summary (proxy_log.faults.item_for_iteration))
--				a_file.put_string ("%N")
--				proxy_log.faults.forth
--			end
--			a_file.put_string ("%N")
		end

invariant
	directory_attached: directory /= Void

end
