indexing
	description:

		"Abstract ancestor to all interpreter requests"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision: 75356 $"

deferred class AUT_REQUEST

inherit
	AUT_SHARED_CONSTANTS

feature {NONE} -- Initialization

	make (a_system: like system) is
			-- Create new request.
		require
			a_system_not_void: a_system /= Void
		do
			system := a_system
		ensure
			system_set: system = a_system
		end

feature -- Status report

	has_response: BOOLEAN is
			-- Does this request have a corresponding response
			-- from the interpreter?
		do
			Result := response /= Void
		ensure
			definition: Result = (response /= Void)
		end

	is_type_request: BOOLEAN is
			-- Is Current a type request?
		do
		end

feature -- Access

	response: AUT_RESPONSE
			-- Interpreter's response to current request;
			-- Void if request is without response.

	system: SYSTEM_I
			-- system

feature -- Change

	set_response (a_response: like response) is
			-- Set `response' to `a_response'.
		require
			a_response_not_void: a_response /= Void
		do
			response := a_response
		ensure
			response_set: response = a_response
		end

	remove_response is
			-- Set `response' to Void.
		do
			response := Void
		ensure
			response_set: response = Void
		end

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR) is
			-- Process current request.
		require
			a_processor_not_void: a_processor /= Void
		deferred
		end

feature -- Duplication

	fresh_twin: like Current is
			-- New request equal to `Current', but no response.
			-- Ready to be used for testing again.
		do
			Result := twin
			Result.remove_response
		ensure
			fresh_twin_not_void: Result /= Void
		end

feature -- SATS project

	test_case_index: INTEGER
			-- Index of test case
			-- Used to synchroinze generated test case
			-- and recorded instrumentation log

	test_case_start_time: INTEGER
			-- Start time in second from starting point of current testing session 

	execution_flag: NATURAL_16
			-- Flag to indicate details for test case execution
			-- the 15th bit (lowest bit): When 1, SAT instrumentation recording is enabled

	is_real_test_case: BOOLEAN is
			-- Is Current request a real test case?
		do
			Result := (execution_flag & sat_real_test_case_request_flag) > 0
		ensure
			good_result: Result = ((execution_flag & sat_real_test_case_request_flag) > 0)
		end

	set_test_case_index (a_index: INTEGER) is
			-- Set `test_case_index' with `a_index'.
		require
			a_index_positive: a_index > 0
		do
			test_case_index := a_index
		ensure
			test_case_index_set: test_case_index = a_index
		end

	set_execution_flag (a_flag: like execution_flag) is
			-- Set `execution_flag' with `a_flag'.
		do
			execution_flag := a_flag
		ensure
			execution_flag_set: execution_flag = a_flag
		end

	set_test_case_start_time (a_start_time: INTEGER) is
			-- Set `test_case_start_time' with `a_start_time'.
		require
			a_start_time_positive: a_start_time > 0
		do
			test_case_start_time := a_start_time
		ensure
			test_case_start_time_set: test_case_start_time = a_start_time
		end

invariant

	system_not_void: system /= Void

end
