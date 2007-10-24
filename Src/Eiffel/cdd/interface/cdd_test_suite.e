indexing
	description: "Objects that represent a test suite containing test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_SUITE

inherit

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

create
	make_with_cluster

feature {NONE} -- Initialization

	make_with_cluster (a_cluster: like tests_cluster) is
			-- Set 'tests_cluster' to 'a_cluster' and create test case list.
		require
			a_cluster_not_void: a_cluster /= Void
		do
			set_tests_cluster (a_cluster)
			create test_cases.make
			create add_test_case_actions
			create remove_test_case_actions
		ensure
			tests_cluster_set: tests_cluster = a_cluster
		end

feature -- Access

	test_cases: DS_LINKED_LIST [CDD_TEST_CASE]
			-- Sorted list of all test cases in 'Current'
			-- Note: Do not modify directly!

	target_under_test: CONF_TARGET is
			-- Currently opened target
		do
			Result := eiffel_universe.target
		end

	tests_cluster: CLUSTER_I
			-- Cluster where all generated classes for testing are stored

	test_case_for_class (a_class: CLASS_I): CDD_TEST_CASE is
			-- Associated test case for test class `a_class' if exists, otherwise Void
		require
			a_class_not_void: a_class /= Void
		do
			find_test_case (agent is_tester_class (a_class, ?))
			Result := last_found_test_case
		end

	test_case_for_class_name (a_name: STRING): CDD_TEST_CASE is
			-- Test case for test class of name `a_name'
			-- Void if there is no such test case
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			find_test_case (agent is_tester_class_name (a_name, ?))
			Result := last_found_test_case
		end

feature -- Status report

	has_test_case_for_class (a_class: CLASS_I): BOOLEAN is
			-- Does 'Current' have a test case for test class 'a_class'
		require
			a_class_not_void: a_class /= Void
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			from
				l_cursor := test_cases.new_cursor
				l_cursor.start
			until
				l_cursor.after or Result
			loop
				if l_cursor.item.tester_class = a_class then
					Result := True
				end
				l_cursor.forth
			end
		end

feature -- Element change

	set_tests_cluster (a_cluster: like tests_cluster) is
			-- Set `tests_cluster' to `a_cluster'.
		require
			a_cluster_not_void: a_cluster /= Void
		do
			tests_cluster := a_cluster
		ensure
			tests_cluster_set: tests_cluster = a_cluster
		end

	add_test_case (a_tc: CDD_TEST_CASE) is
			-- Add `a_tc' to 'test_cases'
		require
			valid_test_case: a_tc /= Void
			not_added_yet: not test_cases.has (a_tc)
			valid_test_case: a_tc.tester_class.cluster = tests_cluster
		local
			l_found: BOOLEAN
		do
			from
				test_cases.start
			until
				test_cases.after or l_found
			loop
				if a_tc < test_cases.item_for_iteration then
					l_found := True
				else
					test_cases.forth
				end
			end
			test_cases.put_left (a_tc)
			add_test_case_actions.call ([a_tc])
		ensure
			test_case_added: test_cases.count = old test_cases.count + 1 and test_cases.has (a_tc)
		end

	remove_test_case (a_tc: CDD_TEST_CASE) is
			-- Remove test class for 'a_tc' and notify class manager.
		require
			valid_test_case: a_tc /= Void
			contains_test_case: test_cases.has (a_tc)
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			l_cursor := test_cases.new_cursor
			l_cursor.start
			l_cursor.search_forth (a_tc)
			l_cursor.remove
			remove_test_case_actions.call ([a_tc])
		ensure
			test_case_removed: not test_cases.has (a_tc)
		end

feature -- Event handling

	add_test_case_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_CASE]]
			-- Agents called when test case is added to `Current'

	remove_test_case_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_CASE]]
			-- Agents called when test case is removed from `Current'

feature {NONE} -- Element retrieving

	find_test_case (a_func: FUNCTION [ANY, TUPLE [CDD_TEST_CASE], BOOLEAN]) is
			-- Find a test case in `test_cases' for that `a_func' returns True and
			-- assign it to last_found_test_case.
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			from
				l_cursor := test_cases.new_cursor
				l_cursor.start
				last_found_test_case := Void
			until
				l_cursor.off or last_found_test_case /= Void
			loop
				a_func.call ([l_cursor.item])
				if a_func.last_result then
					last_found_test_case := l_cursor.item
				else
					l_cursor.forth
				end
			end
		ensure
			valid_result: last_found_test_case /= Void implies test_cases.has (last_found_test_case)
		end

	last_found_test_case: CDD_TEST_CASE
			-- last test case found by `find_test_case'
			-- can be Void if no test case found

	is_tester_class_name (a_name: STRING; a_tc: CDD_TEST_CASE): BOOLEAN is
			-- Is `a_name' the name of the tester class in `a_tc'?
		require
			a_tc_not_void: a_tc /= Void
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			Result := a_tc.tester_class.name.is_equal (a_name)
		ensure
			correct_result: Result = a_tc.tester_class.name.is_equal (a_name)
		end

	is_tester_class (a_class: CLASS_I; a_tc: CDD_TEST_CASE): BOOLEAN is
			-- Is `a_class' a CLASS_I instance of the tester class in `a_tc'?
		require
			a_tc_not_void: a_tc /= Void
			a_class_not_void: a_class /= Void
		do
			Result := a_tc.tester_class = a_class
		ensure
			correct_result: Result = (a_tc.tester_class = a_class)
		end

invariant
	test_cases_not_void: test_cases /= Void
	tests_cluster_not_void: tests_cluster /= Void
	add_test_case_actions_not_void: add_test_case_actions /= Void
	remove_test_case_actions_not_void: remove_test_case_actions /= Void

end -- class CDD_TEST_SUITE
