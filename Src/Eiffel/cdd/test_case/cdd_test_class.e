indexing
	description: "Objects that represent a test class containing test routines"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CLASS

inherit
	CDD_CONSTANTS
		export
			{NONE} all
		end

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
	make_with_ast, make_with_class

feature {NONE} -- Initialization

	make_with_ast (an_ast: CLASS_AS) is
			-- Initialize test class given only the class name `a_name' and
			-- a list of routines names `some_rounite_names' which will be
			-- used to initialize `test_routines'.
		require
			an_ast_not_void: an_ast /= Void
		do
			internal_parsed_class := an_ast
			test_class_name := an_ast.class_name.name.as_upper
			initialize
		ensure
			parsed_class_set: parsed_class = an_ast
		end

	make_with_class (a_class: like compiled_class) is
			-- Initialize test class given a compiled class.
		require
			a_class_not_void: a_class /= Void
			a_class_valid: is_valid_test_class (a_class)
		do
			test_class_name := a_class.name_in_upper.twin
			set_compiled_class (a_class)
			initialize
		ensure
			compiled_class_set: compiled_class = a_class
		end

	initialize is
			-- Initialize `Current'
		do
			create {DS_ARRAYED_LIST [CDD_TEST_ROUTINE_UPDATE]} status_updates.make_default
			update
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
			internal_parsed_class := Void
		ensure
			compiled_class_set: compiled_class = a_class
		end

feature -- Status changes

	status_updates: DS_LIST [CDD_TEST_ROUTINE_UPDATE]
			-- List of changes since creation or last call to `update_test_routines'.

feature {CDD_TEST_SUITE} -- Status change

	update is
			-- Update information about all test routines `compiled_class'
			-- and add update notifications to `status_updates'.
		do
			status_updates.wipe_out
			update_tags
			update_test_routines
		end

feature {CDD_TEST_ROUTINE} -- Test routine properties

	class_tags: DS_HASH_SET [STRING]
			-- CDD tags in `compiled_class'

