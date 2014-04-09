note
	description: "[
		Singly linked lists.
		Random access takes linear time. 
		Once a position is found, inserting or removing elements to the right of it takes constant time 
		and doesn't require reallocation of other elements.
		]"
	author: "Nadia Polikarpova"
	model: sequence

class
	V_LINKED_LIST [G]

inherit
	V_LIST [G]
		redefine
			default_create,
			first,
			last,
			is_empty,
			put,
			prepend,
			reverse,
			extend_back
		end

feature {NONE} -- Initialization

	default_create
			-- Create an empty list.
		note
			status: creator
		do
			lower_ := 1
		ensure then
			sequence_effect: sequence.is_empty
		end

feature -- Initialization

	copy_ (other: V_LIST [G])
			-- Initialize by copying all the items of `other'.
		note
			explicit: wrapping
		require
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
			modify_model ("observers", other)
		do
			if other /= Current then
				wipe_out
				append (other.new_cursor)
			end
		ensure then
			sequence_effect: sequence ~ other.sequence
			other_sequence_effect: other.sequence ~ old other.sequence
		end

feature -- Access

	item alias "[]" (i: INTEGER): G assign put
			-- Value at position `i'.
		do
			check inv end
			if i = count then
				Result := last
			else
				Result := cell_at (i).item
			end
		end

	first: G
			-- First element.
		do
			check inv end
			check across cell_sequence.domain as i all sequence [i.item] = cell_sequence [i.item].item end end
			Result := first_cell.item
		end

	last: G
			-- Last element.
		do
			check inv end
			check across cell_sequence.domain as i all sequence [i.item] = cell_sequence [i.item].item end end
			Result := last_cell.item
		end

	is_empty: BOOLEAN
			-- Is container empty?
		do
			check inv end
			Result := count = 0
		ensure then
			definition: Result = sequence.is_empty
		end

feature -- Measurement

	count: INTEGER
			-- Number of elements.

feature -- Iteration

	at (i: INTEGER): V_LINKED_LIST_ITERATOR [G]
			-- New iterator pointing at position `i'.
		note
			status: impure
			explicit: contracts, wrapping
		do
			create Result.make (Current)
			check Result.inv end
			check inv_only ("lower_definition", "upper_definition", "count_definition") end
			if i < 1 then
				Result.go_before
			elseif i > count then
				Result.go_after
			else
				Result.go_to (i)
			end
		end

feature -- Replacement

	put (v: G; i: INTEGER)
			-- Associate `v' with index `i'.
		note
			explicit: contracts, wrapping
		do
			check inv end
			put_cell (v, cell_at (i), i)
			check inv end
		end

	reverse
			-- Reverse the order of elements.
		note
			skip: true
		local
			rest, next: V_LINKABLE [G]
		do
			from
				last_cell := first_cell
				rest := first_cell
				first_cell := Void
			until
				rest = Void
			loop
				next := rest.right
				rest.put_right (first_cell)
				first_cell := rest
				rest := next
			end
		end

