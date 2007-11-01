indexing
	description: "Objects that represents a test routine in some test class"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_ROUTINE

create
	make

feature {NONE} -- Initialization

	make (a_test_class: like test_class; a_routine_name: STRING) is
			-- Initialize current with `a_test_class' as `test_class'
			-- and `a_routine_name' as `routine_name'.
		require
			a_test_class_not_void: a_test_class /= Void
			a_routines_name_valid: a_routine_name /= Void and then not a_routine_name.is_empty
		do
			test_class := a_test_class
			routine_name := a_routine_name
			create outcomes.make
		ensure
			test_class_set: test_class = a_test_class
			routine_name_set: routine_name = a_routine_name
		end

feature -- Access

	test_class: CDD_TEST_CLASS
			-- Class which contains `Current'

	routine_name: STRING
			-- Name of testable routine in `test_class'

	outcomes: DS_LINKED_LIST [ANY]
			-- Outcomes from previous testing

invariant
	test_class_not_void: test_class /= Void
	routine_name_not_void: routine_name /= Void
	outcomes_not_void: outcomes /= Void

end
