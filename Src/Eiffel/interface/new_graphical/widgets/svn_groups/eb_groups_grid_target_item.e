note
	description: "Representation of a target in the cluster tree."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_GROUPS_GRID_TARGET_ITEM

inherit
	EB_GROUPS_GRID_ITEM
		redefine
			associate_with_window
		end

create
	make

feature {NONE} -- Initialization

	make (a_target: CONF_TARGET)
			-- Create.
		require
			a_target_attached: attached a_target
		do
			default_create
			set_stone (create {TARGET_STONE}.make(a_target))
			set_text (a_target.name)
			name := a_target.name
			set_tooltip (a_target.name)
			set_pixmap (pixmaps.icon_pixmaps.folder_target_icon)
		end

feature -- Interactivity

	associate_with_window (a_window: EB_STONABLE)
			-- Associate recursively with `a_window' so that we can call `set_stone' on `a_window'.
		local
			l_subrow_index: INTEGER
		do
			from l_subrow_index := 1
			until l_subrow_index > row.subrow_count_recursive
			loop
				if attached {EB_GROUPS_GRID_TARGET_ITEM}attached_parent.row (row_index + l_subrow_index).item (1) as target_item then
					target_item.associate_with_window (a_window)
				end
				l_subrow_index := l_subrow_index + 1
			end
		end

invariant
	stone_set: stone /= Void

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
