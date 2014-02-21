note
	description: "Sequences where values can be updated."
	author: "Nadia Polikarpova"
	model: map

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
			explicit: wrapping
		require
			has_index: has_index (i)
			modify_model (["map", "observers"], Current)
		local
			it: V_MUTABLE_SEQUENCE_ITERATOR [G]
		do
			it := at (i)
			it.put (v)
			forget_iterator (it)
		ensure
			map_effect: map ~ old map.updated (i, v)
			observers_restored: observers ~ old observers
		end

	swap (i1, i2: INTEGER)
			-- Swap values at positions `i1' and `i2'.
		note
			explicit: wrapping
		require
			has_index_one: has_index (i1)
			has_index_two: has_index (i2)
			modify_model (["map", "observers"], Current)
		local
			v: G
		do
			v := item (i1)
			put (item (i2), i1)
			put (v, i2)
		ensure
			map_effect: map ~ old map.updated (i1, map [i2]).updated (i2, map [i1])
			observers_restored: observers ~ old observers
		end

	fill (v: G; l, u: INTEGER)
			-- Put `v' at positions [`l', `u'].
		note
			explicit: wrapping
		require
			l_not_too_small: l >= lower
			u_not_too_large: u <= upper
			l_not_too_large: l <= u + 1
			modify_model (["map", "observers"], Current)
		local
			it: V_MUTABLE_SEQUENCE_ITERATOR [G]
			j: INTEGER
			m: like map
		do
			from
				it := at (l)
				j := l
			invariant
				j = lower_ + it.index - 1
				l <= j and j <= u + 1
				map.domain ~ map.domain.old_
				across map.domain as i all map [i.item] = if l <= i.item and i.item < j then v else map.old_ [i.item] end end
				it.is_wrapped
				it.inv
				is_wrapped
				modify_model (["index", "sequence"], it)
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
			l_not_too_small: l >= lower
			u_not_too_large: u <= upper
			l_not_too_large: l <= u + 1
			modify_model (["map", "observers"], Current)
		do
			fill (({G}).default, l, u)
		ensure
			map_domain_effect: map.domain ~ old map.domain
			map_changed_effect: (map | (create {MML_INTERVAL}.from_range (l, u))).is_constant (({G}).default)
			map_unchanged_effect: (map | (map.domain - (create {MML_INTERVAL}.from_range (l, u)))) ~
				old (map | (map.domain - (create {MML_INTERVAL}.from_range (l, u))))
			observers_restored: observers ~ old observers
		end

	copy_range (other: V_SEQUENCE [G]; other_first, other_last, index: INTEGER)
			-- Copy items of `other' within bounds [`other_first', `other_last'] to current sequence starting at index `index'.
		note
			explicit: wrapping
		require
			other_not_current: other /= Current
			other_first_not_too_small: other_first >= other.lower
			other_last_not_too_large: other_last <= other.upper
			other_first_not_too_large: other_first <= other_last + 1
			index_not_too_small: index >= lower
			enough_space: upper - index >= other_last - other_first
			modify_model (["map", "observers"], Current)
			modify_model ("observers", other)
		local
			other_it: V_SEQUENCE_ITERATOR [G]
			it: V_MUTABLE_SEQUENCE_ITERATOR [G]
			j, n: INTEGER
		do
			n := other_last - other_first + 1
			from
				j := 1
				other_it := other.at (other_first)
				it := at (index)
			invariant
				it.index = j + index - lower_
				other_it.index = j + other_first - other.lower_
				1 <= j and j <= n + 1
				map.domain ~ map.domain.old_
				across map.domain as i all map [i.item] = if index <= i.item and i.item < index + j - 1
					then other.map [i.item - index + other_first]
					else map.old_ [i.item] end end
				it.is_wrapped and other_it.is_wrapped
				is_wrapped and other.is_wrapped
				it.inv
				other_it.inv
				modify_model (["index", "sequence"], it)
				modify_model ("index", other_it)
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
			explicit: wrapping
		require
			modify_model (["map", "observers"], Current)
		local
			j, k: INTEGER
			l, u: INTEGER
		do
			from
				l := lower
				u := upper
				j := l
				k := u
			invariant
				inv
				map.domain ~ create {MML_INTERVAL}.from_range (l, u)
				l <= j and j <= k + 1 and k <= u
				k = l + u - j
				across j |..| k as i all map.domain [i.item] and then map [i.item] = map.old_ [i.item] end
				across lower_ |..| (j - 1) as i all map.domain [i.item] and then map [i.item] = map.old_ [l + u - i.item] end
				across (k + 1) |..| upper_ as i all map.domain [i.item] and then map [i.item] = map.old_ [l + u - i.item] end
				is_wrapped
				observers ~ observers.old_
				l = lower_
				u = upper_
			until
				j >= k
			loop
				swap (j, k)
				j := j + 1
				k := k - 1
			end
		ensure
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
