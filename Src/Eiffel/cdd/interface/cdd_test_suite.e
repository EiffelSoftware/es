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

	CDD_CONSTANTS
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
			create add_test_case_actions
			create remove_test_case_actions
			create refresh_actions
		ensure
			target_set: target = a_target
		end

feature -- Access

	target: CONF_TARGET
			-- Target in which `Current' will look for test cases.

	test_cases: DS_LINKED_LIST [CDD_TEST_CASE]
			-- Sorted list with all test cases

	has_test_case_for_class (a_class: CLASS_C): BOOLEAN is
			-- Does `test_cases' contain a test case for test case class `a_class'?
		require
			a_class_not_void: a_class /= Void
		do
			Result := has_test_case_with_property (agent (a_tc: CDD_TEST_CASE; a_cl: CLASS_C): BOOLEAN
					do
						Result := a_tc.test_class = a_cl
					end (?, a_class)
				)
		end

	last_sort_result: DS_LINKED_LIST [CDD_TEST_CASE]
			-- Result from last `sort_by_target' or `sort_by_stack'

feature -- Status setting

	refresh is
			-- Check `eiffel_universe' for new or removed
			-- test cases and update `test_cases'.
		local
			l_uni: UNIVERSE_I
			l_classes: LIST [CLASS_I]
			l_class: CLASS_I
			l_comp_class: CLASS_C
			l_list: ARRAYED_LIST [CLASS_C]
			l_changed: BOOLEAN
			l_tc: CDD_TEST_CASE
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			l_uni := eiffel_universe
			l_classes := l_uni.classes_with_name (abstract_extracted_class_name)
			if not l_classes.is_empty then
				l_class := l_classes.first
				if l_class.is_compiled then
					l_comp_class := l_class.compiled_class
					l_list := l_comp_class.descendants
						-- Add test cases for new classes
					from
						l_list.start
					until
						l_list.after
					loop
						if not has_test_case_for_class (l_list.item) then
							create l_tc.make_with_class (l_list.item)
							test_cases.put_last (l_tc)
							add_test_case_actions.call ([l_tc])
							l_changed := True
						end
						l_list.forth
					end
						-- Remove test cases for which no class exists
					from
						create l_cursor.make (test_cases)
						l_cursor.start
					until
						l_cursor.after or test_cases.count = l_list.count
					loop
						if not l_list.has (l_cursor.item.test_class) then
							l_changed := True
							l_cursor.remove
						else
							l_cursor.forth
						end
					end
				end
			end
			if l_list = Void and not test_cases.is_empty then
				test_cases.wipe_out
				l_changed := True
			end
			if l_changed or not has_refreshed then
				refresh_actions.call ([])
			end
			has_refreshed := True
		end

feature -- Event handling

	add_test_case_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_CASE]]
			-- Agents called when test case is added to `Current'

	remove_test_case_actions: ACTION_SEQUENCE [TUPLE [CDD_TEST_CASE]]
			-- Agents called when test case is removed from `Current'

	refresh_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when `Current' changed its status

feature -- Basic operations

	sort_by_target (a_cluster, a_class, a_feature: STRING) is
			-- Sort `test_cases' by cluster/class/feature name. If any of `a_cluster', `a_class'
			-- or `a_feature' are provided, only include test cases matching the given names.
		do
			extract_test_cases_with_property (
				agent (a_tc: CDD_TEST_CASE; a_cluster_name, a_class_name, a_feature_name: STRING): BOOLEAN
					do
						Result := (a_cluster_name = Void or else a_cluster_name.is_equal (a_tc.cluster_name)) and
							(a_class_name = Void or else a_class_name.is_equal (a_tc.class_name)) and
							(a_feature_name = Void or else a_feature_name.is_equal (a_tc.feature_name))
					end (?, a_cluster, a_class, a_feature))
			sort_with_comparator (
				agent (a_tc1, a_tc2: CDD_TEST_CASE): BOOLEAN
					do
						if a_tc1.cluster_name < a_tc2.cluster_name then
							Result := True
						elseif a_tc1.cluster_name.is_equal (a_tc2.cluster_name) then
							if a_tc1.class_name < a_tc2.class_name then
								Result := True
							elseif a_tc1.class_name.is_equal (a_tc2.class_name) then
								if a_tc1.feature_name < a_tc2.feature_name then
									Result := True
								elseif a_tc1.feature_name.is_equal (a_tc2.class_name) then
									Result := a_tc1.test_class < a_tc2.test_class
								end
							end
						end
					end)
		ensure
			last_sort_result_not_void: last_sort_result /= Void
		end

feature {NONE} -- Implementation

	has_refreshed: BOOLEAN
			-- Have we already done refresh before?

	has_test_case_with_property (a_prop: FUNCTION [ANY, TUPLE [CDD_TEST_CASE], BOOLEAN]): BOOLEAN is
			-- Does `test_cases' contain an item, for which `a_prop' returns True?
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			from
				create l_cursor.make (test_cases)
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

	extract_test_cases_with_property (a_prop: FUNCTION [ANY, TUPLE [CDD_TEST_CASE], BOOLEAN]) is
			-- Create `last_sort_result' containing all test cases in
			-- `test_cases' which satisfy `a_prop'.
		require
			a_prop_not_void: a_prop /= Void
		local
			l_cursor: DS_LINKED_LIST_CURSOR [CDD_TEST_CASE]
		do
			create l_cursor.make (test_cases)
			create last_sort_result.make
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				if a_prop.eval ([l_cursor.item]) then
					last_sort_result.put_last (l_cursor.item)
				end
				l_cursor.forth
			end
		ensure
			last_sort_result_not_void: last_sort_result /= Void
			last_sort_result_valid: last_sort_result.for_all (a_prop)
		end

	sort_with_comparator (a_comp: FUNCTION [ANY, TUPLE [CDD_TEST_CASE, CDD_TEST_CASE], BOOLEAN]) is
			-- Sort `last_sort_result' for a given comparator `a_comp'.
		require
			a_comp_not_void: a_comp /= Void
			last_sort_result_not_void: last_sort_result /= Void
		local
			l_ss: DS_SHELL_SORTER [CDD_TEST_CASE]
		do
			create l_ss.make (create {AGENT_BASED_EQUALITY_TESTER [CDD_TEST_CASE]}.make (a_comp))
			last_sort_result.sort (l_ss)
		ensure
			last_sort_result_not_void: last_sort_result /= Void
			last_sort_result_sorted: last_sort_result.sorted (create {DS_SHELL_SORTER [CDD_TEST_CASE]}.make (create {AGENT_BASED_EQUALITY_TESTER [CDD_TEST_CASE]}.make (a_comp)))
		end

invariant
	target_not_void: target /= Void
	test_cases_not_void: test_cases /= Void

end
