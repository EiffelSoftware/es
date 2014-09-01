note
	description: "Iterators over linked lists."
	author: "Nadia Polikarpova"
	model: target, index_
	manual_inv: true
	false_guards: true

class
	V_LINKED_LIST_ITERATOR [G]

inherit
	V_LIST_ITERATOR [G]
		undefine
			off
		redefine
			target
		end

create {V_CONTAINER, V_ITERATOR}
	make

feature {V_CONTAINER, V_ITERATOR} -- Initialization

	make (list: V_LINKED_LIST [G])
			-- Create iterator over `list'.
		note
			status: creator
		require
			list_wrapped: list.is_wrapped
			modify (Current)
			modify_field (["observers", "closed"], list)
		do
			target := list
			target.unwrap
			target.set_observers (target.observers & Current)
			target.wrap
			active := Void
			after_ := False
			set_target_index_sequence
		ensure
			target_effect: target = list
			index_effect: index_ = 0
			list_observers_effect: list.observers = old list.observers & Current
		end

feature -- Initialization

	copy_ (other: like Current)
			-- Initialize with the same `target' and position as in `other'.
		note
			explicit: wrapping
		require
			target_wrapped: target.is_wrapped
			other_target_wrapped: other.target.is_wrapped
			modify (Current)
			modify_model ("observers", [target, other.target])
		do
			if Current /= other then
				check other.inv_only ("index_constraint", "after_definition", "sequence_definition", "cell_off", "cell_not_off", "default_owns") end
				check inv_only ("no_observers", "subjects_definition", "A2") end
				target.forget_iterator (Current)
				target := other.target
				target.unwrap
				target.set_observers (target.observers & Current)
				target.wrap
				active := other.active
				index_ := other.index_
				after_ := other.after_
				set_target_index_sequence
				set_owns (other.owns)
				check target.inv_only ("cells_domain") end
				wrap
			end
		ensure
			target_effect: target = other.target
			index_effect: index_ = other.index_
			old_target_wrapped: (old target).is_wrapped
			other_target_wrapped: other.target.is_wrapped
			old_target_observers_effect: other.target /= old target implies (old target).observers = old target.observers / Current
			other_target_observers_effect: other.target /= old target implies other.target.observers = old other.target.observers & Current
			target_observers_preserved: other.target = old target implies other.target.observers = old other.target.observers
		end

feature -- Access

	target: V_LINKED_LIST [G]
			-- Container to iterate over.

feature -- Measurement

	item: G
			-- Item at current position.
		do
			check inv end
			check target.inv end
			Result := active.item
		end

	index: INTEGER
			-- Current position.
		do
			check inv end
			if after then
				Result := target.count + 1
			elseif is_last then
				Result := target.count
			elseif active /= Void then
				Result := active_index
			end
		end

feature -- Status report

	off: BOOLEAN
			-- Is current position off scope?
		do
			check inv end
			Result := active = Void
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			check inv end
			check target.inv end
			Result := active /= Void and active = target.first_cell
			target.lemma_cells_distinct
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			check inv end
			check target.inv end
			Result := active /= Void and then active = target.last_cell
			target.lemma_cells_distinct
		end

	after: BOOLEAN
			-- Is current position after the last container position?
		require else
			reads (Current)
		do
			check inv end
			Result := after_
		end

	before: BOOLEAN
			-- Is current position before the first container position?
		do
			check inv end
			Result := off and not after_
		end

feature -- Cursor movement

	start
			-- Go to the first position.
		do
			check target.inv end
			active := target.first_cell
			after_ := active = Void
			index_ := 1
		end

	finish
			-- Go to the last position.
		do
			check target.inv end
			active := target.last_cell
			after_ := False
			index_ := target.sequence.count
		end

	forth
			-- Move one position forward.		
		do
			check target.inv end
			active := active.right
			index_ := index_ + 1
			after_ := active = Void
		end

	back
			-- Go one position backwards.
		note
			explicit: wrapping
		local
			old_active: V_LINKABLE [G]
		do
			check inv end
			check target.inv end
			if is_first then
				go_before
			else
				old_active := active
				from
					start
					target.lemma_cells_distinct
				invariant
					1 <= index_ and index_ < index_.old_
					inv_only ("cell_not_off", "after_definition")
					attached active
					across 1 |..| index_ as i all target.cells [i.item] /= old_active end
					is_wrapped
				until
					active.right = old_active
				loop
					forth
				variant
					index_.old_ - index_
				end
				check target.cells [index_].right = target.cells [index_ + 1] end
			end
		end

	go_before
			-- Go before any position of `target'.
		do
			active := Void
			after_ := False
			index_ := 0
		end

	go_after
			-- Go after any position of `target'.
		do
			check inv end
			check target.inv end
			active := Void
			after_ := True
			index_ := target.count + 1
		end

