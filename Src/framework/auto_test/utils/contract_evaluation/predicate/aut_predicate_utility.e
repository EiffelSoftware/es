note
	description: "Summary description for {AUT_PREDICATE_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_UTILITY

inherit
	ERL_G_TYPE_ROUTINES

	SHARED_WORKBENCH

	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Access

	feature_signature_type_equality_tester: AGENT_BASED_EQUALITY_TESTER [AUT_FEATURE_SIGNATURE_TYPE] is
			-- Equality tester for {AUT_FEATURE_SIGNATURE_TYPE}
		do
			create Result.make (
				agent (a, b: AUT_FEATURE_SIGNATURE_TYPE): BOOLEAN
					do
						Result := a.position = b.position and then a.type.same_type (b.type) and then a.type.is_equivalent (b.type)
					end
				)
		end

	predicate_equality_tester: AGENT_BASED_EQUALITY_TESTER [AUT_PREDICATE] is
			-- Equality tester for predicate
		do
			create Result.make (agent (a, b: AUT_PREDICATE): BOOLEAN do Result := a = b or else a.is_equal (b) end)
		end

	feature_of_type_equality_tester: AUT_FEATURE_OF_TYPE_EQUALITY_TESTER is
			-- Equality tester for feature of type
		do
			create Result.make
		end

	feature_of_type_loose_equality_tester: AUT_FEATURE_OF_TYPE_EQUALITY_TESTER is
			-- Equality tester for feature of type
			-- Doesn't take {AUT_FEATURE_OF_TYPE}.is_creator into consideration.
		do
			create Result.make_with_creator_flag (False)
		end

	feature_of_type_name_equality_tester (a_system: SYSTEM_I): AUT_FEATURE_OF_TYPE_NAME_EQUALITY_TEST is
			-- Equality tester for feature of type based on feature names
		do
			create Result.make (a_system)
		end

	hashable_variable_array_equality_tester: AGENT_BASED_EQUALITY_TESTER [AUT_HASHABLE_ITP_VARIABLE_ARRAY] is
			-- Equality tester for hashable variable array
		do
			create Result.make (agent (a, b: AUT_HASHABLE_ITP_VARIABLE_ARRAY): BOOLEAN do Result := a.is_equal (b) end)
		end

	predicate_access_pattern_equality_tester: AGENT_BASED_EQUALITY_TESTER [AUT_PREDICATE_ACCESS_PATTERN] is
			-- Equality test for predicate access pattern
		do
			create Result.make (agent (a, b: AUT_PREDICATE_ACCESS_PATTERN): BOOLEAN do Result := a.is_equal (b) end)
		end

	variable_equality_tester: AGENT_BASED_EQUALITY_TESTER [ITP_VARIABLE] is
			-- Equality test for predicate access pattern
		do
			create Result.make (agent (a, b: ITP_VARIABLE): BOOLEAN do Result := a.index = b.index end)
		end
feature -- Access

	testable_features_from_type (a_type: TYPE_A; a_system: SYSTEM_I): DS_LINKED_LIST [AUT_FEATURE_OF_TYPE] is
			-- Features in `a_type' in `a_system' which are testable by AutoTest
		require
			a_type_has_class: a_type.has_associated_class
		local
			feature_: AUT_FEATURE_OF_TYPE
			class_: CLASS_C
			feature_i: FEATURE_I
			l_feat_table: FEATURE_TABLE
			l_any_class: CLASS_C
			l_cursor: CURSOR
		do
			create Result.make
			l_any_class := a_system.any_class.compiled_class
			class_ := a_type.associated_class

			l_feat_table := class_.feature_table
			l_cursor := l_feat_table.cursor
			from
				l_feat_table.start
			until
				l_feat_table.after
			loop
				feature_i := l_feat_table.item_for_iteration
				if not feature_i.is_prefix and then not feature_i.is_infix then
						-- Normal exported features.
					if
						feature_i.export_status.is_exported_to (l_any_class) or else
						is_exported_creator (feature_i, a_type)
					then
						Result.force_last (create {AUT_FEATURE_OF_TYPE}.make (feature_i, a_type))
					end
				end
				l_feat_table.forth
			end
			l_feat_table.go_to (l_cursor)
		end

	testable_features_from_types (a_types: DS_LIST [TYPE_A]; a_system: SYSTEM_I): DS_HASH_SET [AUT_FEATURE_OF_TYPE] is
			-- Features from `a_types' that are testable by AutoTest
		require
			a_types_attached: a_types /= Void
			a_system_attached: a_system /= Void
		do
			create Result.make (100)
			Result.set_equality_tester (feature_of_type_loose_equality_tester)
			from
				a_types.start
			until
				a_types.after
			loop
				Result.append_last (testable_features_from_type (a_types.item_for_iteration, a_system))
				a_types.forth
			end
		ensure
			result_attached: Result /= Void
		end

	normalized_argument_name (a_argument_index: INTEGER): STRING is
			-- Normalized name for the `a_argument_index'-th argument
			-- in form of "a_arg_0", "a_arg_1" and so on.
		require
			a_argument_index_positive: a_argument_index > 0
		do
			Result :=normalized_argument_name_prefix + a_argument_index.out
		end

	normalized_argument_name_prefix: STRING is "a_arg_";
		-- Prefix for normalized argument name

