note
	description: "Summary description for {AUT_PREDICATE_CONSTRAINT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_CONSTRAINT

inherit
	AUT_SHARED_PREDICATE_CONTEXT

create
	make_with_precondition

feature{NONE} -- Initialization

	make_with_precondition (a_feature: AUT_FEATURE_OF_TYPE; a_predicates: DS_LIST [AUT_PREDICATE]) is
			-- Initialize current with precondition `a_predicates' which should be evaluted in the context of `a_feature'.
		require
			a_feature_attached: a_feature /= Void
			a_predicates_attached: a_predicates /= Void
			a_predicates_valid: not a_predicates.has (Void)
			a_predicates_in_a_feature: a_predicates.for_all (agent (preconditions_of_feature.item (a_feature)).has)
			access_pattern_exists: predicate_access_pattern.has (a_feature)
			a_predicates_associated_with_a_feature: a_predicates.for_all (agent (predicate_access_pattern_table.item (a_feature)).has)
		local
			l_cursor: DS_LIST_CURSOR [AUT_PREDICATE]
			l_predicate: AUT_PREDICATE
			l_access_pattern_tbl: DS_HASH_TABLE [AUT_PREDICATE_ACCESS_PATTERN, AUT_PREDICATE]
		do
			distinct_argument_count := a_feature.feature_.argument_count + 1
			l_access_pattern_tbl := predicate_access_pattern_table.item (a_feature)
			create argument_mapping.make (a_predicates.count)
			argument_mapping.set_key_equality_tester (predicate_equality_tester)
			from
				l_cursor := a_predicates.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_predicate := l_cursor.item
				argument_mapping.force_last_new (table_with_value_key_swapped (l_access_pattern_tbl.item (l_predicate).access_pattern), l_predicate)
				l_cursor.forth
			end
		end

feature -- Access

	argument_mapping: DS_HASH_TABLE [DS_HASH_TABLE [INTEGER, INTEGER], AUT_PREDICATE]
			-- Mapping of arguments
			-- The inner hash table has the form [0-based feature call argument index, 1-based predicate argument index]

	distinct_argument_count: INTEGER
			-- Number of different arguments

	index_of_predicate_argument (a_predicate: AUT_PREDICATE; a_predicate_argument_index: INTEGER): INTEGER is
			-- 0-based feature call index of argument in 1-based position `a_predicate_argument_index' in `a_predicate'
		require
			a_predicate_attached: a_predicate /= Void
			a_predicate_in_current: has_predicate (a_predicate)
			a_predicate_argument_index_valid: a_predicate_argument_index >= 1 and then a_predicate_argument_index <= a_predicate.arity
		do
			Result := argument_mapping.item (a_predicate).item (a_predicate_argument_index)
		ensure
			good_result: Result = argument_mapping.item (a_predicate).item (a_predicate_argument_index)
		end

	associated_predicates: DS_LINKED_LIST [AUT_PREDICATE] is
			-- Predicates associated in `argument_mapping'.
		do
			create Result.make_from_linear (argument_mapping.keys)
		ensure
			result_attached: Result /= Void
			good_result: argument_mapping.keys.for_all (agent Result.has)
		end

feature -- Status report

	has_predicate (a_predicate: AUT_PREDICATE): BOOLEAN is
			-- Is `a_predicate' contained in current constraint?
		require
			a_predicate_attached: a_predicate /= Void
		do
			Result := argument_mapping.has (a_predicate)
		ensure
			good_result: Result = argument_mapping.has (a_predicate)
		end

feature{NONE} -- Implementation

	table_with_value_key_swapped (a_table: DS_HASH_TABLE [INTEGER, INTEGER]): like a_table is
			-- Table with value and key swapped from `a_table'.
		require
			a_table_attached: a_table /= Void
		do
			to_implement ("Refactoring: consider swap the value and key in {AUT_PREDICATE_ACCESS_PATTERN}.access_pattern so we don't need current feature anymore.")
			a_table.do_all_with_key (
				agent (v: INTEGER; k: INTEGER; tbl: DS_HASH_TABLE [INTEGER, INTEGER])
					do
						tbl.force_last (k, v)
					end (?, ?, Result))
		ensure
			result_attached: Result /= Void
			result_valid: Result.count = a_table.count
		end

invariant
	argument_mapping_attached: argument_mapping /= Void
	distinct_argument_count_positive: distinct_argument_count > 0

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
