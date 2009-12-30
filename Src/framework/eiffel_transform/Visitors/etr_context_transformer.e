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
			process_access_feat_as
		end
create
	make

feature {NONE} -- Implementation

	changed_feature_hash: HASH_TABLE[ETR_CT_CHANGED_FEATURE,STRING]
	changed_args_hash: HASH_TABLE[ETR_CT_CHANGED_ARGUMENT,STRING]

feature {NONE} -- Creation

	make(an_output: like output; a_changed_feature_list: LIST[ETR_CT_CHANGED_FEATURE]; a_changed_argument_list: LIST[ETR_CT_CHANGED_ARGUMENT])
			-- make with `an_output', `a_changed_feature_list', `a_source' and `a_target'
		do
			if not (a_changed_feature_list.is_empty and a_changed_argument_list.is_empty) then
				make_with_output(an_output)

				from
					create changed_feature_hash.make(a_changed_feature_list.count)
					a_changed_feature_list.start
				until
					a_changed_feature_list.after
				loop
					changed_feature_hash.extend(a_changed_feature_list.item,a_changed_feature_list.item.feature_name)

					a_changed_feature_list.forth
				end

				from
					create changed_args_hash.make(a_changed_argument_list.count)
					a_changed_argument_list.start
				until
					a_changed_argument_list.after
				loop
					changed_args_hash.extend(a_changed_argument_list.item, a_changed_argument_list.item.feature_name)

					a_changed_argument_list.forth
				end
			end
		end

feature -- Roundtrip
	process_access_feat_as (l_as: ACCESS_FEAT_AS)
		local
			changed_args: ETR_CT_CHANGED_ARGUMENT
		do
			changed_args := changed_args_hash[l_as.access_name]

			-- check for changed argument name
			if attached changed_args and then changed_args.is_changed_name then
				output.append_string (changed_args.new_name)
			else
				output.append_string (l_as.access_name)
			end

			if processing_needed (l_as.parameters,l_as,1) then
				output.append_string (" (")
				process_child_list(l_as.parameters, ", ", l_as, 1)
				output.append_string (")")
			end
		end

	process_nested_as (l_as: NESTED_AS)
		local
			old_feature,new_feature: FEATURE_I
			changed_types: ETR_CT_CHANGED_FEATURE
			changed_args: ETR_CT_CHANGED_ARGUMENT
		do
			if attached {ACCESS_ID_AS}l_as.target as target and attached {ACCESS_FEAT_AS}l_as.message as msg then
				-- check for changed feature types that need renaming
				check
					not target.is_qualified and msg.is_qualified
				end

				-- check if feature was renamed
				changed_types := changed_feature_hash[target.access_name]
				changed_args := changed_args_hash[target.access_name]

				if attached changed_types then
					process_child (l_as.target, l_as, 1)
					output.append_string (".")

					-- now look up feature id's of the message and print the new name
					fixme("Error handling needed")
					old_feature := changed_types.old_type.feature_named (msg.access_name)
					new_feature := changed_types.new_type.feature_of_feature_id (old_feature.feature_id)

					output.append_string (new_feature.feature_name)
				elseif attached changed_args then
					if changed_args.is_changed_name then
						output.append_string (changed_args.new_name)
					else
						process_child (l_as.target, l_as, 1)
					end
					output.append_string (".")

					if changed_args.is_changed_type then
						old_feature := changed_args.old_type.feature_named (msg.access_name)
						new_feature := changed_args.new_type.feature_of_feature_id (old_feature.feature_id)

						output.append_string (new_feature.feature_name)
					else
						process_child (l_as.message, l_as, 2)
					end
				else
					process_child (l_as.target, l_as, 1)
					output.append_string (".")
					process_child (l_as.message, l_as, 2)
				end
			else
				process_child (l_as.target, l_as, 1)
				output.append_string (".")
				process_child (l_as.message, l_as, 2)
			end
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
