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

	manager_update_code,
			-- The manager has somehow changed his status
	test_class_update_code,
			-- Some test class has been recompiled
			-- (the class is available through
			-- {CDD_MANAGER}.last_updated_test_class)
	executor_step_code,
			-- The executor is compiling the interpreter
			-- or executing the next test routine
	executor_filter_change,
			-- The executor received a new filter for testing
	debugger_step_code,
			-- The test debugger changed its state
	capturer_extracted_code,
			-- The capturer has extracted a
			-- number of new test classes
	printer_step_code,
			-- The printer has extracted a new class,
	capturer_error_code,
			-- There was an error with capturing a new test case
	execution_error_code: INTEGER is unique
			-- There was an error with compiling the interpreter
			-- or execing a test routine

	is_valid_code (a_code: like code): BOOLEAN is
			-- Is `a_code' a valid code?
		do
			Result :=
				a_code = manager_update_code or
				a_code = test_class_update_code or
				a_code = executor_step_code or
				a_code = executor_filter_change or
				a_code = debugger_step_code or
				a_code = capturer_extracted_code or
				a_code = capturer_error_code or
				a_code = execution_error_code or
				a_code = printer_step_code
		end

invariant

	code_valid: is_valid_code (code)

end