feature -- Extension

	extend_front (v: G)
			-- Insert `v' at the front.
		note
			explicit: contracts
		local
			cell: V_LINKABLE [G]
		do
			check across 1 |..| (count - 1) as i all cell_sequence [i.item].right = cell_sequence [i.item + 1] end end

			create cell.put (v)
			if first_cell = Void then
				last_cell := cell
			else
				cell.put_right (first_cell)
			end
			first_cell := cell
			count := count + 1

			cell_sequence := cell_sequence.prepended (cell)
			check cell_sequence.old_ = cell_sequence.but_first end
			sequence := sequence.prepended (v)
			lemma_extended (sequence.old_, sequence, cell_sequence.old_, cell_sequence, 1, cell)
			upper_ := upper_ + 1
		ensure then
			cell_sequence_preserved: old cell_sequence ~ cell_sequence.but_first
		end

	extend_back (v: G)
			-- Insert `v' at the back.
		note
			explicit: contracts
		local
			cell: V_LINKABLE [G]
		do
			create cell.put (v)
			if first_cell = Void then
				first_cell := cell
			else
				last_cell.put_right (cell)
			end
			last_cell := cell
			count := count + 1

			check across cell_sequence.domain as i all sequence [i.item] = cell_sequence [i.item].item end end
			cell_sequence := cell_sequence & cell
			check cell_sequence.old_ = cell_sequence.but_last end
			sequence := sequence & v
			upper_ := upper_ + 1
		ensure then
			cell_sequence_preserved: old cell_sequence ~ cell_sequence.but_last
		end

	extend_at (v: G; i: INTEGER)
			-- Insert `v' at position `i'.
		note
			explicit: contracts, wrapping
		do
			check inv end
			if i = 1 then
				extend_front (v)
			elseif i = count + 1 then
				extend_back (v)
			else
				extend_after (create {V_LINKABLE [G]}.put (v), cell_at (i - 1), i - 1)
			end
		end

	prepend (input: V_ITERATOR [G])
			-- Prepend sequence of values, over which `input' iterates.
		note
			explicit: contracts, wrapping
		local
			it: V_LINKED_LIST_ITERATOR [G]
		do
			if not input.after then
				check input.inv end
				check inv_only ("count_definition") end
				extend_front (input.item)
				check inv_only ("count_definition") end
				input.forth

				from
					it := new_cursor
				invariant
					1 <= input.index_ and input.index_ <= input.sequence.count + 1
					1 <= it.index_ and it.index_ <= it.sequence.count
					it.index_ = input.index_ - input.index_.old_
					sequence ~ input.sequence.interval (input.index_.old_, input.index_ - 1) + sequence.old_
					is_wrapped
					input.is_wrapped
					it.is_wrapped
					it.target = Current
					observers = observers.old_ & it
					across observers.old_ as o all o.item.is_open end
					cell_sequence.old_ ~ cell_sequence.tail (it.index_ + 1)
				until
					input.after
				loop
					check it.inv_only ("no_observers", "subjects_definition", "sequence_definition") end
					lemma_concat_interval ({MML_SEQUENCE [G]}.empty_sequence, input.sequence, sequence.old_, sequence, input.index_.old_, input.index_ - 1)
					check sequence.extended_at (it.index + 1, input.item) = input.sequence.interval (input.index_.old_, input.index_) + sequence.old_ end
					it.extend_right (input.item)
					check it.inv_only ("after_definition", "sequence_definition") end
					it.forth
					input.forth
				variant
					input.sequence.count - input.index_
				end
				forget_iterator (it)
			end
		ensure then
			cell_sequence_preserved: old cell_sequence ~ cell_sequence.tail (input.sequence.count - old input.index_ + 2)
		end

	insert_at (input: V_ITERATOR [G]; i: INTEGER)
			-- Insert sequence of values, over which `input' iterates, starting at position `i'.
		note
			explicit: contracts, wrapping
		local
			it: V_LINKED_LIST_ITERATOR [G]
		do
			if i = 1 then
				prepend (input)
			else
				from
					it := at (i - 1)
					check input.inv end
					check inv_only ("lower_definition", "upper_definition", "count_definition") end
					check it.inv_only ("sequence_definition") end
				invariant
					1 <= input.index_ and input.index_ <= input.sequence.count + 1
					i - 1 <= it.index_ and it.index_ <= it.sequence.count
					it.index_ - i + 1 = input.index_ - input.index_.old_
					sequence ~ sequence.old_.front (i - 1) + input.sequence.interval (input.index_.old_, input.index_ - 1) + sequence.old_.tail (i)
					is_wrapped
					input.is_wrapped
					it.is_wrapped
					it.target = Current
					observers = observers.old_ & it
					across observers.old_ as o all o.item.is_open end
				until
					input.after
				loop
					check it.inv_only ("no_observers", "subjects_definition", "sequence_definition") end
					lemma_concat_interval (sequence.old_.front (i - 1), input.sequence, sequence.old_.tail (i), sequence, input.index_.old_, input.index_ - 1)
					check sequence.extended_at (it.index + 1, input.item) =
						sequence.old_.front (i - 1) + input.sequence.interval (input.index_.old_, input.index_) + sequence.old_.tail (i) end
					it.extend_right (input.item)
					check it.inv_only ("after_definition", "sequence_definition") end
					it.forth
					input.forth
				variant
					input.sequence.count - input.index_
				end
				forget_iterator (it)
			end
		end

