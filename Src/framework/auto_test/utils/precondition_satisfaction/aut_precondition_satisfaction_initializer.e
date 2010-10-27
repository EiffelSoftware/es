note
	description: "Initializer to setup precondition satisfaction related context"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_SATISFACTION_INITIALIZER

inherit
	AUT_SHARED_PREDICATE_CONTEXT

feature -- Basic operations

	initialize (a_config: TEST_GENERATOR)
			-- Initialize precondition satisfaction related context
			-- using `a_config'.
		do
			if a_config.is_precondition_checking_enabled then
					-- Get the list of all features under test.
				class_types_under_test.append_last (a_config.types_under_test)
				setup_feature_id_table

					-- Find out all preconditions.
				find_precondition_predicates

					-- Find out relevant predicates for every feature in `features_under_test'.
				find_relevant_predicates
				build_relevant_predicate_with_operand_table

					-- Setup predicate pool.	
				predicate_pool.setup_predicates (predicates)
			end
		end

	setup_feature_id_table is
			-- Setup `feature_id_table'.
		local
			l_cursor: DS_HASH_SET_CURSOR [AUT_FEATURE_OF_TYPE]
			l_id: INTEGER
		do
			from
				l_cursor := features_under_test.new_cursor
				l_id := 1
				l_cursor.start
			until
				l_cursor.after
			loop
				feature_id_table.force_last (l_id, l_cursor.item.full_name)
				l_id := l_id + 1
				l_cursor.forth
			end
		end

	build_relevant_predicate_with_operand_table is
			-- Build `relevant_predicate_with_operand_table'.
		local
			l_feat_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_TABLE [DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]], AUT_PREDICATE], AUT_FEATURE_OF_TYPE]
			l_pred_cursor: DS_HASH_TABLE_CURSOR [DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]], AUT_PREDICATE]
			l_predicates: DS_LINKED_LIST [TUPLE [predicate_id: INTEGER; operand_indexes: SPECIAL [INTEGER]]]
			l_index_cursor: DS_LINKED_LIST_CURSOR [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]]
			l_indexes: SPECIAL [INTEGER]
		do
			from
				l_feat_cursor := relevant_predicates_of_feature.new_cursor
				l_feat_cursor.start
			until
				l_feat_cursor.after
			loop
				create l_predicates.make
				from
					l_pred_cursor := l_feat_cursor.item.new_cursor
					l_pred_cursor.start
				until
					l_pred_cursor.after
				loop
					from
						l_index_cursor := l_pred_cursor.item.new_cursor
						l_index_cursor.start
					until
						l_index_cursor.after
					loop
						create l_indexes.make_filled (0, l_index_cursor.item.count)
						l_index_cursor.item.do_all_with_index (
							agent (a_pos: AUT_FEATURE_SIGNATURE_TYPE; a_index: INTEGER; a_ops: SPECIAL [INTEGER])
								do
									a_ops.put (a_pos.position, a_index - 1)
								end (?, ?, l_indexes))

						l_index_cursor.forth
					end
					l_predicates.force_last ([l_pred_cursor.key.id, l_indexes])
					l_pred_cursor.forth
				end
				if not l_predicates.is_empty then
					relevant_predicate_with_operand_table.force_last (l_predicates.to_array, l_feat_cursor.key.id)
				end
				l_feat_cursor.forth
			end
		end

	find_precondition_predicates is
			-- Find precondition predicates from `features_under_test',
			-- store those predicates into `predicates', and store
			-- the access patterns of those predicates into
			-- `precondition_access_pattern'.
		local
			l_visitor: AUT_PRECONDITION_ANALYZER
			l_features: like features_under_test
			l_feature: AUT_FEATURE_OF_TYPE
		do
			l_features := features_under_test
			from
				l_features.start
			until
				l_features.after
			loop
					-- Get preconditions from `l_feature'.
				l_feature := l_features.item_for_iteration
				create l_visitor.make
				l_visitor.generate_precondition_predicates (l_feature)

					-- Store predicates and their access patterns.
				if not l_visitor.last_predicates.is_empty then
					l_visitor.last_predicates.do_if (agent put_predicate, agent (a_pred: AUT_PREDICATE): BOOLEAN do Result := not predicates.has (a_pred) end (?))
					put_precondition_access_pattern (l_feature, l_visitor.last_predicate_access_patterns)
					put_precondition_of_feature (l_feature, l_visitor.last_predicates)
					l_visitor.last_predicates.do_all (agent put_predicate_in_feature_table (?, l_feature))
				end
				l_features.forth
			end
		end

	find_relevant_predicates is
			-- For each feature in `features_under_test',
			-- find relevant predicates that needs to be reevalated
			-- every time when that feature is executed.
		local
			l_features: like features_under_test
			l_feature: AUT_FEATURE_OF_TYPE
			l_arranger: AUT_PREDICATE_ARGUMENT_ARRANGER
			l_predicates: like predicates
			l_relevant: DS_HASH_TABLE [DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]], AUT_PREDICATE]
			l_arrangements: DS_LINKED_LIST [ARRAY [AUT_FEATURE_SIGNATURE_TYPE]]
			l_predicate_cursor: DS_HASH_SET_CURSOR [AUT_PREDICATE]
		do
			l_features := features_under_test
			l_predicates := predicates
			from
				l_features.start
			until
				l_features.after
			loop
				l_feature := l_features.item_for_iteration
				create l_relevant.make (10)
				l_relevant.set_key_equality_tester (predicate_equality_tester)
				relevant_predicates_of_feature.force_last (l_relevant, l_feature)
				from
					l_predicate_cursor := l_predicates.new_cursor
					l_predicate_cursor.start
				until
					l_predicate_cursor.after
				loop
					create l_arranger.make (l_predicate_cursor.item, system)
					l_arrangements := l_arranger.arrangements_for_feature (l_feature)
					if not l_arrangements.is_empty then
						l_relevant.force_last (l_arrangements, l_predicate_cursor.item)
					end
					l_predicate_cursor.forth
				end
				l_features.forth
			end
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
