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
		once
			create Result.make (100)
			Result.set_equality_tester (predicate_equality_tester)
		ensure
			result_attached: Result /= Void
			good_result: not Result.has (Void)
		end

	preconditions_of_feature: DS_HASH_TABLE [DS_HASH_SET [AUT_PREDICATE], AUT_FEATURE_OF_TYPE] is
			-- Precondition predicates of features which are under test
			-- [Precondition predicate set, feature]
		once
			create Result.make (100)
			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
		ensure
			result_attached: Result /= Void
			good_result: not Result.has (Void)
		end

	precondition_access_pattern: DS_HASH_TABLE [DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN], AUT_FEATURE_OF_TYPE] is
			-- Precondition predicate access patterns of features
			-- [Access pattern, feature]
		once
			create Result.make (100)
			Result.set_key_equality_tester (feature_of_type_loose_equality_tester)
		ensure
			result_attached: Result /= Void
		end

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
