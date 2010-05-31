note
	description:

		"Abstract ancestor to all interpreter requests"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class AUT_REQUEST

inherit
	AUT_PROXY_EVENT

feature {NONE} -- Initialization

	make (a_system: like system)
			-- Create new request.
		require
			a_system_not_void: a_system /= Void
		do
			system := a_system
		ensure
			system_set: system = a_system
		end

feature -- Status report

	has_response: BOOLEAN
			-- Does this request have a corresponding response
			-- from the interpreter?
		do
			Result := response /= Void
		ensure
			definition: Result = (response /= Void)
		end

	is_type_request: BOOLEAN
			-- Is Current a type request?
		do
		end

feature -- Access

	response: AUT_RESPONSE assign set_response
			-- Interpreter's response to current request;
			-- Void if request is without response.

	system: SYSTEM_I
			-- system

	test_case_index: INTEGER
			-- 1-based number indicating that current request is
			-- the `test_case_index'-th test case in associated test run
			-- A 0 value means that current request is not a test case request.
			-- only creation request and execute request are test case request.

	duration: INTEGER is
			-- Duration in milliseconds of executing current request
		do
			Result := end_time - start_time
		ensure
			good_result: Result = end_time - start_time
		end

	time: DT_DATE_TIME_DURATION
			-- Duration of current request

	set_time (a_time: like time) is
			-- Set `time' with `a_time'.
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

	start_time: INTEGER
			-- Start time in millisecond relative to current AutoTest run

	end_time: INTEGER is
			-- End time in millisecond relative to current AutoTest run
		do
				-- Sometimes, the end time is not correctly set, because
				-- if AutoTest ends immediately after a feature call.
				-- In that case, we use 0 as the duration.
			if start_time > end_time_internal then
				Result := start_time
			else
				Result := end_time_internal
			end
		end

feature -- Change

	set_response (a_response: like response)
			-- Set `response' to `a_response'.
		require
			a_response_not_void: a_response /= Void
		do
			response := a_response
		ensure
			response_set: response = a_response
		end

	remove_response
			-- Set `response' to Void.
		do
			response := Void
		ensure
			response_set: response = Void
		end

	set_test_case_index (a_index: like test_case_index) is
			-- Set `test_case_index' with `a_index'.
		require
			a_index_non_negative: a_index >= 0
		do
			test_case_index := a_index
		ensure
			test_case_index_set: test_case_index = a_index
		end

	set_start_time (a_start_time: like start_time) is
			-- Set `start_time' with `a_start_time'.
		do
			start_time := a_start_time
		ensure
			start_time_set: start_time = a_start_time
		end

	set_end_time (a_end_time: like end_time) is
			-- Set `end_time' with `a_end_time'.
		do
			end_time_internal := a_end_time
		ensure
			end_time_internal_set: end_time_internal = a_end_time
		end

feature {AUT_PROXY_EVENT_PRODUCER} -- Basic operations

	publish (a_producer: AUT_PROXY_EVENT_PRODUCER; a_observer: AUT_PROXY_EVENT_OBSERVER)
			-- <Precursor>
		do
			a_observer.report_request (a_producer, Current)
		end

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		require
			a_processor_not_void: a_processor /= Void
		deferred
		end

feature -- Duplication

	fresh_twin: like Current
			-- New request equal to `Current', but no response.
			-- Ready to be used for testing again.
		do
			Result := twin
			Result.remove_response
		ensure
			fresh_twin_not_void: Result /= Void
		end

feature{NONE} -- Implementation

	end_time_internal: INTEGER
			-- Implementation for `end_time'

invariant

	system_not_void: system /= Void

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
