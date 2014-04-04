note
	description: "Iterators over linked lists."
	author: "Nadia Polikarpova"
	model: target, index_

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
			modify_model ("observers", list)
		do
			target := list
			list.add_iterator (Current)
			active := Void
			after := False
			set_target_index_sequence
			check list.inv end
		ensure
			target_effect: target = list
			index_effect: index_ = 0
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
				check other.inv end
				check inv_only ("no_observers") end
				target.forget_iterator (Current)
				target := other.target
				target.add_iterator (Current)
				active := other.active
				index_ := other.index_
				after := other.after
				set_target_index_sequence
				set_owns (other.owns)
				check target.inv end
				wrap
			end
		ensure then
			target_effect: target = other.target
			index_effect: index_ = other.index_
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
			check target.inv end
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
			check target.inv end
			Result := active = Void
		end

	is_first: BOOLEAN
			-- Is cursor at the first position?
		do
			check inv end
			check target.inv end
			Result := not (active = Void) and active = target.first_cell
			check Result implies target.cell_sequence [1] = active end
			target.lemma_cells_distinct
		end

	is_last: BOOLEAN
			-- Is cursor at the last position?
		do
			check inv end
			check target.inv end
			Result := not (active = Void) and then active = target.last_cell
			check Result implies target.cell_sequence [target.sequence.count] = active end
			target.lemma_cells_distinct
		end

	after: BOOLEAN
			-- Is current position after the last container position?

	before: BOOLEAN
			-- Is current position before the first container position?
		do
			check inv end
			Result := off and not after
		end

feature -- Cursor movement

	start
			-- Go to the first position.
		do
			check target.inv end
			active := target.first_cell
			after := active = Void
			index_ := 1
		end

	finish
			-- Go to the last position.
		do
			check target.inv end
			active := target.last_cell
			after := False
			index_ := target.sequence.count
		end

	forth
			-- Move one position forward.		
		do
			check target.inv end
			check across 1 |..| (target.count - 1) as i all attached target.cell_sequence [i.item] and then target.cell_sequence [i.item].right = target.cell_sequence [i.item + 1] end end
			active := active.right
			index_ := index_ + 1
			after := active = Void
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
					check target.cell_sequence [1] /= old_active end
				invariant
					1 <= index_ and index < index.old_
					inv_only ("cell_not_off", "after_definition")
					attached active
					across 1 |..| index_ as i all target.cell_sequence [i.item] /= old_active end
					is_wrapped
				until
					active.right = old_active
				loop
					target.lemma_next (index_, index_ + 1)
					forth
				variant
					index_.old_ - index_
				end
				target.lemma_next (index_, index_.old_)
			end
		end

	go_before
			-- Go before any position of `target'.
		do
			active := Void
			after := False
			index_ := 0
		end

	go_after
			-- Go after any position of `target'.
		do
			check inv end
			check target.inv end
			active := Void
			after := True
			index_ := target.count + 1
		end

feature -- Replacement

	put (v: G)
			-- Replace item at current position with `v'.
		do
			check target.inv end
			target.put_cell (v, active, index_)
			check target.inv end
			check target.map ~ target.map.old_.updated (index_, v) end
		end

feature -- Extension

	extend_left (v: G)
			-- Insert `v' to the left of current position. Do not move cursor.
		note
			explicit: wrapping
		do
			check inv end
			if is_first then
				unwrap
				target.extend_front (v)
				check target.inv end
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
			check target.inv end
			target.extend_after (create {V_LINKABLE [G]}.put (v), active, index_)
			check target.inv end
			set_target_index_sequence
		end

	insert_left (other: V_ITERATOR [G])
			-- Append sequence of values, over which `input' iterates to the left of current position. Do not move cursor.
		note
			explicit: wrapping
		do
			check inv_only ("subjects_definition", "sequence_definition", "no_observers", "A2") end
			check target.inv_only ("count_definition") end
			check other.inv_only ("subjects_definition", "index_constraint", "no_observers", "A2") end
			if is_first then
				unwrap
				check other.inv_only ("A2") end
				target.prepend (other)
				check target.inv_only ("bag_definition", "map_definition", "count_definition", "cell_sequence_domain", "lower_definition") end
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
		do
			from
				check inv_only ("subjects_definition", "no_observers", "A2") end
				check target.inv_only ("count_definition") end
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
				target.sequence ~ (target.sequence.front (index_.old_).old_ +
					other.sequence.old_.interval (other.index_.old_, other.index_ - 1) +
					target.sequence.tail (index_.old_ + 1).old_)
			until
				other.after
			loop
				check inv_only ("subjects_definition", "sequence_definition") end
				check other.inv_only ("no_observers") end
				lemma_concat_interval (target.sequence.front (index_.old_).old_, other.sequence.old_, target.sequence.tail (index_.old_ + 1).old_, target.sequence, other.index_.old_, other.index_ - 1)
				extend_right (other.item)
				check target.inv_only ("count_definition") end
				check inv_only ("after_definition", "sequence_definition") end
				forth
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
			not_after: not after
			observers_open: across target.observers as o all o.item /= Current implies o.item.is_open end
			other_observers_open: across other.observers as o all o.item.is_open end
			modify_model (["sequence", "target_index_sequence"], Current)
			modify_model (["sequence", "owns"], [target, other])
		do
			check target.inv_only ("cell_sequence_domain", "count_definition") end
			target.merge_after (other, active, index_)
			check target.inv end
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
				check target.inv end
				active := target.first_cell
				after := active = Void
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
			check target.inv end
			target.remove_after (active, index_)
			check target.inv end
			set_target_index_sequence
		end

feature {V_LINKED_LIST_ITERATOR} -- Implementation

	active: V_LINKABLE [G]
			-- Cell at current position.
			-- If unreachable from `target.first_cell' iterator is considered `before'.

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
				c = target.cell_sequence [Result]
			until
				c = active
			loop
				target.lemma_next (Result, Result + 1)
				Result := Result + 1
				c := c.right
			variant
				target.count - Result
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
				1 <= j and j <= target.count + 1
				target_index_sequence.count = j - 1
				across target_index_sequence.domain as i all target_index_sequence [i.item] = i.item end
				target_index_sequence.range = create {MML_INTERVAL}.from_range (1, j - 1)
			until
				j > target.count
			loop
				check across target_index_sequence.domain as i all target_index_sequence [i.item] = i.item end end
				target_index_sequence := target_index_sequence & j
				j := j + 1
			end
		ensure
			domain_set: target_index_sequence.count = target.count
			values_set: across target_index_sequence.domain as i all target_index_sequence [i.item] = i.item end
			range_set: target_index_sequence.range = create {MML_INTERVAL}.from_range (1, target.count)
		end

	lemma_concat_interval (s1, s2, s3, s: MML_SEQUENCE [G]; i, j: INTEGER)
		note
			status: lemma
		require
			i_j_in_bounds: 1 <= i
			p2: i <= j + 1
			p3: j < s2.count
			s_concat: s = s1 + s2.interval (i, j) + s3
		do
		ensure
			s.extended_at (s1.count + j - i + 2, s2 [j + 1]) = s1 + s2.interval (i, j + 1) + s3
		end


invariant
	after_definition: after = (index_ = sequence.count + 1)
	cell_off: not target.cell_sequence.domain [index_] implies active = Void
	cell_not_off: target.cell_sequence.domain [index_] implies active = target.cell_sequence [index_]

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
