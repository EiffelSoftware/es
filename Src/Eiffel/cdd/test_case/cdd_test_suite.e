indexing
	description: "Objects that store and manage test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_SUITE

inherit

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
			create change_actions.make
			target := a_target
			create test_class_table.make_default
			create test_classes.make_default
			refresh
		ensure
			target_set: target = a_target
		end

feature -- Access

	target: CONF_TARGET
			-- Target in which we look for test cases

	test_classes: DS_ARRAYED_LIST [CDD_TEST_CLASS]
			-- All test classes in this suite;
			-- this list is updated whenever `test_class_table',
			-- is updated.

feature -- Element change

	add_test_class (a_test_class: CDD_TEST_CLASS) is
			-- Add `a_test_class' to `test_classes' and call refresh.
		require
			a_test_class_not_void: a_test_class /= Void
			a_test_class_not_added: not test_classes.has (a_test_class)
		do
			test_classes.force_last (a_test_class)
			change_actions.call (Void)
		ensure
			added: test_classes.has (a_test_class)
		end


feature -- State change

	refresh is
			-- Refresh information from system under test.
		do
			update_test_class_ancestor
			if test_class_ancestor /= Void then
				update_class_table
			else
				test_class_table.wipe_out
			end
			change_actions.call (Void)
		end

feature -- Event handling

	change_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be executed whenever test suite has changed;
			-- E.g.: test routine added, removed, changed
			-- For efficiency reasons changes are grouped together in transactions.
			-- TODO: Add list of changes as arguments so observers can be more
			-- efficient in updating their state.

feature {NONE} -- Implementation

	test_class_table: DS_HASH_TABLE [CDD_TEST_CLASS, EIFFEL_CLASS_C]
			-- Table mapping eiffel classes to their test class object

	test_class_ancestor: EIFFEL_CLASS_C
			-- Ancestor all test classes must inherit from

	update_test_class_ancestor is
			-- Find ancestor of all test cases (CDD_TEST_CASE) and make it
			-- available via `test_class_ancestor'. Set `test_class_ancestor' to
			-- Void if class not found or not completely compiled.
		local
			ancestors: LIST [CLASS_I]
			old_cs: CURSOR
		do
			if test_class_ancestor = Void then
				ancestors := eiffel_universe.classes_with_name (abstract_test_class_name)
				from
					old_cs := ancestors.cursor
					ancestors.start
				until
					ancestors.after or test_class_ancestor /= Void
				loop
					test_class_ancestor ?= ancestors.item.compiled_class
					ancestors.forth
				end
				ancestors.go_to (old_cs)
			end
		end

	update_class_table is
			-- Update `test_class_tbale' with current information from system.
		require
			test_class_ancestor_not_void: test_class_ancestor /= Void
		local
			old_table: like test_class_table
		do
			old_table := test_class_table
			create test_class_table.make_default
			fill_with_descendants (test_class_ancestor, old_table)
			create test_classes.make_from_array (test_class_table.to_array)
		end

	fill_with_descendants (an_ancestor: EIFFEL_CLASS_C; an_old_list: like test_class_table) is
			-- Fill `test_class_table' with (direct or indirect) descendants (except NONE)
			-- of `test_class_ancestor'. Reuse CDD_TEST_CLASS objects from an_old_list if
			-- available.
		require
			an_ancestor_not_void: an_ancestor /= Void
			an_old_list_not_void: an_old_list /= Void
		local
			l_list: ARRAYED_LIST [CLASS_C]
			l_ec: EIFFEL_CLASS_C
			test_class: CDD_TEST_CLASS
		do
			l_list := an_ancestor.descendants
			from
				l_list.start
			until
				l_list.after
			loop
				l_ec ?= l_list.item
				if l_ec /= Void then
					if not l_ec.is_deferred then
						an_old_list.search (l_ec)
						if an_old_list.found then
							test_class := an_old_list.found_item
							test_class.update_test_routines
							test_class.update_tags
						else
							create test_class.make_with_class (l_ec)
						end
						check
							test_class_not_void: test_class /= Void
						end
						test_class_table.force (test_class, l_ec)
					end
					fill_with_descendants (l_ec, an_old_list)
				end
				l_list.forth
			end
		end

invariant
	target_not_void: target /= Void
	change_actions_not_void: change_actions /= Void
	test_class_table_not_void: test_class_table /= Void and not test_class_table.has (Void)
	test_classes_not_void: test_classes /= Void and not test_classes.has (Void)

end
