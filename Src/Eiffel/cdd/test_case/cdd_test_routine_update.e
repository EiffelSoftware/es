indexing
	description: "Objects that represent a change of some test routine"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_ROUTINE_UPDATE

create
	make

feature {NONE} -- Initialization

	make (a_test_routine: like test_routine; a_code: like code) is
			-- Initialize `Current' with `a_code'.
		require
			a_test_routine_not_void: a_test_routine /= Void
			valid_code: is_valid_code (a_code)
		do
			test_routine := a_test_routine
			code := a_code
		ensure
			test_routine_set: test_routine = a_test_routine
			code_set: code = a_code
		end

feature -- Access

	is_new_outcome: BOOLEAN is
			-- Does `Current' notify about a new outcome in `test_routine'?
		do
			Result := code = new_outcome_code
		ensure
			correct_result: Result = (code = new_outcome_code)
		end

	is_added: BOOLEAN is
			-- Does `Current' notify that `test_routine' has been added to the test suite?
		do
			Result := code = add_code
		ensure
			correct_result: Result = (code = add_code)
		end

	is_removed: BOOLEAN is
			-- Does `Current' notify that `test_routine' has been removed from the test suite?
		do
			Result := code = remove_code
		ensure
			correct_result: Result = (code = remove_code)
		end

	test_routine: CDD_TEST_ROUTINE
			-- Routine beeing updated

	code: INTEGER
			-- Status code

	add_code,
	remove_code,
	new_outcome_code: INTEGER is unique
			-- Available status codes

	is_valid_code (a_code: like code): BOOLEAN is
			-- Is `a_code' a valid code?
		do
			Result := a_code = add_code or
				a_code = remove_code or
				a_code = new_outcome_code
		end

invariant

	code_valid: is_valid_code (code)

end
