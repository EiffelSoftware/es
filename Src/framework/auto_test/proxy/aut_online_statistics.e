note
	description: "Class to collect online test data"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_ONLINE_STATISTICS

inherit
	SHARED_WORKBENCH

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			create passing_statistics.make (100)
			passing_statistics.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
			create failing_statistics.make (100)
			failing_statistics.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
			create faults.make (64)
			faults.set_key_equality_tester (create {AUT_EXCEPTION_EQUALITY_TESTER})
			create faults_with_detected_time.make (64)
			faults_with_detected_time.set_key_equality_tester (create {AUT_EXCEPTION_EQUALITY_TESTER})
		end

feature -- Access

	passing_statistics: DS_HASH_TABLE [INTEGER, AUT_FEATURE_OF_TYPE]
			-- Statistic for passing test cases
			-- Key is the feature under test, value is the number
			-- of passing test cases of that feature

	failing_statistics: DS_HASH_TABLE [INTEGER, AUT_FEATURE_OF_TYPE]
			-- Statistic for failing test cases
			-- Key is the feature under test, value is the number
			-- of failing test cases of that feature

	faults: DS_HASH_TABLE [detachable STRING, AUT_EXCEPTION]
			-- Set of found faults
			-- Keys are faults that are found, values are
			-- meta data (if any) associated with that fault.

	faults_with_detected_time: DS_HASH_TABLE [INTEGER, AUT_EXCEPTION]
			-- Set of detected faults and the number of times that they are detected
			-- Keys are the detected faults, and values are the number of times that
			-- they are detected.

	last_fault_meta: detachable STRING
			-- Meta data which will be associated with each found fault			

	log_file_path: STRING
			-- Full path to the log file

	output_frequency: INTEGER
			-- The number of seconds for the statistics to be outputed once
			-- If 0, no statistics is outputed.

feature -- Setting

	set_last_fault_meta (a_meta: like last_fault_meta)
			-- Set `last_fault_meta' with `a_meta'.
		do
			if a_meta = Void then
				last_fault_meta := Void
			else
				last_fault_meta := a_meta.twin
			end
		end

	set_log_file_path (a_path: STRING)
			-- Set `log_file_path' with `a_path'.
		do
			log_file_path := a_path.twin
		ensure
			log_file_path_set: log_file_path ~ a_path
		end

	set_output_frequency (i: INTEGER)
			-- Set `output_frequency' with `i'.
		do
			output_frequency := i
		ensure
			output_frequency_set: output_frequency = i
		end

