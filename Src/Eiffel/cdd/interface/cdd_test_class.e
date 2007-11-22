indexing
	description: "Objects that represent a test class containing test routines"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CDD_TEST_CLASS

inherit

	CDD_ROUTINES
		export
			{NONE} all
		undefine
			is_equal
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		undefine
			is_equal
		end

	COMPARABLE

feature {NONE} -- Initialization

	make_with_class (a_class: like test_class) is
			-- Initialize test class.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_valid_test_class (a_class)
		do
			test_class := a_class
			create test_routines.make
			refresh
		ensure
			test_class_set: test_class = a_class
		end

feature -- Access

	test_class: EIFFEL_CLASS_C
			-- Compiled instance of test class

	test_routines: DS_LINKED_LIST [CDD_TEST_ROUTINE]
			-- List of testable routines routines in `test_class'

	is_modified: BOOLEAN
			-- Has `test_routines' been modified by last call to `refresh'?

	is_valid_test_class (a_class: like test_class): BOOLEAN
			-- Is `a_class' a descendant of a test class?
		require
			a_class_not_void: a_class /= Void
		deferred
		end

feature -- Status change

	refresh is
			-- Look in `test_class' for testable features and update `test_routines' appropriately.
		local
			l_feature_table: FEATURE_TABLE
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_ROUTINE]
			l_name: STRING
		do
			is_modified := False
			l_feature_table := test_class.feature_table

				-- Remove all routines for which feature table does not have an entry
			from
				create l_cursor.make (test_routines)
				l_cursor.start
			until
				l_cursor.after
			loop
				if not l_feature_table.has (l_cursor.item.routine_name) then
					is_modified := True
					l_cursor.remove
				end
				l_cursor.forth
			end

				-- Make sure there is a routine for each test routine in feature table
			from
				l_feature_table.start
			until
				l_feature_table.after
			loop
				l_name := l_feature_table.item_for_iteration.feature_name
				if l_name.count >= test_routine_prefix.count and then
					l_name.substring (1, test_routine_prefix.count).is_case_insensitive_equal (test_routine_prefix) then
					test_routines.put_last (create {CDD_TEST_ROUTINE}.make (Current, l_name))
					is_modified := True
				end
				l_feature_table.forth
			end
		end

invariant
	test_class_not_void: test_class /= Void
	test_class_valid: is_valid_test_class (test_class)
	test_routines_not_void: test_routines /= Void
	test_routines_valid: test_routines.for_all (agent (a_routine: CDD_TEST_ROUTINE): BOOLEAN
		do
			Result := a_routine /= Void and then
				a_routine.test_class = Current
		end)

end
