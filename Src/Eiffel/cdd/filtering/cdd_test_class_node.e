indexing
	description: "Objects that represent a tree node for test classes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CLASS_NODE

inherit
	CDD_FILTER_NODE

feature {NONE} -- Initialization

	make_with_test_class (a_test_class: like test_class) is
			-- Create a test class node for `a_test_class'.
		require
			a_test_class_not_void: a_test_class /= Void
		do
			initialize
			test_class := a_test_class
		end

feature -- Access

	is_leaf: BOOLEAN is False
			-- Is `Current' a leave within the filter result tree?

	test_class: CDD_TEST_CLASS
			-- Actual test class `Current' represents

	tag: STRING is
			-- Tag for describing `Current'
		do
			Result := test_class.test_class.name_in_upper
		end

feature -- Processing

	process (a_visitor: CDD_FILTER_NODE_VISITOR) is
			-- Call appropriate processor for `Current'.
		do
			a_visitor.process_test_class_node (Current)
		end

invariant

	test_class_not_void: test_class /= Void

end
