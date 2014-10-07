note
	description: "[
		Helper ghost objects that prevent set elements from unwanted modifications.
		]"
	author: "Nadia Polikarpova"
	status: ghost
	model: sets
	manual_inv: true
	false_guards: true
	explicit: "all"

class
	V_LOCK [G]

feature -- Access	

	sets: MML_SET [V_SET [G]]
			-- Sets that might share elements owned by this lock.

feature -- Basic operations

	add_set (s: V_SET [G])
			-- Add `s' to `sets'.
		note
			status: setter
		require
			wrapped: is_wrapped
			s_wrapped: s.is_wrapped
			valid_lock: s.lock = Current
			valid_observers: s.observers [Current]
			empty_set: s.set.is_empty
			modify_field (["sets", "subjects", "closed"], Current)
			modify_field ("owner", owns)
		do
			unwrap
			sets := sets & s
			set_subjects (subjects & s)
			wrap
		ensure
			sets_effect: sets = old sets & s
			wrapped: is_wrapped
		end

	lock (item: G)
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

	unlock (item: G)
			-- Remove `item' that is not in any of the `sets' from `owns'.
		note
			status: setter
		require
			wrapped: is_wrapped
			item_locked: owns [item]
			not_in_set: across sets as s all not s.item.set [item] end
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

invariant
	subjects_definition: subjects = sets
	subjects_lock: across sets as s all s.item.lock = Current end
	owns_items: across sets as s all
		across s.item.set as x all owns [x.item] end end
	no_owned_sets: subjects.is_disjoint (owns)
	no_duplicates: across sets as s all s.item.set.non_void and then s.item.no_duplicates (s.item.set) end
--		across s.item.set as x all
--			across s.item.set as y all
--				x.item /= Void and y.item /= Void and then (x.item /= y.item implies not x.item.is_model_equal (y.item)) end end end
	adm2: across sets as s all s.item.observers [Current] end
	no_observers: observers.is_empty

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
