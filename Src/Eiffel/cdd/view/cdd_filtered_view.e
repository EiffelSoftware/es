indexing
	description: "Objects that filter test classes/routines for a given test suite"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_FILTERED_VIEW

create
	make

feature {NONE} -- Initialization

	make (a_test_suite: like test_suite) is
			-- Create a filter for `a_test_suite'.
		require
			a_test_suite_not_void: a_test_suite /= Void
		do
			create change_actions.make
			test_suite := a_test_suite
			create filters.make_default
			change_agent := agent refresh
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
			Result := test_suite.change_actions.has (change_agent)
		end

feature {ANY} -- Access

	test_suite: CDD_TEST_SUITE
			-- Test suite containing test cases to be filtered

	test_routines: DS_LINEAR [CDD_TEST_ROUTINE] is
			-- Test routines from `test_suite' matching filter criterion
		do
			if test_routines_cache = Void then
				refresh
			end
			Result := test_routines_cache
		ensure
			test_routines_not_void: Result /= Void
			test_routines_doesnt_have_void: not Result.has (Void)
		end

	filters: DS_ARRAYED_LIST [STRING]
			-- List of tag patterns, restricting what routines should
			-- be in this view of the test suite.

feature -- Event handling

	change_actions: ACTION_SEQUENCE [TUPLE]
			-- Actions to be executed whenever test suite has changed;
			-- E.g.: test routine added, removed, changed
			-- For efficiency reasons changes are grouped together in transactions.
			-- TODO: Add list of changes as arguments so observers can be more
			-- efficient in updating their state.

feature {ANY} -- Status setting

	enable_observing is
			-- Enable auto update mode.
		require
			not_observing: not is_observing
		do
			test_suite.change_actions.force (change_agent)
		ensure
			observing: is_observing
		end

	disable_observing is
			-- Disable auto update mode.
		require
			observing: is_observing
		do
			test_suite.change_actions.prune (change_agent)
		ensure
			not_observing: not is_observing
		end

feature {ANY} -- Element change

	refresh is
			-- Update `test_routines_cache' with information from `test_suite'.
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
			change_actions.call (Void)
		end

feature {NONE} -- Implementation

	test_routines_cache: DS_ARRAYED_LIST [CDD_TEST_ROUTINE]
			-- Cache for `test_routines'

	internal_refresh_action: PROCEDURE [like Current, TUPLE]
			-- Agent subscribed in test suite. Needed for
			-- unsubscription.

	change_agent: PROCEDURE [ANY, TUPLE]

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
	filters_not_void: filters /= Void
	filters_doesnt_have_void: not filters.has (Void)

end
