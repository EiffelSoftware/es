indexing
	description: "Objects that store and manage test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_SUITE

inherit

	CDD_OBSERVED_CONTAINER [CDD_TEST_CLASS, EIFFEL_CLASS_C]
		rename
			items as test_classes,
			add_item as add_test_class,
			remove_item as remove_test_class,
			add_item_actions as add_test_class_actions,
			remove_item_actions as remove_test_class_actions,
			corresponds_to_item as is_cdd_test_class_for_class,
			compute_object_list as retrieve_test_classes,
			create_new_item as create_new_test_class
		redefine
			refresh
		end

	CDD_ROUTINES
		export
			{NONE} all
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

create
	make_with_target

feature {NONE} -- Initialization

	make_with_target (a_target: like target) is
			-- Set `target' to `a_target'.
		require
			a_target_not_void: a_target /= Void
		do
			make
			target := a_target
		ensure
			target_set: target = a_target
		end

feature -- Access

	target: CONF_TARGET
			-- Target in which we look for test cases

feature -- Status settings

	refresh is
			-- Refresh test suite.
		do
			Precursor
			test_classes.do_all (agent {CDD_TEST_CLASS}.refresh)
		end

feature {NONE} -- Implementation

	is_cdd_test_class_for_class (a_test_class: CDD_TEST_CLASS; a_class: EIFFEL_CLASS_C): BOOLEAN is
			-- Does `a_test_class' represent `a_class'?
		do
			Result := a_test_class.test_class = a_class
		end

	create_new_test_class (a_class: EIFFEL_CLASS_C) is
			-- Set `last_created_item' to a new cdd test class object for `a_class'.
		do
			last_created_item := create {CDD_TEST_CLASS}.make_with_class (a_class)
		end

	retrieve_test_classes is
			-- Find all test classes in system and store them in `last_object_list'.
		local
			l_ancestor: EIFFEL_CLASS_C
			l_class_list: LIST [CLASS_I]
		do
			create last_object_list.make
			l_class_list := eiffel_universe.classes_with_name (abstract_test_class_name)
			from
				l_class_list.start
			until
				l_class_list.after or l_ancestor /= Void
			loop
				l_ancestor ?= l_class_list.item.compiled_class
				l_class_list.forth
			end
			if l_ancestor /= Void then
				descendants_of_class_recursive (l_ancestor)
			end
		end

	has_test_class_for_class (a_class: EIFFEL_CLASS_C; a_list: DS_LINKED_LIST [CDD_TEST_CLASS]): BOOLEAN is
			-- Does `a_list' contain a test class for `a_class'?
		require
			a_class_not_void: a_class /= Void
			a_list_not_void: a_list /= Void
		do
			Result := a_list.there_exists (agent (a_tc: CDD_TEST_CLASS; a_ec: EIFFEL_CLASS_C): BOOLEAN
				do
					Result := a_tc.test_class = a_ec
				end (?, a_class))
		end

	descendants_of_class_recursive (a_class: EIFFEL_CLASS_C) is
			-- Put all non-void descendants of `a_class' into `a_list' recursive.
		require
			a_class_not_void: a_class /= Void
			last_object_list_not_void: last_object_list /= Void
		local
			l_list: ARRAYED_LIST [CLASS_C]
			l_ec: EIFFEL_CLASS_C
		do
			l_list := a_class.descendants
			from
				l_list.start
			until
				l_list.after
			loop
				l_ec ?= l_list.item
				if l_ec /= Void then
					if not l_ec.is_deferred then
						last_object_list.put_last (l_ec)
					end
					descendants_of_class_recursive (l_ec)
				end
				l_list.forth
			end
		end

invariant
	target_not_void: target /= Void

end
