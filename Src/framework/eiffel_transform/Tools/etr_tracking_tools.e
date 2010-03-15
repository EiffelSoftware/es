note
	description: "Some features that help with tracking code."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRACKING_TOOLS
inherit
	ETR_SHARED_TOOLS

feature -- New mappings

	new_directly_mapped_region (a_count: INTEGER): HASH_TABLE[INTEGER,INTEGER]
			-- Returns a new directly mapped region with `a_count'
		require
			count_pos: a_count>=0
		local
			i: INTEGER
		do
			from
				i:=1
				create Result.make(a_count*2)
			until
				i>a_count
			loop
				Result.extend(i,i)
				i:=i+1
			end
		end

	new_directly_mapped_region_of (a_transformable: ETR_TRANSFORMABLE): HASH_TABLE[INTEGER,INTEGER]
			-- Returns a new directly mapped region with `a_count'
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
		local
			i: INTEGER
			l_count: INTEGER
		do
			l_count := ast_tools.num_breakpoint_slots_in (a_transformable.target_node)

			from
				i:=1
				create Result.make(l_count*2)
			until
				i>l_count
			loop
				Result.extend(i,i)
				i:=i+1
			end
		end

feature -- Map subregion

	map_region_one_to_one (a_breakpoint_mapping: HASH_TABLE[INTEGER,INTEGER]; a_start, a_end: INTEGER)
			-- Map region from `a_start' to `a_end' 1:1
		require
			non_void: a_breakpoint_mapping /= void
			pos_numbers: a_start>0 and a_end>0
			valid_order: a_end>=a_start
		local
			i: INTEGER
		do
			from
				i:=a_start
			until
				i>a_end
			loop
				a_breakpoint_mapping.force (i, i)
				i:=i+1
			end
		end

	map_region_shifted (a_breakpoint_mapping: HASH_TABLE[INTEGER,INTEGER]; a_new, a_old, a_count: INTEGER)
			-- Map `a_count' slots at `a_new' to `a_old'
		require
			pos_numbers: a_count>0 and a_new>0 and a_old>0
			non_void: a_breakpoint_mapping /= void
		local
			i: INTEGER
			l_dif: INTEGER
		do
			from
				i:=0
			until
				i>=a_count
			loop
				a_breakpoint_mapping.force (a_old+i, a_new+i)
				i:=i+1
			end
		end

feature -- Combine mappings

	unified_breakpoint_mapping (a_modifications: LIST[ETR_TRACKABLE_MODIFICATION]; a_count: INTEGER): HASH_TABLE[INTEGER,INTEGER]
			-- Unify multiple mappings in a single region
		require
			non_void: a_modifications /= void
			count_pos: a_count>=0
		local
			l_current_shift: INTEGER
			l_current_old_bp: INTEGER
			l_current_new_bp: INTEGER
			l_cur_count: INTEGER
			l_prev_old, l_prev_new: INTEGER
			i: INTEGER
			l_filtered_mods: LINKED_LIST[ETR_TRACKABLE_MODIFICATION]
		do
			-- filter modifications with no changes
			from
				a_modifications.start
				create l_filtered_mods.make
			until
				a_modifications.after
			loop
				if a_modifications.item.are_breakpoints_changed then
					l_filtered_mods.extend (a_modifications.item)
				end

				a_modifications.forth
			end

			if not l_filtered_mods.is_empty then
				create Result.make (a_count*2)
				-- create correct mappins for the whole breakpoint range
				l_current_old_bp:=1
				l_current_new_bp := l_current_old_bp
				l_current_shift := 0

				from
					l_filtered_mods.start
				until
					l_filtered_mods.after
				loop
					if l_filtered_mods.item.region_start>l_current_old_bp then
						-- Map everything before current region
						l_cur_count :=l_filtered_mods.item.region_start-l_current_new_bp+l_current_shift
						map_region_shifted (Result, l_current_new_bp, l_current_old_bp, l_cur_count)
						l_current_old_bp:=l_filtered_mods.item.region_start
						l_current_new_bp:=l_current_new_bp+l_cur_count
					end

					-- Refresh mappings of the current region
					from
						i:=0
					until
						i>=l_filtered_mods.item.new_slot_count
					loop
						l_prev_new := l_filtered_mods.item.region_start+i
						l_prev_old := l_filtered_mods.item.breakpoint_mapping[l_prev_new]
						Result.force (l_prev_old, l_prev_new+l_current_shift)
						i:=i+1
					end

					l_current_shift := l_current_shift+l_filtered_mods.item.new_slot_count-l_filtered_mods.item.old_slot_count
					l_current_old_bp := l_current_old_bp+l_filtered_mods.item.old_slot_count
					l_current_new_bp := l_current_new_bp+l_filtered_mods.item.new_slot_count

					l_filtered_mods.forth
				end

				-- Make sure full range is mapped
				if l_current_new_bp<a_count then
					map_region_shifted (Result, l_current_new_bp, l_current_old_bp, a_count-l_current_new_bp+1)
				end
			else
				-- Map all 1:1
				Result := new_directly_mapped_region (a_count)
			end
		end

	chained_breakpoint_mapping (a_original_mapping, a_new_mapping: HASH_TABLE[INTEGER,INTEGER]; a_count: INTEGER): HASH_TABLE[INTEGER,INTEGER]
			-- Combine two maps to a single one. Range from 1 to `a_count'.
		local
			i:INTEGER
			l_cur_item: INTEGER
		do
			from
				create Result.make (a_count*2)
				i:=1
			until
				i>a_count
			loop
				l_cur_item := a_new_mapping[i]
				l_cur_item := a_original_mapping[l_cur_item]

				Result.extend (l_cur_item, i)
				i:=i+1
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
