indexing
	description: "Objects that filter test classes/routines for a given test suite"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_FILTERED_VIEW

inherit

	CDD_ACTIVE_VIEW

	KL_SHARED_STRING_EQUALITY_TESTER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_test_suite: like test_suite) is
			-- Create a filter for `a_test_suite'.
		require
			a_test_suite_not_void: a_test_suite /= Void
		do
			create change_actions
			test_suite := a_test_suite
			create internal_filters.make (0)
			internal_filters.set_equality_tester (case_insensitive_string_equality_tester)
			change_agent := agent incremental_refresh
		ensure
			test_suite_set: test_suite = a_test_suite
		end

feature {ANY} -- Status Report

	is_matching_routine (a_routine: CDD_TEST_ROUTINE): BOOLEAN is
			-- Does `a_routine' satisfy the filter criteria of
			-- this filter? If there are no filter criteria any test
			-- case matches. If there are more than zero criteria a test
			-- case matches iff at least one filter criterion is a substring
			-- of at least one of the tags of the test routine.
		require
			a_routine_not_void: a_routine /= Void
		local
			cs: DS_LINEAR_CURSOR [STRING]
		do
			if filters.count > 0 then
				from
					cs := filters.new_cursor
					cs.start
				until
					cs.off or Result
				loop
					Result := a_routine.has_matching_tag (cs.item)
					cs.forth
				end
				cs.go_after
			else
				-- Every test case matches, if no filter criterion is present.
				Result := True
			end
		end

	is_observing: BOOLEAN is
			-- Is this filter observing `test_suite'?
			-- If it is then changes to `test_suite' will be
			-- reflected by this filter immediately, otherwise
			-- `refresh' must be called.
		do
			Result := test_suite.test_routine_update_actions.has (change_agent)
		end

feature {ANY} -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases to be filtered

	test_routines: DS_LINEAR [CDD_TEST_ROUTINE] is
			-- Test routines from `test_suite' matching filter criterion
		require
			observing: is_observing
		do
			if test_routines_cache = Void then
				fill_test_routines_cache
			end
			Result := test_routines_cache
		ensure
			test_routines_not_void: Result /= Void
			test_routines_doesnt_have_void: not Result.has (Void)
		end

	filters: DS_LINEAR [STRING] is
			-- List of tag patterns, restricting what routines should
			-- be in this view of the test suite.
		do
			Result := internal_filters
		ensure
			not_void: Result /= Void
			valid: not Result.has (Void)
		end

feature -- Status setting

	set_filters (new_tags: like filters) is
			-- Set `filters' to `new_tags' and adopt `test_routine' to new filters.
		require
			new_tags_not_void: new_tags /= Void
		local
			l_old_tags: like internal_filters
			l_cursor: DS_LINEAR_CURSOR [STRING]
		do
			l_old_tags := internal_filters
			create internal_filters.make (new_tags.count)
			internal_filters.set_equality_tester (case_insensitive_string_equality_tester)
			l_cursor := new_tags.new_cursor
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				internal_filters.force (l_cursor.item)
				l_cursor.forth
			end
			if not internal_filters.is_equal (l_old_tags) then
					-- NOTE: To further optimize filtering, one could
					-- implement an incremental update for each removed
					-- or added tag in `internal_filter'. For now we
					-- will just simply refresh the view.
				wipe_out_test_routines_cache
			end
		ensure

		end

feature -- Event handling

	change_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be executed whenever test suite has changed;
			-- E.g.: test routine added, removed, changed
			-- For efficiency reasons changes are grouped together in transactions.
			-- TODO: Add list of changes as arguments so observers can be more
			-- efficient in updating their state.


feature {NONE} -- Status setting

	enable_observing is
			-- Enable auto update mode.
		do
			test_suite.test_routine_update_actions.force (change_agent)
		end

	disable_observing is
			-- Disable auto update mode.
		do
			test_suite.test_routine_update_actions.prune (change_agent)
			wipe_out_test_routines_cache
		end

feature {NONE} -- Element change

	incremental_refresh (a_list: DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]) is
			-- Incremental update of `test_routines_cache' applying changes
			-- from `a_list'
		require
			observing: is_observing
		do
			-- TODO: implement incremental update.
			refresh
		end

	refresh is
			-- Wipe out `test_routines_cache' and call observers.
		require
			observing: is_observing
		do
			wipe_out_test_routines_cache
			change_actions.call ([Void])
		end

	fill_test_routines_cache is
			-- Update `test_routines_cache' with information from `test_suite'.
		require
			observing: is_observing
			cache_void: test_routines_cache = Void
		local
			class_cs: DS_LINEAR_CURSOR [CDD_TEST_CLASS]
			routine_cs: DS_LINEAR_CURSOR [CDD_TEST_ROUTINE]
		do
			from
				class_cs := test_suite.test_classes.new_cursor
				class_cs.start
				create test_routines_cache.make_default
			until
				class_cs.off
			loop
				from
					routine_cs := class_cs.item.test_routines.new_cursor
					routine_cs.start
				until
					routine_cs.off
				loop
					if is_matching_routine (routine_cs.item) then
						test_routines_cache.force_last (routine_cs.item)
					end
					routine_cs.forth
				end
				class_cs.forth
			end
		ensure
			test_routines_cache_not_void: test_routines_cache /= Void
		end

feature {NONE} -- Implementation

	test_routines_cache: DS_ARRAYED_LIST [CDD_TEST_ROUTINE]
			-- Cache for `test_routines'

	internal_filters: DS_HASH_SET [STRING]
			-- List of tag patterns, restricting what routines should
			-- be in this view of the test suite.

	change_agent: PROCEDURE [ANY, TUPLE [DS_LINEAR [CDD_TEST_ROUTINE_UPDATE]]]
			-- Agent called when `test_suite' changes

	wipe_out_test_routines_cache is
			-- Remove all entries from cache of test routines.
		do
			test_routines_cache := Void
		ensure
			test_routines_void: test_routines_cache = Void
		end

invariant

	test_suite_not_void: test_suite /= Void
	change_actions_not_void: change_actions /= Void
	change_agent_not_void: change_agent /= Void
	not_observing_implies_test_routines_cache_void: (not is_observing) implies test_routines_cache = Void
	test_routines_cache_not_void_implies_valid: test_routines_cache /= Void implies
			test_routines_cache.for_all (agent is_matching_routine)
	internal_filters_not_void: filters /= Void
	internal_filters_doesnt_have_void: not filters.has (Void)
	internal_filter_has_valid_equality_tester: filters.equality_tester = case_insensitive_string_equality_tester

end
