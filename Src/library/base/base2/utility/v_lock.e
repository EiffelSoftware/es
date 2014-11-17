note
	description: "[
		Helper ghost objects that prevent table keys and set elements from unwanted modifications.
		]"
	author: "Nadia Polikarpova"
	status: ghost
	model: sets, tables
	manual_inv: true
	false_guards: true
	explicit: "all"

class
	V_LOCK [K, V]

feature -- Access	

	sets: MML_SET [V_SET [K]]
			-- Sets that might share elements owned by this lock.
		note
			guard: in_sets
		attribute
		end

	tables: MML_SET [V_MAP [K, V]]
			-- Tables that might share keys owned by this lock.
		note
			guard: in_tables
		attribute
		end

feature -- Basic operations

	lock (item: K)
			-- Add `item' to `owns'.
		note
			status: setter
		require
			wrapped: is_wrapped
			item_wrapped: item.is_wrapped
			not_current: item /= Current
			item_not_set: not subjects [item]
			modify_field (["owns", "closed"], Current)
			modify_field ("owner", [item, owns])
		do
			unwrap
			set_owns (owns & item)
			wrap
		ensure
			owns_effect: owns = old owns & item
			wrapped: is_wrapped
		end

	unlock (item: K)
			-- Remove `item' that is not in any of the `sets' from `owns'.
		note
			status: setter
		require
			wrapped: is_wrapped
			item_locked: owns [item]
			not_in_set: across sets as s all not s.item.set [item] end
			not_in_table: across tables as t all not t.item.map.domain [item] end
			modify_field (["owns", "closed"], Current)
			modify_field ("owner", [item, owns])
		do
			unwrap
			set_owns (owns / item)
			wrap
		ensure
			owns_effect: owns = old owns / item
			item_wrapped: item.is_wrapped
			wrapped: is_wrapped
		end

feature -- Specification

	in_sets (new_sets: like observers; o: ANY): BOOLEAN
			-- Is `o' in `new_sets'? (Guard for `sets')
		note
			status: functional, ghost, nonvariant
		do
			Result := new_sets [o] or attached {V_MAP [K, V]} o
		end

	in_tables (new_tables: like observers; o: ANY): BOOLEAN
			-- Is `o' in `new_tables'? (Guard for `tables')
		note
			status: functional, ghost, nonvariant
		do
			Result := new_tables [o] or attached {V_SET [K]} o
		end

	set_has (s: MML_SET [K]; v: K): BOOLEAN
			-- Does `s' contain an element equal to `v' under object equality?
		note
			status: ghost, functional, nonvariant, static
		require
			v_exists: v /= Void
			set_non_void: s.non_void
			reads (s, v)
		do
			Result := across s as x some v.is_model_equal (x.item) end
		end

	set_item (set: MML_SET [K]; v: K): K
			-- Element of `set' that is equal to `v' under object equality.
		note
			status: ghost, nonvariant, static
		require
			v_exists: v /= Void
			v_in_set: set_has (set, v)
			set_non_void: set.non_void
			reads (set, v)
		local
			s: MML_SET [K]
		do
			from
				s := set
				Result := s.any_item
			invariant
				s [Result]
				across s as x some v.is_model_equal (x.item) end
				s <= set
				decreases (s)
			until
				Result.is_model_equal (v)
			loop
				s := s / Result
				check across s as x some v.is_model_equal (x.item) end end
				Result := s.any_item
			end
		ensure
			result_in_set: set [Result]
			equal_to_v: Result.is_model_equal (v)
		end

	no_duplicates (s: MML_SET [K]): BOOLEAN
			-- Are all objects in `s' unique by value?
		note
			status: ghost, functional, nonvariant, static
		require
			non_void: s.non_void
			reads (s)
		do
			Result := across s as x all across s as y all x.item /= y.item implies not x.item.is_model_equal (y.item) end end
		end

invariant
	subjects_definition: subjects = {MML_SET [ANY]} [sets] + tables
	observers_definition: observers = subjects
	disjoint: {MML_SET [ANY]} [sets].is_disjoint (tables)
	sets_non_void: sets.non_void
	tables_non_void: tables.non_void
	items_non_void: across sets as s all s.item.set.non_void end
	keys_non_void: across tables as t all t.item.map.domain.non_void end
	owns_items: across sets as s all
		across s.item.set as x all owns [x.item] end end
	owns_keys: across tables as t all
		across t.item.map.domain as x all owns [x.item] end end
	no_owned_subjects: subjects.is_disjoint (owns)
	sets_no_duplicates: across sets as s all no_duplicates (s.item.set) end
	no_duplicates: across tables as t all no_duplicates (t.item.map.domain) end
	adm2_sets: across sets as s all s.item.observers [Current] end
	adm2_tables: across tables as t all t.item.observers [Current] end

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
