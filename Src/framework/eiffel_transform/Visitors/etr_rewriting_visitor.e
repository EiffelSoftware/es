note
	description: "Visitor used for rewriting code."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_REWRITING_VISITOR
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		end
	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end
	ETR_SHARED_TOOLS
	ETR_SHARED_BASIC_OPERATORS

feature -- Access

	modifications: LIST[ETR_AST_MODIFICATION]
	breakpoint_mappings: HASH_TABLE[INTEGER,INTEGER]

feature {NONE} -- Implementation

	remapped_regions: LINKED_LIST[TUPLE[old_start: INTEGER; new_start: INTEGER; old_count: INTEGER; new_count: INTEGER]]
	breakpoint_mappings_internal: LINKED_LIST[like breakpoint_mappings]

	map_region_one_to_one(a_start, a_end: INTEGER)
		local
			i: INTEGER
		do
			from
				i:=a_start
			until
				i>a_end
			loop
				breakpoint_mappings.force (i, i)
				i:=i+1
			end
		end

	map_region_shifted(a_start, a_count, a_reference: INTEGER)
		require
			count_pos: a_count>0
		local
			i: INTEGER
			l_dif: INTEGER
		do
			from
				i:=0
			until
				i>=a_count
			loop
				breakpoint_mappings.force (a_reference+i, a_start+i)
				i:=i+1
			end
		end

	init_and_process (a_ast: AST_EIFFEL)
			-- Init fields and process `a_ast'
		require
			non_void: a_ast /= void
		local
			l_old_total_bp_count: INTEGER
			l_current_shift: INTEGER
			l_current_old_bp: INTEGER
			l_current_new_bp: INTEGER
			l_cur_count: INTEGER
			l_prev_old, l_prev_new: INTEGER
			i: INTEGER
		do
			create {LINKED_LIST[ETR_AST_MODIFICATION]}modifications.make
			create remapped_regions.make
			create breakpoint_mappings_internal.make

			l_old_total_bp_count := ast_tools.num_breakpoint_slots_in (a_ast)+1

			a_ast.process (Current)

			create breakpoint_mappings.make (l_old_total_bp_count*2)
			if not remapped_regions.is_empty then
				-- create correct mappins for the whole breakpoint range
				l_current_old_bp:=1
				l_current_new_bp := l_current_old_bp
				l_current_shift := 0

				from
					remapped_regions.start
					breakpoint_mappings_internal.start
				until
					remapped_regions.after
				loop
					if remapped_regions.item.old_start>l_current_old_bp then
						-- Map everything before current region
						l_cur_count := remapped_regions.item.new_start-l_current_new_bp+l_current_shift
						map_region_shifted (l_current_new_bp, l_cur_count, l_current_old_bp)
						l_current_old_bp:=remapped_regions.item.old_start
						l_current_new_bp:=l_current_new_bp+l_cur_count
					end

					-- Refresh mappings of the current region
					from
						i:=0
					until
						i>=remapped_regions.item.new_count
					loop
						l_prev_new := remapped_regions.item.new_start+i
						l_prev_old := breakpoint_mappings_internal.item[l_prev_new]
						breakpoint_mappings.force (l_prev_old, l_prev_new+l_current_shift)
						i:=i+1
					end

					l_current_shift := l_current_shift+remapped_regions.item.new_count-remapped_regions.item.old_count
					l_current_old_bp := l_current_old_bp+remapped_regions.item.old_count
					l_current_new_bp := l_current_new_bp+remapped_regions.item.new_count

					remapped_regions.forth
					breakpoint_mappings_internal.forth
				end

				-- remap after last region
				if l_current_old_bp<l_old_total_bp_count then
					map_region_shifted (l_current_new_bp, l_old_total_bp_count-l_current_old_bp, l_current_old_bp)
				end
			else
				-- Map all 1:1
				map_region_one_to_one (1, l_old_total_bp_count)
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
