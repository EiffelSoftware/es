note
	description: "Summary description for {AUT_SHARED_PREDICATE_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_SHARED_PREDICATE_CONTEXT

inherit
	AUT_PREDICATE_UTILITY

feature -- Access

	features_under_test: DS_HASH_SET [AUT_FEATURE_OF_TYPE] is
			-- Features under test
		once
			create Result.make (100)
			Result.set_equality_tester (feature_of_type_loose_equality_tester)
		ensure
			result_attached: Result /= Void
			good_result: not Result.has (Void)
		end

	predicates: DS_HASH_SET [AUT_PREDICATE] is
			-- Predicates that are managed in current test session
			-- Note: Should only be manipulated by `put_predicate'.
		once
			create Result.make (100)
			Result.set_equality_tester (predicate_equality_tester)
		ensure
			result_attached: Result /= Void
			good_result: not Result.has (Void)
		end

	predicate_table: DS_HASH_TABLE [AUT_PREDICATE, INTEGER] is
			-- Predicate table indexed by {AUT_PREDICATE}.`id'
			-- Note: Should only be manipulated by `put_predicate'.
		once
			create Result.make (100)
		ensure
			result_attached: Result /= Void
		end

	precondition_access_pattern: DS_HASH_TABLE [DS_HASH_SET [AUT_PREDICATE_ACCESS_PATTERN], AUT_FEATURE_OF_TYPE] is
			-- Precondition predicate access patterns of features
			-- Only predicates appearing in preconditions should be stored here.
			-- This should be a subset of `predicate_access_pattern'.
			-- [Access pattern, feature]
			-- Note: should only be modified by `put_precondition_access_pattern'.
		once
			create Result.make (100)
			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
		ensure
			result_attached: Result /= Void
		end

	predicate_feature_table: DS_HASH_TABLE [DS_HASH_SET [AUT_FEATURE_OF_TYPE], AUT_PREDICATE] is
			-- Table from predicates to features.
			-- [List of features which have the predicate as precondition, predicate]
			-- Note: Should only be modified by `put_predicate_in_feature_table'.
		once
			create Result.make (100)
			Result.set_key_equality_tester (predicate_equality_tester)
		ensure
			result_attached: Result /= Void
		end



