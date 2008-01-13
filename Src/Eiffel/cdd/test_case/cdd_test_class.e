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

	KL_SHARED_STRING_EQUALITY_TESTER
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
			l_test_routine: CDD_TEST_ROUTINE
		do
			test_class_name := a_name
			create test_routines.make (some_routine_names.count)
			create test_routine_table.make (some_routine_names.count)
			create class_tags.make (0)
			class_tags.set_equality_tester (case_insensitive_string_equality_tester)
			l_cursor := some_routine_names.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				create l_test_routine.make (Current, l_cursor.item)
				test_routines.put_last (l_test_routine)
				test_routine_table.put (l_test_routine, l_cursor.item)
				status_updates.force_last (create {CDD_TEST_ROUTINE_UPDATE}.make (l_test_routine, {CDD_TEST_ROUTINE_UPDATE}.add_code))
				l_cursor.forth
			end
			create {DS_ARRAYED_LIST [CDD_TEST_ROUTINE_UPDATE]} status_updates.make_default
		ensure
			test_class_name_set: test_class_name = a_name
		end

	make_with_class (a_class: like compiled_class) is
			-- Initialize test class given a compiled class.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_valid_test_class (a_class)
		do
			create test_routine_table.make_default
			create test_routines.make_default
			set_compiled_class (a_class)
			create class_tags.make (0)
			class_tags.set_equality_tester (case_insensitive_string_equality_tester)
			create {DS_ARRAYED_LIST [CDD_TEST_ROUTINE_UPDATE]} status_updates.make_default
			update
		ensure
			compiled_class_set: compiled_class = a_class
		end

feature -- Access

	is_valid_test_class (a_class: like compiled_class): BOOLEAN is
			-- Is `a_class' a valid test class?
		require
			a_class_not_void: a_class /= Void
		do
			Result := a_class.has_ast and not a_class.is_deferred and
				is_descendant_of_class (a_class, test_ancestor_class_name)
		ensure
			result_implies_has_ast: Result implies a_class.has_ast
			result_implies_deferred: Result implies a_class.is_deferred
			result_implies_is_descendant: Result implies is_descendant_of_class (a_class, test_ancestor_class_name)
		end

	compiled_class: EIFFEL_CLASS_C
			-- Compiled instance of test class

	test_class_name: STRING
			-- Name of the `compiled_class'

	test_routines: DS_ARRAYED_LIST [CDD_TEST_ROUTINE]
			-- Test routines associated with this class;
			-- A test routine is a routine from class `compiled_class'
			-- which has a name starting with `test_routine_prefix'.
			-- This routine is updated whenever `test_routine_table' is.

feature -- Element change

	set_compiled_class (a_class: like compiled_class) is
			-- Set `compiled_class' to `a_class'.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_valid_test_class (a_class)
		do
			compiled_class := a_class
			test_class_name := a_class.name_in_upper
		ensure
			compiled_class_set: compiled_class = a_class
		end

feature {CDD_TEST_SUITE} -- Status change

	status_updates: DS_LIST [CDD_TEST_ROUTINE_UPDATE]
			-- List of changes since creation or else
			-- last call to `update_test_routines'.

	update is
			-- Update information about all test routines `compiled_class'
			-- and add update notifications to `status_updates'.
		require
			compiled_class_set: compiled_class /= Void
		do
			status_updates.wipe_out
			update_tags
			update_test_routines
		end

feature {CDD_TEST_ROUTINE} -- Test routine properties

	class_tags: DS_HASH_SET [STRING]
			-- CDD tags in `compiled_class'

