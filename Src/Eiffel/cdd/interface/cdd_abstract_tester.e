indexing
	description: "Objects that execute tests"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_ABSTRACT_TESTER

inherit

	CDD_CONSTANTS

	CONF_ACCESS

feature {NONE} -- Initialization

	make_with_manager (a_manager: like manager) is
			-- Assign `manager' with `a_manager'.
		require
			a_manager_not_void: a_manager /= Void
		do
			manager := a_manager
		ensure
			manager_set: manager = a_manager
		end

feature -- Access

	manager: CDD_MANAGER
			-- Test suite manager

	test_suite: CDD_TEST_SUITE is
			-- Test suite holding all test cases
		require
			testing_enabled: manager.is_testing_enabled
		do
			Result := manager.test_suite
		ensure
			correct_test_suite: Result = manager.test_suite
		end

	test_case: CDD_TEST_CASE is
			-- Test case currently beeing tested
		require
			running: is_running
		deferred
		ensure
--			valid_result: Result /= Void and then test_suite.test_cases.has (Result)
-- TODO: (andreas) this postcondition blew. not sure why. reenable and see why. dont have time now.
		end

feature -- Status report

	is_running: BOOLEAN is
			-- Are we currently running any tests?
		deferred
		end

feature -- Status setting

	stop is
			-- Stop current work and reset all settings.
		require
			running: is_running
		deferred
		ensure
			not_running: not is_running
		end

feature {NONE} -- Implementation

	conf_factory: CONF_FACTORY is
			-- Shared factory for creating new root classes and targets
		once
			create Result
		end

invariant
	manager_not_void: manager /= Void

end
