note
	description: "Sequences where values can be updated."
	author: "Nadia Polikarpova"
	model: map
	manual_inv: true	

deferred class
	V_MUTABLE_SEQUENCE [G]

inherit
	V_SEQUENCE [G]
		redefine
			item
		end

feature -- Access

	item alias "[]" (i: INTEGER): G assign put
			-- Value at position `i'.
		deferred
		end

feature -- Iteration

	at (i: INTEGER): V_MUTABLE_SEQUENCE_ITERATOR [G]
			-- New iterator pointing at position `i'.
		note
			status: impure
			explicit: contracts
		deferred
		end

feature -- Replacement

	put (v: G; i: INTEGER)
			-- Replace value at position `i' with `v'.
		note
			explicit: contracts, wrapping
		require
			is_wrapped: is_wrapped
			has_index: has_index (i)
			observers_open: across observers as o all o.item.is_open end
			modify_model (["map", "observers"], Current)
		local
			it: V_MUTABLE_SEQUENCE_ITERATOR [G]
		do
			it := at (i)
			it.put (v)
			forget_iterator (it)
		ensure
			is_wrapped: is_wrapped
			map_effect: map ~ old map.updated (i, v)
			observers_restored: observers ~ old observers
		end

	swap (i1, i2: INTEGER)
			-- Swap values at positions `i1' and `i2'.
		note
			explicit: contracts, wrapping
		require
			is_wrapped: is_wrapped
			has_index_one: has_index (i1)
			has_index_two: has_index (i2)
			observers_open: across observers as o all o.item.is_open end
			modify_model (["map", "observers"], Current)
		local
			v: G
		do
			v := item (i1)
			put (item (i2), i1)
			put (v, i2)
		ensure
			is_wrapped: is_wrapped
			map_effect: map ~ old map.updated (i1, map [i2]).updated (i2, map [i1])
			observers_restored: observers ~ old observers
		end

	fill (v: G; l, u: INTEGER)
			-- Put `v' at positions [`l', `u'].
		note
			explicit: contracts, wrapping
		require
			is_wrapped: is_wrapped
			l_not_too_small: l >= lower
			u_not_too_large: u <= upper
			l_not_too_large: l <= u + 1
			observers_open: across observers as o all o.item.is_open end
			modify_model (["map", "observers"], Current)
		local
			it: V_MUTABLE_SEQUENCE_ITERATOR [G]
			j: INTEGER
			m: like map
		do
			check inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty") end
			from
				it := at (l)
				j := l
			invariant
				is_wrapped and it.is_wrapped
				inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty") and it.inv
				j = lower_ + it.index_ - 1
				l <= j and j <= u + 1
				map.domain ~ map.domain.old_
				across map.domain as i all map [i.item] = if l <= i.item and i.item < j then v else map.old_ [i.item] end end
				modify_model (["index_", "sequence"], it)
				modify_model ("map", Current)
			until
				j > u
			loop
				it.put (v)
				it.forth
				j := j + 1
			end

			forget_iterator (it)
		ensure
			is_wrapped: is_wrapped
			map_domain_effect: map.domain ~ old map.domain
			map_changed_effect: (map | (create {MML_INTERVAL}.from_range (l, u))).is_constant (v)
			map_unchanged_effect: (map | (map.domain - (create {MML_INTERVAL}.from_range (l, u)))) ~
				old (map | (map.domain - (create {MML_INTERVAL}.from_range (l, u))))
			observers_restored: observers ~ old observers
		end

	clear (l, u: INTEGER)
			-- Put default value at positions [`l', `u'].
		note
			explicit: wrapping
		require
			is_wrapped: is_wrapped
			l_not_too_small: l >= lower
			u_not_too_large: u <= upper
			l_not_too_large: l <= u + 1
			observers_open: across observers as o all o.item.is_open end
			modify_model (["map", "observers"], Current)
		do
			fill (({G}).default, l, u)
		ensure
			is_wrapped: is_wrapped
			map_domain_effect: map.domain ~ old map.domain
			map_changed_effect: (map | (create {MML_INTERVAL}.from_range (l, u))).is_constant (({G}).default)
			map_unchanged_effect: (map | (map.domain - (create {MML_INTERVAL}.from_range (l, u)))) ~
				old (map | (map.domain - (create {MML_INTERVAL}.from_range (l, u))))
			observers_restored: observers ~ old observers
		end

	copy_range (other: V_SEQUENCE [G]; other_first, other_last, index: INTEGER)
			-- Copy items of `other' within bounds [`other_first', `other_last'] to current sequence starting at index `index_'.
		note
			explicit: wrapping
		require
			is_wrapped: is_wrapped
			other_wrapped: other.is_wrapped
			other_not_current: other /= Current
			other_first_not_too_small: other_first >= other.lower
			other_last_not_too_large: other_last <= other.upper
			other_first_not_too_large: other_first <= other_last + 1
			index_not_too_small: index >= lower
			enough_space: upper - index >= other_last - other_first
			observers_open: across observers as o all o.item.is_open end
			modify_model (["map", "observers"], Current)
			modify_model ("observers", other)
		local
			other_it: V_SEQUENCE_ITERATOR [G]
			it: V_MUTABLE_SEQUENCE_ITERATOR [G]
			j, n: INTEGER
		do
			n := other_last - other_first + 1
			check inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty") end
			check other.inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty") end
			from
				j := 1
				other_it := other.at (other_first)
				it := at (index)
			invariant
				is_wrapped and other.is_wrapped
				it.is_wrapped and other_it.is_wrapped
				inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty")
				other.inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty")
				it.inv
				it.index_ = j + index - lower_
				other_it.index_ = j + other_first - other.lower_
				1 <= j and j <= n + 1
				map.domain ~ map.domain.old_
				across map.domain as i all map [i.item] = if index <= i.item and i.item < index + j - 1
					then other.map [i.item - index + other_first]
					else map.old_ [i.item] end end
				modify_model (["index_", "sequence"], it)
				modify_model ("index_", other_it)
				modify_model ("map", Current)
			until
				j > n
			loop
				it.put (other_it.item)
				other_it.forth
				it.forth
				j := j + 1
			end

			other.forget_iterator (other_it)
			forget_iterator (it)
		ensure
			is_wrapped: is_wrapped
			map_domain_effect: map.domain ~ old map.domain
			map_changed_effect: across create {MML_INTERVAL}.from_range (index, index + other_last - other_first) as i all
				map [i.item] = other.map [i.item - index + other_first] end
			map_unchanged_effect: (map | (map.domain - (create {MML_INTERVAL}.from_range (index, index + other_last - other_first)))) ~
				old (map | (map.domain - (create {MML_INTERVAL}.from_range (index, index + other_last - other_first))))
			observers_restored: observers ~ old observers
			other_observers_restored: other.observers ~ old other.observers
		end

	reverse
			-- Reverse the order of elements.
		note
			explicit: contracts, wrapping
		require
			is_wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["map", "observers"], Current)
		local
			j, k: INTEGER
		do
			from
				j := lower
				k := upper
			invariant
				inv_only ("indexes_in_interval", "lower_when_empty", "upper_when_empty")
				map.domain ~ map.domain.old_
				lower_ <= j and j <= k + 1 and k <= upper_
				k = lower_ + upper_ - j
				across j |..| k as i all map.domain [i.item] and then map [i.item] = map.old_ [i.item] end
				across lower_ |..| (j - 1) as i all map.domain [i.item] and then map [i.item] = map.old_ [lower_ + upper_ - i.item] end
				across (k + 1) |..| upper_ as i all map.domain [i.item] and then map [i.item] = map.old_ [lower_ + upper_ - i.item] end
				is_wrapped
				observers ~ observers.old_
			until
				j >= k
			loop
				swap (j, k)
				j := j + 1
				k := k - 1
			end
		ensure
			is_wrapped: is_wrapped
			map_domain_effect: map.domain ~ old map.domain
			map_effect: across map.domain as i all map [i.item] = (old map) [lower_ + upper_ - i.item] end
			observers_restored: observers ~ old observers
		end

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