feature -- Constraint solving related

	constrained_operands_from_access_patterns (a_patterns: DS_LINEAR [AUT_PREDICATE_ACCESS_PATTERN]): DS_HASH_SET [STRING] is
			-- Names of contrained arguments in `a_patterns'
		require
			a_patterns_attached: a_patterns /= Void
		local
			l_ptn_cursor: DS_LINEAR_CURSOR [AUT_PREDICATE_ACCESS_PATTERN]
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
		do
			create Result.make (5)
			Result.set_equality_tester (string_equality_tester)

			from
				l_ptn_cursor := a_patterns.new_cursor
				l_ptn_cursor.start
			until
				l_ptn_cursor.after
			loop
				if attached {AUT_LINEAR_SOLVABLE_PREDICATE} l_ptn_cursor.item.predicate as l_linear_pred then
					from
						l_cursor := l_ptn_cursor.item.access_pattern.new_cursor
						l_cursor.start
					until
						l_cursor.after
					loop
						if l_cursor.item > 0 then
							Result.force_last (normalized_argument_name (l_cursor.item))
						end
						l_cursor.forth
					end
				end
				l_ptn_cursor.forth
			end
		ensure
			result_attached: Result /= Void
		end

	constraining_queries_from_access_patterns (a_patterns: DS_LINEAR [AUT_PREDICATE_ACCESS_PATTERN]): DS_HASH_SET [STRING] is
			-- Names of constraining queries in `a_patterns'
		require
			a_patterns_attached: a_patterns /= Void
		local
			l_ptn_cursor: DS_LINEAR_CURSOR [AUT_PREDICATE_ACCESS_PATTERN]
		do
			create Result.make (5)
			Result.set_equality_tester (string_equality_tester)

			from
				l_ptn_cursor := a_patterns.new_cursor
				l_ptn_cursor.start
			until
				l_ptn_cursor.after
			loop
				if attached {AUT_LINEAR_SOLVABLE_PREDICATE} l_ptn_cursor.item.predicate as l_linear_pred then
					l_linear_pred.constraining_queries.do_all (agent Result.force_last)
				end
				l_ptn_cursor.forth
			end
		ensure
			result_attached: Result /= Void
		end

	assertions_from_access_patterns (a_patterns: DS_LINEAR [AUT_PREDICATE_ACCESS_PATTERN]): DS_LINKED_LIST [TUPLE [assertion: EPA_EXPRESSION; pattern: AUT_PREDICATE_ACCESS_PATTERN]] is
			-- Predicate assertions in `a_patterns'
		require
			a_patterns_attached: a_patterns /= Void
		local
			l_ptn_cursor: DS_LINEAR_CURSOR [AUT_PREDICATE_ACCESS_PATTERN]
		do
			create Result.make

			from
				l_ptn_cursor := a_patterns.new_cursor
				l_ptn_cursor.start
			until
				l_ptn_cursor.after
			loop
				if attached {AUT_LINEAR_SOLVABLE_PREDICATE} l_ptn_cursor.item.predicate as l_linear_pred then
					Result.force_last ([l_ptn_cursor.item.assertion, l_ptn_cursor.item])
				end
				l_ptn_cursor.forth
			end
		ensure
			result_attached: Result /= Void
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
