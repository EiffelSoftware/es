note
	description: "Summary description for {AUT_DESERIALIZED_TEST_CASE_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TEST_CASE_DESERIALIZABILITY_CHECKER

inherit

	EQA_TEST_CASE_SERIALIZATION_UTILITY

create
	make

feature{NONE} -- Initialization

	make (a_config: TEST_GENERATOR)
			-- Initialization.
		require
			config_attached: a_config /= Void
		do
			log_file_full_path := a_config.serialization_validity_log
			create deserializability_table.make (128)
		end

feature -- Access

	last_result: BOOLEAN
			-- Result from last check.

	deserializability_table: DS_HASH_TABLE [BOOLEAN, INTEGER]
			-- Table mapping test case time stamps to their deserializability states.

feature -- Derived access

	log_file_full_path: FILE_NAME
			-- Full path to the log file.

feature -- Constant

	log_end_str: STRING = "<<END>>"
			-- End string of a log.

	fatal_state_str: STRING = "Fatal"
			-- State string for test cases whose deserialization will crash the program.

feature -- Basic operation

	start_checking
			-- Prepare for checking.
		local
			l_table: like deserializability_table
			l_file: KL_TEXT_INPUT_FILE
			l_line, l_uuid, l_state_str: STRING
			l_state, l_end: BOOLEAN
			l_fields: LIST [STRING]
		do
			load_existing_log
			close_pending_state
			open_log_file_for_appending
		end

	check_deserializability (a_tc: AUT_DESERIALIZED_TEST_CASE)
			-- Check deserializability of `a_tc'.
		require
			tc_not_void: a_tc /= Void
		local
			l_time: INTEGER
		do
			last_result := False

			l_time := a_tc.time
			if deserializability_table.has (l_time) then
				last_result := deserializability_table.item (l_time)
			else
					-- Log time stamp.
				log_time (l_time)
					-- The following check might cause program crash, leaving the log entry unfinished.
					-- When this happens, we know the test case is not deserializable.
				last_result := is_deserializable (a_tc)
					-- Deserialization succeeded.
					-- Update `deserializability_table' and log.
				deserializability_table.force (last_result, l_time)
				log_state (last_result)
			end
		end

	finish_checking
			-- Finish checking.
		do
			close_log
		end

feature{NONE} -- Access

	log_file: KL_TEXT_OUTPUT_FILE
			-- File where time stamp, UUID, and validation state of all test cases are logged.

	is_log_closed: BOOLEAN
			-- Is log closed, i.e. ending with `log_end_str'.

	has_pending_state: BOOLEAN
			-- Has `log_file' any pending validation state due to, for example, program crash caused by failed object deserialization.

feature{NONE} -- Deserializability check

	is_deserializable (a_tc: AUT_DESERIALIZED_TEST_CASE): BOOLEAN
			-- Is 'a_tc' deserializable into {SPECIAL[detachable ANY]}?
		local
			l_retried: BOOLEAN
		do
			Result := False
			if not l_retried then
--	            if attached {SPECIAL [detachable ANY]} deserialized_object_from_array (a_tc.pre_serialization) as lt_variable then
	            if attached deserialized_object_from_array (a_tc.pre_serialization) as lt_variable then
	            	if attached {SPECIAL [ANY]} lt_variable as lt1 then
	            		Result := True
	            	end
				end
			end
		rescue
			l_retried := True
			retry
		end

feature{NONE} -- Log file operation

	load_existing_log
			-- Load existing log, into `deserializability_table'.
		local
			l_file: KL_TEXT_INPUT_FILE
			l_table: like deserializability_table
			l_line: STRING
			l_record: TUPLE[time: INTEGER; is_complete: BOOLEAN; state: BOOLEAN]
		do
			has_pending_state := False
			create l_file.make (log_file_full_path)
			if l_file.exists then
				l_table := deserializability_table

				l_file.open_read
				if l_file.is_open_read then
					from
					until l_file.end_of_file or else is_log_closed
					loop
						l_file.read_line
						l_line := l_file.last_string

						if l_line ~ log_end_str then
							is_log_closed := True
						elseif not l_line.is_empty then
							l_record := deserializability_from (l_line)
							check unique_time_stamp: not l_table.has (l_record.time) end
							l_table.force (l_record.is_complete and then l_record.state, l_record.time)
							has_pending_state := not l_record.is_complete
						end
					end
					l_file.close
				end
			end
		end

	close_pending_state
			-- Close the pending state, if any, in the log file.
		local
			l_file: KL_TEXT_OUTPUT_FILE
		do
			if has_pending_state then
				create l_file.make (log_file_full_path)
				l_file.recursive_open_append
				if l_file.is_open_write then
					l_file.put_string (fatal_state_str)
					l_file.put_new_line
					l_file.flush
					l_file.close
				end
			end
		end

	open_log_file_for_appending
			-- Open the log file for appending.
		do
			create log_file.make (log_file_full_path)
			log_file.recursive_open_append
		ensure
			log_file_open_for_append: log_file /= Void and then log_file.is_open_write
		end

	close_log
			-- Close log file.
			-- Append `log_end_str' to `log_file', if necessary.
		require
			log_file_open_for_write: log_file /= Void and then log_file.is_open_write
		do
			if not is_log_closed then
				log_file.put_string (log_end_str)
				log_file.put_new_line
			end
			log_file.close
		end

feature{NONE} -- Log entry reading/writing

	log_time (a_time: INTEGER)
			-- Log the generation time of a test case, in the format "a_time:", to `log_file'.
		require
			log_open_for_write: log_file /= Void and then log_file.is_open_write
			valid_time: a_time > 0
		do
			log_file.put_string (a_time.out + ":")
			log_file.flush
		end

	log_state (a_state: BOOLEAN)
			-- Write `a_state' to `log_file'.
			-- This is to finish the log entry started by `log_time_and_uuid'.
		require
			log_open_for_write: log_file /= Void and then log_file.is_open_write
		do
			log_file.put_string (a_state.out)
			log_file.put_new_line
			log_file.flush
		end

	deserializability_from (a_line: STRING): TUPLE[time: INTEGER; is_complete: BOOLEAN; state: BOOLEAN]
			-- Deserializability from a log entry `a_line'.
		require
			line_not_empty: a_line /= Void and then not a_line.is_empty
		local
			l_fields: LIST [STRING]
			l_state: STRING
			l_time: INTEGER
		do
			l_fields := a_line.split (':')
			check l_fields.count = 2 and then l_fields.i_th (1).is_integer end
			l_time := l_fields.i_th (1).to_integer
			l_state := l_fields.i_th (2)
			if l_state.is_boolean then
				Result := [l_time, True, l_state.to_boolean]
			elseif l_state ~ fatal_state_str then
				Result := [l_time, True, False]
			else
				Result := [l_time, False, False]
			end
		end

invariant

	deserializability_table_attached: deserializability_table /= Void

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
