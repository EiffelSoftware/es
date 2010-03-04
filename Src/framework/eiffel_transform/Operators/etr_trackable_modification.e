note
	description: "A modification of an AST that can be tracked."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRACKABLE_MODIFICATION
inherit
	ETR_AST_MODIFICATION
		redefine
			is_trackable
		end
create
	make_replace,
	make_insert_after,
	make_insert_before,
	make_delete,
	make_list_prepend,
	make_list_append,
	make_list_put_ith

feature -- Access

	is_trackable: BOOLEAN
			-- <precursor>
		do
			Result := has_tracking_data
		end

	are_breakpoints_changed: BOOLEAN

	breakpoint_mapping: HASH_TABLE[INTEGER,INTEGER]

	region_start: INTEGER

	old_slot_count, new_slot_count: INTEGER

feature {NONE} -- Implementation

	has_tracking_data: BOOLEAN

feature  -- Operation

	initialize_unchanged_tracking
			-- Set tracking info so the region is unchanged
		do
			has_tracking_data := true
			are_breakpoints_changed := false
		ensure
			has_info: is_trackable
		end

	initialize_tracking_info (a_breakpoint_mapping: like breakpoint_mapping; a_region_start, a_old_count, a_new_count: INTEGER)
			-- Create a new modification
		require
			non_void: a_breakpoint_mapping /= void
			pos_numbers: a_region_start>0 and a_old_count>=0 and a_new_count>=0
		do
			has_tracking_data := true
			are_breakpoints_changed := true

			breakpoint_mapping := a_breakpoint_mapping

			region_start := a_region_start
			old_slot_count := a_old_count
			new_slot_count := a_new_count
		ensure
			has_info: is_trackable
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
