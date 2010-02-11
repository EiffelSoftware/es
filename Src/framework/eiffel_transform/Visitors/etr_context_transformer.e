note
	description: "Performs renamings as transformations between contexts"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTEXT_TRANSFORMER
inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_nested_as,
			process_access_feat_as,
			process_id_as,
			process_instr_call_as,
			process_expr_call_as,
			process_type_dec_as,
			process_creation_as,
			process_nested_expr_as
		end
	SHARED_NAMES_HEAP
create
	make

feature {NONE} -- Implementation

	changed_feature_hash: HASH_TABLE[ETR_CT_CHANGED_FEATURE,STRING]
			-- Features that require transformation

	changed_args_hash: HASH_TABLE[ETR_CT_CHANGED_ARG_LOCAL,STRING]
			-- Arguments that require transformation

	constraint_renaming_hash: HASH_TABLE[ETR_CT_RENAMED_CONSTRAINT_FEATURES,STRING]
			-- Renamings in source & target context			

	rename_next: BOOLEAN
			-- Will be rename the next feature/local

	last_was_unqualified_or_current: BOOLEAN
			-- Are we in an "unqualified" call?

	next_new_name: STRING
			-- Name that will be use in the next renaming

	next_access_name_id(a_message: CALL_AS): INTEGER
			-- name id of next access as
		do
			if attached {ACCESS_AS}a_message as l_msg_access_as then
				Result := names_heap.id_of (l_msg_access_as.access_name)
			elseif attached {NESTED_AS}a_message as l_msg_nested_as then
				Result := names_heap.id_of (l_msg_nested_as.target.access_name)
			else
				-- nothing which can be renamed
				-- i.e. NESTED_EXPR_AS
				Result :=-1
			end
		end

	process_identifier_list_with_renaming (l_as: IDENTIFIER_LIST)
			-- process `l_as'
		local
			l_cursor: INTEGER
			l_name: STRING
			l_changed: ETR_CT_CHANGED_ARG_LOCAL
		do
			-- process the id's list
			-- which is not an ast but an array of indexes into the names heap
			from
				l_cursor := l_as.index
				l_as.start
			until
				l_as.after
			loop
				l_name := names_heap.item (l_as.item)
				l_changed := changed_args_hash[l_name]
				if attached l_changed and then l_changed.is_changed_name then
					output.append_string(l_changed.new_name)
				else
					output.append_string(l_name)
				end

				if l_as.index /= l_as.count then
					output.append_string(", ")
				end

				l_as.forth
			end
			l_as.go_i_th (l_cursor)
		end

feature {NONE} -- Creation

	make(an_output: like output; a_changed_feature_list: LIST[ETR_CT_CHANGED_FEATURE]; a_changed_argument_list: LIST[ETR_CT_CHANGED_ARG_LOCAL]; a_constraint_renaming_list: LIST[ETR_CT_RENAMED_CONSTRAINT_FEATURES])
			-- make with `an_output', `a_changed_feature_list', `a_source' and `a_target'
		do
			make_with_output(an_output)

			if attached a_constraint_renaming_list then
				from
					create constraint_renaming_hash.make(a_constraint_renaming_list.count)
					a_constraint_renaming_list.start
				until
					a_constraint_renaming_list.after
				loop
					constraint_renaming_hash.extend(a_constraint_renaming_list.item,a_constraint_renaming_list.item.feature_name)

					a_constraint_renaming_list.forth
				end
			else
				create constraint_renaming_hash.make(0)
			end

			if attached a_changed_feature_list then
				from
					create changed_feature_hash.make(a_changed_feature_list.count)
					a_changed_feature_list.start
				until
					a_changed_feature_list.after
				loop
					changed_feature_hash.extend(a_changed_feature_list.item,a_changed_feature_list.item.feature_name)

					a_changed_feature_list.forth
				end
			else
				create changed_feature_hash.make (0)
			end

			if attached a_changed_argument_list then
				from
					create changed_args_hash.make(a_changed_argument_list.count)
					a_changed_argument_list.start
				until
					a_changed_argument_list.after
				loop
					changed_args_hash.extend(a_changed_argument_list.item, a_changed_argument_list.item.feature_name)

					a_changed_argument_list.forth
				end
			else
				create changed_args_hash.make (1)
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			process_identifier_list_with_renaming (l_as.id_list)
			output.append_string(": ")
			process_child(l_as.type, l_as, 1)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			last_was_unqualified_or_current := true
			process_child (l_as.call, l_as, 1)
			output.append_string("%N")
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			last_was_unqualified_or_current := true
			process_child (l_as.call, l_as, 1)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			fixme ("Add renaming handling here!")
			last_was_unqualified_or_current := true

			output.append_string ("create ")

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string("{")
				process_child (l_as.type, l_as, 2)
				output.append_string("} ")
			end

			process(l_as.target, l_as, 1)
			if processing_needed (l_as.call, l_as, 3) then
				output.append_string (".")
			end
			last_was_unqualified_or_current := false
			process_child (l_as.call, l_as, 3)
			output.append_string("%N")
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_changed_arguments: ETR_CT_CHANGED_ARG_LOCAL
		do
			if rename_next then
				output.append_string (next_new_name)
				rename_next := false
			elseif not last_was_unqualified_or_current then
				output.append_string (l_as.access_name)
			else
				l_changed_arguments := changed_args_hash[l_as.access_name]

				-- check for changed argument name
				if attached l_changed_arguments and then l_changed_arguments.is_changed_name then
					output.append_string (l_changed_arguments.new_name)
				else
					output.append_string (l_as.access_name)
				end
			end

			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (" (")
				process_child_list(l_as.parameters, ", ", l_as, 1)
				output.append_string (")")
			end
		end

	process_id_as (l_as: ID_AS)
		local
			l_changed_arguments: ETR_CT_CHANGED_ARG_LOCAL
		do
			if rename_next then
				output.append_string (next_new_name)
				rename_next := false
			else
				output.append_string (l_as.name)
			end
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			if attached {BINARY_AS}l_as.target or attached {UNARY_AS}l_as.target or attached {OBJECT_TEST_AS}l_as.target then
				output.append_string (ti_l_parenthesis)
				process_child(l_as.target, l_as, 1)
				output.append_string (ti_r_parenthesis)
			else
				process_child(l_as.target, l_as, 1)
			end

			output.append_string (ti_dot)
			last_was_unqualified_or_current := false
			process_child(l_as.message, l_as, 2)
		end

	process_nested_as (l_as: NESTED_AS)
		local
			l_old_feature,l_new_feature: FEATURE_I
			l_changed_features: ETR_CT_CHANGED_FEATURE
			l_changed_arguments: ETR_CT_CHANGED_ARG_LOCAL
			l_renamings: ETR_CT_RENAMED_CONSTRAINT_FEATURES
			l_old_msg_name, l_new_msg_name: STRING
			l_old_msg_name_id, l_new_msg_name_id, l_next_access_name_id: INTEGER
		do
			process_child (l_as.target, l_as, 1)
			output.append_string (".")

			if not last_was_unqualified_or_current then
				process_child (l_as.message, l_as, 2)
			else
				if not attached {CURRENT_AS}l_as.target then
					last_was_unqualified_or_current := false
				end

				l_changed_features := changed_feature_hash[l_as.target.access_name]
				l_changed_arguments := changed_args_hash[l_as.target.access_name]
				l_renamings := constraint_renaming_hash[l_as.target.access_name]

				-- we have to get the old message name before the renamings!
				-- this might not be possible for things like NESTED_EXPR_AS
				-- but in that case there's nothing to rename anyway
				l_next_access_name_id := next_access_name_id(l_as.message)

				if l_next_access_name_id>0 then
					if attached l_renamings and then attached l_renamings.source_renaming then
						l_old_msg_name_id := l_renamings.source_renaming.renamed (l_next_access_name_id)
						l_old_msg_name := names_heap.item (l_old_msg_name_id)
					else
						l_old_msg_name := names_heap.item (l_next_access_name_id)
					end

					if attached l_changed_features then
						-- now look up feature id's of the message and print the new name
						-- consider possible renamings
						l_old_feature := l_changed_features.old_type.feature_named (l_old_msg_name)
						l_new_feature := l_changed_features.new_type.feature_of_feature_id (l_old_feature.feature_id)

						-- we have to get the new name of the feature
						if attached l_renamings and then attached l_renamings.target_renaming then
							l_new_msg_name_id := l_renamings.target_renaming.new_name (l_new_feature.feature_name_id)
							l_new_msg_name := names_heap.item (l_new_msg_name_id)
						else
							l_new_msg_name := l_new_feature.feature_name
						end

						rename_next := true
						next_new_name := l_new_msg_name
						process_child (l_as.message, l_as, 2)
					elseif attached l_changed_arguments then
						if l_changed_arguments.is_changed_type then
							l_old_feature := l_changed_arguments.old_type.feature_named (l_old_msg_name)
							l_new_feature := l_changed_arguments.new_type.feature_of_feature_id (l_old_feature.feature_id)

							-- we have to get the new name of the feature
							if attached l_renamings and then attached l_renamings.target_renaming then
								l_new_msg_name_id := l_renamings.target_renaming.new_name (l_new_feature.feature_name_id)
								l_new_msg_name := names_heap.item (l_new_msg_name_id)
							else
								l_new_msg_name := l_new_feature.feature_name
							end

							rename_next := true
							next_new_name := l_new_msg_name
							process_child (l_as.message, l_as, 2)
						else
							process_child (l_as.message, l_as, 2)
						end
					else
						process_child (l_as.message, l_as, 2)
					end
				else
					process_child (l_as.message, l_as, 2)
				end
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
