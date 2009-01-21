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

	make (a_directory: STRING; a_system: SYSTEM_I; a_start_time, a_end_time: INTEGER; a_session_length: INTEGER) is
			-- Initialize current to load result from `a_directory'.
		require
			a_directory_attached: a_directory /= Void
		do
			directory := a_directory.twin
			system := a_system
			start_time := a_start_time
			end_time := a_end_time
			session_length := a_session_length
		end

	start_time: INTEGER
	end_time: INTEGER

	session_length: INTEGER
			-- Session length in minute

feature -- Access

	system: SYSTEM_I
			-- System from which current result is generated

	directory: STRING
			-- Directory where log files are stored

	instrument_config: SAT_DCS_INSTRUMENT_CONFIG_LOADER
			-- Config for instrumenation

	instrument_log: SAT_DECISION_COVERAGE_LOG_ANALYZER
			-- Instrumentation log

--	proxy_log: SAT_AUTO_TEST_LOG_PARSER
--			-- Proxy log loader to analyze faults

	original_proxy_log: SAT_AUTO_TEST_LOG_PARSER
			-- Proxy log loader to analyze original faults

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
				-- Generate fault related results.
			create l_file_name.make_from_string (directory)
			l_file_name.set_file_name ("fault_description.txt")
			generate_fault_description (original_proxy_log, l_file_name)
			if original_proxy_log.last_test_case_time < (session_length * 60) * 0.99 then
				create l_file_name.make_from_string (directory)
				l_file_name.set_file_name ("warning.txt")
				create l_file.make_create_read_write (l_file_name)
				l_file.put_string ("Session length: " + original_proxy_log.last_test_case_time.out + "%N")
				l_file.close
			end

--			create l_file_name.make_from_string (directory)
--			l_file_name.set_file_name ("faults.txt")
--			generate_fault_statistics_result (proxy_log, l_file_name)

				-- Generate original fault related results.
			create l_file_name.make_from_string (directory)
			l_file_name.set_file_name ("original_fault_description.txt")
			generate_fault_description (original_proxy_log, l_file_name)

			create l_file_name.make_from_string (directory)
			l_file_name.set_file_name ("original_faults.txt")
			generate_fault_statistics_result (original_proxy_log, l_file_name)

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

--				-- Analyze faults.
--			create proxy_log.make (system, create {AUT_ERROR_HANDLER}.make (system))
--			proxy_log.set_analyzsis_time (start_time, end_time)
--			proxy_log.set_same_witness_function (agent proxy_log.is_same_bug)
--			proxy_log.load_file (l_log_file)

				-- Analyze original faults.
			create original_proxy_log.make (system, create {AUT_ERROR_HANDLER}.make (system))
			original_proxy_log.set_analyzsis_time (start_time, end_time)
			original_proxy_log.set_same_witness_function (agent original_proxy_log.is_same_original_bug)
			original_proxy_log.load_file (l_log_file)
		end

	load_instrument_log is
			-- Load `instrument_log' from `directory'.
		require
			proxy_log_attached: original_proxy_log /= Void
		do
			create instrument_log.make (original_proxy_log.test_session_start_time, start_time, end_time, instrument_config)
			instrument_log.set_fault_table (original_proxy_log.fault_table)
			instrument_log.load (directory)
		end

feature{NONE} -- Statistics generation

	horizantal_line: STRING is "==================================================================%N"

	generate_fault_statistics_result (a_fault_analyzer: like original_proxy_log; a_file_name: STRING) is
			-- Generate fault statistics result in `a_file_name' from `a_fault_analyzer'.
		require
			a_fault_analyzer_attached: a_fault_analyzer /= Void
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
				l_faults := a_fault_analyzer.fault_statistics
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

	generate_fault_description (a_fault_analyzer: like original_proxy_log; a_file_name: STRING) is
			-- Generate fault descriptions in `a_file_name' from `a_fault_analyzer'.
		require
			a_fault_analyzer_attached: a_fault_analyzer /= Void
			a_file_name_attached: a_file_name /= Void and then not a_file_name.is_empty
		local
			l_file: PLAIN_TEXT_FILE
			l_faults: ARRAY [TUPLE [found_times: INTEGER; first_found_time: INTEGER; first_found_test_case_index: INTEGER; summary: STRING]]
			l_fault: TUPLE [found_times: INTEGER; first_found_time: INTEGER; first_found_test_case_index: INTEGER; summary: STRING]
			i: INTEGER
			count: INTEGER
			l_slot_table: HASH_TABLE [INTEGER, INTEGER]
		do
			create l_file.make_create_read_write (a_file_name)
			from
				l_faults := a_fault_analyzer.fault_statistics
				i := 1
				count := l_faults.count
			until
				i > count
			loop
				l_fault := l_faults.item (i)
				l_file.put_string (i.out + "%T") 									-- Fault index
				l_file.put_string (l_fault.summary + "%N")					-- Fault description

				if instrument_log.fault_branch_visit_table.has (l_fault.first_found_test_case_index) then
					l_slot_table := instrument_log.fault_branch_visit_table.item (l_fault.first_found_test_case_index)
					from
						l_slot_table.start
					until
						l_slot_table.after
					loop
						l_file.put_string ("-- >> ")
						l_file.put_string (l_slot_table.key_for_iteration.out + "%T" + l_slot_table.item_for_iteration.out + "%N")
						l_slot_table.forth
					end
					l_file.put_string ("%N")
				end
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

invariant
	directory_attached: directory /= Void

end
