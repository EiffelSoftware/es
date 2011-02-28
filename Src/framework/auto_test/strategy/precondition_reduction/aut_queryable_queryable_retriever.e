note
	description: "Class to retrieve queryables from semantic database"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_QUERYABLE_QUERYABLE_RETRIEVER

inherit
	REFACTORING_HELPER

	EPA_UTILITY

	EPA_STRING_UTILITY

	SEMQ_TABLE_CONSTANTS

	SEM_SHARED_EQUALITY_TESTER

	EPA_TIME_UTILITY

feature -- Access

	last_objects: LINKED_LIST [SEMQ_RESULT]
			-- Objects that are retrieved through last `retrieve_invariant_violating_objects'

feature -- Logging

	log_manager: ELOG_LOG_MANAGER
			-- Log manager

feature -- Setting

	set_log_manager (a_manager: like log_manager)
			-- Set `log_manager' with `a_manager'.
		do
			log_manager := a_manager
		ensure
			log_manager_set: log_manager = a_manager
		end

feature -- Basic operations

	retrieve_objects (a_predicate: EPA_EXPRESSION; a_context_class: CLASS_C; a_feature: FEATURE_I; a_satisfying: BOOLEAN; a_connection: MYSQL_CLIENT)
			-- Retrieve objects that satisfying `a_predicate' if `a_satisfying' is True;
			-- otherwise, retrieve objects that violating `a_predicate'.
			-- Make result available in `last_objects'.
			-- `a_context_class' and `a_feature' compose the context where `a_predicate' appears.
			-- `a_connection' includes the config used to connect to the semantic database.
		local
			l_sql_gen: SEM_SIMPLE_QUERY_GENERATOR
			l_select: STRING
			l_curly_expr: STRING
			l_row: ARRAY [STRING]
			l_column_names: ARRAY [STRING]
			i: INTEGER
			l_sql_result: MYSQL_RESULT
			l_operand_mapping: like operands_from_curly_braced_operands
			l_column_name: STRING
			l_mapping: HASH_TABLE [SEM_VARIABLE_WITH_UUID, STRING]
			l_var_count: INTEGER
			l_data_row: HASH_TABLE [STRING, STRING]
			l_opd_name: STRING
			l_uuid: STRING
			l_var_with_uuid: SEM_VARIABLE_WITH_UUID
			l_result_item: SEMQ_RESULT
			l_qry_id: INTEGER
			l_uuids: DS_HASH_TABLE [SEMQ_RESULT, STRING]
			l_query: SEMQ_WHOLE_QUERYABLE_QUERY
			l_query_executor: SEMQ_WHOLE_QUERYABLE_QUERY_EXECUTOR
			l_obj_list: LINKED_LIST [SEM_QUERYABLE]
			l_obj_meta: HASH_TABLE [HASH_TABLE [STRING, STRING], STRING]
			l_tmp_result: SEMQ_RESULT
			l_msg: STRING
			l_time: DT_DATE_TIME
		do
			create last_objects.make

			l_curly_expr := curly_braced_integer_form (a_predicate, a_context_class, a_feature)
			create l_sql_gen
			l_select := l_sql_gen.sql_to_select_objects (a_context_class, a_feature, l_curly_expr, not a_satisfying, 5)

			if log_manager /= Void then
				log_manager.put_line_with_time ("Start query: " + a_predicate.text + " from " + a_context_class.name_in_upper + "." + a_feature.feature_name)
				l_msg := l_select.twin
				l_msg.replace_substring_all ("%N", " ")
				log_manager.put_line ("%T" + l_msg)
				l_time := time_now
			end

			a_connection.execute_query (l_select)
			if log_manager /= Void then
				create l_msg.make (50)
				l_msg.append ("%TDuration: ")
				l_msg.append_integer (duration_from_time (l_time))
				l_msg.append_character ('s')
				log_manager.put_line (l_msg)
			end
			if a_connection.last_error_number = 0 then
				l_sql_result := a_connection.last_result
				l_column_names := l_sql_result.column_names
				l_var_count := l_sql_result.column_count - 1
				l_operand_mapping := operands_from_curly_braced_operands (a_feature, a_context_class)

				from
					l_sql_result.start
				until
					l_sql_result.after
				loop
					create l_mapping.make (l_var_count)
					l_mapping.compare_objects
					l_data_row := l_sql_result.data_as_table
					l_uuid := l_data_row.item (queryables_uuid)
					l_qry_id := l_data_row.item (queryables_qry_id).to_integer
					across l_operand_mapping as l_map loop
						l_data_row.search (l_map.key)
						if l_data_row.found then
							create l_var_with_uuid.make ({ITP_SHARED_CONSTANTS}.variable_name_prefix + l_data_row.found_item.out, l_uuid)
							l_mapping.force (l_var_with_uuid, l_operand_mapping.item (l_map.key))
						end
					end
					create l_result_item.make
					across l_mapping as l_map loop
						l_result_item.variable_mapping.force (l_map.item, l_map.key)
					end
					last_objects.extend (l_result_item)
					l_sql_result.forth
				end

					-- Retrieve actual objects.
				create l_uuids.make (5)
				l_uuids.set_key_equality_tester (string_equality_tester)
				from
					last_objects.start
				until
					last_objects.after
				loop
					across last_objects.item_for_iteration.variable_mapping as l_map loop
						l_uuid := l_map.item.uuid
						if l_uuids.has (l_map.item.uuid) then
							l_tmp_result := l_uuids.item (l_map.item.uuid)
						else
							create l_query.make (l_uuid, {SEM_CONSTANTS}.object_field_value)
							create l_query_executor.make (a_connection)
							l_query_executor.execute (l_query)
							l_tmp_result := l_query_executor.last_results.first
							l_uuids.force_last (l_tmp_result, l_uuid)
							last_objects.item_for_iteration.queryables.append (l_tmp_result.queryables)
							across last_objects.item_for_iteration.meta  as l_meta loop
								last_objects.item_for_iteration.meta.force (l_meta.item, l_meta.key)
							end
						end
					end
					last_objects.forth
				end
			end
		end

	curly_braced_integer_form (a_expression: EPA_EXPRESSION; a_class: CLASS_C; a_feature: FEATURE_I): STRING
			-- Curly-braced integer form for `a_expression', viewed from `a_feature' in `a_class'.
			-- All occurrences of operands in `a_expression' will be replaced by curly-braced integers.
			-- For example, if `a_expression' is "Current.has (v)", the result would be
			-- "{0}.has ({1})", given that "v" is the first argument in `a_feature'.
		local
			l_operands: like operands_of_feature
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			l_operands := operands_of_feature (a_feature)
			l_replacements := curly_braced_operands_from_operands (a_feature, a_class)
			Result := expression_rewriter.expression_text (a_expression, l_replacements)
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