feature -- Removal

	remove_front
			-- Remove first element.
		note
			explicit: contracts
		do
			check across 1 |..| (count - 1) as i all cell_sequence [i.item].right = cell_sequence [i.item + 1] end end
			if count = 1 then
				last_cell := Void
			end
			first_cell := first_cell.right
			count := count - 1

			check across cell_sequence.domain as i all sequence [i.item] = cell_sequence [i.item].item end end
			cell_sequence := cell_sequence.but_first
			sequence := sequence.but_first
			upper_ := upper_ - 1
		ensure then
			cell_sequence_preserved: cell_sequence ~ old cell_sequence.but_first
		end

	remove_back
			-- Remove last element.
		note
			explicit: contracts, wrapping
		do
			check inv end
			if count = 1 then
				wipe_out
				check inv_only ("cell_sequence_domain", "count_definition") end
			else
				remove_after (cell_at (count - 1), count - 1)
			end
		ensure then
			cell_sequence_preserved: cell_sequence ~ old cell_sequence.but_last
		end

	remove_at  (i: INTEGER)
			-- Remove element at position `i'.
		note
			explicit: contracts, wrapping
		do
			check inv end
			if i = 1 then
				remove_front
			else
				remove_after (cell_at (i - 1), i - 1)
			end
		ensure then
			cell_sequence_preserved: cell_sequence ~ old cell_sequence.removed_at (i)
		end

	wipe_out
			-- Remove all elements.
		note
			explicit: contracts
		do
			first_cell := Void
			last_cell := Void
			count := 0
			create cell_sequence
			create sequence
			upper_ := 0
		ensure then
			old_cells_wrapped: across owns.old_ as c all c.item.is_wrapped end
			cell_sequence_last: old count > 0 implies (old last_cell).right = Void
			cell_sequence_later: is_linked (old cell_sequence)
		end

feature {V_CONTAINER, V_ITERATOR} -- Implementation

	first_cell: V_LINKABLE [G]
			-- First cell of the list.

	last_cell: V_LINKABLE [G]
			-- Last cell of the list.

	cell_at (i: INTEGER): V_LINKABLE [G]
			-- Cell at position `i'.
		require
			valid_position: 1 <= i and i <= count
			inv_only ("cell_sequence_domain", "cells_exist", "cell_sequence_first", "cell_sequence_later")
			reads (Current, cell_sequence.range)
		local
			j: INTEGER
		do
			from
				j := 1
				Result := first_cell
			invariant
				1 <= j and j <= i
				Result = cell_sequence [j]
			until
				j = i
			loop
				Result := Result.right
				check across cell_sequence.domain as k all attached cell_sequence [k.item] end end
				check across 1 |..| (count - 1) as k all cell_sequence [k.item].right = cell_sequence [k.item + 1] end end
				j := j + 1
			end
		ensure
			definition: Result = cell_sequence [i]
		end

	put_cell (v: G; c: V_LINKABLE [G]; index_: INTEGER)
			-- Put `v' into `c' located at `index_'.
		require
			index_in_domain: cell_sequence.domain [index_]
			c_in_list: cell_sequence [index_] = c
			wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence"], Current)
		do
			unwrap
			c.put (v)
			lemma_cells_distinct
			sequence := sequence.replaced_at (index_, v)
			wrap
		ensure
			sequence ~ old sequence.replaced_at (index_, v)
			cell_sequence ~ old cell_sequence
			wrapped: is_wrapped
		end


	extend_after (new, c: V_LINKABLE [G]; index_: INTEGER)
			-- Add a new cell with value `v' after `c'.
		require
			index_in_domain: cell_sequence.domain [index_]
			c_in_list: cell_sequence [index_] = c
			new_rigth_void: new.right = Void
			new_is_wrapped: new.is_wrapped
			wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
			modify_model (["right", "owner"], new)
		do
			unwrap
			lemma_cells_distinct

			check across 1 |..| (count - 1) as i all cell_sequence [i.item].right = cell_sequence [i.item + 1] end end
			if c.right = Void then
				last_cell := new
			else
				new.put_right (c.right)
			end
			c.put_right (new)
			count := count + 1

			cell_sequence := cell_sequence.extended_at (index_ + 1, new)
			sequence := sequence.extended_at (index_ + 1, new.item)
			lemma_extended (sequence.old_, sequence, cell_sequence.old_, cell_sequence, index_ + 1, new)
			upper_ := upper_ + 1
			wrap
		ensure
			sequence ~ old sequence.extended_at (index_ + 1, new.item)
			cell_sequence ~ old cell_sequence.extended_at (index_ + 1, new)
			wrapped: is_wrapped
		end

	remove_after (c: V_LINKABLE [G]; index_: INTEGER)
			-- Remove the cell to the right of `c'.
		require
			valid_index: 1 <= index_ and index_ <= cell_sequence.count - 1
			c_in_list: cell_sequence [index_] = c
			wrapped: is_wrapped
			observers_open: across observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], Current)
		do
			unwrap
			lemma_cells_distinct
			check across 1 |..| (count - 1) as i all cell_sequence [i.item].right = cell_sequence [i.item + 1] end end

			c.put_right (c.right.right)
			if c.right = Void then
				last_cell := c
			end
			count := count - 1

			cell_sequence := cell_sequence.removed_at (index_ + 1)
			sequence := sequence.removed_at (index_ + 1)
			lemma_removed (sequence.old_, sequence, cell_sequence.old_, cell_sequence, index_ + 1)
			upper_ := upper_ - 1
			wrap
		ensure
			sequence ~ old sequence.removed_at (index_ + 1)
			cell_sequence ~ old cell_sequence.removed_at (index_ + 1)
			wrapped: is_wrapped
		end

	merge_after (other: V_LINKED_LIST [G]; c: V_LINKABLE [G]; index_: INTEGER)
			-- Merge `other' into `Current' after cell `c'. If `c' is `Void', merge to the front.
		note
			skip: true
		require
			valid_index: 0 <= index_ and index_ <= cell_sequence.count
			c_void_if_before: index_ = 0 implies c = Void
			c_in_list_if_in_domain: cell_sequence.domain [index_] implies cell_sequence [index_] = c
			other_not_current: other /= Current
			wrapped: is_wrapped
			other_wrapped: other.is_wrapped
			observers_open: across observers as o all o.item.is_open end
			other_observers_open: across other.observers as o all o.item.is_open end
			modify_model (["sequence", "owns"], [Current, other])
		local
			other_first, other_last: V_LINKABLE [G]
			other_count: INTEGER
		do
			if not other.is_empty then
				check other.inv_only ("count_definition", "cell_sequence_domain", "cell_sequence_first", "cell_sequence_last", "cells_exist", "owns_definition") end
				other_first := other.first_cell
				other_last := other.last_cell
				other_count := other.count
				other.wipe_out

				unwrap
				check across 1 |..| (count - 1) as i all cell_sequence [i.item].right = cell_sequence [i.item + 1] end end
				count := count + other_count
				if c = Void then
					if first_cell = Void then
						last_cell := other_last
					else
						other_last.put_right (first_cell)
					end
					first_cell := other_first
					check last_cell.right = Void end
				else
					if c.right = Void then
						last_cell := other_last
					else
						other_last.put_right (c.right)
					end
					c.put_right (other_first)
				end

				cell_sequence := cell_sequence.front (index_) + other.cell_sequence.old_ + cell_sequence.tail (index_ + 1)
				sequence := sequence.front (index_) + other.sequence.old_ + sequence.tail (index_ + 1)
				upper_ := upper_ + other.count.old_
				map := sequence.to_map
				bag := map.to_bag
				set_owns (cell_sequence.range)

