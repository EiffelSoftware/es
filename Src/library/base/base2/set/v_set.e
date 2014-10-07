note
	description: "[
		Container where all elements are unique with respect to some equivalence relation. 
		Elements can be added and removed.
		]"
	author: "Nadia Polikarpova"
	model: set, lock
	manual_inv: true
	false_guards: true

deferred class
	V_SET [G]

inherit
	V_CONTAINER [G]
		rename
			has as has_exactly
		redefine
--			has_exactly,
			occurrences
--			is_equal
		end

feature -- Search

	has (v: G): BOOLEAN
			-- Is `v' contained?
			-- (Uses object equality.)
		require
			non_void: v /= Void
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
		deferred
		ensure
			definition: Result = set_has (v)
		end

	item (v: G): G
			-- Element of `set' equivalent to `v' according to object equality.
		require
			has: set_has (v)
		deferred
		ensure
			definition: Result = set_item (v)
--			in_set: set [Result]
--			equals_v: Result.is_model_equal (v)
		end

--	has_exactly (v: G): BOOLEAN
--			-- Is value `v' contained?
--			-- (Uses reference equality.)
--		note
--			status: impure
--		local
--			it: V_SET_ITERATOR [G]
--		do
--			it := new_cursor
--			it.search (v)
--			Result := not it.after and then it.item = v
--			check assume: lock.sets [Current] end -- ToDo: missing precondition
--			check assume: lock.inv_only ("no_duplicates") end
--			check Result = set [v] end
--			forget_iterator (it)
--		end

	occurrences (v: G): INTEGER
			-- How many times is `v' contained?
			-- (Uses reference equality.)
		note
			status: impure, dynamic
			explicit: wrapping
		do
			if has_exactly (v) then
				Result := 1
			end
			check inv end
		end

feature -- Iteration

	new_cursor: V_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		note
			status: impure
			explicit: contracts
		deferred
		end

	at (v: G): V_SET_ITERATOR [G]
			-- New iterator over `Current' pointing at element `v' if it exists and `after' otherwise.
		note
			status: impure
		require
			modify_field (["observers", "closed"], Current)
		deferred
		ensure
			result_fresh: Result.is_fresh
			result_wrapped: Result.is_wrapped and Result.inv
			result_in_observers: observers = old observers & Result
			target_definition: Result.target = Current
			index_definition_found: set_has (v) implies v.is_model_equal (Result.sequence [Result.index])
			index_definition_not_found: not set_has (v) implies Result.index = Result.sequence.count + 1
		end

