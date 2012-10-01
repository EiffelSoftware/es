note
	description: "Object keeping the execution profiles' data..."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	DEBUGGER_PROFILES

obsolete "[2009-09-14] Please use DEBUGGER_PROFILE_MANAGER"

inherit
	DEBUGGER_STORABLE_DATA_I

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		require
			n_non_negative: n >= 0
		do
			create internal_storage.make (n)
		end

feature -- Conversion

	to_profile_provider: DEBUGGER_PROFILE_MANAGER
		local
			l_item: DEBUGGER_EXECUTION_PROFILE
		do
			from
				create Result.make (count)
				start
			until
				after
			loop
				l_item := item_for_iteration.to_profile
				l_item.set_title (key_for_iteration)
				Result.add (l_item)
				forth
			end
		end
feature -- Access

	last_profile_name: detachable STRING_32
			-- Last profile's name

	last_profile: like profile
			-- Last profile details
		do
			if attached last_profile_name as n then
				Result := profile (n)
			end
		end

	profile (a_name: STRING_32): TUPLE [name: STRING_32; params: DEBUGGER_EXECUTION_PARAMETERS]
			-- Profile indexed by `a_name'
		require
			a_name_not_void: a_name /= Void
		local
			cursor: CURSOR
			lst: like internal_storage
		do
			lst := internal_storage
			cursor := lst.cursor
			from
				lst.start
			until
				lst.after or Result /= Void
			loop
				Result := lst.item
				if Result /= Void and then not Result.name.same_string (a_name) then
					Result := Void
				end
				lst.forth
			end
			internal_storage.go_to (cursor)
		end

feature -- Element change

	force (new: DEBUGGER_EXECUTION_PARAMETERS; key: STRING_32)
			-- Update Current so that `new' will be the item associated
			-- with `key'.
		do
			if has (key) then
				check profile (key).name.is_equal (key) end
				internal_storage.replace ([key, new])
			else
				internal_storage.force ([key, new])
			end
		end

	set_last_profile (v: like profile)
			-- Set `last_profile_name' related to `v'
		do
			if v = Void then
				last_profile_name := Void
			else
				check v_name_not_empty: v.name /= Void and then not v.name.is_empty end
				last_profile_name := v.name
				force (v.params, v.name)
			end
		end

	set_last_profile_by_name (n: like last_profile_name)
			-- Set `last_profile_name' to `n'
		do
			if n /= Void and then has (n) then
				set_last_profile (profile (n))
			else
				set_last_profile (Void)
			end
		end

feature -- Removal

	wipe_out
			-- Reset all items to default values; reset status.
		do
			internal_storage.wipe_out
		end

feature -- Cursor movement

	has (key: like last_profile_name): BOOLEAN
			-- Has profile named `key' ?
			-- move cursor to found profile if any
		local
			cursor: CURSOR
			lst: like internal_storage
			p: like profile
		do
			lst := internal_storage
			cursor := lst.cursor
			from
				lst.start
			until
				lst.after or Result
			loop
				p := lst.item
				if p /= Void and then p.name.same_string (key) then
					Result := True
				else
					lst.forth
				end
			end
			if not Result then
				lst.go_to (cursor)
			end
		ensure
			found_at_position: Result implies (attached internal_storage.item as el_item and then el_item.name.same_string (key))
		end

	start
			-- Bring cursor to first position.
		do
			internal_storage.start
		end

	forth
			-- Advance cursor to next occupied position,
			-- or `off' if no such position remains.
		require
			not_off: not after
		do
			internal_storage.forth
		end

	after: BOOLEAN
			-- Is cursor past last item?
		do
			Result := internal_storage.after
		end

	item_for_iteration: DEBUGGER_EXECUTION_PARAMETERS
			-- Element at current iteration position
		require
			not_off: not after
		do
			Result := internal_storage.item.params
		end

	key_for_iteration: STRING_32
			-- Key at current iteration position
		require
			not_off: not after
		do
			Result := internal_storage.item.name
		end

	count: INTEGER
			-- Number of items.
		do
			Result := internal_storage.count
		end

feature {NONE} -- Implementation

	internal_storage: ARRAYED_LIST [like profile]
			-- Storage for the profiles.

invariant
	internal_storage_not_void: internal_storage /= Void

note
	copyright:	"Copyright (c) 1984-2009, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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
