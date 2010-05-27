note
	description: "Context transformation: Performs renamings and prints the result."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTEXT_TRANSFORMING_VISITOR
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
			process_nested_expr_as,
			process_like_id_as
		end
	ETR_SHARED_TOOLS
	ETR_SHARED_ERROR_HANDLER
	SHARED_NAMES_HEAP
create
	make

feature {NONE} -- Creation

	make (a_output: like output; a_changed_local_list: detachable LIST[ETR_CT_CHANGED_NAME_TYPE]; a_constraint_renaming_list: detachable LIST[ETR_CT_CONSTRAINT_RENAMING])
			-- Make with `a_output', `a_changed_local_list' and `a_constraint_renaming_list'
		do
			make_with_output(a_output)

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

			if attached a_changed_local_list then
				from
					create changed_locals_hash.make(a_changed_local_list.count)
					a_changed_local_list.start
				until
					a_changed_local_list.after
				loop
					changed_locals_hash.extend(a_changed_local_list.item, a_changed_local_list.item.feature_name)

					a_changed_local_list.forth
				end
			else
				create changed_locals_hash.make (1)
			end
		end

feature {NONE} -- Implementation

	changed_locals_hash: HASH_TABLE[ETR_CT_CHANGED_NAME_TYPE,STRING]
			-- Locals that need renaming

	constraint_renaming_hash: HASH_TABLE[ETR_CT_CONSTRAINT_RENAMING,STRING]
			-- Renamings in source & target context			

	rename_next: BOOLEAN
			-- Will be rename the next feature/local

	last_was_unqualified_or_current: BOOLEAN
			-- Are we in an "unqualified" call?

	last_was_changed: BOOLEAN
			-- Did we change the type of the last access

	changed_old_type, changed_new_type: CLASS_C
			-- Changed types of a nested expression

	changed_old_renamings, changed_new_renamings: RENAMING_A
			-- Renamings in the current nested expression

	next_new_name: STRING
			-- Name that will be use in the next renaming

	next_access_name_id (a_message: CALL_AS): INTEGER
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
			l_changed: ETR_CT_CHANGED_NAME_TYPE
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
				l_changed := changed_locals_hash[l_name]
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

	old_message_name (a_name_id: INTEGER; a_renaming: detachable RENAMING_A): STRING
			-- Name of `a_name_id' before `a_renaming'
		local
			l_old_msg_name_id: INTEGER
		do
			if a_renaming /= void then
				l_old_msg_name_id := a_renaming.renamed (a_name_id)
				Result := names_heap.item (l_old_msg_name_id)
			else
				Result := names_heap.item (a_name_id)
			end
		end

	new_message_name (a_name_id: INTEGER; a_renaming: detachable RENAMING_A): STRING
			-- Name of `a_name_id' after `a_renaming'
		local
			l_new_msg_name_id: INTEGER
		do
			if a_renaming /= void then
				l_new_msg_name_id := a_renaming.new_name (a_name_id)
				Result := names_heap.item (l_new_msg_name_id)
			else
				Result := names_heap.item (a_name_id)
			end
		end

	set_additional_renaming(a_old_type, a_new_type: TYPE_A)
			-- Set additional renaming resulting from changed types
		do
			if not a_old_type.same_as (a_new_type) then
				changed_old_type := a_old_type.associated_class
				changed_new_type := a_new_type.associated_class

				if attached {RENAMED_TYPE_A[TYPE_A]}a_old_type as l_ren_old then
					changed_old_renamings := l_ren_old.renaming
				else
					changed_old_renamings := void
				end

				if attached {RENAMED_TYPE_A[TYPE_A]}a_new_type as l_ren_new then
					changed_new_renamings := l_ren_new.renaming
				else
					changed_new_renamings := void
				end

				last_was_changed := true
			else
				last_was_changed := false
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_like_id_as (l_as: LIKE_ID_AS)
		do
			last_was_unqualified_or_current := true
			Precursor (l_as)
		end

	process_type_dec_as (l_as: TYPE_DEC_AS)
		do
			process_identifier_list_with_renaming (l_as.id_list)
			output.append_string(": ")
			process_child(l_as.type, l_as, 1)
		end

	process_instr_call_as (l_as: INSTR_CALL_AS)
		do
			last_was_unqualified_or_current := true
			Precursor(l_as)
		end

	process_expr_call_as (l_as: EXPR_CALL_AS)
		do
			last_was_unqualified_or_current := true
			Precursor(l_as)
		end

	process_creation_as (l_as: CREATION_AS)
		do
			last_was_unqualified_or_current := true
			output.append_string (ti_create_keyword+ti_Space)

			if processing_needed (l_as.type, l_as, 2) then
				output.append_string(ti_l_curly)
				process_child (l_as.type, l_as, 2)
				output.append_string(ti_r_curly+ti_Space)
			end
			process(l_as.target, l_as, 1)
			last_was_unqualified_or_current := false
			if processing_needed (l_as.call, l_as, 3) then
				output.append_string (ti_dot)
				process_child (l_as.call, l_as, 3)
			end
			output.append_string(ti_New_line)
		end

	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			l_changed_arguments: ETR_CT_CHANGED_NAME_TYPE
		do
			if rename_next then
				output.append_string (next_new_name)
				rename_next := false
			elseif not last_was_unqualified_or_current then
				output.append_string (l_as.access_name)
			else
				l_changed_arguments := changed_locals_hash[l_as.access_name]

				-- check for changed argument name
				if attached l_changed_arguments and then l_changed_arguments.is_changed_name then
					output.append_string (l_changed_arguments.new_name)
				else
					output.append_string (l_as.access_name)
				end
			end

			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (ti_Space+ti_l_parenthesis)
				process_child_list(l_as.parameters, ti_comma+ti_Space, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end
		end

	process_id_as (l_as: ID_AS)
		local
			l_changed: ETR_CT_CHANGED_NAME_TYPE
		do
			if rename_next then
				output.append_string (next_new_name)
				rename_next := false
			elseif last_was_unqualified_or_current then
				l_changed := changed_locals_hash[l_as.name]

				if l_changed /= void and then l_changed.is_changed_name then
					output.append_string (l_changed.new_name)
				else
					output.append_string (l_as.name)
				end
			else
				output.append_string (l_as.name)
			end
		end

	process_nested_expr_as (l_as: NESTED_EXPR_AS)
		do
			if attached {BRACKET_AS}l_as.target then
				process_child(l_as.target, l_as, 1)
			else
				output.append_string (ti_l_parenthesis)
				process_child(l_as.target, l_as, 1)
				output.append_string (ti_r_parenthesis)
			end

			output.append_string (ti_dot)
			last_was_unqualified_or_current := false
			process_child(l_as.message, l_as, 2)
		end

	process_nested_as (l_as: NESTED_AS)
		local
			l_old_feature,l_new_feature: FEATURE_I
			l_changed_local: ETR_CT_CHANGED_NAME_TYPE
			l_renamings: ETR_CT_CONSTRAINT_RENAMING
			l_old_msg_name, l_new_msg_name: STRING
			l_old_msg_name_id, l_new_msg_name_id, l_next_access_name_id: INTEGER
			l_old_expl_type, l_new_expl_type: TYPE_A

			l_msg_name: STRING
		do
			process_child (l_as.target, l_as, 1)
			output.append_string (ti_dot)

			if not last_was_unqualified_or_current then
				l_next_access_name_id := next_access_name_id(l_as.message)
				if last_was_changed and l_next_access_name_id>0 then
					-- Further renaming!
					l_old_msg_name := old_message_name (l_next_access_name_id, changed_old_renamings)

					l_old_feature := changed_old_type.feature_named (l_old_msg_name)
					l_new_feature := changed_new_type.feature_of_rout_id_set (l_old_feature.rout_id_set)

					if l_new_feature /= void then
						l_new_msg_name := new_message_name (l_new_feature.feature_name_id, changed_new_renamings)

						-- Check if type of expression changed
						l_old_expl_type := type_checker.explicit_type (l_old_feature.type, changed_old_type, void)
						l_new_expl_type := type_checker.explicit_type (l_new_feature.type, changed_new_type, void)

						set_additional_renaming(l_old_expl_type, l_new_expl_type)

						rename_next := true
						next_new_name := l_new_msg_name
						process_child (l_as.message, l_as, 2)
					else
						error_handler.add_error (Current, "process_nested_as", "Cannot transform "+l_as.target.access_name+"."+names_heap.item (l_next_access_name_id)+" to target context.")
						last_was_changed := false
						process_child (l_as.message, l_as, 2)
					end
				else
					last_was_changed := false
					process_child (l_as.message, l_as, 2)
				end
			else
				if not attached {CURRENT_AS}l_as.target then
					last_was_unqualified_or_current := false
				end

				l_changed_local := changed_locals_hash[l_as.target.access_name]
				l_renamings := constraint_renaming_hash[l_as.target.access_name]

				-- we have to get the old message name before the renamings!
				-- this might not be possible for things like NESTED_EXPR_AS
				-- but in that case there's nothing to rename anyway
				l_next_access_name_id := next_access_name_id(l_as.message)

				if l_next_access_name_id>0 then
					if l_renamings /= void then
						l_old_msg_name := old_message_name (l_next_access_name_id, l_renamings.source_renaming)
					else
						l_old_msg_name := old_message_name (l_next_access_name_id, void)
					end

					if l_changed_local /= void and then l_changed_local.is_changed_type then
						l_old_feature := l_changed_local.old_type.feature_named (l_old_msg_name)
						l_new_feature := l_changed_local.new_type.feature_of_rout_id_set (l_old_feature.rout_id_set)

						if l_new_feature /= void then
							-- we have to get the new name of the feature
							if l_renamings /= void then
								l_new_msg_name := new_message_name (l_new_feature.feature_name_id, l_renamings.target_renaming)
							else
								l_new_msg_name := new_message_name (l_new_feature.feature_name_id, void)
							end

							-- Check if type of expression changed
							l_old_expl_type := type_checker.explicit_type (l_old_feature.type, l_changed_local.old_type, void)
							l_new_expl_type := type_checker.explicit_type (l_new_feature.type, l_changed_local.new_type, void)

							set_additional_renaming (l_old_expl_type, l_new_expl_type)

							rename_next := true
							next_new_name := l_new_msg_name
							process_child (l_as.message, l_as, 2)
						else
							error_handler.add_error (Current, "process_nested_as", "Cannot transform "+l_as.target.access_name+"."+names_heap.item (l_next_access_name_id)+" to target context.")
							last_was_changed := false
							process_child (l_as.message, l_as, 2)
						end
					else
						last_was_changed := false
						process_child (l_as.message, l_as, 2)
					end
				else
					last_was_changed := false
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
