note
	description: "Rewriting: Removes if-branches."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_IF_REMOVING_VISITOR
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_if_as
		end
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end
	ETR_SHARED_TOOLS
	ETR_SHARED_BASIC_OPERATORS
	ETR_SHARED_ERROR_HANDLER

feature -- Access

	modifications: LIST[ETR_AST_MODIFICATION]
			-- Modifications computed	

feature -- Operation

	remove_ifs_in (a_ast: AST_EIFFEL; a_take_branches: BOOLEAN; a_first_only: BOOLEAN)
		require
			non_void: a_ast /= void
		do
			first_only := a_first_only
			was_processed := false
			take_branches := a_take_branches

			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			a_ast.process (Current)
		end

feature {NONE} -- Implementation

	take_branches: BOOLEAN
	first_only: BOOLEAN
	was_processed: BOOLEAN

feature {AST_EIFFEL} -- Roundtrip

	process_if_as (l_as: IF_AS)
		local
			l_old_bp_count, l_new_bp_count: INTEGER
			l_else_part_count, l_if_part_count: INTEGER
			l_new_first, l_old_first: INTEGER
			i: INTEGER
			l_current_mapping: HASH_TABLE[INTEGER,INTEGER]
			l_mod: ETR_TRACKABLE_MODIFICATION
		do
			if not (first_only and was_processed) then
				l_old_bp_count := ast_tools.num_breakpoint_slots_in (l_as)
				l_old_first := l_as.breakpoint_slot
				l_new_first := l_as.breakpoint_slot
				create l_current_mapping.make (l_old_bp_count)

				if take_branches then
					if l_as.compound /= void and then not l_as.compound.is_empty then
						create l_mod.make_replace (l_as.path, ast_tools.ast_to_string (l_as.compound))

						l_new_bp_count := ast_tools.num_breakpoint_slots_in (l_as.compound)
						tracking_tools.map_region_shifted (l_current_mapping, l_old_first, l_as.compound.first.breakpoint_slot, l_new_bp_count)
					else
						create l_mod.make_delete (l_as.path)
					end
				else
					if l_as.else_part /= void and then not l_as.else_part.is_empty then
						create l_mod.make_replace (l_as.path, ast_tools.ast_to_string (l_as.else_part))

						-- Map else-part
						l_new_bp_count := ast_tools.num_breakpoint_slots_in (l_as.else_part)
						tracking_tools.map_region_shifted (l_current_mapping, l_old_first, l_as.else_part.first.breakpoint_slot, l_new_bp_count)
					else
						create l_mod.make_delete (l_as.path)
					end
				end
				was_processed := true

				l_mod.initialize_tracking_info (l_current_mapping, l_old_first, l_old_bp_count, l_new_bp_count)
				modifications.extend (l_mod)
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