feature -- Replacement

	put (v: G)
			-- Replace item at current position with `v'.
		do
			check target.inv_only ("cells_domain", "map_definition_list", "bag_definition") end
			target.put_cell (v, active, index_)
			check target.inv_only ("bag_definition", "map_definition_list", "lower_definition") end
		end

feature -- Extension

	extend_left (v: G)
			-- Insert `v' to the left of current position. Do not move cursor.
		note
			explicit: wrapping
		do
			check inv_only ("subjects_definition") end
			if is_first then
				unwrap
				target.extend_front (v)
				check target.inv_only ("bag_definition", "map_definition_list", "cells_domain", "count_definition", "lower_definition") end
				index_ := index_ + 1
				set_target_index_sequence
				wrap
			else
				back
				extend_right (v)
				check inv end
				forth
				check inv end
				forth
			end
		end

	extend_right (v: G)
			-- Insert `v' to the right of current position. Do not move cursor.
		do
			check target.inv_only ("cells_domain") end
			target.extend_after (create {V_LINKABLE [G]}.put (v), active, index_)
			check target.inv_only ("bag_definition", "map_definition_list", "cells_domain",  "count_definition", "lower_definition") end
			set_target_index_sequence
		ensure then
			cell_sequence_front_preserved: target.cells.old_.front (index_) ~ target.cells.front (index_)
			cell_sequence_tail_preserved: target.cells.old_.tail (index_ + 1) ~ target.cells.tail (index_ + 2)
		end

	insert_left (other: V_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates to the left of current position. Do not move cursor.
		note
			explicit: wrapping
		do
			check inv_only ("subjects_definition", "sequence_definition", "no_observers", "A2") end
			check other.inv_only ("subjects_definition", "index_constraint", "no_observers", "A2") end
			if is_first then
				unwrap
				target.prepend (other)
				check target.inv_only ("bag_definition", "map_definition_list", "cells_domain",  "count_definition", "lower_definition") end
				index_ := index_ + other.sequence.tail (other.index_.old_).count
				set_target_index_sequence
				wrap
			else
				back
				insert_right (other)
				check inv_only ("sequence_definition", "after_definition") end
				forth
			end
		end

	insert_right (other: V_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates to the right of current position. Move cursor to the last element of inserted sequence.
		note
			explicit: wrapping
		local
			s: like sequence
		do
			from
				check inv_only ("subjects_definition", "no_observers", "A2") end
				check other.inv_only ("target_exists", "subjects_definition", "index_constraint") end
			invariant
				1 <= index_.old_ and index_.old_ <= index_ and index_ <= sequence.count
				1 <= other.index_.old_ and other.index_.old_ <= other.index_ and other.index_ <= other.sequence.count + 1
				index_ - index_.old_ = other.index_ - other.index_.old_
				is_wrapped
				other.is_wrapped
				target.is_wrapped
				target /= Current
				across target.observers as o all o.item /= Current implies o.item.is_open end
				s = other.sequence.old_.interval (other.index_.old_, other.index_ - 1)
				target.sequence ~ (target.sequence.front (index_.old_).old_ +
					s + target.sequence.tail (index_.old_ + 1).old_)
			until
				other.after
			loop
				check inv_only ("after_definition", "sequence_definition") end
				extend_right (other.item)
				s := s & other.item
				check inv_only ("after_definition", "sequence_definition") end
				forth
				check other.inv_only ("no_observers") end
				other.forth
			variant
				other.sequence.count - other.index_
			end
		end

	merge (other: V_LINKED_LIST [G])
			-- Merge `other' into `target' after current position. Do not copy elements. Empty `other'.
		require
			target_wrapped: target.is_wrapped
			other_wrapped: other.is_wrapped
			other_not_target: other /= target
			not_after: index_ <= sequence.count
			observers_open: across target.observers as o all o.item /= Current implies o.item.is_open end
			other_observers_open: across other.observers as o all o.item.is_open end
			modify_model (["sequence", "target_index_sequence"], Current)
			modify_model (["sequence", "owns"], [target, other])
		do
			check target.inv_only ("cells_domain") end
			target.merge_after (other, active, index_)
			check target.inv_only ("bag_definition", "map_definition_list", "count_definition", "lower_definition") end
			set_target_index_sequence
		ensure
			sequence_effect: sequence ~ old (sequence.front (index_) + other.sequence + sequence.tail (index_ + 1))
			other_sequence_effect: other.sequence.is_empty
		end

feature -- Removal

	remove
			-- Remove element at current position. Move cursor to the next position.
		note
			explicit: wrapping
		do
			if is_first then
				unwrap
				target.remove_front
				check target.inv_only ("bag_definition", "map_definition_list",  "count_definition", "lower_definition", "cells_domain", "cells_exist", "first_cell_empty", "cells_first") end
				active := target.first_cell
				after_ := active = Void
				set_target_index_sequence
				wrap
			else
				check inv_only ("subjects_definition", "sequence_definition") end
				back
				remove_right
				check inv end
				forth
			end
		end

	remove_left
			-- Remove element to the left of current position. Do not move cursor.
		note
			explicit: wrapping
		do
			back
			check inv end
			remove
		end

	remove_right
			-- Remove element to the right of current position. Do not move cursor.
		do
			check target.inv_only ("cells_domain") end
			target.remove_after (active, index_)
			check target.inv_only ("bag_definition", "map_definition_list", "count_definition", "lower_definition") end
			set_target_index_sequence
		end

feature {V_LINKED_LIST_ITERATOR} -- Implementation

	active: V_LINKABLE [G]
			-- Cell at current position.
			-- If unreachable from `target.first_cell' iterator is considered `before'.

	after_: BOOLEAN
			-- Is current position after the last container position?			

	active_index: INTEGER
			-- Distance from `target.first_cell' to `active'.
			-- 0 if `active' is not reachable from `target.first_cell'.
		require
			active_exists: active /= Void
			closed: closed
			target_closed: target.closed
			reads (Current, target.ownership_domain)
		local
			c: V_LINKABLE [G]
		do
			check inv end
			check target.inv end
			from
				c := target.first_cell
				Result := 1
			invariant
				1 <= Result and Result <= index_
				c = target.cells [Result]
			until
				c = active
			loop
				Result := Result + 1
				c := c.right
			variant
				target.count_ - Result
			end
			target.lemma_cells_distinct
		ensure
			definition: Result = index_
		end

