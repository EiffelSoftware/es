indexing
	description: "Represents the outcome and log of a test case execution"
	author: "aleitner"
	date: "$Date$"
	revision: "$Revision$"

class CDD_TEST_EXECUTION_RESPONSE

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make (a_setup_response: CDD_ROUTINE_INVOCATION_RESPONSE;
			a_test_response: CDD_ROUTINE_INVOCATION_RESPONSE;
			a_teardown_response: CDD_ROUTINE_INVOCATION_RESPONSE) is
					-- Create a new response.
		require
			a_test_response_good: (a_setup_response /= Void and then a_setup_response.is_normal) = (a_test_response /= Void)
			a_teardonwn_response_good: (a_test_response /= Void and then not a_test_response.is_bad) = (a_teardown_response /= Void)
		do
			setup_response := a_setup_response
			test_response := a_test_response
			teardown_response := a_teardown_response
		ensure
			setup_response_set: setup_response = a_setup_response
			test_response_set: test_response = a_test_response
			teardown_response_set: teardown_response = a_teardown_response
		end

feature {ANY} -- Status

	is_pass: BOOLEAN is
			-- Did the implementation under test pass the test case?
		do
			Result := test_response /= Void and then test_response.is_normal
		end

	is_fail: BOOLEAN is
			-- Did the implementation under test fail the test case?
		do
			Result := test_response /= Void and then test_response.is_exceptional and not has_bad_context
		end

	is_unresolved: BOOLEAN is
			-- Is the test judgment unresolvable?
		do
			Result := not (is_fail or is_pass)
		end

	requires_maintenance: BOOLEAN is
			-- Does the test case need to be fixed?
		do
			Result := has_compile_error or has_bad_context or has_bad_communication
		end

	has_compile_error: BOOLEAN is
			-- Does the test case produce a compiler error?
		do
			Result := setup_response = Void
		end

	has_bad_context: BOOLEAN is
			-- Does the test case seem to have an invalid context?
			-- (e.g. are the preconditions of the feature under test not satisfied?)
		do
			if test_response /= Void and then test_response.is_exceptional then
				-- TODO: need test class/routine information...
			end
		end

	has_bad_communication: BOOLEAN is
			-- Was the communication between master and client outside of its specification?
		do
			Result := setup_response /= Void and then (setup_response.is_bad or
				(setup_response.is_normal and then (test_response.is_bad or else teardown_response.is_bad)))
		end

feature {ANY} -- Access

	setup_response: CDD_ROUTINE_INVOCATION_RESPONSE
			-- Response from test setup

	test_response: CDD_ROUTINE_INVOCATION_RESPONSE
			-- Response from actual test routine

	teardown_response: CDD_ROUTINE_INVOCATION_RESPONSE
			-- Response from test teardown

	text: STRING is
			-- Textual description of kind of outcome;
			-- I.e.: "pass", "fail", "unresolved"
		do
			if is_pass then
				Result := "pass"
			elseif is_fail then
				Result := "fail"
			elseif is_unresolved then
				Result := "unresolved"
			else
				check
					dead_end: False
				end
			end
		ensure
			text_not_void: Result /= Void
		end

feature -- Output

	out: STRING is
			-- String representation of `Current'.
		do
			create Result.make_empty
			Result.append ("Conclusion: ")
			if is_pass then
				Result.append ("PASS")
			elseif is_fail then
				Result.append ("FAIL")
			else
				Result.append ("UNRESOLVED")
			end
			if setup_response /= Void then
				Result.append ("%N%NSetup " + setup_response.out)
				if test_response /= Void then
					Result.append ("%NTest " + test_response.out)
					if teardown_response /= Void then
						Result.append ("%NTeardown " + teardown_response.out)
					end
				end
			end
			if requires_maintenance then
				Result.append ("%N%N")
				if has_bad_communication then
					Result.append ("bad communication")
				elseif has_bad_context then
					Result.append ("bad context")
				else
					Result.append ("compile error")
				end
			end
		end

feature {NONE} -- Assertion helpers

	one_of (a: BOOLEAN; b: BOOLEAN; c: BOOLEAN): BOOLEAN
		-- Is exactly one out of the three variables `a', `b', `c' true?
		do
			Result := (a xor b xor c) and not (a and b and c)
		ensure
			definition: (a xor b xor c) and not (a and b and c)
		end

invariant

	setup_normal_equals_test_not_void: (setup_response /= Void and then setup_response.is_normal) = (test_response /= Void)
	test_normal_equals_teardown_not_void: (test_response /= Void and then not test_response.is_bad) = (teardown_response /= Void)
	unresolved_implies_maintenance: is_unresolved implies requires_maintenance
	one_of_fail_pass_unresolved: one_of (is_pass, is_fail, is_unresolved)
	maintenance_implies_one_error: requires_maintenance implies (one_of (has_compile_error, has_bad_context, has_bad_communication))
	not_requires_maintenance_implies_no_error: not requires_maintenance implies not (has_compile_error or has_bad_context or has_bad_communication)

end
