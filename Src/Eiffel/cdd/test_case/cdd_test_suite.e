indexing
	description: "Objects that store and manage test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_SUITE

inherit

	CDD_ROUTINES
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_cdd_manager: like cdd_manager) is
			-- Initialize `Current' for `a_cdd_manager'.
		require
			a_cdd_manager_not_void: a_cdd_manager /= Void
		do
			create test_routine_update_actions
			cdd_manager := a_cdd_manager
			cdd_manager.status_update_actions.extend (agent check_for_modified_class)
			create test_class_table.make_default
			create test_classes.make_default
			create modified_classes.make_default
		ensure
			cdd_manager_set: cdd_manager = a_cdd_manager
		end

feature -- Access

	target: CONF_TARGET is
			-- Target in which we look for test cases
		require
			project_initialized: cdd_manager.is_project_initialized
		do
			Result := cdd_manager.project.system.universe.target
		ensure
			not_void: Result /= Void
		end

	cdd_manager: CDD_MANAGER
			-- CDD manager

	test_classes: DS_ARRAYED_LIST [CDD_TEST_CLASS]
			-- All test classes in this suite;
			-- this list is updated whenever `test_class_table',
			-- is updated.

	has_test_case_for_class (a_class: EIFFEL_CLASS_C): BOOLEAN is
			-- Do we have a test class for `a_class'?
		require
			a_class_not_void: a_class /= Void
		do
			test_class_table.search (a_class.name_in_upper)
			if test_class_table.found then
				Result := test_class_table.found_item.compiled_class = a_class
			end
		ensure
			correct_result: Result = (test_class_table.found and then test_class_table.found_item.compiled_class = a_class)
		end

feature -- Element change

	add_test_class (a_test_class: CDD_TEST_CLASS) is
			-- Add `a_test_class' to `test_classes' and call refresh.
		require
			a_test_class_not_void: a_test_class /= Void
			a_test_class_not_added: not test_classes.has (a_test_class)
			has_valid_status_updates: a_test_class.status_updates.for_all (
				agent (an_update: CDD_TEST_ROUTINE_UPDATE): BOOLEAN
					do
						Result := an_update.is_added
					end)
		do
			test_classes.force_last (a_test_class)
			test_class_table.force (a_test_class, a_test_class.test_class_name)
			test_routine_update_actions.call ([a_test_class.status_updates])
		ensure
			added: test_classes.has (a_test_class)
		end

feature {CDD_MANAGER} -- State change

	refresh is
			-- Refresh information from system under test.
		require
			project_initialized: cdd_manager.is_project_initialized
		do
			create {DS_ARRAYED_LIST [CDD_TEST_ROUTINE_UPDATE]} status_updates.make_default
			update_class_table
			modified_classes.wipe_out
		ensure
			modified_classes_empty: modified_classes.is_empty
		end

feature -- Event handling

	test_routine_update_actions: ACTION_SEQUENCE [TUPLE [DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]]]
			-- Actions to be executed whenever the test suite or one of
			-- its test routines changes; E.g.: test routine added,
			-- removed, changed.
			-- The argument is a list of all changes representing all changes
			-- as a transaction.
			-- The argument can also be void, in this case we do not make an
			-- incremental update. Instead we just read out all test routines
			-- from scratch.

