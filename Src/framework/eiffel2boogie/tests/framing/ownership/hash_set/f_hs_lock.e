note
	description: "A ghost object that prevents set elements from modification."
	status: ghost
	manual_inv: true
	false_guards: true
	explicit: "all"

frozen class
	F_HS_LOCK

feature -- Access

	sets: MML_SET [F_HS_SET [F_HS_HASHABLE]]
			-- Sets that might share elements owned by this lock.

feature -- Basic operations

	add_set (s: F_HS_SET [F_HS_HASHABLE])
			-- Add `s' to `sets'.
		require
			wrapped: is_wrapped
			valid_lock: s.lock = Current
			valid_observers: s.observers [Current]
			empty_set: s.set.is_empty
			modify_field (["sets", "subjects", "closed"], Current)
		do
			unwrap
			sets := sets & s
			set_subjects (subjects & s)
			wrap
		ensure
			is_wrapped
			sets [s]
		end

	lock (item: F_HS_HASHABLE)
			-- Add `item' to `owns'.
		require
			is_wrapped
			item.is_wrapped
			modify_field (["owns", "closed"], Current)
			modify_field ("owner", item)
		do
			unwrap
			set_owns (owns & item)
			wrap
		ensure
			owns [item]
			is_wrapped
		end

	unlock (item: F_HS_HASHABLE)
			-- Remove `item' that is not in any of the `sets' from `owns'.
		require
			is_wrapped
			owns [item]
			across sets as s all not s.item.set [item] end
			modify_field (["owns", "closed"], Current)
			modify_field ("owner", item)
		do
			unwrap
			set_owns (owns / item)
			wrap
		ensure
			item.is_wrapped
			is_wrapped
		end

invariant
	subjects_definition: subjects = sets
	subjects_lock: across sets as s all s.item.lock = Current end
	owns_items: across sets as s all
		across s.item.set as x all owns [x.item] end end
	valid_buckets: across sets as s all
		across s.item.set as x all
			s.item.buckets.domain [x.item.hash_code_] and then
			s.item.buckets [x.item.hash_code_].has (x.item) end end
	no_duplicates: across sets as s all
		across s.item.set as x all
			across s.item.set as y all x.item /= y.item implies not x.item.is_model_equal (y.item) end end end
	adm2: across sets as s all s.item.observers [Current] end
	no_observers: observers.is_empty

end