--	predicate_access_pattern: DS_HASH_TABLE [DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN], AUT_FEATURE_OF_TYPE] is
--			-- Predicate access patterns associated with a feature.
--			-- Predicates associated with a feature can be preconditions, postconditions and all "interesting" predcates
--			-- extracted from the code or provided by programmers.
--			-- [Access pattern, feature]
--			-- Note: Should be modified only by `put_predicate_access_pattern'.
--		once
--			create Result.make (100)
--			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
--		ensure
--			result_attached: Result /= Void
--		end

--	preconditions_of_feature: DS_HASH_TABLE [DS_HASH_SET [AUT_PREDICATE], AUT_FEATURE_OF_TYPE] is
--			-- Precondition predicates of features which are under test
--			-- [Precondition predicate set, feature]
--		once
--			create Result.make (100)
--			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
--		ensure
--			result_attached: Result /= Void
--			good_result: not Result.has (Void)
--		end

--	predicate_access_pattern_table: DS_HASH_TABLE [DS_HASH_TABLE [AUT_PREDICATE_ACCESS_PATTERN, AUT_PREDICATE], AUT_FEATURE_OF_TYPE] is
--			-- Table of predicate access patterns associated with a feature.
--			-- Predicates associated with a feature can be preconditions, postconditions and all "interesting" predcates
--			-- extracted from the code or provided by programmers.
--			-- [[Access pattern, predicate], feature]
--			-- Note: Should be modified only by `put_predicate_access_pattern'.
--		once
--			create Result.make (100)
--			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
--		ensure
--			result_attached: Result /= Void
--		end

	relevant_predicates_of_feature: DS_HASH_TABLE [DS_HASH_TABLE [DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]], AUT_PREDICATE], AUT_FEATURE_OF_TYPE] is
			-- Relevant predicates of features which are under test
			-- A predicate is relevent to a feature means that after execution of that feature
			-- the predicate needs to be reevaluated because the execution may change the value of the predicate.
			-- [Predicate set and their evaluation arrangement, feature]
		once
			create Result.make (100)
			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
		ensure
			result_attached: Result /= Void
			good_result: not Result.has (Void)
		end

	class_types_under_test: DS_ARRAYED_LIST [CL_TYPE_A] is
			-- Types under test
		once
			create Result.make (10)
		ensure
			result_attached: Result /= Void
			good_result: not Result.has_void
		end

	typed_object_pool: AUT_TYPED_OBJECT_POOL is
			-- Type object pool
		do
			Result := typed_object_pool_cell.item
		ensure
			good_result: Result = typed_object_pool_cell.item
		end

	typed_object_pool_cell: CELL [detachable AUT_TYPED_OBJECT_POOL] is
			-- Cell for `typed_object_pool'
		once
			create Result.put (Void)
		end

	predicate_pool: AUT_PREDICATE_POOL is
			-- Predicate pool
		once
			create Result.make
		ensure
			result_attached: Result /= Void
		end

	constant_pool: AUT_CONSTANT_POOL is
			-- Constant pool
		once
			create Result.make
		ensure
			result_attached: Result /= Void
		end

	feature_invalid_test_case_rate: DS_HASH_TABLE [TUPLE [invalid_times: INTEGER; all_times: INTEGER; last_tested_time: INTEGER], AUT_FEATURE_OF_TYPE] is
			-- Table for invalid test case rate of features
			-- `invalid_times' is the number of times which the feature fails because precondition violation.
			-- `all_times' is the number of times that the feature has been tried to test
			-- `last_tested_time' is the number of second (from the start of the current test sesseion)
			--  when the feature is tested for the last time.
		once
			create Result.make (100)
			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
		ensure
			result_attached: Result /= Void
		end

	used_integer_values: DS_HASH_TABLE [AUT_INTEGER_VALUE_SET, AUT_FEATURE_OF_TYPE] is
			-- Used integers from linear constraint solver for features
		once
			create Result.make (50)
			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
		ensure
			result_attached: Result /= Void
		end

	predefined_integers: LINKED_LIST [INTEGER] is
			-- Predefined integers
		once
			create Result.make
			Result.extend (0)
			Result.extend (1)
			Result.extend (2)
			Result.extend (3)
			Result.extend (4)
			Result.extend (5)
			Result.extend (6)
			Result.extend (7)
			Result.extend (8)
			Result.extend (9)
			Result.extend (10)
			Result.extend (-1)
			Result.extend (-2)
			Result.extend (-3)
			Result.extend (-4)
			Result.extend (-5)
			Result.extend (-6)
			Result.extend (-7)
			Result.extend (-8)
			Result.extend (-9)
			Result.extend (-10)
			Result.extend (100)
			Result.extend (-100)
--			Result.extend ({INTEGER}.Min_value)
--			Result.extend ({INTEGER}.Max_value)
		ensure
			result_attached: Result /= Void
		end

	feature_id_table: DS_HASH_TABLE [INTEGER, STRING] is
			-- Table of feature id
			-- [Feature ID, feature_name]
			-- feature_name is in the form of "CLASS_NAME.feature_name'.
		once
			create Result.make (200)
			Result.set_key_equality_tester (string_equality_tester)
		end

	relevant_predicate_with_operand_table: DS_HASH_TABLE [ARRAY [TUPLE [predicate_id: INTEGER; operand_indexes: SPECIAL [INTEGER]]], INTEGER]
			-- Table of predicates that are to be evaluated after the execution of some feature.
			-- Key is feature id.
		once
			create Result.make (200)
		end

