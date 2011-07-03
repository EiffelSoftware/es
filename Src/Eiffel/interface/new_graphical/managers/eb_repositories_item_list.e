note
	description: "Abstract list of Item for EB_REPOSITORIES"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_REPOSITORIES_ITEM_LIST

inherit
	ARRAYED_LIST[EB_REPOSITORIES_ITEM]
		redefine
			remove,
			extend,
			prune,
			wipe_out
		end

	SHARED_LOCALE
		undefine
			is_equal,
			copy
		end

feature -- Access

	parent: EB_REPOSITORIES_ITEM_LIST
			-- Parent for Current
		deferred
		end

	name: STRING_32
			-- Name for Current
		deferred
		end

	initialize_with_string(a_string: STRING_32)
		-- Initialize Repositories from `a_string'
		local
			repositories_list: LIST[STRING_32]
			repositories_root: EB_REPOSITORIES_ROOT
		do
			repositories_list := a_string.split (';')
			from repositories_list.start
			until repositories_list.after
			loop
				if not repositories_list.item_for_iteration.is_empty then
					create repositories_root.make (repositories_list.item_for_iteration, Current)
					repositories_root.load_repository
					extend (repositories_root)
				end
				repositories_list.forth
			end
		end

feature -- List operations

	remove
			-- Remove current item.
			-- Move cursor to right neighbor
			-- (or `after' if no right neighbor)
		local
			removed_item: like item
		do
			removed_item := item
			in_operation := True
			Precursor
			in_operation := False
			on_item_removed (removed_item, create {ARRAYED_LIST [EB_REPOSITORIES_FOLDER]}.make (3))
		end

	extend (v: like item)
			-- Add `v' to end.
			-- Do not move cursor.
		local
			cur: CURSOR
		do
			in_operation := True
			cur := cursor
			start
			compare_objects
			if not has (v) then
				Precursor (v)
				go_to (cur)
				v.set_parent (Current)
				in_operation := False
				on_item_added (v, create {ARRAYED_LIST [EB_REPOSITORIES_FOLDER]}.make (3))
			else
				go_to (cur)
				in_operation := False
			end
			compare_references
		end

   	prune (v: like item)
   			-- Remove first occurrence of `v', if any,
   			-- after cursor position.
   			-- Move cursor to right neighbor
   			-- (or `after' if no right neighbor or `v' does not occur)
		do
			in_operation := True
			Precursor (v)
			in_operation := False
			on_item_removed (v, create {ARRAYED_LIST [EB_REPOSITORIES_FOLDER]}.make (3))
		end

   	wipe_out
   			-- Remove all items.
		do
				-- Notify everybody that we will wipe_out the list.
			from
				start
			until
				after
			loop
				on_item_removed (item, create {ARRAYED_LIST [EB_REPOSITORIES_FOLDER]}.make (3))
				forth
			end

				-- Wipe out the list.
			in_operation := True
			Precursor
			in_operation := False
		end

feature {EB_REPOSITORIES_ITEM_LIST} -- Observer pattern

	on_item_added (an_item: EB_REPOSITORIES_ITEM; a_item_list: ARRAYED_LIST [EB_REPOSITORIES_ITEM])
			-- Notify the root parent of a change
		require
			valig_args: an_item /= Void and a_item_list /= Void
		local
			l_item: EB_REPOSITORIES_ITEM
		do
			if not in_operation then
				l_item ?= Current
				if l_item /= Void then
					a_item_list.put_front (l_item)
					parent.on_item_added (an_item, a_item_list)
				end
			end
		end

	on_item_removed (an_item: EB_REPOSITORIES_ITEM; a_item_list: ARRAYED_LIST [EB_REPOSITORIES_ITEM])
			-- Notify the root parent of a change
		require
			valig_args: an_item /= Void and a_item_list /= Void
		local
			a_item: EB_REPOSITORIES_ITEM
		do
			if not in_operation then
				a_item ?= Current
				if a_item /= Void then
					a_item_list.put_front (a_item)
					parent.on_item_removed (an_item, a_item_list)
				end
			end
		end

feature {NONE} -- Attributes

	in_operation: BOOLEAN
			-- Are we in the middle of a list operation (put, extend, remove, ...)?

feature {EB_REPOSITORIES_ITEM_LIST, EB_REPOSITORIES_ITEM} -- Load/Save

	string_representation: STRING_32
			-- String representation for Current.
			-- The representation will be of the form "Repositories(repository_1;repository_2)"
		do
			Result := name.twin
			Result.append ("(")
			from
				start
			until
				after
			loop
				Result := Result
				Result.append (item.string_representation)
				forth
				if not after then
					Result.append (";")
				end
			end
			Result.append (")")
		end

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
