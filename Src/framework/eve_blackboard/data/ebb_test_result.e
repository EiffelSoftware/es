note
	description: "Result of a test."
	date: "$Date$"
	revision: "$Revision$"

expanded class
	EBB_TEST_RESULT

inherit

	ANY
		redefine default_create end

create
	default_create,
	set_successful_test,
	set_failed_test,
	set_not_tested

feature {NONE} -- Initialization

	default_create
			-- Initialize test result as `is_not_tested'.
		do
			set_not_tested
		ensure then
			is_not_tested: is_not_tested
		end

feature -- Status report

	is_successful_test: BOOLEAN
			-- Is this test successful?

	is_failed_test: BOOLEAN
			-- Is this test failed?

	is_not_tested: BOOLEAN
			-- Is this condition not tested?

	is_update: BOOLEAN
			-- Is this value an update compared to last result in history?

feature -- Status setting

	set_successful_test
				-- Set `is_successful_test' to true.
			do
				set_all_to_false
				is_successful_test := True
			ensure
				is_successful_test: is_successful_test
			end

	set_failed_test
				-- Set `is_failed_test' to true.
			do
				set_all_to_false
				is_failed_test := True
			ensure
				is_failed_test: is_failed_test
			end

	set_not_tested
			-- Set `is_not_tested' to true.
		do
			set_all_to_false
			is_not_tested := True
		ensure
			is_not_tested: is_not_tested
		end

	set_update
			-- Set `is_update' to true.
		do
			is_update := True
		ensure
			is_update: is_update
		end

	merge (a_other: EBB_TEST_RESULT)
			-- Merge with `a_other'.
			-- This copies the values of `a_other' if `a_other.is_update' is true.
		do
			if a_other.is_update then
				is_successful_test := a_other.is_successful_test
				is_failed_test := a_other.is_failed_test
				is_not_tested := a_other.is_not_tested
				is_update := a_other.is_update
			end
		end

feature {NONE} -- Implementation

	set_all_to_false
			-- Set all properties to False.
		do
			is_successful_test := False
			is_failed_test := False
			is_not_tested := False
		ensure
			effect: not is_successful_test and not is_failed_test and not is_not_tested
		end

invariant
	one_state_is_true: is_successful_test or is_failed_test or is_not_tested
	only_one_state_is_true1: is_successful_test implies not is_failed_test and not is_not_tested
	only_one_state_is_true2: is_failed_test implies not is_successful_test and not is_not_tested
	only_one_state_is_true3: is_not_tested implies not is_successful_test and not is_failed_test

end
