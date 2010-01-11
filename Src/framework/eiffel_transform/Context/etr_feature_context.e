note
	description: "Represents the context of a feature"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_FEATURE_CONTEXT
inherit
	ETR_CONTEXT
	ETR_SHARED
		export
			{NONE} all
		end
	SHARED_NAMES_HEAP
		export
			{NONE} all
		end
create
	make,
	make_from_other

feature -- Access

	original_written_feature: FEATURE_I

	has_return_value: BOOLEAN
	has_arguments: BOOLEAN
	has_locals: BOOLEAN

	type: detachable TYPE_A
	name: STRING

	feature_id: INTEGER
	arguments: detachable ARRAY[ETR_CONTEXT_TYPED_VAR]
	locals: detachable ARRAY[ETR_CONTEXT_TYPED_VAR]

	arg_by_name: detachable HASH_TABLE[ETR_CONTEXT_TYPED_VAR, STRING]
	local_by_name: detachable HASH_TABLE[ETR_CONTEXT_TYPED_VAR, STRING]

feature {NONE} -- Creation
	make_from_other(a_other: like Current)
			-- make from `a_other'
		local
			l_index: INTEGER
		do
			has_arguments := a_other.has_arguments
			has_locals := a_other.has_locals
			has_return_value := a_other.has_return_value

			fixme("Ok to just twin the type?")
			if a_other.has_return_value then
				type := a_other.type.twin
			end
			name := a_other.name.twin

			if a_other.has_arguments then
				from
					create arguments.make (1, a_other.arguments.count)
					create arg_by_name.make (a_other.arguments.count)
					l_index := 1
				until
					l_index > a_other.arguments.count
				loop
					arguments[l_index] := a_other.arguments[l_index].twin
					arg_by_name.extend (arguments[l_index], arguments[l_index].name)
					l_index := l_index + 1
				end
			end

			if a_other.has_locals then
				from
					create locals.make (1, a_other.locals.count)
					create local_by_name.make (a_other.arguments.count)
					l_index := 1
				until
					l_index > a_other.locals.count
				loop
					locals[l_index] := a_other.locals[l_index].twin
					local_by_name.extend (locals[l_index], locals[l_index].name)
					l_index := l_index + 1
				end
			end

			original_written_feature := a_other.original_written_feature
			create class_context.make(original_written_feature.written_class)
			feature_id := a_other.feature_id
		end

	make(a_written_feature: like original_written_feature; a_class_context: detachable like class_context)
			-- make with `a_written_feature' and `a_class_context'
		local
			l_arg_list,l_local_list: LINKED_LIST[ETR_CONTEXT_TYPED_VAR]
			l_expl_type: TYPE_A
			l_e_feat: E_FEATURE
			l_name: STRING
		do
			-- compute explicit type
			if a_written_feature.has_return_value then
				type := explicit_type (a_written_feature.type, a_written_feature.written_class)
				has_return_value := true
			end

			-- store name
			name := a_written_feature.feature_name

			l_e_feat := a_written_feature.e_feature

			if attached l_e_feat.arguments then
				-- store arguments
				from
					create l_arg_list.make
					l_e_feat.arguments.start
					l_e_feat.argument_names.start
				until
					l_e_feat.arguments.after or l_e_feat.argument_names.after
				loop
					l_expl_type := explicit_type (l_e_feat.arguments.item, l_e_feat.written_class)
					l_name := l_e_feat.argument_names.item
					l_arg_list.extend (create {ETR_CONTEXT_TYPED_VAR}.make(l_name, l_expl_type))

					l_e_feat.argument_names.forth
					l_e_feat.arguments.forth
				end

				if not l_arg_list.is_empty then
					has_arguments := true

					from
						create arguments.make (1, l_arg_list.count)
						create arg_by_name.make (l_arg_list.count)
						l_arg_list.start
					until
						l_arg_list.after
					loop
						arg_by_name.extend (l_arg_list.item, l_arg_list.item.name)
						arguments[l_arg_list.index] := l_arg_list.item
						l_arg_list.forth
					end
				end
			end

			if attached l_e_feat.locals then
				-- store locals
				from
					create l_local_list.make
					l_e_feat.locals.start
				until
					l_e_feat.locals.after
				loop
					l_expl_type := explicit_type_from_type_as (l_e_feat.locals.item.type, a_written_feature.written_class, a_written_feature)

					-- add a local for each name
					from
						l_e_feat.locals.item.id_list.start
					until
						l_e_feat.locals.item.id_list.after
					loop
						l_name := names_heap.item (l_e_feat.locals.item.id_list.item)
						l_local_list.extend (create {ETR_CONTEXT_TYPED_VAR}.make(l_name, l_expl_type))
						l_e_feat.locals.item.id_list.forth
					end

					l_e_feat.locals.forth
				end

				if not l_local_list.is_empty then
					has_locals := true

					from
						create locals.make (1, l_local_list.count)
						create local_by_name.make (l_local_list.count)
						l_local_list.start
					until
						l_local_list.after
					loop
						local_by_name.extend (l_local_list.item, l_local_list.item.name)
						locals[l_local_list.index] := l_local_list.item
						l_local_list.forth
					end
				end
			end

			feature_id := a_written_feature.feature_id

			-- store original written feature
			original_written_feature := a_written_feature

			if attached a_class_context then
				class_context := a_class_context
			else
				create class_context.make(a_written_feature.written_class)
			end
		end
invariant
	locals_valid: has_locals implies attached locals
	arguments_valid: has_arguments implies attached arguments
	type_valid: has_return_value implies attached type
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
