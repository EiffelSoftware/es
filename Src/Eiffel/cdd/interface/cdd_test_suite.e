indexing
	description: "Objects that store and manage test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_SUITE

inherit

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

	CDD_ROUTINES
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
			target := a_target
			create test_cases.make
			create refresh_actions
		ensure
			target_set: target = a_target
		end

feature -- Access

	target: CONF_TARGET
			-- Target in which `Current' will look for test cases.

	test_cases: DS_LINKED_LIST [CDD_TEST_CASE]
	last_sort_result: DS_LINKED_LIST [CDD_TEST_CASE]
			-- To be removed

	test_classes: DS_LINKED_LIST [CDD_TEST_CLASS]
			-- List of all test classes found in system

	extracted_test_classes: DS_LINKED_LIST [CDD_EXTRACTED_TEST_CLASS] is
			-- Sorted list of all extracted test classes found in system
		do
			if internal_extracted_test_classes = Void then
				create internal_extracted_test_classes.make
				test_classes.do_all (agent (a_tc: CDD_TEST_CLASS)
					local
						l_etc: CDD_EXTRACTED_TEST_CLASS
						l_cursor: DS_LINKED_LIST_CURSOR [CDD_EXTRACTED_TEST_CLASS]
					do
						l_etc ?= a_tc
						if l_etc /= Void then
							l_cursor := internal_extracted_test_classes.new_cursor
							from
								l_cursor.start
							until
								l_cursor.after or else l_etc < l_cursor.item
							loop
								l_cursor.forth
							end
							l_cursor.put_left (l_etc)
						end
					end)
			end
			Result := internal_extracted_test_classes
		ensure
			not_void: Result /= Void
		end

	manual_test_classes: DS_LINKED_LIST [CDD_MANUAL_TEST_CLASS] is
			-- Sorted list of all manual test classes found in system
		do
			if internal_manual_test_classes = Void then
				create internal_manual_test_classes.make
				test_classes.do_all (agent (a_tc: CDD_TEST_CLASS)
					local
						l_mtc: CDD_MANUAL_TEST_CLASS
						l_cursor: DS_LINKED_LIST_CURSOR [CDD_MANUAL_TEST_CLASS]
					do
						l_mtc ?= a_tc
						if l_mtc /= Void then
							l_cursor := internal_manual_test_classes.new_cursor
							from
								l_cursor.start
							until
								l_cursor.after or else l_mtc < l_cursor.item
							loop
								l_cursor.forth
							end
							l_cursor.put_left (l_mtc)
						end
					end)
			end
			Result := internal_manual_test_classes
		ensure
			not_void: Result /= Void
		end

	call_stack_table: DS_HASH_TABLE [CDD_EXTRACTED_TEST_CASE, STRING] is
			-- Hash table with call stack uuid's as keys and first
			-- call frame in stack as value.
		do
			-- Todo: implement
		end

	has_test_class_for_class (a_class: EIFFEL_CLASS_C): BOOLEAN is
			-- Does `test_classes' contain a test case for test case class `a_class'?
		require
			a_class_not_void: a_class /= Void
		do
			Result := has_test_class_with_property (agent (a_tc: CDD_TEST_CLASS; a_cl: EIFFEL_CLASS_C): BOOLEAN
					do
						Result := a_tc.test_class = a_cl
					end (?, a_class)
				)
		end

feature -- Status setting		

	refresh is
			-- Check `eiffel_universe' for new or removed
			-- test cases and update `test_cases'.
		do
			update_test_class_list
			if is_modified then
				refresh_actions.call ([])
			end
		end

feature -- Event handling

	refresh_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when test classes or routines have been removed or added

feature {NONE} -- Implementation access

	is_modified: BOOLEAN
			-- Has `test_classes' been modified by last call to `update_test_class_list'?

	internal_extracted_test_classes: DS_LINKED_LIST [CDD_EXTRACTED_TEST_CLASS]
			-- Internal list for extracted test classes

	internal_manual_test_classes: DS_LINKED_LIST [CDD_MANUAL_TEST_CLASS]
			-- Internal list for manual test classes

feature {NONE} -- Implementation

	has_test_class_with_property (a_prop: FUNCTION [ANY, TUPLE [CDD_TEST_CLASS], BOOLEAN]): BOOLEAN is
			-- Does `test_classes' contain an item, for which `a_prop' returns True?
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CLASS]
		do
			from
				create l_cursor.make (test_classes)
				l_cursor.start
			until
				l_cursor.after or Result
			loop
				a_prop.call ([l_cursor.item])
				if a_prop.last_result then
					Result := True
				else
					l_cursor.forth
				end
			end
		end

	descendants_of_class (a_class_name: STRING): ARRAYED_LIST [CLASS_C] is
			-- Compiled representation of `a_class_name' if one exists
		require
			a_class_name_not_void: a_class_name /= Void
		local
			l_ancestor: CLASS_C
			l_class_list: LIST [CLASS_I]
		do
			l_class_list := eiffel_universe.classes_with_name (a_class_name)
			from
				l_class_list.start
			until
				l_class_list.after or l_ancestor /= Void
			loop
				l_ancestor ?= l_class_list.item.compiled_class
				l_class_list.forth
			end
			if l_ancestor /= Void then
				Result := l_ancestor.descendants
			else
				create Result.make (0)
			end
		end

	update_test_class_list is
			-- Update `a_list' corresponding to existing classes in universe
		local
			l_list: ARRAYED_LIST [CLASS_C]
			l_test_class: CDD_TEST_CLASS
			l_ec: EIFFEL_CLASS_C
			l_extracted_test_class: CDD_EXTRACTED_TEST_CLASS
			l_manual_test_class: CDD_MANUAL_TEST_CLASS
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CLASS]
		do
			is_modified := False
			l_list := descendants_of_class (abstract_test_class_name)
				-- Add test cases for new classes
			from
				l_list.start
			until
				l_list.after
			loop
				l_ec ?= l_list.item
				if l_ec /= Void and then not l_ec.is_deferred and then not has_test_class_for_class (l_ec) then
					if is_descendant_of_class (l_ec, extracted_test_class_name) then
						create {CDD_EXTRACTED_TEST_CLASS} l_test_class.make_with_class (l_ec)
					elseif is_descendant_of_class (l_ec, manual_test_class_name) then
						create {CDD_MANUAL_TEST_CLASS} l_test_class.make_with_class (l_ec)
					end
					test_classes.put_last (l_test_class)
					internal_extracted_test_classes := Void
					internal_manual_test_classes := Void
					is_modified := True
				end
				l_list.forth
			end
				-- Remove test cases for which no class exists
			from
				create l_cursor.make (test_classes)
				l_cursor.start
			until
				l_cursor.after or test_cases.count = l_list.count
			loop
				if not l_list.has (l_cursor.item.test_class) then
					is_modified := True
					l_cursor.remove
					internal_extracted_test_classes := Void
					internal_manual_test_classes := Void
				else
					l_cursor.item.refresh
					if l_cursor.item.is_modified then
						is_modified := True
					end
					l_cursor.forth
				end
			end
		end


invariant
	target_not_void: target /= Void
	test_cases_not_void: test_cases /= Void

end