feature {NONE} -- Implementation

	internal_class_name: like test_class_name
			-- Internally stored class name which is used when `compiled_class' is Void.

	test_routine_table: DS_HASH_TABLE [CDD_TEST_ROUTINE, STRING]
			-- Table mapping all test routine names to their actual instance

	is_valid_routine_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' a valid test routine name?
		require
			a_name_not_void: a_name /= Void
		do
			Result := a_name.count >= test_routine_prefix.count and then
				a_name.substring (1, test_routine_prefix.count).is_case_insensitive_equal (test_routine_prefix)
		end

	is_valid_feature (a_feature: FEATURE_I): BOOLEAN is
			--
		require
			a_feature_not_void: a_feature /= Void
		local
			l_name: STRING
		do
			Result := not a_feature.has_arguments and a_feature.is_routine and
				a_feature.export_status.is_all and is_valid_routine_name (a_feature.feature_name)
		end

	is_valid_feature_as (a_feature_as: FEATURE_AS): BOOLEAN is
			-- Is `a_feature_as' the syntax of a valid test routine?
			-- (Note: for now only with respect to the first visible name)
		local
			l_name: STRING
		do
			Result := (a_feature_as.body.arguments = Void or else a_feature_as.body.arguments.is_empty) and
				not a_feature_as.is_function and is_valid_routine_name (a_feature_as.feature_names.first.visual_name)
		end

	is_valid_clause_as (a_clause_as: FEATURE_CLAUSE_AS): BOOLEAN is
			-- Is `a_clause_as' exported to ANY?
		require
			a_clause_as_not_void: a_clause_as /= Void
		local
			l_list: CLASS_LIST_AS
			l_old_cs: CURSOR
		do
			if a_clause_as.clients /= Void then
				l_list := a_clause_as.clients.clients
				from
					l_old_cs := l_list.cursor
					l_list.start
				until
					Result or l_list.after
				loop
					if l_list.item.name.is_case_insensitive_equal ("ANY") then
						Result := True
					end
					l_list.forth
				end
				l_list.go_to (l_old_cs)
			else
				Result := True
			end
		end

	update_test_routines is
			-- Update test_routine_table with information from currently compiled system.
		require
			compiled_class_set: compiled_class /= Void
		local
			l_ft: FEATURE_TABLE
			l_fcl: EIFFEL_LIST [FEATURE_CLAUSE_AS]
			l_fl: EIFFEL_LIST [FEATURE_AS]
			l_feature: FEATURE_I
			l_feature_as: FEATURE_AS
			l_old_cs, l_old_cs2: CURSOR
			l_feature_list: DS_ARRAYED_LIST [STRING]
		do
				-- If feature table not available, could we look at AST?
			create l_feature_list.make_default
			if compiled_class.has_feature_table then
				l_ft := compiled_class.feature_table
				from
					l_old_cs := l_ft.cursor
					l_ft.start
				until
					l_ft.after
				loop
					l_feature := l_ft.item_for_iteration
					if is_valid_feature (l_ft.item_for_iteration) then
						l_feature_list.force_last (l_ft.item_for_iteration.feature_name)
					end
					l_ft.forth
				end
				l_ft.go_to (l_old_cs)
			elseif compiled_class.ast.features /= Void then
				l_fcl := compiled_class.ast.features
				from
					l_old_cs := l_fcl.cursor
					l_fcl.start
				until
					l_fcl.after
				loop
					if is_valid_clause_as (l_fcl.item) and not l_fcl.item.features.is_empty then
						l_fl := l_fcl.item.features
						from
							l_old_cs2 := l_fl.cursor
							l_fl.start
						until
							l_fl.after
						loop
							if is_valid_feature_as (l_fl.item) then
								l_feature_list.force_last (l_fl.item.feature_names.first.visual_name)
							end
							l_fl.forth
						end
						l_fl.go_to (l_old_cs2)
					end
					l_fcl.forth
				end
				l_fcl.go_to (l_old_cs)
			end
			update_test_routine_table (l_feature_list)
		end

	update_test_routine_table (a_routine_list: DS_LINEAR [STRING]) is
			-- Update `test_routine_table' according to `a_routine_list' and
			-- add all create update for all notifications in `status_udpates'.
		require
			a_routine_list_not_void: a_routine_list /= Void
			a_routine_list_valid: not a_routine_list.has (Void)
		local
			l_old_table: like test_routine_table
			l_cursor: DS_LINEAR_CURSOR [STRING]
			l_name: STRING
			l_test_routine: CDD_TEST_ROUTINE
		do
			l_old_table := test_routine_table
			create test_routine_table.make (a_routine_list.count)

			l_cursor := a_routine_list.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_name := l_cursor.item
				l_old_table.search (l_name)
				if l_old_table.found then
					l_test_routine := l_old_table.found_item
					test_routine_table.put (l_test_routine, l_name)
					l_old_table.remove_found_item
					l_test_routine.update
					if l_test_routine.is_modified then
						status_updates.force_last (create {CDD_TEST_ROUTINE_UPDATE}.make (l_test_routine, {CDD_TEST_ROUTINE_UPDATE}.new_outcome_code))
					end
				else
					create l_test_routine.make (Current, l_name)
					test_routine_table.put (l_test_routine, l_name)
					status_updates.force_last (create {CDD_TEST_ROUTINE_UPDATE}.make (l_test_routine, {CDD_TEST_ROUTINE_UPDATE}.add_code))
				end
				l_cursor.forth
			end
			if not l_old_table.is_empty then
				from
					l_old_table.start
				until
					l_old_table.after
				loop
					status_updates.force_last (create {CDD_TEST_ROUTINE_UPDATE}.make (l_old_table.item_for_iteration, {CDD_TEST_ROUTINE_UPDATE}.remove_code))
					l_old_table.forth
				end
			end

			create test_routines.make_from_array (test_routine_table.to_array)
		end

	update_tags is
			-- Update tags of test routines contained in this class.
		do
			create class_tags.make_default
			class_tags.set_equality_tester (case_insensitive_string_equality_tester)
			update_explicit_tags
		end

	update_explicit_tags is
			-- Update `tags' with data from the indexing clause.
		local
			l_ast: CLASS_AS
			l_ilist: INDEXING_CLAUSE_AS
			l_item: INDEX_AS
			l_value_list: EIFFEL_LIST [ATOMIC_AS]
			v: STRING
		do
			if compiled_class /= Void then
				l_ast := compiled_class.ast
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
							class_tags.force (v)
							l_value_list.forth
						end
					end
					l_ilist.forth
				end
			end
		end

invariant
	test_class_name_not_void: test_class_name /= Void
	test_class_name_valid: compiled_class /= Void implies test_class_name = compiled_class.name_in_upper
	comlied_class_not_void_implies_has_ast: compiled_class /= Void implies is_valid_test_class (compiled_class)
	test_routine_table_not_void: test_routine_table /= Void
	test_routines_not_void: test_routines /= Void
	test_routines_valid: test_routines.for_all (agent (a_routine: CDD_TEST_ROUTINE): BOOLEAN
		do
			Result := a_routine /= Void and then
				a_routine.test_class = Current
		end)
	status_updates_not_void: status_updates /= Void
	status_updates_valid: not status_updates.has (Void)
	class_tags_not_void: class_tags /= Void
	class_tags_has_equality_tester: class_tags.equality_tester = case_insensitive_string_equality_tester

end
