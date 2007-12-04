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
			create extracted_test_classes.make
			create manual_test_classes.make
			create refresh_actions
		ensure
			target_set: target = a_target
		end

feature -- Access

	target: CONF_TARGET
			-- Target in which we look for test cases

	extracted_test_classes: DS_LINKED_LIST [CDD_EXTRACTED_TEST_CLASS]
			-- Sorted list of all extracted test classes found in system

	manual_test_classes: DS_LINKED_LIST [CDD_MANUAL_TEST_CLASS]
			-- Sorted list of all manual test classes found in system

	call_stack_table: DS_HASH_TABLE [CDD_EXTRACTED_TEST_CASE, STRING] is
			-- Hash table with call stack uuid's as keys and first
			-- call frame in stack as value.
		do
			-- Todo: implement
		end

feature -- Status setting		

	refresh is
			-- Check `eiffel_universe' for new or removed
			-- test cases and update `test_cases'.
		do
			update_test_class_lists
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

feature {NONE} -- Implementation

	update_test_class_lists is
			-- Update `a_list' corresponding to existing classes in universe
		do
			update_class_list (extracted_test_class_name, extracted_test_classes,
				agent (a_class: EIFFEL_CLASS_C): CDD_EXTRACTED_TEST_CLASS
					do
						create Result.make_with_class (a_class)
					end)
			update_class_list (manual_test_class_name, manual_test_classes,
				agent (a_class: EIFFEL_CLASS_C): CDD_MANUAL_TEST_CLASS
					do
						create Result.make_with_class (a_class)
					end)
		end

	update_class_list (an_ancestor: STRING; a_list: DS_LINKED_LIST [CDD_TEST_CLASS];
		a_creator: FUNCTION [ANY, TUPLE [EIFFEL_CLASS_C], CDD_TEST_CLASS]) is
			-- Update `a_list' corresponding to all non void descendants of `an_ancestor'.
			-- `a_creator' returns an new instance when extending the list.
		require
			an_ancestor_valid: an_ancestor /= Void and then not an_ancestor.is_empty
			a_list_not_void: a_list /= Void
			a_creator_not_void: a_creator /= Void
		local
			l_tccur: DS_LINKED_LIST_CURSOR [CDD_TEST_CLASS]
			l_eccur: DS_LINKED_LIST_CURSOR [EIFFEL_CLASS_C]
			l_test_class: CDD_TEST_CLASS


			-- Temporary locals for compilation
			l_f: CDD_FILTER
			l_fnc: CDD_TEST_CLASS_NODE
			l_fnr: CDD_TEST_ROUTINE_NODE
			l_fv: CDD_FILTER_NODE_VISITOR
		do
			create l_eccur.make (descendants_of_class (an_ancestor))
			create l_tccur.make (a_list)
			from
				l_eccur.start
			until
				l_eccur.after
			loop
				if not has_test_class_for_class (l_eccur.item, a_list) then
					a_creator.call ([l_eccur.item])
					l_test_class := a_creator.last_result
					from
						l_tccur.start
					until
						l_tccur.after or l_test_class = Void
					loop
						if l_test_class < l_tccur.item then
							l_tccur.put_left (l_test_class)
							l_test_class := Void
						else
							l_tccur.forth
						end
					end
					if l_test_class /= Void then
						l_tccur.put_left (l_test_class)
					end
					is_modified := True
				end
				l_eccur.forth
			end

			from
				l_tccur.start
			until
				l_tccur.after
			loop
				if not l_eccur.container.has (l_tccur.item.test_class) then
					l_tccur.remove
					is_modified := True
				else
					l_tccur.item.refresh
					is_modified := is_modified or l_tccur.item.is_modified
					l_tccur.forth
				end
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

	descendants_of_class (a_class_name: STRING): DS_LINKED_LIST [EIFFEL_CLASS_C] is
			-- Compiled representation of `a_class_name' if one exists
		require
			a_class_name_not_void: a_class_name /= Void
		local
			l_ancestor: EIFFEL_CLASS_C
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
			create Result.make
			if l_ancestor /= Void then
				descendants_of_class_recursive (l_ancestor, Result)
			end
		end

	descendants_of_class_recursive (a_class: EIFFEL_CLASS_C; a_list: DS_LINKED_LIST [EIFFEL_CLASS_C]) is
			-- Put all non-void descendants of `a_class' into `a_list' recursive.
		require
			a_class_not_void: a_class /= Void
			a_list_not_void: a_list /= Void
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
						a_list.put_last (l_ec)
					end
					descendants_of_class_recursive (l_ec, a_list)
				end
				l_list.forth
			end
		end

invariant
	target_not_void: target /= Void
	extracted_test_classes_not_void: extracted_test_classes /= Void
	manual_test_classes_not_void: extracted_test_classes /= Void

end
