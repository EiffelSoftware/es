note
	description: "[
		Helper ghost objects that prevent hash set elements from unwanted modifications.
		]"
	author: "Nadia Polikarpova"
	status: ghost
	model: sets
	manual_inv: true
	false_guards: true
	explicit: "all"

frozen class
	V_HASH_LOCK [K -> V_HASHABLE, V]

inherit
	V_LOCK [K, V]
		redefine
			sets,
			tables
		end

feature -- Access	

	sets: MML_SET [V_HASH_SET [K]]
			-- Sets that might share elements owned by this lock.

	tables: MML_SET [V_HASH_TABLE [K, V]]
			-- Tables that might share elements owned by this lock.

feature -- Basic operations

	add_table (t: V_HASH_TABLE [K, V])
			-- Add `t' to `tables'.
		require
			wrapped: is_wrapped
			t_wrapped: t.is_wrapped
			no_observers: t.observers.is_empty
			empty_map: t.map.is_empty
			modify_field (["tables", "subjects", "observers", "closed"], Current)
			modify_field (["lock", "subjects", "observers", "closed"], t)
		do
			unwrap
			t.unwrap
			t.set_lock (Current)
			tables := tables & t
			Current.subjects := subjects & t
			Current.observers := observers & t
			t.wrap
			wrap
		ensure
			tables_effect: tables = old tables & t
			wrapped: is_wrapped
			t_wrapped: t.is_wrapped
			t_lock_effect: t.lock = Current
			t_observers_effect: t.observers = [Current]
		end

	add_set (s: V_HASH_SET [K]; t: V_HASH_TABLE [K, V])
			-- Add `s' to `sets'.
		require
			wrapped: is_wrapped
			s_wrapped: s.is_wrapped
			no_observers: s.observers.is_empty
			empty_set: s.set.is_empty
			valid_table: t = s.table
			modify_field (["sets", "tables", "subjects", "observers", "closed"], Current)
			modify_field (["lock", "subjects", "observers", "closed"], s)
		do
			s.unwrap
			add_table (t)
			unwrap
			s.set_lock (Current)
			sets := sets & s
			Current.subjects := subjects & s
			Current.observers := observers & s
			s.wrap
			wrap
		ensure
			sets_effect: sets = old sets & s
			wrapped: is_wrapped
			s_wrapped: s.is_wrapped
			s_lock_effect: s.lock = Current
			s_observers_effect: s.observers = [Current]
		end

invariant
	valid_buckets: across tables as t all
		across t.item.map.domain as x all
			t.item.buckets_.count > 0 and then
			t.item.buckets_ [t.item.bucket_index (x.item.hash_code_, t.item.buckets_.count)].has (x.item)
			end end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
