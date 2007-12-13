indexing
	description: "Objects that represent a test class containing test routines"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CLASS

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
	make_with_class

feature {NONE} -- Initialization

	make_with_class (a_class: like test_class) is
			-- Initialize test class.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_descendant_of_class (a_class, abstract_test_class_name) and then not a_class.is_deferred
		do
			test_class := a_class
			create test_routine_table.make_default
			create test_routines.make_default
			update_test_routines
			update_tags
		ensure
			test_class_set: test_class = a_class
		end

feature -- Access

	test_class: EIFFEL_CLASS_C
			-- Compiled instance of test class

	test_routines: DS_ARRAYED_LIST [CDD_TEST_ROUTINE]
			-- Test routines associated with this class;
			-- A test routine is a routine from class `test_class'
			-- which has a name starting with `test_routine_prefix'.
			-- This routine is updated whenever `test_routine_table' is.

feature {CDD_TEST_SUITE}

	update_test_routines is
			-- Update test_routine_table with information from currently compiled system.
		local
			l_ft: FEATURE_TABLE
			l_name: STRING
			old_cs: CURSOR
			old_table: like test_routine_table
			rt: CDD_TEST_ROUTINE
		do
			old_table := test_routine_table
			create test_routine_table.make_default
			l_ft := test_class.feature_table
			from
				old_cs := l_ft.cursor
				l_ft.start
			until
				l_ft.after
			loop
				l_name := l_ft.item_for_iteration.feature_name
				if l_name.count >= test_routine_prefix.count and then
					l_name.substring (1, test_routine_prefix.count).is_case_insensitive_equal (test_routine_prefix) then
					old_table.search (l_name)
					if old_table.found then
						rt := old_table.found_item
					else
						create rt.make (Current, l_name)
					end
					test_routine_table.force (rt, l_name)
				end
				l_ft.forth
			end
			l_ft.go_to (old_cs)
			create test_routines.make_from_array (test_routine_table.to_array)
		end

feature {NONE} -- Implementation

	test_routine_table: DS_HASH_TABLE [CDD_TEST_ROUTINE, STRING]
			-- Table mapping all test routine names to their

	is_cdd_test_routine_for_feature_name (a_routine: CDD_TEST_ROUTINE; a_name: STRING): BOOLEAN is
			-- Is `a_name' feature name of `a_routine'?
		do
			Result := a_routine.name.is_equal (a_name)
		end

	update_tags is
			-- Update `tags' with data from the indexing clause.
		local
			r_cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
			l_ast: CLASS_AS
			l_ilist: INDEXING_CLAUSE_AS
			l_item: INDEX_AS
			l_value_list: EIFFEL_LIST [ATOMIC_AS]
			v: STRING
		do
			from
				r_cs := test_routines.new_cursor
				r_cs.start
			until
				r_cs.off
			loop
				r_cs.item.tags.wipe_out
				r_cs.forth
			end

			l_ast := test_class.ast
			l_ilist := l_ast.top_indexes
			from
				l_ilist.start
			until
				l_ilist.after
			loop
				l_item := l_ilist.item
				if l_item.tag.name.is_equal ("tag") then
					from
						l_value_list := l_item.index_list
						l_value_list.start
					until
						l_value_list.after
					loop
						v := l_value_list.item.string_value.twin
						v.prune_all_leading ('"')
						v.prune_all_trailing ('"')
						from
							r_cs := test_routines.new_cursor
							r_cs.start
						until
							r_cs.off
						loop
							r_cs.item.tags.force_last (v)
							r_cs.forth
						end
						l_value_list.forth
					end
				end
				l_ilist.forth
			end
		end

invariant
	test_class_not_void: test_class /= Void
	test_class_has_ast: test_class.has_ast
	test_class_valid: is_descendant_of_class (test_class, abstract_test_class_name) and then not test_class.is_deferred
	test_routine_table_not_void: test_routine_table /= Void
	test_routines_not_void: test_routines /= Void
	test_routines_valid: test_routines.for_all (agent (a_routine: CDD_TEST_ROUTINE): BOOLEAN
		do
			Result := a_routine /= Void and then
				a_routine.test_class = Current
		end)

end