feature {NONE} -- Implementation

	parsed_class: CLASS_AS is
			-- Abstract syntax tree of the corresponding eiffel class
		do
			if compiled_class /= Void then
				Result := compiled_class.ast
			else
				Result := internal_parsed_class
			end
		ensure
			not_void: Result /= Void
			valid: (compiled_class /= Void) implies (Result = compiled_class.ast)
			valid: (compiled_class = Void) implies (Result = internal_parsed_class)
		end

	internal_parsed_class: like parsed_class
			-- Abstract syntax tree if `compiled_class' is not available

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
			-- Is `a_feature' a valid test routine feature?
		require
			a_feature_not_void: a_feature /= Void
		do
			Result := not a_feature.has_arguments and a_feature.is_routine and
				a_feature.export_status.is_all and is_valid_routine_name (a_feature.feature_name)
		end

	is_valid_feature_as (a_feature_as: FEATURE_AS): BOOLEAN is
			-- Is `a_feature_as' the syntax of a valid test routine?
			-- (Note: for now only with respect to the first name)
		do
			Result := (a_feature_as.body.arguments = Void or else a_feature_as.body.arguments.is_empty) and
				not a_feature_as.is_function and is_valid_routine_name (a_feature_as.feature_name.name)
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
		local
			l_ft: FEATURE_TABLE
			l_fcl: EIFFEL_LIST [FEATURE_CLAUSE_AS]
			l_fl: EIFFEL_LIST [FEATURE_AS]
			l_feature: FEATURE_I
			l_old_cs, l_old_cs2: CURSOR
			l_feature_list: DS_ARRAYED_LIST [FEATURE_AS]
		do
			create l_feature_list.make_default
			if compiled_class /= Void and then compiled_class.has_feature_table then
				l_ft := compiled_class.feature_table
				from
					l_old_cs := l_ft.cursor
					l_ft.start
				until
					l_ft.after
				loop
					l_feature := l_ft.item_for_iteration
					if is_valid_feature (l_ft.item_for_iteration) then
						l_feature_list.force_last (l_ft.item_for_iteration.e_feature.ast)
					end
					l_ft.forth
				end
				l_ft.go_to (l_old_cs)
			elseif parsed_class.features /= Void then
				l_fcl := parsed_class.features
				if l_fcl /= Void then
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
									l_feature_list.force_last (l_fl.item)
								end
								l_fl.forth
							end
							l_fl.go_to (l_old_cs2)
						end
						l_fcl.forth
					end
					l_fcl.go_to (l_old_cs)
				end
			end
			update_test_routine_table (l_feature_list)
		end

	update_test_routine_table (a_routine_list: DS_LINEAR [FEATURE_AS]) is
			-- Update `test_routine_table' according to `a_routine_list' and
			-- add all create update for all notifications in `status_udpates'.
		require
			a_routine_list_not_void: a_routine_list /= Void
			a_routine_list_valid: not a_routine_list.has (Void)
		local
			l_old_table: like test_routine_table
			l_cursor: DS_LINEAR_CURSOR [FEATURE_AS]
			l_name: STRING
			l_test_routine: CDD_TEST_ROUTINE
			l_found: BOOLEAN
		do
			l_old_table := test_routine_table
			create test_routine_table.make (a_routine_list.count)

				-- Insert or update test routine for each item in `a_routine_list'
				-- Remove existing test routines in `l_old_table'
			l_cursor := a_routine_list.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_name := l_cursor.item.feature_name.name
				l_found := False
				if l_old_table /= Void then
					l_old_table.search (l_name)
					if l_old_table.found then
						l_found := True
						l_test_routine := l_old_table.found_item
						test_routine_table.put (l_test_routine, l_name)
						l_old_table.remove_found_item
						l_test_routine.set_ast (l_cursor.item)
						l_test_routine.update
						if l_test_routine.is_modified then
							status_updates.force_last (create {CDD_TEST_ROUTINE_UPDATE}.make (l_test_routine, {CDD_TEST_ROUTINE_UPDATE}.changed_code))
						end
					end
				end
				if not l_found then
					create l_test_routine.make (Current, l_cursor.item)
					test_routine_table.put (l_test_routine, l_name)
					status_updates.force_last (create {CDD_TEST_ROUTINE_UPDATE}.make (l_test_routine, {CDD_TEST_ROUTINE_UPDATE}.add_code))
				end
				l_cursor.forth
			end

				-- Add update message for each test routine left in `l_old_table'.
			if l_old_table /= Void and then not l_old_table.is_empty then
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
			add_explicit_tags
			add_implicit_tags
		end

	add_explicit_tags is
			-- Update `tags' with data from the indexing clause.
		local
			l_ast: CLASS_AS
			l_ilist: INDEXING_CLAUSE_AS
			l_item: INDEX_AS
			l_value_list: EIFFEL_LIST [ATOMIC_AS]
			v: STRING
		do
			l_ast := parsed_class
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

	add_implicit_tags is
			-- Add implicit tags for `Current' to `class_tags'.
		local
			l_tag: STRING
			is_extracted_test_case: BOOLEAN
			is_manual_test_case: BOOLEAN
		do
			if compiled_class /= void and then compiled_class.parents_classes /= void then
				from
					compiled_class.parents_classes.start
				until
					compiled_class.parents_classes.after or is_extracted_test_case
				loop
					is_extracted_test_case := compiled_class.parents_classes.item.name_in_upper.is_equal (extracted_test_class_name)
					compiled_class.parents_classes.forth
				end

					-- TODO: check if source is synthesized test case

				from
					compiled_class.parents_classes.start
				until
					compiled_class.parents_classes.after or is_extracted_test_case or is_manual_test_case
				loop
					is_manual_test_case := compiled_class.parents_classes.item.name_in_upper.is_equal (test_ancestor_class_name)
				end

				if
					is_extracted_test_case
				then
					create l_tag.make (20)
					l_tag := "source."
					l_tag.append ("extracted")
					class_tags.force (l_tag)
				elseif
					is_manual_test_case
				then
					create l_tag.make (20)
					l_tag := "source."
					l_tag.append ("manual")
					class_tags.force (l_tag)
				end
			end
		end


invariant
	test_class_name_not_void: test_class_name /= Void
	compiled_class_xor_internal_parsed_class_not_void: (compiled_class /= Void) xor (internal_parsed_class /= Void)
	compiled_class_not_void_implies_valid: (compiled_class /= Void) implies is_valid_test_class (compiled_class)
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
