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

	make_with_precondition (a_feature: AUT_FEATURE_OF_TYPE; a_access_pattern: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN]) is
			-- Initialize current with precondition `a_predicates' which should be evaluted in the context of `a_feature'.
		require
			a_feature_attached: a_feature /= Void
			a_access_pattern_attached: a_access_pattern /= Void
		local
			l_cursor: DS_LINKED_LIST_CURSOR [AUT_PREDICATE_ACCESS_PATTERN]
			l_pattern: AUT_PREDICATE_ACCESS_PATTERN

			l_constraint_arg_set: DS_HASH_SET [INTEGER]
			l_tbl: DS_HASH_TABLE [INTEGER, INTEGER]
		do
			operand_count := a_feature.feature_.argument_count + 1
			create argument_operand_mapping.make (a_access_pattern.count)
			argument_operand_mapping.set_key_equality_tester (predicate_access_pattern_equality_tester)
			create l_constraint_arg_set.make (4)

			from
				l_cursor := a_access_pattern.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_pattern := l_cursor.item
				l_tbl := l_pattern.access_pattern
				l_tbl.do_all (agent l_constraint_arg_set.force_last)
				argument_operand_mapping.force_last (l_tbl, l_pattern)
				l_cursor.forth
			end
			constraint_operand_indexes := l_constraint_arg_set
		end

feature -- Access

	argument_operand_mapping: DS_HASH_TABLE [DS_HASH_TABLE [INTEGER, INTEGER], AUT_PREDICATE_ACCESS_PATTERN]
			-- Mapping of arguments
			-- The inner hash table has the form [0-based operand index, 1-based predicate argument index]

	operand_count: INTEGER
			-- Number of operands
			-- Result = 1 + number of arguments in feature.

	constraint_operand_indexes: DS_HASH_SET [INTEGER]
			-- 0-based indexes of feature call variables that are constraint

	operand_index (a_pattern: AUT_PREDICATE_ACCESS_PATTERN; a_predicate_argument_index: INTEGER): INTEGER is
			-- 0-based feature call index of argument in 1-based position `a_predicate_argument_index' in `a_pattern'
		require
			a_pattern_attached: a_pattern /= Void
			a_predicate_argument_index_valid: a_predicate_argument_index > 0 and then a_predicate_argument_index <= a_pattern.predicate.arity
		do
			Result := argument_operand_mapping.item (a_pattern).item (a_predicate_argument_index)
		ensure
			good_result: Result = argument_operand_mapping.item (a_pattern).item (a_predicate_argument_index)
		end

	access_patterns: DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN] is
			-- Predicates associated in `argument_operand_mapping'.
		do
			create Result.make_from_linear (argument_operand_mapping.keys)
			Result.set_equality_tester (predicate_access_pattern_equality_tester)
		ensure
			result_attached: Result /= Void
			good_result: argument_operand_mapping.keys.for_all (agent Result.has)
		end

	associated_predicates: DS_HASH_SET [AUT_PREDICATE] is
			-- Predicates associated with current constraint
			-- Note: In Current constraint, a predicate can appear for more than once,
			-- becauese a feature can have the same predicates as different precondition assertions,
			-- but in here, only distinct predicates are returned.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_TABLE [INTEGER, INTEGER], AUT_PREDICATE_ACCESS_PATTERN]
		do
			create Result.make (argument_operand_mapping.count)
			Result.set_equality_tester (predicate_equality_tester)
			from
				l_cursor := argument_operand_mapping.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_cursor.key.predicate)
				l_cursor.forth
			end
		ensure
			result_attached: Result /= Void
			result_count_valid: Result.count <= argument_operand_mapping.count
			result_valid: argument_operand_mapping.keys.for_all (
				agent (a_ptn: AUT_PREDICATE_ACCESS_PATTERN; a_set: DS_HASH_SET [AUT_PREDICATE]): BOOLEAN
					do
						Result := a_set.has (a_ptn.predicate)
					end (?, Result)
				)
		end

feature -- Status report

	has_predicate (a_predicate: AUT_PREDICATE): BOOLEAN is
			-- Is `a_predicate' contained in current constraint?
		require
			a_predicate_attached: a_predicate /= Void
		do
			Result := associated_predicates.has (a_predicate)
		ensure
			good_result: Result = associated_predicates.has (a_predicate)
		end

	is_constraint_operand_bound (a_variables: ARRAY [detachable ITP_VARIABLE]): BOOLEAN is
			-- Are all variables whose indexes are given by `constraint_operand_indexes'
			-- are bound in `a_variables'?
		require
			a_variables_attached: a_variables /= Void
			a_variables_index_valid: a_variables.lower = 0 and then a_variables.count = operand_count
		do
			Result := constraint_operand_indexes.for_all (
				agent (a_index: INTEGER; a_vars: ARRAY [detachable ITP_VARIABLE]): BOOLEAN
					do
						Result := a_vars.item (a_index) /= Void
					end (?, a_variables)
				)
		end

invariant
	argument_mapping_attached: argument_operand_mapping /= Void
	distinct_argument_count_positive: operand_count > 0
	constraint_variable_indexes_attached: constraint_operand_indexes /= Void

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
