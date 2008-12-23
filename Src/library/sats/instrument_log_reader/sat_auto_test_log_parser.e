indexing
	description: "Summary description for {SAT_AUTO_TEST_LOG_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_AUTO_TEST_LOG_PARSER

inherit
	AUT_RESULT_REPOSITORY_BUILDER
		redefine
			make,
			report_comment_line,
			update_request_with_test_case_info,
			report_last_request,
			update_result_reposotory,
			parse_stream
		end

	SAT_RESULT_ANALYZER_UTILITY

	AUT_SHARED_INTERPRETER_INFO

create
	make

feature {NONE} -- Initialization

	make (a_system: like system; an_error_handler: like error_handler) is
			-- Create new log file parser.
		do
			Precursor (a_system, an_error_handler)

				-- Setup `request_list'.
			create request_list.make
			create dummy_request.make (a_system)
			request_list.set_default_item_agent (agent dummy_request)

				-- `analyzsis_end_time' is set to negative initially, meaning that we analyze the log until end.
			analyzsis_end_time := -1

			create unique_failure_witnesses.make

			create fault_frequency_table.make (1, 100)
			create fault_first_found_time_table.make (1, 100)

			compute_interpreter_class
		end

feature -- Analysis time zone

	analysis_start_time: INTEGER
			-- Start time in second related to the start time of current proxy_log
			-- indicating whether the analysis of faults should be done.
			-- For example, if [`analysis_start_time', `analyzsis_end_time'] is [5, 10],
			-- only the log between 5th~10th second are going to be analyzed.

	analyzsis_end_time: INTEGER
			-- End time in second related to the start time of current proxy_log
			-- indicating whether the analysis of faults should be done.
			-- If negative, the analysis will be done until the end of the log file.

	set_analyzsis_time (a_start_time: INTEGER; a_end_time: INTEGER) is
			-- Set `analysis_start_time' with `a_start_time' and
			-- `analysis_end_time' with `a_end_time'.
		require
			a_start_time_non_negative: a_start_time >= 0
			a_end_time_valid: a_end_time>=0 implies a_end_time >= a_start_time
		do
			analysis_start_time := a_start_time
			analyzsis_end_time := a_end_time
		ensure
			analysis_start_time_set: analysis_start_time = a_start_time
			analyzsis_end_time_set: analyzsis_end_time = a_end_time
		end

feature -- Access

	faults: DS_ARRAYED_LIST [AUT_TEST_CASE_RESULT]
			-- Table of found distinguish faults in `last_repository'

	fault_frequency_table: ARRAY [INTEGER]
			-- Table of fault frequency.
			-- Index is fault id given by `fault_index_table'.
			-- Value is the number of times that the fault is found.

	fault_first_found_time_table: ARRAY [TUPLE [first_found_time: INTEGER; first_found_test_case_index: INTEGER]]
			-- Table of time when faults are first found.
			-- Index is the index of feature given by `fault_index_table'.
			-- `first_found_time' is the time (related to `test_session_start_time' in second when that fault is found.
			-- `first_found_test_case_index' is the index of the test case where the fault is found for the first time.

	fault_time_table: ARRAY [INTEGER]
			-- Table for faults over time
			-- [Faults until time, time]

	test_session_start_time: INTEGER
			-- Start time of this test session.
			-- If this test session contains several interpreter runs,
			-- the start time is the start time of the first interpreter run.
			-- The value is the number of seconds since based date.

	accumulated_fault_time_table (a_start_time: INTEGER; a_end_time: INTEGER; a_time_unit: INTEGER): ARRAY [INTEGER] is
			-- Table of things that happesn over time.
			-- Index of the result array is time, value of the array is the number of faults that are found until that time.
			-- `a_start_time' is the starting time related to `test_session_start_time',
			-- `a_end_time' is the end time related to `test_session_start_time'.
			-- `a_start_time' and `a_end_time' points are included in the result.
			-- `a_time_unit' is the unit of `a_start_time', `a_end_time' and the time index used in the result array.
			-- `a_time_unit' is in the unit of second. For example, if you want to see fault time table in minute time unit,
			-- the `a_time_unit' should be 60.
		require
			a_start_time_non_negative: a_start_time >= 0
			a_end_time_non_negative: a_end_time >= 0
			a_end_time_valid: a_end_time >= a_start_time
			a_time_unit_positive: a_time_unit > 0
		local
			l_time_table: ARRAY [INTEGER]
			i: INTEGER
			count: INTEGER
		do
			create l_time_table.make (1, fault_first_found_time_table.count)
			from
				i := 1
				count := fault_first_found_time_table.count
			until
				i > count
			loop
				l_time_table.put (fault_first_found_time_table.item (i).first_found_time, i)
				i := i + 1
			end
			Result := accumulated_time_table (a_start_time, a_end_time, a_time_unit, l_time_table)
		ensure
			result_attached: Result /= Void
			result_valid: Result.lower = a_start_time and Result.upper = a_end_time
			result_increasing: is_array_increasing (Result, False)
		end

	test_case_result_summary (a_test_case_result: AUT_TEST_CASE_RESULT): STRING is
			-- String summarizing `a_test_case_result'
		require
			a_test_case_result_attached: a_test_case_result /= Void
		local
			l_response: AUT_NORMAL_RESPONSE
			l_trace: STRING
		do
			create Result.make (64)
			Result.append (a_test_case_result.class_.name_in_upper)
			Result.append_character ('.')
			Result.append (a_test_case_result.feature_.feature_name)
			Result.append ("%T")

			Result.append ("test_case_index=")
			Result.append (a_test_case_result.witness.item (a_test_case_result.witness.count).test_case_index.out)

			l_response ?= a_test_case_result.witness.item (a_test_case_result.witness.count).response
			if l_response /= Void then
				Result.append ("%T")

				Result.append ("exception_code=")
				Result.append (l_response.exception.code.out)
				Result.append ("%T")

				Result.append ("tag=")
				Result.append (l_response.exception.tag_name)
				Result.append ("%T")

				Result.append ("recipient=")
				Result.append (l_response.exception.class_name)
				Result.append (".")
				Result.append (l_response.exception.recipient_name)
				Result.append ("%T")

				Result.append ("break_point_slot=")
				Result.append (l_response.exception.break_point_slot.out)
				Result.append ("%N")

					-- Store exception trace.
				l_trace := l_response.exception.trace.twin
				l_trace.replace_substring_all ("%N", "%N-- > ")
				l_trace.prepend ("-- > ")
				Result.append (l_trace)
				Result.append ("%N")
			end
		ensure
			result_attached: Result /= Void
		end

	fault_statistics: ARRAY [TUPLE [found_times: INTEGER; first_found_time: INTEGER; first_found_test_case_index: INTEGER; summary: STRING]] is
			-- Array of found faults
			-- Index of the array is 1-based fault ID (the scope is within one testing session)
			-- `found_times' is the number of times that a fault is found in the analysis time range.
			-- `first_found_time' is the time in second related to `analysis_start_time' when the fault is found for the first time.
			-- `first_found_test_case_index' is the index of the test case where the fault is found for the first time.
			-- `summary' is the summary containing exception trace of that fault.
		local
			l_fault_count: INTEGER
			l_index: INTEGER
			l_frequency_table: ARRAY [INTEGER]
			l_first_found_table: ARRAY[TUPLE [first_found_time: INTEGER; first_found_test_case_index: INTEGER]]
		do
			l_fault_count := faults.count
			create Result.make (1, l_fault_count)
			l_frequency_table := fault_frequency_table
			l_first_found_table := fault_first_found_time_table
			from
				l_index := 1
			until
				l_index > l_fault_count
			loop
				Result.put (
					[l_frequency_table.item (l_index),  							-- Found times
					l_first_found_table.item (l_index).first_found_time, 			-- Fault first found time
					l_first_found_table.item (l_index).first_found_test_case_index, -- Fault first found test case index
					test_case_result_summary (faults.item (l_index))], 				-- Fault summary
					l_index)
				l_index := l_index + 1
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Operations

	load_file (a_log_file_path: STRING) is
			-- Load log file from `a_log_file_path'.
			-- Make result available from `last_result_repository',
			-- `faults'.
		require
			a_log_file_path_attached: a_log_file_path /= Void
			not_a_log_file_path_is_empty: not a_log_file_path.is_empty
		local
			l_log_stream: KL_TEXT_INPUT_FILE
		do
			create last_result_repository.make
				-- Pare log file.
			create l_log_stream.make (a_log_file_path)
			l_log_stream.open_read
			parse_stream (l_log_stream)
			l_log_stream.close

				-- Calculate unique faults.
			calculate_faults
		end

feature{NONE} -- Reporting

	report_comment_line (a_line: STRING) is
			-- Report that a comment line `a_line' is found.
			-- `a_line' contains the comment starter "--".
		do
			if a_line.substring_index (test_case_comment_header, 1) = 1 then
				report_test_case_comment (a_line)
			elseif a_line.substring_index (interpreter_start_comment_header, 1) = 1 then
				report_interpreter_start_comment (a_line)
			end
		end

	report_test_case_comment (a_line: STRING) is
			-- Report that a comment line for test case.
		require
			a_line_attached: a_line /= Void
			a_line_valid: a_line.substring_index (test_case_comment_header, 1) = 1
		local
			l_start_index: INTEGER
			l_end_index: INTEGER
		do
			l_start_index :=test_case_count_header.count + 1
			l_end_index := a_line.index_of (',', l_start_index + 1)
			last_test_case_index := a_line.substring (l_start_index, l_end_index - 1).to_integer
			last_test_case_start_time := a_line.substring (l_end_index + 1, a_line.count).to_integer
		end

	report_interpreter_start_comment (a_line: STRING) is
			-- Report that a comment line for interpreter start.
		require
			a_line_attached: a_line /= Void
			a_line_valid: a_line.substring_index (interpreter_start_comment_header, 1) = 1
		local
			l_starter: STRING
			l_start_index, l_end_index: INTEGER
		do
				-- We only record the start time of the first interpreter run.
			if test_session_start_time = 0 then
				l_starter := "-- Interpreter started after: "
				l_start_index := a_line.index_of (',', l_starter.count + 1)
				l_end_index := a_line.index_of (',', l_start_index + 1)
				test_session_start_time := a_line.substring (l_start_index + 1, l_end_index - 1).to_integer
			end
		end

	report_last_request is
			-- Report `last_request' in `request_parser'.
		do
			last_reported_request := request_parser.last_request
			reported_request_count := reported_request_count + 1
			request_parser.last_request.process (Current)
		end

	last_reported_request: AUT_REQUEST
			-- Last reported request

	has_failure_repsone (a_request: AUT_REQUEST): BOOLEAN is
			-- Does `a_request' has a failure response?
		local
			invoke_request: AUT_INVOKE_FEATURE_REQUEST
			create_request: AUT_CREATE_OBJECT_REQUEST
			normal_response: AUT_NORMAL_RESPONSE
		do
			invoke_request ?= a_request
			create_request ?= a_request
			if invoke_request /= Void or else create_request /= Void then
				normal_response ?= a_request.response
				Result := normal_response /= Void and then normal_response.exception /= Void
			end
		end

	update_result_reposotory is
			-- Update result repository based on last request in result-history.			
		require else
			True
		local
			witness: AUT_WITNESS
			l_test_case_start_time: INTEGER
			l_unique_witnesses: like unique_failure_witnesses
			l_old_failure: BOOLEAN
			l_index: INTEGER
			l_fault_first_found_table: like fault_first_found_time_table
			l_fault_frequency_table: like fault_frequency_table
			l_last_reported_request: like last_reported_request
		do
			check last_reported_request /= Void end
			l_last_reported_request := last_reported_request
			if has_failure_repsone (l_last_reported_request) then
				request_list.force_i_th (l_last_reported_request, reported_request_count)

				create witness.make (request_list, last_start_index, reported_request_count)

					-- Check if current test case is within the required time range.
				l_test_case_start_time := witness.item (witness.count).test_case_start_time
				if  l_test_case_start_time >= analysis_start_time then
					if analyzsis_end_time >=0 and then l_test_case_start_time > analyzsis_end_time then
						is_parse_ended := True
					end

					if not is_parse_ended then

							-- We only add failed test cases.
						if witness.is_fail then
							l_unique_witnesses := unique_failure_witnesses
							from
								l_unique_witnesses.start
							until
								l_unique_witnesses.after or l_old_failure
							loop
								l_old_failure := is_witness_the_same (l_unique_witnesses.item, witness)
								if l_old_failure then
									l_index := l_unique_witnesses.index
								end
								l_unique_witnesses.forth
							end

								-- We found a new failure.
							if not l_old_failure then
								last_result_repository.add_witness (witness)
								unique_failure_witnesses.extend (witness)
								l_index := unique_failure_witnesses.count

								l_fault_first_found_table := fault_first_found_time_table
								l_fault_first_found_table.force ([l_last_reported_request.test_case_start_time, l_last_reported_request.test_case_index], l_index)
							end

							l_fault_frequency_table := fault_frequency_table
							if l_fault_frequency_table.valid_index (l_index) then
								l_fault_frequency_table.force (l_fault_frequency_table.item (l_index) + 1, l_index)
							else
								l_fault_frequency_table.force (1, l_index)
							end
							io.put_string ((witness.item (witness.count).test_case_start_time // 60).out + ", ")
						end
					end
				end
			end
		end

	is_witness_the_same (a_witness, b_witness: AUT_WITNESS): BOOLEAN is
			-- Do `a_witness' the same as `b_witness' reveal the same bug?
		require
			a_witness_attached: a_witness /= Void
			b_witness_attached: b_witness /= Void
		do
			Result := a_witness.is_same_original_bug (b_witness)
		end

	unique_failure_witnesses: LINKED_LIST [AUT_WITNESS]
			-- List of found unique failure witnesses

feature -- Parsing

	parse_stream (an_input_stream: KI_TEXT_INPUT_STREAM) is
			-- Parse log from `an_input_stream'.
			-- Save parsed requests along with their responses in `request_history'.
		local
			line: STRING
		do
			found_request_count := 0
			reported_request_count := 0
			request_parser.set_filename (an_input_stream.name)
			from
				has_error := False
				create last_response_text.make (default_response_length)
				variable_table.wipe_out
				line_number := 1
				is_parse_ended := False
			until
				an_input_stream.end_of_input or has_error or is_parse_ended
			loop
				an_input_stream.read_line
					-- We ignore empty lines.
				if not an_input_stream.last_string.is_empty then
					line := an_input_stream.last_string.twin

					if line.count >= 2 and then line.substring (1, 2).same_string ("--") then
							-- We are in the comment line. If this line matches the start request,
							-- the start request will be handled, otherwise, the line is ignored.
						if line.same_string (proxy_has_started_and_connected_message) then
							-- We are in the "start" request.
							report_request_line (line)
						else
							report_comment_line (line)
						end
					else
						if line.count >= interpreter_log_prefix.count and then line.substring (1, interpreter_log_prefix.count).same_string (interpreter_log_prefix) then
								-- We are inside a response comment-block
							report_response_line (line)
						else
								-- Report that some request other than "start" request is found in current line.
							report_request_line (line)
						end
					end
				end
				line_number := line_number + 1
			end
			if found_request_count = reported_request_count + 1 then
				report_last_request
			end
		end

feature{NONE} -- Fault calculation

	calculate_faults is
			-- Analyze `last_repository' to find distinguish faults and
			-- store result in `faults', and assign an unique index for each faults,
			-- store those indexes in `fault_index_table'.
		local
			l_index: INTEGER
		do
			create faults.make (100)
			if last_result_repository.results.unique_failure_list /= Void then
				last_result_repository.results.unique_failure_list.do_all (agent faults.force_last)
			end
			check faults.count = unique_failure_witnesses.count end
			fault_frequency_table.conservative_resize (1, faults.count)
			fault_first_found_time_table.conservative_resize (1, faults.count)
		end

feature{NONE}  -- Implementation

	witness_end_time (a_witness: AUT_WITNESS): INTEGER is
			-- Time in second relative to the starting time of current testing session
			-- of `a_witness'
		require
			a_witness_attached: a_witness /= Void
			a_witness_has_request: not a_witness.request_list.is_empty
		do
			Result := a_witness.request_list.item (a_witness.count).test_case_start_time
		end

	last_test_case_index: INTEGER
			-- Last found test case index

	last_test_case_start_time: INTEGER
			-- Start time of last found test case
			-- The value is the number of seconds since based date.

	interpreter_start_comment_header: STRING is "-- Interpreter started after: "

	test_case_comment_header: STRING is "-- Test case No."

	update_request_with_test_case_info (a_request: AUT_REQUEST) is
			-- Update `a_request' with test case information including:
			-- `last_test_case_index',
			-- `last_test_case_start_time'.
		local
			l_create_request: AUT_CREATE_OBJECT_REQUEST
			l_invoke_request: AUT_INVOKE_FEATURE_REQUEST
		do
			l_invoke_request ?= a_request
			if l_invoke_request = Void then
				l_create_request ?= a_request
			end
			if l_create_request /= Void or else l_invoke_request /= Void then
				a_request.set_test_case_index (last_test_case_index)
				a_request.set_test_case_start_time (last_test_case_start_time - test_session_start_time)
			end
		end

	is_parse_ended: BOOLEAN
			-- Should log parsing end because the time of the test case is out of the time zone
			-- specified by `analysis_start_time' and `analysis_end_time'?

	request_list: SAT_PARTIAL_LIST [AUT_REQUEST]
			-- List to store requests with a failure response

	dummy_request: AUT_DUMMY_REQUEST
			-- Dummy request

invariant
	request_list_attached: request_list /= Void

indexing
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			 Eiffel Software
			 5949 Hollister Ave., Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
end
