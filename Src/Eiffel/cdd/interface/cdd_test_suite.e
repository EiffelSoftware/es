indexing
	description: "Objects that store and manage test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_SUITE

create
	make_with_cluster

feature {NONE} -- Initialization

	make_with_cluster (a_cluster: like tests_cluster) is
			-- Initialize `Current'.
		do

		end

feature -- Access

	test_cases: DS_LINKED_QUEUE [CDD_TEST_CASE]
			-- Sorted list with all test cases
			-- Note: Do not modify directly!

	tests_cluster: CLUSTER_I

feature -- Element change

	set_tests_cluster (a_cluster: like tests_cluster) is
			-- Set `tests_cluster' to `a_cluster'.
		do
		end

	add_test_case (a_test_case: CDD_TEST_CASE) is
			-- Add test case `a_test_case' and notify add actions.
		do
		end

feature -- Removal

	remove_test_case (a_test_case: CDD_TEST_CASE) is
			-- Remove test case `a_test_case' and notify remove actions.
		do
		end

feature -- Event handling

	add_test_case_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_CASE]]
			-- Agents called when test case is added to `Current'

	remove_test_case_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_CASE]]
			-- Agents called when test case is removed from `Current'

end
