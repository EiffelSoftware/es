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
	make_with_class_name, make_with_class

feature {NONE} -- Initialization

	make_with_class_name (a_name: like test_class_name; some_routine_names: DS_LINEAR [STRING]) is
			-- Initialize test class given only the class name `a_name' and
			-- a list of routines names `some_rounite_names' which will be
			-- used to initialize `test_routines'.
		require
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
			some_routine_names_not_void: some_routine_names /= Void
			some_routine_names_valid: not some_routine_names.has (Void)
		local
			l_cursor: DS_LINEAR_CURSOR [STRING]
		do
			test_class_name := a_name
			l_cursor := some_routine_names.new_cursor
			from
				create test_routines.make (some_routine_names.count)
				create test_routine_table.make (some_routine_names.count)
				l_cursor.start
			until
				l_cursor.after
			loop
				test_routines.put_last (create {CDD_TEST_ROUTINE}.make (Current, l_cursor.item))
				test_routine_table.put (test_routines.last, l_cursor.item)
				l_cursor.forth
			end
		ensure
			test_class_name_set: test_class_name = a_name
		end

	make_with_class (a_class: like test_class) is
			-- Initialize test class given a compiled class.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_valid_test_class (a_class)
		do
			create test_routine_table.make_default
			create test_routines.make_default
			set_test_class (a_class)
		ensure
			test_class_set: test_class = a_class
		end

feature -- Access

	is_valid_test_class (a_class: like test_class): BOOLEAN is
			-- Is `a_class' a valid test class?
		require
			a_class_not_void: a_class /= Void
		do
			Result := a_class.has_ast and not a_class.is_deferred and
				is_descendant_of_class (a_class, abstract_test_class_name)
		ensure
			result_implies_has_ast: Result implies a_class.has_ast
			result_implies_deferred: Result implies a_class.is_deferred
			result_implies_is_descendant: Result implies is_descendant_of_class (a_class, abstract_test_class_name)
		end

	test_class: EIFFEL_CLASS_C
			-- Compiled instance of test class

	test_class_name: STRING
			-- Name of the `test_class'

	test_routines: DS_ARRAYED_LIST [CDD_TEST_ROUTINE]
			-- Test routines associated with this class;
			-- A test routine is a routine from class `test_class'
			-- which has a name starting with `test_routine_prefix'.
			-- This routine is updated whenever `test_routine_table' is.

feature -- Element change

	set_test_class (a_class: like test_class) is
			-- Set `test_class' to `a_class'.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_valid_test_class (a_class)
		do
			test_class := a_class
			test_class_name := a_class.name_in_upper
			update_test_routines
			update_tags
		ensure
			test_class_set: test_class = a_class
		end

feature {CDD_TEST_SUITE}

	update_tags is
			-- Update tags of test routines contained in this class.
		do
			wipe_out_tags
			update_explicit_tags
			update_implicit_tags
		end

	update_test_routines is
			-- Update test_routine_table with information from currently compiled system.
		local
			l_ft: FEATURE_TABLE
			l_name: STRING
			old_cs: CURSOR
			old_table: like test_routine_table
			rt: CDD_TEST_ROUTINE
		do
			if test_class /= Void then
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
		end

feature {NONE} -- Implementation

	internal_class_name: like test_class_name
			-- Internally stored class name which is used when `test_class' is Void.

	test_routine_table: DS_HASH_TABLE [CDD_TEST_ROUTINE, STRING]
			-- Table mapping all test routine names to their

	wipe_out_tags is
			-- Remove tags from test routines.
		local
			r_cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
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
		end


	update_explicit_tags is
			-- Update `tags' with data from the indexing clause.
		local
			r_cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
			l_ast: CLASS_AS
			l_ilist: INDEXING_CLAUSE_AS
			l_item: INDEX_AS
			l_value_list: EIFFEL_LIST [ATOMIC_AS]
			v: STRING
		do
			if test_class /= Void then
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
		end

	update_implicit_tags is
			-- Update implicit tags of test routines.
		local
			r_cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
			tag: STRING
		do
			from
				r_cs := test_routines.new_cursor
				r_cs.start
			until
				r_cs.off
			loop
				create tag.make (20)
				tag.append_string ("name.")
				tag.append_string (test_class_name)
				tag.append_character ('.')
				tag.append_string (r_cs.item.name)
				r_cs.item.tags.force_last (tag)
				r_cs.forth
			end
		end

invariant
	test_class_name_not_void: test_class_name /= Void
	test_class_name_valid: test_class /= Void implies test_class_name = test_class.name_in_upper
	test_class_not_void_implies_has_ast: test_class /= Void implies is_valid_test_class (test_class)
	test_routine_table_not_void: test_routine_table /= Void
	test_routines_not_void: test_routines /= Void
	test_routines_valid: test_routines.for_all (agent (a_routine: CDD_TEST_ROUTINE): BOOLEAN
		do
			Result := a_routine /= Void and then
				a_routine.test_class = Current
		end)

end
