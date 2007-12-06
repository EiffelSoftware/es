indexing
	description: "Objects that represent a test class containing test routines"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CLASS

inherit

	CDD_OBSERVED_CONTAINER [CDD_TEST_ROUTINE, STRING]
		rename
			items as test_routines,
			add_item as add_test_routine,
			remove_item as remove_test_routine,
			add_item_actions as add_test_routine_actions,
			remove_item_actions as remove_test_routine_actions,
			corresponds_to_item as is_cdd_test_routine_for_feature_name,
			compute_object_list as retrieve_test_routines,
			create_new_item as create_new_test_routine
		undefine
			is_equal
		end

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

create
	make_with_class

feature {NONE} -- Initialization

	make_with_class (a_class: like test_class) is
			-- Initialize test class.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_valid_test_class (a_class)
		do
			make
			test_class := a_class
		ensure
			test_class_set: test_class = a_class
		end

feature -- Access

	test_class: EIFFEL_CLASS_C
			-- Compiled instance of test class

	is_valid_test_class (a_class: like test_class): BOOLEAN is
			-- Is `a_class' a descendant of a test class?
		require
			a_class_not_void: a_class /= Void
		do
			Result := is_descendant_of_class (a_class, abstract_test_class_name) and then not a_class.is_deferred
		end

feature -- Comparism

	infix "<" (other: like Current): BOOLEAN is
			-- Is `Current' less than `other'?
		do
			Result := test_class < other.test_class
		end

feature {NONE} -- Implementation

	is_cdd_test_routine_for_feature_name (a_routine: CDD_TEST_ROUTINE; a_name: STRING): BOOLEAN is
			-- Is `a_name' feature name of `a_routine'?
		do
			Result := a_routine.routine_name.is_equal (a_name)
		end

	retrieve_test_routines is
			-- Store a list of all features starting with `test_routine_prefix' in `last_object_list'.
		local
			l_ft: FEATURE_TABLE
			l_name: STRING
		do
			l_ft := test_class.feature_table
			create last_object_list.make
			from
				l_ft.start
			until
				l_ft.after
			loop
				l_name := l_ft.item_for_iteration.feature_name
				if l_name.count >= test_routine_prefix.count and then
					l_name.substring (1, test_routine_prefix.count).is_case_insensitive_equal (test_routine_prefix) then
					last_object_list.put_last (l_name)
				end
				l_ft.forth
			end
		end

	create_new_test_routine (a_name: STRING) is
			-- Create a new cdd test routine for `a_name' and store it in `last_created_item'.
		do
			last_created_item := create {CDD_TEST_ROUTINE}.make (Current, a_name)
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
