indexing
	description: "Stores the history of items which were edited. Used inside the ES_EBBRO_DISPLAYABLE class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_EDIT_HISTORY

create
	make

feature -- init

	make is
			-- init
		do
			create history.make
		end


feature -- Access

	history_item: TUPLE[EV_GRID_EDITABLE_ITEM,STRING,STRING] is
			-- current history item
			--[editable_grid_item,old_value,new_value]
		do
			Result := history.item
		end

feature -- Status report

	is_undo_possible: BOOLEAN is
			--
		do
			Result := not (history.before or history.is_empty)
		end

	is_redo_possible: BOOLEAN is
			--
		do
			Result := not (history.islast or history.is_empty or history.after)
		end

feature -- Basic operations

	add_item (an_edit_item:EV_GRID_EDITABLE_ITEM;an_old_value,a_new_value:STRING) is
			-- add item to history
			-- [editable_grid_item,old_value,new_value]
		require
			item_exists:an_edit_item /= void
			values_exist:an_old_value /= void and a_new_value /= void
		do
			-- remove right part from history
			if not  history.is_empty then
				if history.before then
					history.wipe_out
				else
					from
					until
						history.islast
					loop
						history.remove_right
					end
				end
			end


			-- insert at end
			history.extend ([an_edit_item,an_old_value,a_new_value])
			history.finish
		end

	undo is
			-- undo
			-- history_item gets reset to old_vale
			-- and cursor of history is moved back
		local
			l_tuple:like history_item
			l_edit_item:EV_GRID_EDITABLE_ITEM
		do
			if is_undo_possible then
				l_tuple := history.item
				if l_tuple /= void then
					l_edit_item ?= l_tuple.item (1)
					if l_edit_item /= void then
						l_edit_item.set_text (l_tuple.item (2).out)
						ensure_item_visible(l_edit_item)
					end
				end
				history.back
			end
		end

	redo is
			-- redo
			-- cursor of history is moved forth
			-- and then the history item gets reset to the new_value
		local
			l_tuple:like history_item
			l_edit_item:EV_GRID_EDITABLE_ITEM
		do
			if is_redo_possible then
				history.forth
				l_tuple := history.item
				if l_tuple /= void then
					l_edit_item ?= l_tuple.item (1)
					if l_edit_item /= void then
						l_edit_item.set_text (l_tuple.item (3).out)
						ensure_item_visible(l_edit_item)
					end
				end
			end
		end

	reset is
			-- removes all history items
		do
			history.wipe_out
		end


feature {NONE} -- Implementation

	history: LINKED_LIST[like history_item]

	ensure_item_visible (an_edit_item:EV_GRID_EDITABLE_ITEM) is
			-- ensures that the item is visible
		require
			valid_item:an_edit_item /= void
		local
			l_row:EV_GRID_ROW
		do
			from
				l_row := an_edit_item.row
			until
				l_row.parent_row = void
			loop
				l_row := l_row.parent_row
				l_row.expand
			end
		end


invariant
	history_initialized: history /= void

indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
