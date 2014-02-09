note
	description: "[
		Containers for a finite number of values.
		Immutable interface.
		]"
	author: "Nadia Polikarpova"
	model: bag

deferred class
	V_CONTAINER [G]

inherit
	ITERABLE [G]

feature -- Measurement

	count: INTEGER
			-- Number of elements.
		deferred
		ensure
			definition: Result = bag.count
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is container empty?
		do
			Result := count = 0
		ensure
			definition: Result = bag.is_empty
		end

feature -- Search

	has (v: G): BOOLEAN
			-- Is value `v' contained?
			-- (Uses reference equality.)
		note
			status: impure
			explicit: contracts
		require
			is_wrapped: is_wrapped
			modify_model (["closed", "observers"], Current)
		local
			it: V_ITERATOR [G]
		do
			it := new_cursor
			it.search_forth (v)
			Result := not it.after
			unwrap; it.unwrap
			set_observers (observers / it)
			wrap
		ensure
			definition: Result = bag.domain [v]
			observers_restored: observers = old observers
			is_wrapped: is_wrapped
		end

	occurrences (v: G): INTEGER
			-- How many times is value `v' contained?
			-- (Uses reference equality.)
		note
			status: impure
			explicit: contracts
		require
			is_wrapped: is_wrapped
			modify_model (["closed", "observers"], Current)
		local
			it: like new_cursor
			s: MML_SEQUENCE [G]
		do
			from
				it := new_cursor
			invariant
				1 <= it.index and it.index <= it.sequence.count + 1
				s = it.sequence.front (it.index - 1)
				Result = s.occurrences (v)
				modify_model (["index", "box"], it)
			until
				it.off
			loop
				if it.item = v then
					Result := Result + 1
				end
				s := s & it.item
				it.forth
			variant
				it.sequence.count - it.index
			end
			check s = it.sequence end
			unwrap; it.unwrap
			set_observers (observers / it)
			wrap
		ensure
			definition: Result = bag [v]
			observers_restored: observers = old observers
			is_wrapped: is_wrapped
		end

--	count_satisfying (pred: PREDICATE [ANY, TUPLE [G]]): INTEGER
--			-- How many elements satisfy `pred'?
--		require
--			pred_exists: pred /= Void
--			pred_has_one_arg: pred.open_count = 1
--			precondition_satisfied: bag.domain.for_all (agent (x: G; p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--				do
--					Result := p.precondition ([x])
--				end (?, pred))
--		do
--			across
--				Current as it
--			loop
--				if pred.item ([it.item]) then
--					Result := Result + 1
--				end
--			end
--		ensure
--			definition: Result = (bag | (bag.domain | pred)).count
--		end

--	exists (pred: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--			-- Is there an element that satisfies `pred'?
--		require
--			pred_exists: pred /= Void
--			pred_has_one_arg: pred.open_count = 1
--			precondition_satisfied: bag.domain.for_all (agent (x: G; p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--				do
--					Result := p.precondition ([x])
--				end (?, pred))
--		do
--			Result := across Current as it some pred.item ([it.item]) end
--		ensure
--			definition: Result = bag.domain.exists (pred)
--		end

--	for_all (pred: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--			-- Do all elements satisfy `pred'?
--		require
--			pred_exists: pred /= Void
--			pred_has_one_arg: pred.open_count = 1
--			precondition_satisfied: bag.domain.for_all (agent (x: G; p: PREDICATE [ANY, TUPLE [G]]): BOOLEAN
--				do
--					Result := p.precondition ([x])
--				end (?, pred))
--		do
--			Result := across Current as it all pred.item ([it.item]) end
--		ensure
--			definition: Result = bag.domain.for_all (pred)
--		end

feature -- Iteration

	new_cursor: V_ITERATOR [G]
			-- New iterator pointing to a position in the container, from which it can traverse all elements by going `forth'.
		note
			explicit: contracts
			status: impure
		deferred
		ensure then
			target_definition: Result.target = Current
			index_definition: Result.index = 1
		end

--feature -- Output

--	out: STRING
--			-- String representation of the content.
--		local
--			stream: V_STRING_OUTPUT
--		do
--			create Result.make_empty
--			create stream.make (Result)
--			stream.pipe (new_cursor)
--			Result.remove_tail (stream.separator.count)
--		end

feature -- Specification

	bag: MML_BAG [G]
			-- Bag of elements.
		note
			status: ghost
		attribute
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
