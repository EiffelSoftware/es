note
	description: "[
		Helper ghost objects that prevent table keys from unwanted modifications.
		]"
	author: "Nadia Polikarpova"
	status: ghost
	model: tables
	manual_inv: true
	false_guards: true
	explicit: "all"

class
	V_KEY_LOCK [K]

feature -- Access	

	tables: MML_SET [V_MAP [K, ANY]]
			-- Tables that might share keys owned by this lock.
		note
			guard: in_tables
		attribute
		end

feature -- Basic operations

	add_table (t: V_MAP [K, ANY])
			-- Add `s' to `sets'.
		note
			status: setter
		require
			wrapped: is_wrapped
			t_wrapped: t.is_wrapped
			valid_lock: t.lock = Current
			valid_observers: t.observers [Current]
			empty_set: t.map.is_empty
			modify_field (["tables", "subjects", "observers", "closed"], Current)
			modify_field ("owner", owns)
		do
			unwrap
			tables := tables & t
			Current.subjects := subjects & t
			Current.observers := observers & t
			wrap
		ensure
			tables_effect: tables = old tables & t
			wrapped: is_wrapped
		end

	remove_table (t: V_MAP [K, ANY])
			-- Add `s' to `tables'.
		note
			status: setter
		require
			wrapped: is_wrapped
			t_open: t.is_open
			modify_field (["tables", "subjects", "observers", "closed"], Current)
			modify_field ("owner", owns)
		do
			unwrap
			tables := tables / t
			Current.subjects := subjects / t
			Current.observers := observers / t
			wrap
		ensure
			tables_effect: tables = old tables / t
			wrapped: is_wrapped
		end

	lock (key: K)
			-- Add `key' to `owns'.
		note
			status: setter
		require
			wrapped: is_wrapped
			key_wrapped: key.is_wrapped
			not_current: key /= Current
			key_not_table: not subjects [key]
			modify_field (["owns", "closed"], Current)
			modify_field ("owner", [key, owns])
		do
			unwrap
			set_owns (owns & key)
			wrap
		ensure
			owns_effect: owns = old owns & key
			wrapped: is_wrapped
		end

	unlock (key: K)
			-- Remove `key' that is not in any of the `tables' from `owns'.
		note
			status: setter
		require
			wrapped: is_wrapped
			key_locked: owns [key]
			not_in_table: across tables as t all not t.item.map.domain [key] end
			modify_field (["owns", "closed"], Current)
			modify_field ("owner", [key, owns])
		do
			unwrap
			set_owns (owns / key)
			wrap
		ensure
			owns_effect: owns = old owns / key
			item_wrapped: key.is_wrapped
			wrapped: is_wrapped
		end

feature -- Specification

	in_tables (new_tables: like observers; o: ANY): BOOLEAN
			-- Is `o' in `new_tables'? (Guard for `tables')
		note
			status: functional, ghost
		do
			Result := new_tables [o]
		end

invariant
	subjects_definition: subjects = tables
	observers_definition: observers = tables
	keys_non_void: across tables as t all t.item.map.domain.non_void end
	owns_keys: across tables as t all
		across t.item.map.domain as x all owns [x.item] end end
	no_owned_tables: subjects.is_disjoint (owns)
	no_duplicates: across tables as t all t.item.no_duplicates (t.item.map.domain) end
	adm2: across tables as t all t.item.observers [Current] end

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