feature {NONE} -- Specification

	set_target_index_sequence
			-- Set `target_index_sequence' to [1..target.count]
		note
			status: ghost
		require
			target_wrapped: target.is_wrapped
			no_observers: observers = []
			modify_field ("target_index_sequence", Current)
		local
			j: INTEGER
		do
			check target.inv end
			from
				create target_index_sequence
				j := 1
			invariant
				1 <= j and j <= target.sequence.count + 1
				target_index_sequence.count = j - 1
				across 1 |..| (j - 1) as i all target_index_sequence [i.item] = i.item end
				target_index_sequence.range = create {MML_INTERVAL}.from_range (1, j - 1)
			until
				j > target.count
			loop
				check (target_index_sequence & j).range = target_index_sequence.range & j end
				target_index_sequence := target_index_sequence & j
				j := j + 1
			end
		ensure
			domain_set: target_index_sequence.count = target.count_
			values_set: across 1 |..| target.count_ as i all target_index_sequence [i.item] = i.item end
			range_set: target_index_sequence.range = create {MML_INTERVAL}.from_range (1, target.sequence.count)
		end

invariant
	after_definition: after_ = (index_ = sequence.count + 1)
	cell_off: (index_ < 1 or sequence.count < index_) = (active = Void)
	cell_not_off: 1 <= index_ and index_ <= target.cells.count implies active = target.cells [index_]

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
