indexing
	description: "Objects that represent CDD test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CASE

create
	make_with_class

feature {NONE} -- Initialization

	make_with_class (a_class: like test_class) is
			-- Set `test_class' to `a_class'.
		do

		end

feature -- Access

	test_class: EIFFEL_CLASS_C
			-- Class containing context for `current'

	feature_under_test: E_FEATURE
			-- Feature beeing tested by `current'

	class_under_test: EIFFEL_CLASS_C
			-- Class containing `feature_under_test'

	cluster_under_test: CLUSTER_I
			-- Cluster containing `class_under_test'

	status: INTEGER
			-- Current status of test case

	contains_prestate: BOOLEAN
			-- Is context of `current' actual pre-state?

	call_stack_uuid: UUID
			-- uuid of the call stack

	position_in_call_stack: NATURAL
			-- position within the call stack

feature -- Status report

	status_change_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions called when `status' changes

feature -- Status setting

	set_status (a_status: like status) is
			-- Set `status' to `a_status' and notify agents.
		do
		end

end
