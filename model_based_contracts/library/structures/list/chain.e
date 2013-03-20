indexing

	description: "[
		Possibly circular sequences of items,
		without commitment to a particular representation
		]"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: chain, sequence;
	access: index, cursor, membership;
	contents: generic;
	model: sequence, index, extendible, prunable, full, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

deferred class CHAIN [G] inherit

	CURSOR_STRUCTURE [G]
		rename
			cursor_to_item as sequence,
			cursor_position as index
		undefine
			prune_all, bag
		redefine
			fill,
			go_to
		select
			put
		end

	INDEXABLE [G]
		rename
			item as i_th alias "[]",
			put as put_i_th,
			relation as sequence
		undefine
			prune_all
		redefine
			fill,
			sequence
		end

	SEQUENCE [G]
		rename
			put as sequence_put
		export
			{NONE} sequence_put
		undefine
			bag
		redefine
			index_of, has, off, occurrences, fill, append,
			sequence
		select
			index_of, has, occurrences
		end

	SEQUENCE [G]
		rename
			put as sequence_put,
			index_of as sequential_index_of,
			has as sequential_has,
			occurrences as sequential_occurrences
		export
			{NONE}
				sequential_index_of, sequential_has,
				sequence_put
		undefine
			bag
		redefine
			off, fill, append,
			sequence
		end

feature -- Access

	first: like item is
			-- Item at first position
		require
			not_empty: not is_empty
		local
			pos: CURSOR
		do
			pos := cursor
			start
			Result := item
			go_to (pos)
		ensure
		-- ensure: model
			definition: Result = sequence.first
		end

	last: like item is
			-- Item at last position
		require
			not_empty: not is_empty
		local
			pos: CURSOR
		do
			pos := cursor
			finish
			Result := item
			go_to (pos)
		ensure
		-- ensure: model
			definition: Result = sequence.last
		end

	has (v: like item): BOOLEAN is
			-- Does chain include `v'?
			-- (Reference or object equality,
			-- based on `object_comparison'.)

		local
			pos: CURSOR
		do
			pos := cursor
			Result := sequential_has (v)
			go_to (pos)
		end

	index_of (v: like item; i: INTEGER): INTEGER is
			-- Index of `i'-th occurrence of item identical to `v'.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
			-- 0 if none.
		local
			pos: CURSOR
		do
			pos := cursor
			Result := sequential_index_of (v, i)
			go_to (pos)
		end

	i_th alias "[]", infix "@" (i: INTEGER): like item assign put_i_th is
			-- Item at `i'-th position
		local
			pos: CURSOR
		do
			pos := cursor
			go_i_th (i)
			Result := item
			go_to (pos)
		end

feature -- Measurement

	occurrences (v: like item): INTEGER is
			-- Number of times `v' appears.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		local
			pos: CURSOR
		do
			pos := cursor
			Result := sequential_occurrences (v)
			go_to (pos)
		end

	index_set: INTEGER_INTERVAL is
			-- Range of acceptable indexes
		do
			create Result.make (1, count)
		ensure then
			count_definition: Result.count = count
		end

feature -- Cursor movement

	start is
			-- Move cursor to first position.
			-- (No effect if empty)
		do
			if not is_empty then
				go_i_th (1)
			end
		ensure then
			at_first: not is_empty implies isfirst
		end

	finish is
			-- Move cursor to last position.
			-- (No effect if empty)
		do
			if not is_empty then
				go_i_th (count)
			end
		ensure then
			at_last: not is_empty implies islast
		end

	move (i: INTEGER) is
			-- Move cursor `i' positions. The cursor
			-- may end up `off' if the absolute value of `i'
			-- is too big.
		local
			counter, pos, final: INTEGER
		do
			if i > 0 then
				from
				until
					(counter = i) or else off
				loop
					forth
					counter := counter + 1
				end
			elseif i < 0 then
				final := index + i
				if final <= 0 then
					start
					back
				else
					from
						start
						pos := 1
					until
						pos = final
					loop
						forth
						pos := pos + 1
					end
				end
			end
		ensure
			too_far_right: (old index + i > count) implies exhausted
			too_far_left: (old index + i < 1) implies exhausted
			expected_index: (not exhausted) implies (index = old index + i)
		-- ensure: model
			index_effect_too_far_right: (old index + i > sequence.count) implies index = sequence.count + 1
			index_effect_too_far_left: (old index + i < 1) implies index = 0
			index_effect_expected: sequence.is_defined (old index + i) implies (index = old index + i)
		end

	go_i_th (i: INTEGER) is
			-- Move cursor to `i'-th position.
		require
			valid_cursor_index: valid_cursor_index (i)
		do
			move (i - index)
		ensure
			position_expected: index = i
		-- ensure: model
			index_effect: index = i
		end

	go_to (p: CURSOR) is
			-- Move cursor to position `p'.
		deferred
		ensure then
		-- ensure then: model
			index_effect: index = p.position
		end

 feature -- Status report

	valid_index (i: INTEGER): BOOLEAN is
			-- Is `i' within allowable bounds?
		do
			Result := (i >= 1) and (i <= count)
		ensure then
			valid_index_definition: Result = (i >= 1 and i <= count)
		end


	isfirst: BOOLEAN is
			-- Is cursor at first position?
		do
			Result := not is_empty and (index = 1)
		ensure
			valid_position: Result implies not is_empty
		-- ensure: model
			definition: Result = (index = 1)
		end

	islast: BOOLEAN is
			-- Is cursor at last position?
		do
			Result := not is_empty and (index = count)
		ensure
			valid_position: Result implies not is_empty
		-- ensure: model
			definition: Result = (not sequence.is_empty and index = sequence.count)
		end

	off: BOOLEAN is
			-- Is there no current item?
		do
			Result := (index = 0) or (index = count + 1)
		end


	valid_cursor_index (i: INTEGER): BOOLEAN is
			-- Is `i' correctly bounded for cursor movement?
		do
			Result := (i >= 0) and (i <= count + 1)
		ensure
			valid_cursor_index_definition: Result = ((i >= 0) and (i <= count + 1))
		-- ensure: model
			definition: Result = sequence.is_defined (i) or i = 0 or i = sequence.count + 1
		end