feature -- Basic operations

	report_session_restart (a_time_until_now: INTEGER)
			-- Report that a new testing proxy session has started.
			-- `a_time_until_now' is the number of milliseconds since the start of current testing session.
		do
			last_minute_statistics.set_session_restart_count (last_minute_statistics.session_restart_count + 1)
		end

	report_test_case (a_request: AUT_REQUEST; a_time_until_now: INTEGER; a_object_count: INTEGER)
			-- Add test case `a_request' into Current.
			-- `a_time_until_now' is the number of milliseconds since the start of current testing session.
			-- `a_object_count' is the number of objects in object pool.
		local
			l_feature: AUT_FEATURE_OF_TYPE
			l_exception: AUT_EXCEPTION
			l_type: TYPE_A
			l_feat: FEATURE_I
			l_class: CLASS_C
		do
			if attached {AUT_CALL_BASED_REQUEST} a_request as l_request then
				create l_feature.make (l_request.feature_to_call, l_request.target_type)
				if l_request.response.is_normal then
					if l_request.response.is_exception then
						if
							attached {AUT_NORMAL_RESPONSE} l_request.response as l_normal_response and then
							l_normal_response.exception /= Void
						then
							if l_normal_response.exception.is_test_invalid then
								last_minute_statistics.set_invalid_test_case_count (last_minute_statistics.invalid_test_case_count + 1)
							else
								l_exception := l_normal_response.exception
								if not l_exception.is_invariant_violation_on_feature_entry then
									l_class := workbench.universe.classes_with_name (l_exception.class_name).first.compiled_representation
									l_feat := l_class.feature_named_32 (l_exception.recipient_name)
									if l_feat /= Void then
										if faults.has (l_exception) then
												-- We already detected this fault before.
											faults_with_detected_time.force_last (faults_with_detected_time.item (l_exception) + 1, l_exception)
										else
												-- We detected a new fault.
											faults.force_last (last_fault_meta, l_exception)
											last_minute_statistics.set_fault_count (last_minute_statistics.fault_count + 1)
											faults_with_detected_time.force_last (1, l_exception)
										end
										create l_feature.make (l_feat, l_class.constraint_actual_type)
										failing_statistics.search (l_feature)
										if failing_statistics.found then
											failing_statistics.replace (failing_statistics.found_item + 1, l_feature)
										else
											failing_statistics.force_last (1, l_feature)
										end
									end
									last_minute_statistics.set_failing_test_case_count (last_minute_statistics.failing_test_case_count + 1)
								else
									last_minute_statistics.set_invalid_test_case_count (last_minute_statistics.invalid_test_case_count + 1)
								end
							end
						end
					else
						passing_statistics.search (l_feature)
						if passing_statistics.found then
							passing_statistics.replace (passing_statistics.found_item + 1, l_feature)
						else
							passing_statistics.force_last (1, l_feature)
						end
						last_minute_statistics.set_passing_test_case_count (last_minute_statistics.passing_test_case_count + 1)
					end
				end
			end
			last_minute_statistics.set_object_count (a_object_count)

				-- Store statistics on file every minute.
			if output_frequency > 0 then
				if a_time_until_now - last_time_stamp > 1000 * output_frequency then
					save_last_minute_statistics
					set_last_time_stamp (a_time_until_now)
				end
			end
		end

	finish
			-- Finish testing session, close opened file.
		do
			if log_file /= Void and then log_file.is_open_write then
				log_file.close
			end
		end

feature{NONE} -- Implementation

	log_file: PLAIN_TEXT_FILE
			-- File to store loges

	last_time_stamp: INTEGER
			-- Last recorded time (in milliseconds)

	set_last_time_stamp (a_stamp: INTEGER)
			-- Set `last_time_stamp' with `a_stamp'.
		do
			last_time_stamp := a_stamp
		ensure
			last_time_stamp_set: last_time_stamp = a_stamp
		end

	last_minute_statistics: AUT_ONLINE_STATISTICS_DATA
			-- Statistics of the last minute
		do
			if last_minute_statistics_internal = Void then
				create last_minute_statistics_internal.make (0, 0, 0, 0, 0, 0)
			end
			Result := last_minute_statistics_internal
		end

	last_minute_statistics_internal: like last_minute_statistics
			-- Cache for `last_minute_statistics'

	save_last_minute_statistics
			-- Save `last_minute_statistics' into log file.
		local
			l_message: STRING
		do
			if log_file = Void and then log_file_path /= Void then
				create log_file.make_create_read_write (log_file_path)
				log_file.put_string ("Second%TPassing test cases%TFailing test cases%TInvalid test cases%TObjects%TFaults%TProxy sessions%TFault details%N")
			end
			if log_file /= Void then
				create l_message.make (1024)
				l_message.append_integer (last_time_stamp // 1000 + 1)
				l_message.append_character ('%T')
				l_message.append (last_minute_statistics.out)

				l_message.append_character ('%T')
				l_message.append (fault_details)
				l_message.append_character ('%N')
				log_file.put_string (l_message)
				log_file.flush
			end
		end

	fault_details: STRING
			-- String containing details of detected faults.			
		local
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, AUT_EXCEPTION]
		do
			create Result.make (faults_with_detected_time.count * 64)
			from
				l_cursor := faults_with_detected_time.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if not Result.is_empty then
					Result.append_character (',')
				end
				Result.append (l_cursor.key.signature)
				Result.append_character ('(')
				Result.append_integer (l_cursor.item)
				Result.append_character (')')
				l_cursor.forth
			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
