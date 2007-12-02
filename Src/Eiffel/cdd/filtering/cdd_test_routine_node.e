indexing
	description: "Objects that represent a tree node for test routines"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_ROUTINE_NODE

inherit

	CDD_FILTER_NODE

feature {NONE} -- Initialization

	make_with_test_routine (a_test_routine: like test_routine) is
			-- Create a test routine node for `a_test_routine'.
		require
			a_test_routine_not_void: a_test_routine /= Void
		do
			initialize
			test_routine := a_test_routine
		end

feature -- Access

	is_leaf: BOOLEAN is False
			-- Is `Current' a leave within the filter result tree?

	test_routine: CDD_TEST_ROUTINE

	tag: STRING is
			-- Tag for describing `Current'
		do
			Result := test_routine.routine_name
		end

feature -- Processing

	process (a_visitor: CDD_FILTER_NODE_VISITOR) is
			-- Call appropriate processor for `Current'.
		do
			a_visitor.process_test_routine_node (Current)
		end

invariant

	test_routine_not_void: test_routine /= Void

end