--				check count_definition: count = sequence.count end
----				check owns_definition: owns = cell_sequence.range end
--				check cell_sequence_domain: cell_sequence.count = count end
--				check first_cell_empty: count = 0 implies first_cell = Void end
--				check last_cell_empty: count = 0 implies last_cell = Void end
--				check cell_sequence_first: count > 0 implies cell_sequence.first = first_cell end
--				check cell_sequence_last: count > 0 implies cell_sequence.last = last_cell and last_cell.right = Void end
--				check cells_exist: across cell_sequence.domain as i all attached cell_sequence [i.item] end end
----				check assume: across 1 |..| (count - 1) as i all cell_sequence [i.item].right = cell_sequence [i.item + 1] end end
----				check assume: across cell_sequence.domain as i all sequence [i.item] = cell_sequence [i.item].item end end
				check assume: inv end

--				check assume: false end
				wrap
			end
		ensure
			wrapped: is_wrapped
			other_wrapped: other.is_wrapped
			sequence_effect: sequence = old (sequence.front (index_) + other.sequence + sequence.tail (index_ + 1))
			other_sequence_effect: other.sequence.is_empty
			cell_sequence_effect: cell_sequence = old (cell_sequence.front (index_) + other.cell_sequence + cell_sequence.tail (index_ + 1))
		end

feature -- Specificaton

	cell_sequence: MML_SEQUENCE [V_LINKABLE [G]]
			-- Sequence of linakble cells.
		note
			status: ghost
		attribute
		end

