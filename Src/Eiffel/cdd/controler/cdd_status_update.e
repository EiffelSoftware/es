indexing
	description: "Objects that represent a notification for status CDD status changes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_STATUS_UPDATE

create
	make_with_code

feature {NONE} -- Initialization

	make_with_code (a_code: like code) is
			-- Initialize `Current' with `a_code'.
		require
			valid_code: is_valid_code (a_code)
		do
			code := a_code
		ensure
			code_set: code = a_code
		end

feature -- Access

	code: INTEGER
			-- Status code

	enable_extracting_code,
			-- Extracting new test cases has been enabled
	disable_extracting_code,
			-- Extracting new test cases has been disabled
	executor_step_code,
			-- The executor is compiling the interpreter
			-- or executing the next test routine
	debugger_step_code,
			-- The test debugger changed its state
	capture_error_code,
			-- There was an error with capturing a new test case
	execution_error_code: INTEGER is unique
			-- There was an error with compiling the interpreter
			-- or execing a test routine

	is_valid_code (a_code: like code): BOOLEAN is
			-- Is `a_code' a valid code?
		do
			Result :=
				a_code = enable_extracting_code or
				a_code = disable_extracting_code or
				a_code = executor_step_code or
				a_code = debugger_step_code or
				a_code = capture_error_code or
				a_code = execution_error_code
		end

invariant

	code_valid: is_valid_code (code)

end