feature -- Comparison

	is_subset_of (other: V_SET [G]): BOOLEAN
			-- Does `other' have all elements of `Current'?
			-- (Uses `other.equivalence'.)
		deferred
--			Result := for_all (agent other.has)
		ensure
			definition: Result = across set as x all other.set_has (x.item) end
		end

	is_superset_of (other: V_SET [G]): BOOLEAN
			-- Does `Current' have all elements of `other'?
			-- (Uses `equivalence'.)
		note
			status: dynamic
		do
			Result := other.is_subset_of (Current)
		ensure
			definition: Result = across other.set as x all set_has (x.item) end
		end

	disjoint (other: V_SET [G]): BOOLEAN
			-- Do no elements of `other' occur in `Current'?
			-- (Uses `equivalence'.)
		require
			other_exists: other /= Void
		deferred
--			Result := not other.exists (agent has)
		ensure
			definition: Result = across other.set as x all not set_has (x.item) end
		end

--	is_equal (other: like Current): BOOLEAN
--			-- Does `other' has equivalent elements (with respect to both `equivalence' and `other.equivalence')?
--		local
--			i, j: V_SET_ITERATOR [G]
--		do
--			if other = Current then
--				Result := True
--			elseif count = other.count then
--				from
--					Result := True
--					i := new_cursor
--					j := other.new_cursor
--				until
--					i.after or not Result
--				loop
--					j.search (i.item)
--					Result := not j.after and then i.item ~ j.item
--					i.forth
--				end
--			end
--		ensure then
--			definition: Result = (set.count = other.set.count and
--				set.for_all (agent (x: G; o: like Current): BOOLEAN
--					do
--						Result := o.has (x) and then equivalent (x, o.item (x))
--					end (?, other)))
--		end

feature -- Extension

	extend (v: G)
			-- Add `v' to the set.
		require
			v_locked: lock.owns [v]
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			iterators_open: across observers as o all o.item /= lock implies o.item.is_open end
			modify_model ("set", Current)
		deferred
		ensure
			abstract_effect: set_has (v)
			precise_effect_has: old set_has (v) implies set = old set
			precise_effect_new: not old set_has (v) implies set = old set & v
		end

	join (other: V_SET [G])
			-- Add all elements from `other'.
		note
			status: dynamic
			explicit: wrapping
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			other_registered: lock.sets [other]
			iterators_open: across observers as o all o.item /= lock implies o.item.is_open end
			modify_model ("set", Current)
			modify_model ("observers", other)
		local
			it: V_SET_ITERATOR [G]
		do
			check inv_only ("set_non_void") end
			if other /= Current then
				from
					it := other.new_cursor
				invariant
					is_wrapped
					other.is_wrapped
					it.is_wrapped
					inv_only ("lock_non_current")
					other.inv_only ("set_non_void", "lock_non_current")
					lock.inv_only ("subjects_lock", "owns_items")
					1 <= it.index_ and it.index_ <= it.sequence.count + 1
					set.old_ <= set
					across 1 |..| (it.index_ - 1) as i all set_has (it.sequence [i.item]) end
					across set as x all set.old_ [x.item] or other.set_has (x.item).old_ end
					modify_model ("set", Current)
					modify_model ("index_", it)
				until
					it.after
				loop
					extend (it.item)
					it.forth
				variant
					it.sequence.count - it.index_
				end
				other.forget_iterator (it)
			end
		ensure
			has_old: old set <= set
			has_other: across old other.set as y all y.item /= Void and then set_has (y.item) end
			no_extra: across set as x all set_has (x.item).old_ or other.set_has (x.item).old_ end
			other_observers_restored: other.observers ~ old other.observers
		end

feature -- Removal

	remove (v: G)
			-- Remove `v' from the set, if contained.
			-- Otherwise do nothing.		
		note
			status: dynamic
			explicit: wrapping
		require
			v_locked: lock.owns [v]
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			iterators_open: across observers as o all o.item /= lock implies o.item.is_open end
			modify_model (["set", "observers"], Current)
		local
			it: V_SET_ITERATOR [G]
		do
			check inv_only ("set_non_void", "bag_definition", "lock_non_current") end
			it := at (v)
			if not it.after then
--				check it.sequence.to_bag [it.sequence [it.index_]] = 1 end
				it.remove
				check it.inv end
			end
			check lock.inv_only ("subjects_lock", "owns_items", "no_duplicates") end
			forget_iterator (it)
			check inv_only ("set_non_void") end
		ensure
			abstract_effect: not set_has (v)
			precise_effect_not_found: not old set_has (v) implies set = old set
			precise_effect_found: old set_has (v) implies set = old set / set_item (v)
			observers_restored: observers ~ old observers
		end

	meet (other: V_SET [G])
			-- Keep only elements that are also in `other'.
		note
			status: dynamic
			explicit: wrapping
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			other_registered: lock.sets [other]
			iterators_open: across observers as o all o.item /= lock implies o.item.is_open end
			modify_model (["set", "observers"], Current)
		local
			it: V_SET_ITERATOR [G]
		do
			check inv_only ("set_non_void", "lock_non_current") end
			if other /= Current then
				from
					it := new_cursor
				invariant
					is_wrapped
					other.is_wrapped
					it.is_wrapped
					inv_only ("set_non_void")
					it.inv
					lock.inv_only ("subjects_lock", "owns_items", "no_duplicates")
					1 <= it.index_ and it.index_ <= it.sequence.count + 1
					set <= set.old_
					across 1 |..| (it.index_ - 1) as i all other.set_has (it.sequence [i.item]) end
					across set.old_ as y all other.set_has (y.item) implies set [y.item] end
					modify_model ("set", Current)
					modify_model (["sequence", "index_"], it)
				until
					it.after
				loop
					if not other.has (it.item) then
						it.remove
					else
						it.forth
					end
				variant
					it.sequence.count - it.index_
				end
				forget_iterator (it)
			end
		ensure
			only_old: set <= old set
			not_too_few: across old set as y all other.set_has (y.item).old_ = set_has (y.item) end
			observers_restored: observers ~ old observers
		end

	subtract (other: V_SET [G])
			-- Remove elements that are in `other'.
		note
			status: dynamic
			explicit: wrapping
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			other_registered: lock.sets [other]
			iterators_open: across observers as o all o.item /= lock implies o.item.is_open end
			modify_model (["set", "observers"], Current)
			modify_model ("observers", other)
		local
			it: V_SET_ITERATOR [G]
		do
			check inv_only ("set_non_void", "lock_non_current") end
			if other /= Current then
				from
					it := other.new_cursor
				invariant
					is_wrapped
					other.is_wrapped
					it.is_wrapped
					inv_only ("lock_non_current")
					other.inv_only ("set_non_void", "lock_non_current")
					lock.inv_only ("subjects_lock", "owns_items", "no_duplicates")
					1 <= it.index_ and it.index_ <= it.sequence.count + 1
					set <= set.old_
					across 1 |..| (it.index_ - 1) as i all not set_has (it.sequence [i.item]) end
					across set.old_ as y all not other.set_has (y.item) implies set [y.item] end
					observers ~ observers.old_
					modify_model (["set", "observers"], Current)
					modify_model ("index_", it)
				until
					it.after
				loop
					remove (it.item)
					it.forth
				variant
					it.sequence.count - it.index_
				end
				other.forget_iterator (it)
			else
				wipe_out
			end
		ensure
			only_old: set <= old set
			not_too_few: across old set as y all other.set_has (y.item).old_ /= set_has (y.item) end
			observers_restores: observers ~ old observers
			other_observers_restored: other.observers ~ old other.observers
		end

	symmetric_subtract (other: V_SET [G])
			-- Keep elements that are only in `Current' or only in `other'.
		note
			status: dynamic
			explicit: wrapping
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			other_registered: lock.sets [other]
			iterators_open: across observers as o all o.item /= lock implies o.item.is_open end
			modify_model (["set", "observers"], Current)
			modify_model ("observers", other)
		local
			it: V_SET_ITERATOR [G]
			s: MML_SEQUENCE [G]
		do
			check inv_only ("set_non_void", "lock_non_current") end
			if other /= Current then
				check lock.inv end
				check across set as x all lock.owns [x.item] end end
				from
					it := other.new_cursor
					s := it.sequence
				invariant
					is_wrapped
					other.is_wrapped
					it.is_wrapped
					other.inv_only ("set_non_void", "lock_non_current")
					lock.inv_only ("subjects_lock", "owns_items", "no_duplicates")
					1 <= it.index_ and it.index_ <= it.sequence.count + 1
					across set.old_ as x all other.set_has (x.item).old_ or set [x.item]  end
					across 1 |..| (it.index_ - 1) as i all set_has (s [i.item]).old_ or set_has (s [i.item]) end
					across set as x all set.old_ [x.item] or other.set_has (x.item).old_ end
					observers ~ observers.old_
					modify_model (["set", "observers"], Current)
					modify_model ("index_", it)
				until
					it.after
				loop
					if has (it.item) then
						remove (it.item)
					else
						extend (it.item)
					end
					it.forth
				variant
					it.sequence.count - it.index_
				end
				other.forget_iterator (it)
			else
				wipe_out
			end
		ensure
			set_effect_old: across old set as x all other.set_has (x.item).old_ or set_has (x.item)  end
			set_effect_other: across other.set.old_ as x all set_has (x.item).old_ or set_has (x.item) end
			set_effect_new: across set as x all set_has (x.item).old_ or other.set_has (x.item).old_ end
		end

	wipe_out
			-- Remove all elements.
		require
			lock_wrapped: lock.is_wrapped
			set_registered: lock.sets [Current]
			modify_model ("set", Current)
		deferred
		ensure
			set_effect: set.is_empty
		end

feature -- Specification

	set: MML_SET [G]
			-- Set of elements.
		note
			status: ghost
			replaces: bag
			guard: inv
		attribute
		end

	lock: V_LOCK [G]
			-- Helper object for keeping items consistent.
		note
			status: ghost
		attribute
		end

	set_has (v: G): BOOLEAN
			-- Does `set' contain an element equal to `v' under object equality?
		note
			status: ghost, functional
		require
			v_exists: v /= Void
			set_non_void: set.non_void
			reads (Current, set, v)
		do
			Result := across set as x some v.is_model_equal (x.item) end
		end

	set_item (v: G): G
			-- Element of `set' that is equal to `v' under object equality.
		note
			status: ghost
		require
			v_exists: v /= Void
			v_in_set: set_has (v)
			set_non_void: set.non_void
			reads (Current, set, v)
		local
			s: like set
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

	no_duplicates (s: like set): BOOLEAN
			-- Are all objects in `s' unique by value?
		note
			status: ghost, functional
		require
			non_void: s.non_void
			reads (s)
		do
			Result := across s as x all across s as y all x.item /= y.item implies not x.item.is_model_equal (y.item) end end
		end

invariant
	set_non_void: set.non_void
	lock_non_void: lock /= Void
	lock_non_current: lock /= Current
	lock_non_iterator: not attached {V_ITERATOR [G]} lock
	observers_constraint: observers [lock]
	bag_domain_definition: bag.domain ~ set
	bag_definition: bag.is_constant (1)

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