feature {V_LINKED_LIST, V_LINKED_LIST_ITERATOR} -- Specificaton	

	lemma_cells_distinct
			-- All cells in `cell_sequence' are distinct.
		note
			status: lemma
		require
			inv_only ("cell_sequence_domain", "cell_sequence_last", "cells_exist", "cell_sequence_later")
		do
			if count > 0 then
				lemma_cells_distinct_from (1)
			end
		ensure
			cells_distinct: across cell_sequence.domain as j all
				across cell_sequence.domain as k all
					j.item < k.item implies cell_sequence [j.item] /= cell_sequence [k.item]
				end
			end
		end

	lemma_cells_distinct_from (i: INTEGER)
			-- All cells in `cell_sequence' starting from `i' are distinct.
		note
			status: lemma
		require
			in_bounds: 1 <= i and i <= count
			inv_only ("cell_sequence_domain", "cell_sequence_last", "cells_exist", "cell_sequence_later")
			decreases (count - i)
		do
			check across cell_sequence.domain as j all attached cell_sequence [j.item] end end
			check across 1 |..| (count - 1) as j all cell_sequence [j.item].right = cell_sequence [j.item + 1] end end
			if i /= count then
				lemma_cells_distinct_from (i + 1)
				check across cell_sequence.domain as j all j.item <= i - 1 implies cell_sequence [j.item].right /= cell_sequence [i + 1] end end
			end
		ensure
			cells_distinct: across cell_sequence.domain as j all
				across cell_sequence.domain as k all
					i <= k.item and j.item < k.item implies cell_sequence [j.item] /= cell_sequence [k.item]
				end
			end
		end

	lemma_next (i1, i2: INTEGER)
			-- Given two indexes `i1' < `i2' into the list,
			-- the cell at `i1' has the cell at `i2' as its `right' iff `i2' = `i1' + 1.
		note
			status: lemma
		require
			indexes_in_bounds: 1 <= i1 and i1 < i2 and i2 <= count
			almost_holds: inv_only ("count_definition", "cell_sequence_domain", "cells_exist", "cell_sequence_later", "cell_sequence_last")
		do
			check across cell_sequence.domain as i all attached cell_sequence [i.item] end end
			check across 1 |..| (count - 1) as i all attached cell_sequence [i.item] and then cell_sequence [i.item].right = cell_sequence [i.item + 1] end end
			lemma_cells_distinct
		ensure
			(i1 + 1 = i2) = (cell_sequence [i1].right = cell_sequence [i2])
		end

	lemma_extended (s, s1: MML_SEQUENCE [G]; cs, cs1: MML_SEQUENCE [V_LINKABLE [G]]; index: INTEGER; cell: V_LINKABLE [G])
		note
			status: lemma
		require
			s.count = cs.count
			across cs.domain as i all attached cs [i.item] and then cs [i.item].item = s [i.item] end
			1 <= index and index <= cs.count + 1
			cell /= Void
			cs1 = cs.extended_at (index, cell)
			s1 = s.extended_at (index, cell.item)
		do
			check across cs.domain as i all attached cs [i.item] and then cs [i.item].item = s [i.item] end end
		ensure
			across cs1.domain as i all attached cs1 [i.item] and then cs1 [i.item].item = s1 [i.item] end
		end

	lemma_removed (s, s1: MML_SEQUENCE [G]; cs, cs1: MML_SEQUENCE [V_LINKABLE [G]]; index: INTEGER)
		note
			status: lemma
		require
			s.count = cs.count
			across cs.domain as i all attached cs [i.item] and then cs [i.item].item = s [i.item] end
			cs.domain [index]
			cs1 = cs.removed_at (index)
			s1 = s.removed_at (index)
		do
			check across cs.domain as i all attached cs [i.item] and then cs [i.item].item = s [i.item] end end
		ensure
			across cs1.domain as i all attached cs1 [i.item] and then cs1 [i.item].item = s1 [i.item] end
		end

	is_linked (cs: like cell_sequence): BOOLEAN
			-- Are adjacent cells of `cs' liked to each other?
		note
			status: ghost, functional
		require
			reads (cs.but_last.range)
		do
			Result := across 1 |..| (cs.count - 1) as i all attached cs [i.item] and then cs [i.item].right = cs [i.item + 1] end
		end

invariant
	count_definition: count = sequence.count
	owns_definition: owns = cell_sequence.range
	cell_sequence_domain: cell_sequence.count = count
	first_cell_empty: count = 0 implies first_cell = Void
	last_cell_empty: count = 0 implies last_cell = Void
	cells_exist: across cell_sequence.domain as i all attached cell_sequence [i.item] end
	cell_sequence_first: count > 0 implies cell_sequence.first = first_cell
	cell_sequence_last: count > 0 implies (cell_sequence.last = last_cell and attached last_cell) and then last_cell.right = Void
	cell_sequence_later: is_linked (cell_sequence)
	sequence_definition: across cell_sequence.domain as i all sequence [i.item] = cell_sequence [i.item].item end

note
	explicit: observers
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