feature -- Element change

	put (v: like item) is
			-- Replace current item by `v'.
			-- (Synonym for `replace')
		do
			replace (v)
		ensure then
	 		same_count: count = old count
	 	-- ensure then: model
	 		sequence_effect: sequence |=| old sequence.replaced_at (v, index)
		end

	put_i_th (v: like item; i: INTEGER) is
			-- Put `v' at `i'-th position.
		local
			pos: CURSOR
		do
			pos := cursor
			go_i_th (i)
			replace (v)
			go_to (pos)
		ensure then
	 	-- ensure then: model
	 		sequence_effect: sequence |=| old sequence.replaced_at (v, i) -- Not really needed			
		end

	append (s: SEQUENCE [G]) is
			-- Append a copy of `s'.
		local
			l: like s
			l_cursor: CURSOR
		do
			l := s
			if s = Current then
				l := twin
			end
			from
				l_cursor := cursor
				l.start
			until
				l.exhausted
			loop
				extend (l.item)
				finish
				l.forth
			end
			go_to (l_cursor)
		end

	fill (other: CONTAINER [G]) is
			-- Fill with as many items of `other' as possible.
			-- The representations of `other' and current structure
			-- need not be the same.
		local
			lin_rep: LINEAR [G]
			l_cursor: CURSOR
		do
			lin_rep := other.linear_representation
			from
				l_cursor := cursor
				lin_rep.start
			until
				not extendible or else lin_rep.off
			loop
				extend (lin_rep.item)
				finish
				lin_rep.forth
			end
			go_to (l_cursor)
		end
feature -- Transformation

	swap (i: INTEGER) is
			-- Exchange item at `i'-th position with item
			-- at cursor position.
		require
			not_off: not off
			valid_index: valid_index (i)
		local
			old_item, new_item: like item
			pos: CURSOR
		do
			pos := cursor
			old_item := item
			go_i_th (i)
			new_item := item
			replace (old_item)
			go_to (pos)
			replace (new_item)
		ensure
	 		swapped_to_item: item = old i_th (i)
	 		swapped_from_item: i_th (i) = old item
	 	-- ensure: model
	 		sequence_effect: sequence |=| old (sequence.replaced_at (sequence.item (i), index).replaced_at (sequence.item (index), i))
		end

feature -- Duplication

	duplicate (n: INTEGER): like Current is
			-- Copy of sub-chain beginning at current position
			-- and having min (`n', `from_here') items,
			-- where `from_here' is the number of items
			-- at or to the right of current position.
		require
			not_off_unless_after: off implies after
			valid_subchain: n >= 0
		deferred
		ensure
		-- ensure: model
			sequence_definition: Result.sequence |=| sequence.interval (index, sequence.count.min (index + n))
		end

feature {NONE} -- Inapplicable

	remove is
			-- Remove current item.
		do
		end

feature -- Model
	sequence: MML_SEQUENCE [G] is
			-- Mathematical relation, representing content of the container
		local
			i: INTEGER
		do
			create {MML_DEFAULT_SEQUENCE [G]} Result
			from
				i := 1
			until
				i > count
			loop
				Result := Result.extended (i_th (i))
				i := i + 1
			end
		end

	cursors: MML_SET [INTEGER] is
			-- Set of possible cursors
		do
			create {MML_RANGE_SET} Result.make_from_range (0, sequence.count + 1)
		end

invariant

	non_negative_index: index >= 0
	index_small_enough: index <= count + 1
	off_definition: off = ((index = 0) or (index = count + 1))
	isfirst_definition: isfirst = ((not is_empty) and (index = 1))
	islast_definition: islast = ((not is_empty) and (index = count))
	item_corresponds_to_index: (not off) implies (item = i_th (index))
	index_set_has_same_count: index_set.count = count

-- invariant: model
	cursors_sequence_constraint: cursors |=| sequence.domain.extended (0).extended (sequence.count + 1)

indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2008, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"







end -- class CHAIN



