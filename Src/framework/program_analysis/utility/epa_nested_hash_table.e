note
	description: "Summary description for {AUT_NESTED_HASH_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_NESTED_HASH_TABLE [V -> HASHABLE, K2 -> HASHABLE, K1 -> HASHABLE]

inherit

	DS_HASH_TABLE [DS_HASH_TABLE[DS_HASH_SET[V], K2], K1]
		rename
			make_with_equality_testers as make_table_with_equality_testers
		end

create
	make, make_with_equality_testers

feature -- Initialization

	make_with_equality_testers (n: INTEGER; a_val_tester: KL_EQUALITY_TESTER[V];
				a_k2_tester: KL_EQUALITY_TESTER[K2]; a_k1_tester: KL_EQUALITY_TESTER[K1])
			-- Initialization.
		do
			make (n)

			set_value_equality_tester (a_val_tester)
			set_secondary_key_equailty_tester (a_k2_tester)
			set_primary_key_equailty_tester (a_k1_tester)
		end

feature -- Access

	value_equality_tester: KL_EQUALITY_TESTER[V]
			-- Value equality tester.
		do
			if value_equality_tester_cache = Void then
				create value_equality_tester_cache
			end
			Result := value_equality_tester_cache
		end

	primary_key_equality_tester: KL_EQUALITY_TESTER[K1]
			-- Primary key equality tester.
		do
			if primary_key_equality_tester_cache = Void then
				create primary_key_equality_tester_cache
			end
			Result := primary_key_equality_tester_cache
		end

	secondary_key_equality_tester: KL_EQUALITY_TESTER[K2]
			-- Secondary key equality tester.
		do
			if secondary_key_equality_tester_cache = Void then
				create secondary_key_equality_tester_cache
			end
			Result := secondary_key_equality_tester_cache
		end

	value_event: EVENT_TYPE [TUPLE [value: V; is_unique: BOOLEAN]]
			-- Event raised whenever trying to put a value into the table.
			-- value: the value to be put into the table.
			-- is_unique: is the value a unique one, i.e. not existing in current table.
		do
			if value_event_cache = Void then
				create value_event_cache
			end
			Result := value_event_cache
		end

	value_set (a_k2: K2; a_k1: K1): detachable DS_HASH_SET[V]
			-- Values under key 'a_k1' and 'a_k2'.
		do
			if has (a_k1) and then attached value (a_k1) as lt_table then
				if lt_table.has (a_k2) and then attached lt_table.value (a_k2) as lt_set then
					Result := lt_set
				end
			end
		end

	all_values: DS_LINEAR[V]
			-- List of all values in the table.
		local
			l_list: DS_ARRAYED_LIST[V]
		do
			if is_empty then
				create l_list.make_default
			else
				create l_list.make (100)
				from start
				until after
				loop
					if attached item_for_iteration as lt_table then
						from lt_table.start
						until lt_table.after
						loop
							if attached lt_table.item_for_iteration as lt_set then
								from lt_set.start
								until lt_set.after
								loop
									l_list.force_last (lt_set.item_for_iteration)
									lt_set.forth
								end
							end
							lt_table.forth
						end
					end
					forth
				end
			end

			Result := l_list
		end

feature -- Status report

	has_value (a_val: V; a_k2: K2; a_k1: K1): BOOLEAN
			-- Is 'a_val' in the table under key 'a_k1' and 'a_k2'?
		do
			if has (a_k1) and then attached value (a_k1) as lt_table then
				if lt_table.has (a_k2) and then attached lt_table.value (a_k2) as lt_set then
					Result := lt_set.has(a_val)
				end
			end
		end

feature -- Store

	put_value (a_val: V; a_k2: K2; a_k1: K1)
			-- Put 'a_val' under secondary key 'a_k2' and primary key 'a_k1'.
		local
			l_is_unique: BOOLEAN
			l_set: DS_HASH_SET [V]
			l_table: DS_HASH_TABLE[DS_HASH_SET[V], K2]
		do
			l_is_unique := False
			if not has_value (a_val, a_k2, a_k1) then
				l_is_unique := True
				if has (a_k1) and then attached value (a_k1) as lt_table then
					if lt_table.has (a_k2) and then attached lt_table.value (a_k2) as lt_set then
						l_set := lt_set
					else
						create l_set.make (50)
						l_set.set_equality_tester (value_equality_tester)
						lt_table.force (l_set, a_k2)
					end
				else
					create l_set.make (50)
					l_set.set_equality_tester (value_equality_tester)
					create l_table.make (20)
					l_table.set_key_equality_tester (secondary_key_equality_tester)
					l_table.put (l_set, a_k2)
					force (l_table, a_k1)
				end
				l_set.force (a_val)
			end

			-- Publish the value event.
			value_event.publish([a_val, l_is_unique])
		end

feature -- Setting

	set_value_equality_tester (a_tester: KL_EQUALITY_TESTER[V])
			-- Set value equality tester.
		do
			value_equality_tester_cache := a_tester
		end

	set_primary_key_equailty_tester (a_tester: KL_EQUALITY_TESTER[K1])
			-- Set primary key equality tester.
		do
			primary_key_equality_tester_cache := a_tester
		end

	set_secondary_key_equailty_tester (a_tester: KL_EQUALITY_TESTER[K2])
			-- Set secondary key equality tester.
		do
			secondary_key_equality_tester_cache := a_tester
		end

feature{NONE} -- Implementation

	value_equality_tester_cache: detachable KL_EQUALITY_TESTER[V]

	primary_key_equality_tester_cache: detachable KL_EQUALITY_TESTER[K1]

	secondary_key_equality_tester_cache: detachable KL_EQUALITY_TESTER[K2]

	value_event_cache: detachable like value_event

;note
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