feature {NONE} -- Implementation

	test_class_table: DS_HASH_TABLE [CDD_TEST_CLASS, STRING]
			-- Table mapping eiffel classes to their test class object

	modified_classes: DS_ARRAYED_LIST [EIFFEL_CLASS_C]
			-- Test classes which have been modified since last compilation

	test_class_ancestor: EIFFEL_CLASS_C
			-- Ancestor all test classes must inherit from

	status_updates: DS_LIST [CDD_TEST_ROUTINE_UPDATE]
			-- List with all test routine updates since last `refresh'

	check_for_modified_class (an_update: CDD_STATUS_UPDATE) is
			-- Check if a test class has been modified and if
			-- so add it to `modified_classes'.
		require
			an_update_not_void: an_update /= Void
		do
			if an_update.code = {CDD_STATUS_UPDATE}.test_class_update_code then
				modified_classes.force_last (cdd_manager.last_updated_test_class)
			end
		end

	update_test_class_ancestor is
			-- Find ancestor of all test cases (CDD_TEST_CASE) and make it
			-- available via `test_class_ancestor'. Set `test_class_ancestor' to
			-- Void if class not found or not completely compiled.
		require
			project_initialized: cdd_manager.is_project_initialized
		local
			ancestors: LIST [CLASS_I]
			old_cs: CURSOR
			l_universe: UNIVERSE_I
		do
			if test_class_ancestor = Void then
				l_universe := cdd_manager.project.system.universe
				ancestors := l_universe.classes_with_name (test_ancestor_class_name)
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
			-- Update `test_class_table' with current information from system.
		require
			status_updates_not_void: status_updates /= Void
		local
			l_old_table: like test_class_table
			l_cursor: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
			l_incremental: BOOLEAN
		do
			update_test_class_ancestor
			l_old_table := test_class_table
			create test_class_table.make_default
			if test_class_ancestor /= Void then
				l_incremental := True
				fill_with_descendants (test_class_ancestor, l_old_table)

				-- Create remove update for each remaining test routine in `l_old_table'
				from
					l_old_table.start
				until
					l_old_table.after
				loop
					l_cursor := l_old_table.item_for_iteration.test_routines.new_cursor
					from
						l_cursor.start
					until
						l_cursor.after
					loop
						status_updates.force_last (create {CDD_TEST_ROUTINE_UPDATE}.make (l_cursor.item, {CDD_TEST_ROUTINE_UPDATE}.remove_code))
						l_cursor.forth
					end
					l_old_table.forth
				end
			end

				-- This should not be necessary once bug is fixed in gobo library
			create test_classes.make_from_array (test_class_table.to_array)

			if l_incremental then
				test_routine_update_actions.call ([status_updates])
			else
				test_routine_update_actions.call ([Void])
			end
		end

	fill_with_descendants (an_ancestor: EIFFEL_CLASS_C; an_old_list: like test_class_table) is
			-- Fill `test_class_table' with (direct or indirect) descendants (except NONE)
			-- of `test_class_ancestor'. Reuse CDD_TEST_CLASS objects from an_old_list if
			-- available.
		require
			an_ancestor_not_void: an_ancestor /= Void
			an_old_list_not_void: an_old_list /= Void
			status_updates_not_void: status_updates /= Void
		local
			l_list: ARRAYED_LIST [CLASS_C]
			l_ec: EIFFEL_CLASS_C
			test_class: CDD_TEST_CLASS
			l_update: BOOLEAN
		do
			l_list := an_ancestor.descendants
			from
				l_list.start
			until
				l_list.after
			loop
					-- NOTE: if the EIFGEN is messed up enough, it can happen
					-- that l_list has two different EIFFEL_CLASS_C entries
					-- for the same class name.
				l_ec ?= l_list.item
				if l_ec /= Void then
					-- Need to check whether there is an entry for `l_ec'
					-- in `test_class_table' so we do not create two
					-- test classes for `l_ec'. This happened in very
					-- rare situation where the system has two compiled
					-- class instances for the same class name.
					if not (l_ec.is_deferred or l_ec.is_generic) and not test_class_table.has (l_ec.name_in_upper) then
						l_update := True
						an_old_list.search (l_ec.name_in_upper)
						if an_old_list.found then
							test_class := an_old_list.found_item
							an_old_list.remove_found_item
							if test_class.compiled_class = Void then
								test_class.set_compiled_class (l_ec)
								test_class.update
							elseif modified_classes.has (l_ec) then
								test_class.update
							else
									-- The test class existed and was not
									-- changed since last `refresh'
								l_update := False
							end
						else
							create test_class.make_with_class (l_ec)
						end
						check
							test_class_not_void: test_class /= Void
						end
						if l_update then
							status_updates.append_last (test_class.status_updates)
						end
						test_class_table.force (test_class, l_ec.name_in_upper)
					end
					fill_with_descendants (l_ec, an_old_list)
				end
				l_list.forth
			end
		end

invariant
	test_routine_update_actions_not_void: test_routine_update_actions /= Void
	test_class_table_not_void: test_class_table /= Void and not test_class_table.has (Void)
	test_classes_not_void: test_classes /= Void and not test_classes.has (Void)
	modified_classes_not_void: modified_classes /= Void
	modified_classes_valid: not modified_classes.has (Void)
	modified_classes_valid: modified_classes.for_all (agent has_test_case_for_class)

end