feature -- Basic operations

	put_predicate (a_predicate: AUT_PREDICATE) is
			-- Put `a_predicate' into `predicates' and `predicate_table'.
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_not_exist: not predicates.has (a_predicate)
		do
			predicates.force_last (a_predicate)
			predicate_table.force_last (a_predicate, a_predicate.id)
		ensure
			predicate_put: predicates.has (a_predicate)
			predicate_table_put: predicate_table.has (a_predicate.id) and then predicate_table.item (a_predicate.id) = a_predicate
		end

	put_precondition_access_pattern (a_feature: AUT_FEATURE_OF_TYPE; a_access_patterns: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN]) is
			-- Put `a_access_patterns' for `a_feature' into `precondition_access_pattern'.
		require
			a_feature_attached: a_feature /= Void
			a_access_patterns_attached: a_access_patterns /= Void
			a_access_patterns_not_has_void: not a_access_patterns.has (Void)
		local
			l_patterns: DS_HASH_SET [AUT_PREDICATE_ACCESS_PATTERN]
		do
			create l_patterns.make (a_access_patterns.count)
			a_access_patterns.do_all (agent l_patterns.force_last)
			precondition_access_pattern.force_last (l_patterns, a_feature)
		end

	put_precondition_of_feature (a_feature: AUT_FEATURE_OF_TYPE; a_preconditions: DS_LINKED_LIST [AUT_PREDICATE]) is
			-- Put `a_preconditions' into `preconditions_of_feature' for `a_feature'.
		require
			a_feature_attached: a_feature /= Void
			a_preconditions_attached: a_preconditions /= Void
		local
			l_set: DS_HASH_SET [AUT_PREDICATE]
		do
			create l_set.make (a_preconditions.count)
			l_set.set_equality_tester (predicate_equality_tester)
			a_preconditions.do_all (agent l_set.force_last)
--			preconditions_of_feature.force_last (l_set, a_feature)
		end

	put_predicate_in_feature_table (a_predicate: AUT_PREDICATE; a_feature: AUT_FEATURE_OF_TYPE) is
			-- Put `a_feature' with `a_predicate' into `predicate_feature_table'.
		require
			a_predicate_attached: a_predicate /= Void
			a_feature_attached: a_feature /= Void
		local
			l_table: like predicate_feature_table
			l_features: DS_HASH_SET [AUT_FEATURE_OF_TYPE]
		do
			l_table := predicate_feature_table
			l_table.search (a_predicate)
			if l_table.found then
				l_features := l_table.found_item
			else
				create l_features.make (20)
				l_features.set_equality_tester (feature_of_type_loose_equality_tester)
				l_table.force_last (l_features, a_predicate)
			end
			l_features.force_last (a_feature)
		end

feature -- Feature selection

	high_priority_features: LINKED_QUEUE [AUT_FEATURE_OF_TYPE] is
			-- Features that are to be selected first
			-- because part of their preconditions assertions
			-- are observed to be True
		once
			create Result.make
		end

	high_priority_feature_set: DS_HASH_SET [AUT_FEATURE_OF_TYPE] is
			-- Set storage of `high_priority_features' for fast lookup
		do
			create Result.make (10)
			Result.set_equality_tester (feature_of_type_loose_equality_tester)
		end

	mark_feature_as_high_priority (a_feature: AUT_FEATURE_OF_TYPE) is
			-- Mark `a_feature' as high priority for test
		require
			a_feature_attached: a_feature /= Void
		do
			if not high_priority_feature_set.has (a_feature) and then high_priority_features.count < max_feature_as_high_priority then
				high_priority_feature_set.force_last (a_feature)
				high_priority_features.extend (a_feature)
			end
		end

	unmark_feature_as_high_priority is
			-- Unmark `a_feature' as high priority for test
		local
			l_feature: AUT_FEATURE_OF_TYPE
		do
			if not high_priority_features.is_empty then
				l_feature := high_priority_features.item
				high_priority_features.remove
				high_priority_feature_set.remove (l_feature)
			end
		end

	max_feature_as_high_priority: INTEGER is 2
			-- Max number of features in `high_priority_features'


	enforce_precondition_satisfaction: BOOLEAN is
			-- Should precondition satisfaction be enforced for the next feature?
		do
			Result := enforce_precondition_satisfaction_cell.item
		end

	enforce_precondition_satisfaction_cell: CELL [BOOLEAN] is
			-- Cell to store value for `enforce_precondition_satisfaction'
		once
			create Result.put (False)
		end

	set_enforce_precondition_satisfaction (b: BOOLEAN) is
			-- Set `enforce_precondition_satisfaction' with `b'.
		do
			enforce_precondition_satisfaction_cell.put (b)
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
