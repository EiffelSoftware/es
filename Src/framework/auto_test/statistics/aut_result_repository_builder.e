note
	description:

		"Builds result repositories from log files"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class AUT_RESULT_REPOSITORY_BUILDER

inherit
	AUT_PROXY_EVENT_RECORDER
		redefine
			make,
			process_start_request,
			process_create_object_request,
			process_invoke_feature_request,
			report_comment_line,
			report_request
		end

	AUT_SHARED_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_system: like system)
			-- <Precursor>
		do
			Precursor {AUT_PROXY_EVENT_RECORDER} (a_system)
			create result_repository.make
		end

feature -- Access

	result_repository: AUT_TEST_CASE_RESULT_REPOSITORY
			-- Last result repository built by `build'

	comment_processors: LINKED_LIST [PROCEDURE [ANY, TUPLE [STRING]]] is
			-- list of processors for comment lines
		do
			if comment_processors_internal = Void then
				create comment_processors_internal.make
				comment_processors_internal.extend (agent test_case_time_comment_processor)
				comment_processors_internal.extend (agent test_case_index_comment_processor)
				comment_processors_internal.extend (agent test_case_operand_type_comment_processor)
			end
			Result := comment_processors_internal
		end

feature -- Report

	report_request (a_producer: AUT_PROXY_EVENT_PRODUCER; a_request: AUT_REQUEST)
			-- <Precursor>
		do
			Precursor (a_producer, a_request)
			a_request.set_test_case_index (last_test_case_index)
			a_request.set_start_time (last_test_case_start_time)
		end

feature{NONE} -- Processing

	process_start_request (a_request: AUT_START_REQUEST)
		do
			check
				a_request_in_history: request_history.has (a_request)
			end
			Precursor (a_request)
			last_start_index := request_history.count + 1
		end

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
		do
--			if last_test_case_request /= Void then
--				last_test_case_request.set_end_time (last_test_case_end_time)
--			end
--			a_request.set_start_time (last_test_case_start_time)
			a_request.set_end_time (last_test_case_end_time)
			Precursor (a_request)
			update_result_repository
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
		do
--			if last_test_case_request /= Void then
--				last_test_case_request.set_end_time (last_test_case_end_time)
--			end
--			a_request.set_start_time (last_test_case_start_time)
			a_request.set_end_time (last_test_case_end_time)
			Precursor (a_request)
			update_result_repository
		end

	report_comment_line (a_producer: AUT_PROXY_EVENT_PRODUCER; a_line: STRING) is
			-- Report comment line `a_line'.
		local
			l_processors: like comment_processors
		do
			from
				l_processors := comment_processors
				l_processors.start
			until
				l_processors.after
			loop
				l_processors.item.call ([a_line])
				l_processors.forth
			end
		end

feature {NONE} -- Implementation

	last_start_index: INTEGER
			-- Index of the last "start" request in `request_history'

	update_result_repository
			-- Update result repository based on last request in result-history.			
		require
			last_start_index_large_enough: last_start_index > 0 -- To be removed when added back to invariant
			last_start_index_small_enough: last_start_index <= request_history.count -- To be removed when added back to invariant
			request_history_not_empty: request_history.count > 0
			last_request_has_response: request_history.item (request_history.count).response /= Void
		local
			witness: AUT_WITNESS
		do
			create witness.make (request_history, last_start_index, request_history.count)
			result_repository.add_witness (witness)
--			last_test_case_request := witness.item (witness.count)
--			last_test_case_request.set_test_case_index (last_test_case_index)
		end

feature -- Time measurement

	last_test_case_start_time: INTEGER
			-- Time in millisecond when the last test case started

	last_test_case_end_time: INTEGER
			-- Time in millisecond when the last test case ended

	test_case_time_comment_processor (a_line: STRING) is
			-- Process `a_line' if it is a time stamp for test cases start/end.
		local
			l_line: STRING
		do
			if a_line.substring (1, time_stamp_header.count).is_equal (time_stamp_header) then
				l_line := a_line.substring (time_stamp_header.count + 1, a_line.count)
				analyze_time_stamp (l_line)
			end
		end

	analyze_time_stamp (a_line: STRING) is
			-- Analyze time stamp in `a_line'.
		local
			l_parts: LIST [STRING]
			l_time: INTEGER
		do
			l_parts := a_line.split (';')
			check l_parts.count = 3 end
			l_time := l_parts.last.to_integer

			if l_parts.first.is_equal (test_case_start_tag) then
				last_test_case_start_time := l_time
			elseif l_parts.first.is_equal (test_case_end_tag) then
				last_test_case_end_time := l_time
			end
		end

	test_case_index_comment_processor (a_line: STRING) is
			-- Process `a_line' if it is a test case index comment.
		local
			l_line: STRING
		do
			if a_line.substring (1, test_case_index_header.count).is_equal (test_case_index_header) then
				l_line := a_line.substring (test_case_index_header.count + 1, a_line.count)
				last_test_case_index := l_line.to_integer
			end
		end

	test_case_operand_type_comment_processor (a_line: STRING)
			-- Process `a_line' as specification for test case operands with types.
		local
			l_line: STRING
			l_header_count: INTEGER
			l_vars: LIST [STRING]
			l_variable: ITP_VARIABLE
			l_index: INTEGER
			l_var_def: STRING
			l_var_name: STRING
			l_type_name: STRING
			l_existing_var_type: TYPE_A
			l_type: TYPE_A
		do
			l_header_count := interpreter_type_message_prefix.count
			if a_line.substring (1, l_header_count) ~ interpreter_type_message_prefix then
				variable_table.wipe_out
				l_index := a_line.index_of (':', 1)
				l_vars := a_line.substring (l_index + 2, a_line.count).split (';')
				from
					l_vars.start
				until
					l_vars.after
				loop
					l_var_def := l_vars.item_for_iteration
					l_var_def.left_adjust
					l_var_def.right_adjust
					if not l_var_def.is_empty then
						l_var_def.left_adjust
						l_var_def.right_adjust
						l_index := l_var_def.index_of (':', 1)
						l_var_name := l_var_def.substring (3, l_index - 1)
						l_type_name := l_var_def.substring (l_index + 1, l_var_def.count)
						l_var_name.left_adjust
						l_var_name.right_adjust
						l_type_name.left_adjust
						l_type_name.right_adjust
						create l_variable.make (l_var_name.to_integer)
						l_type := base_type (l_type_name)
						variable_table.define_variable (l_variable, l_type)
					end

					l_vars.forth
				end
			end
		end

	exception_thrown_comment_processor (a_line: STRING) is
			-- Process `a_line' if it is an exception thrown line.
		do
				-- Ilinca, "number of faults law" experiment
			if a_line.has_substring ({AUT_SHARED_CONSTANTS}.exception_thrown_message) then
--				last_response_text.append_string (a_line)
			end
		end

--	last_test_case_request: detachable AUT_REQUEST
--			-- Request of the last met test case

	last_test_case_index: INTEGER
			-- Last met test case index

	comment_processors_internal: like comment_processors
			-- Implementation of `comment_processors'

;note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
