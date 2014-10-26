note
	description: "[
			Hash sets with hash function provided by HASHABLE and object equality.
			Implementation uses hash tables.
			Search, extension and removal are amortized constant time.
		]"
	author: "Nadia Polikarpova"
	model: set, lock
	manual_inv: true
	false_guards: true

frozen class
	V_HASH_SET [G -> V_HASHABLE]

inherit
	V_SET [G]
		redefine
			default_create,
			lock,
			forget_iterator
		end

feature {NONE} -- Initialization

	default_create
			-- Create an empty set without a lock.
		note
			status: creator
		do
			create table
		ensure then
			set_empty: set.is_empty
			no_lock: lock = Void
			observers_empty: observers.is_empty
		end

feature -- Initialization

	copy_ (other: V_HASH_SET [G])
			-- Initialize by copying all the items of `other'.
		note
			explicit: wrapping
		require
			lock_wrapped: lock.is_wrapped
			same_lock: lock = other.lock
			no_iterators: observers = [lock]
			modify_model (["set", "owns"], Current)
			modify_model ("observers", [Current, other])
		do
			if other /= Current then
				unwrap
				other.unwrap
				check table.inv_only ("observers_constraint") end
				table.copy_ (other.table)
				other.wrap
				wrap
			end
		ensure
			set_effect: set ~ old other.set
			observers_restored: observers ~ old observers
			other_observers_restored: other.observers ~ old other.observers
		end

feature -- Measurement

	count: INTEGER
			-- Number of elements.
		do
			check inv end
			Result := table.count
		end

feature -- Search

	has (v: G): BOOLEAN
			-- Is `v' contained?
			-- (Uses object equality.)
		do
			check inv end
			Result := table.has_key (v)
		end

	item (v: G): G
			-- Element of `set' equivalent to `v' according to object equality.
		do
			check inv end
			Result := table.key (v)
		end

feature -- Iteration

	new_cursor: V_HASH_SET_ITERATOR [G]
			-- New iterator pointing to a position in the set, from which it can traverse all elements by going `forth'.
		note
			status: impure
		do
			create Result.make (Current)
			Result.start
		end

	at (v: G): V_HASH_SET_ITERATOR [G]
			-- New iterator over `Current' pointing at element `v' if it exists and `after' otherwise.
		note
			status: impure
		do
			create Result.make (Current)
			Result.search (v)
		end

feature -- Extension

	extend (v: G)
			-- Add `v' to the set.
		do
			check table.inv_only ("observers_constraint") end
			check lock.inv_only ("owns_items") end
			table.force (Void, v)
			if not table.domain_has (v).old_ then
				check table.map.domain [v] end
			else
				check table.map.domain = table.map.domain.old_ end
			end
		end

feature -- Removal

	wipe_out
			-- Remove all elements.
		do
			check table.inv_only ("observers_constraint") end
			table.lemma_domain
			table.wipe_out
		end

feature {V_CONTAINER, V_ITERATOR, V_LOCK} -- Implementation

	table: V_HASH_TABLE [G, ANY]
			-- Hash table that stores set elements as keys.

feature -- Specification

	lock: V_HASH_LOCK [G]
			-- Helper object for keeping items consistent.
		note
			status: ghost
		attribute
		end

	forget_iterator (it: V_ITERATOR [G])
			-- Remove `it' from `observers'.
		note
			status: ghost
			explicit: contracts
		do
			check it.inv_only ("subjects_definition", "A2") end
			check attached {V_HASH_SET_ITERATOR [G]} it as hsit then
				hsit.unwrap
				set_observers (observers / hsit)
				check hsit.iterator.inv_only ("subjects_definition", "A2") end
				table.lemma_domain
				check hsit.iterator.inv_only ("owns_definition"); hsit.iterator.list_iterator.inv_only ("default_owns") end
				table.forget_iterator (hsit.iterator)
			end
		end

feature {V_CONTAINER, V_ITERATOR, V_LOCK}

	set_lock (l: V_HASH_LOCK [G])
			-- Set `lock' to `l'.
		note
			status: ghost, setter
		require
			open: is_open
			no_observers: observers.is_empty
			modify_field (["lock", "subjects", "observers"], Current)
		do
			lock := l
			Current.subjects := [lock]
			Current.observers := [lock]
		ensure
			lock = l
			subjects = [l]
			observers = [l]
		end

invariant
	table_exists: table /= Void
	owns_definition: owns = [table]
	set_implementation: set = table.map.domain
	same_lock: lock = table.lock
	observers_type: across observers as o all o /= lock implies attached {V_HASH_SET_ITERATOR [G]} o.item end
	observers_correspond: table.observers.count <= observers.count

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
