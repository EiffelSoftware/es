indexing
	description: "A flat and model contracted version of the EiffelBase linked list."
	version: "$Id$"
	author: "Bernd Schoeller, based on LINKED_LIST of EiffelBase"
	copyright: "http://archive.eiffel.com/products/base/license.txt"

class
	FLAT_LINKED_LIST[G]

inherit
	ANY
		redefine
			is_equal,
			copy
		end

	MML_COMPARISON
		undefine
			is_equal,
			copy
		end

	MML_CONVERSION [INTEGER]
		undefine
			is_equal,
			copy
		end

create
	make

feature {NONE} -- Initialization

	make is
			-- Create an empty list.
		do
			internal_before := True
		ensure
			is_before: before
		end

feature -- {MML_SPECIFICATION} -- Model

	model_sequence: MML_SEQUENCE [G] is
			-- Model representation of the list.
		local
			cell: FLAT_LINKABLE [G]
		do
			create {MML_DEFAULT_SEQUENCE [G]}Result.make_empty
			from
				cell := first_element
			until
				cell = Void
			loop
				Result := Result.extended (cell.item)
				cell := cell.right
			end
		ensure
			not_void: Result /= Void
		end

	model_index: INTEGER is
			-- The model of the cursor position.
		do
			Result := index
		end

	model: MML_PAIR [MML_SEQUENCE [G],INTEGER] is
			-- Model representation of the list.
		do
			create {MML_DEFAULT_PAIR[MML_SEQUENCE [G],INTEGER]}Result.make_from (model_sequence, model_index)
		end

feature -- Access

	cursor: FLAT_LINKED_LIST_CURSOR [G] is
			-- Current cursor position
		do
			create Result.make (active, after, before)
		ensure
			cursor_not_void: Result /= Void
			model_invariant: equal_value (model, old model)
		end

	first: like item is
			-- Item at first position
		require
			not_empty: not is_empty
		do
			Result := first_element.item
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result,model_sequence.item (1))
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
		ensure
			not_found_in_empty: Result implies not is_empty
			model_invariant: equal_value (model, old model)
			model_contract: Result = model_sequence.range.contains (v)
		end

	i_th alias "[]" (i: INTEGER): like item assign put_i_th is
			-- Item at `i'-th position
			-- Was declared in CHAIN as synonym of `@'.
		require
			valid_key: valid_index (i)
		local
			pos: CURSOR
		do
			pos := cursor
			go_i_th (i)
			Result := item
			go_to (pos)
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result,model_sequence.item (i))
		end

	index: INTEGER is
			-- Index of current position
		local
			p: FLAT_LINKED_LIST_CURSOR [G]
		do
			if after then
				Result := internal_count + 1
			elseif not before then
				p ?= cursor
				check
					p /= Void
				end
				from
					start
					Result := 1
				until
					p.active = active
				loop
					forth
					Result := Result + 1
				end
				go_to (p)
			end
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: model_index = Result
		end

	index_of (v: like item; i: INTEGER): INTEGER is
			-- Index of `i'-th occurrence of item identical to `v'.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
			-- 0 if none.
		require
			positive_occurrences: i > 0
		local
			pos: CURSOR
		do
			pos := cursor
			Result := sequential_index_of (v, i)
			go_to (pos)
		ensure
			non_negative_result: Result >= 0
			model_invariant: equal_value (model, old model)
			model_contract: Result = model_sequence.index_of_i_th_occurrence_of (v, i)
		end

	item: G is
			-- Current item
		require
			not_off: not off
			readable: readable
		do
			Result := active.item
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result,model_sequence.item (model_index))
		end

	last: like item is
			-- Item at last position
		require
			not_empty: not is_empty
		do
			Result := last_element.item
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result,model_sequence.item (model_sequence.count))
		end

	sequential_occurrences (v: G): INTEGER is
			-- Number of times `v' appears.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		do
			from
				start
				search (v)
			until
				exhausted
			loop
				Result := Result + 1
				forth
				search (v)
			end
		ensure
			non_negative_occurrences: Result >= 0
			model_invariant: equal_value (model, old model)
			model_contract: Result = model_sequence.occurrences (v)
		end

	infix "@" (i: INTEGER): like item assign put_i_th is
			-- Item at `i'-th position
			-- Was declared in CHAIN as synonym of `i_th'.
		require
			valid_key: valid_index (i)
		local
			pos: CURSOR
		do
			pos := cursor
			go_i_th (i)
			Result := item
			go_to (pos)
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result, model_sequence.item (i))
		end

feature {NONE} -- Access

	sequential_has (v: like item): BOOLEAN is
			-- Does structure include an occurrence of `v'?
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		do
			start
			if not off then
				search (v)
			end
			Result := not exhausted
		ensure
			not_found_in_empty: Result implies not is_empty
		end

	sequential_index_of (v: like item; i: INTEGER): INTEGER is
			-- Index of `i'-th occurrence of `v'.
			-- 0 if none.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		require
			positive_occurrences: i > 0
		local
			occur, pos: INTEGER
		do
			if object_comparison and v /= Void then
				from
					start
					pos := 1
				until
					exhausted or (occur = i)
				loop
					if item /= Void and then v.is_equal (item) then
						occur := occur + 1
					end
					forth
					pos := pos + 1
				end
			else
				from
					start
					pos := 1
				until
					exhausted or (occur = i)
				loop
					if item = v then
						occur := occur + 1
					end
					forth
					pos := pos + 1
				end
			end
			if occur = i then
				Result := pos - 1
			end
		ensure
			non_negative_result: Result >= 0
		end

	sequential_search (v: like item) is
			-- Move to first position (at or after current
			-- position) where `item' and `v' are equal.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
			-- If no such position ensure that `exhausted' will be true.
		do
			if object_comparison and v /= Void then
				from
				until
					exhausted or else (item /= Void and then v.is_equal (item))
				loop
					forth
				end
			else
				from
				until
					exhausted or else v = item
				loop
					forth
				end
			end
		ensure
			object_found: (not exhausted and object_comparison) implies equal (v, item)
			item_found: (not exhausted and not object_comparison) implies v = item
		end

feature -- Measurement

	count: INTEGER is
			-- Number of items
		do
			Result := internal_count
		end

	index_set: INTEGER_INTERVAL is
			-- Range of acceptable indexes
		do
			create Result.make (1, count)
		ensure
			not_void: Result /= Void
			count_definition: Result.count = count
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result.lower,1)
			model_contract: equal_value (Result.upper,model_sequence.count)
		end

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
		ensure
			non_negative_occurrences: Result >= 0
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result, model_sequence.occurrences (v))
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Does `other' contain the same elements?
		local
			c1, c2: CURSOR
		do
			if Current = other then
				Result := True
			else
				Result := (is_empty = other.is_empty) and (object_comparison = other.object_comparison) and (count = other.count)
				if Result and not is_empty then
					c1 ?= cursor
					c2 ?= other.cursor
					check
						cursors_exist: c1 /= Void and c2 /= Void
					end
					from
						start
						other.start
					until
						after or not Result
					loop
						if object_comparison then
							Result := equal (item, other.item)
						else
							Result := (item = other.item)
						end
						forth
						other.forth
					end
					go_to (c1)
					other.go_to (c2)
				elseif is_empty and other.is_empty and object_comparison = other.object_comparison then
					Result := True
				end
			end
		ensure then
			model_invariant: equal_value (model, old model)
			model_contract: equal_value (Result, equal_value (model_sequence,other.model_sequence))
		end

feature -- Status report

	after: BOOLEAN is
			-- Is there no valid cursor position to the right of cursor?
		do
			Result := internal_after
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: Result = (model_index = model_sequence.count + 1)
		end

	before: BOOLEAN is
			-- Is there no valid cursor position to the left of cursor?
		do
			Result := internal_before
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: Result = (model_index = 0)
		end

	changeable_comparison_criterion: BOOLEAN is
			-- May `object_comparison' be changed?
			-- (Answer: yes by default.)
		do
			Result := True
		ensure
			model_invariant: equal_value (model, old model)
		end

	exhausted: BOOLEAN is
			-- Has structure been completely explored?
		do
			Result := off
		ensure
			exhausted_when_off: off implies Result
			model_invariant: equal_value (model, old model)
		end

	Extendible: BOOLEAN is True
			-- May new items be added? (Answer: yes.)

	Full: BOOLEAN is False
			-- Is structured filled to capacity? (Answer: no.)

	is_empty: BOOLEAN is
			-- Is structure empty?
		do
			Result := (count = 0)
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: Result = model_sequence.is_empty
		end

	is_inserted (v: G): BOOLEAN is
			-- Has `v' been inserted at the end by the most recent `put' or
			-- `extend'?
		do
			if not is_empty then
				check
					put_constraint: (v /= last_element.item) implies not off
				end
				Result := (v = last_element.item) or else (v = item)
			end
		ensure
			model_invariant: equal_value (model, old model)
		end

	isfirst: BOOLEAN is
			-- Is cursor at first position?
		do
			Result := not after and not before and (active = first_element)
		ensure
			valid_position: Result implies not is_empty
			model_invariant: equal_value (model, old model)
			model_contract: Result = (equal_value (model_index,1))
		end

	islast: BOOLEAN is
			-- Is cursor at last position?
		do
			Result := not after and not before and (active /= Void) and then (active.right = Void)
		ensure
			valid_position: Result implies not is_empty
			model_invariant: equal_value (model, old model)
			model_contract: Result = (equal_value (model_index,model_sequence.count))
		end

	object_comparison: BOOLEAN
			-- Must search operations use `equal' rather than `='
			-- for comparing references? (Default: no, use `='.)

	off: BOOLEAN is
			-- Is there no current item?
		do
			Result := after or before
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: Result = (equal_value (model_index,0) or equal_value (model_index,model_sequence.count+1))
		end

	prunable: BOOLEAN is
			-- May items be removed? (Answer: yes.)
		do
			Result := True
		ensure
			model_invariant: equal_value (model, old model)
		end

	readable: BOOLEAN is
			-- Is there a current item that may be read?
		do
			Result := not off
		ensure
			model_invariant: equal_value (model, old model)
			model_contract: Result = (model_index >= 1) and (model_index <= model_sequence.count)
		end

	valid_cursor (p: CURSOR): BOOLEAN is
			-- Can the cursor be moved to position `p'?
		local
			ll_c: like cursor
			temp, sought: like first_element
		do
			ll_c ?= p
			if ll_c /= Void then
				from
					temp := first_element
					sought := ll_c.active
					Result := ll_c.after or else ll_c.before
				until
					Result or else temp = Void
				loop
					Result := (temp = sought)
					temp := temp.right
				end
			end
		ensure
			model_invariant: equal_value (model, old model)
		end

	valid_cursor_index (i: INTEGER): BOOLEAN is
			-- Is `i' correctly bounded for cursor movement?
		do
			Result := (i >= 0) and (i <= count + 1)
		ensure
			valid_cursor_index_definition: Result = ((i >= 0) and (i <= count + 1))
			model_invariant: equal_value (model, old model)
			model_contract: Result = (model_index >= 0) and (model_index <= model_sequence.count+1)
		end

	valid_index (i: INTEGER): BOOLEAN is
			-- Is `i' within allowable bounds?
		do
			Result := (i >= 1) and (i <= count)
		ensure
			only_if_in_index_set: Result implies ((i >= index_set.lower) and (i <= index_set.upper))
			valid_index_definition: Result = ((i >= 1) and (i <= count))
			model_invariant: equal_value (model, old model)
			model_contract: Result = (model_index >= 1) and (model_index <= model_sequence.count)
		end

	writable: BOOLEAN is
			-- Is there a current item that may be modified?
		do
			Result := not off
		ensure
			model_invariant: equal_value (model, old model)
		end

feature -- Status setting

	compare_objects is
			-- Ensure that future search operations will use `equal'
			-- rather than `=' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			object_comparison := True
		ensure
			object_comparison
			model_invariant: equal_value (model, old model)
		end

	compare_references is
			-- Ensure that future search operations will use `='
			-- rather than `equal' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			object_comparison := False
		ensure
			reference_comparison: not object_comparison
			model_invariant: equal_value (model, old model)
		end

feature -- Cursor movement

	back is
			-- Move to previous item.
		require
			not_before: not before
			model_contract: model_index >= 1
		do
			if is_empty then
				internal_before := True
				internal_after := False
			elseif after then
				internal_after := False
			elseif isfirst then
				internal_before := True
			else
				active := previous
			end
		ensure
			model_invariant: equal_value (model_sequence,old model_sequence)
			model_contract: model_index = old model_index - 1
		end

	finish is
			-- Move cursor to last position.
			-- (Go before if empty)
		local
			p: like first_element
		do
			if not is_empty then
				from
					p := active
				until
					p.right = Void
				loop
					p := p.right
				end
				active := p
				internal_after := False
				internal_before := False
			else
				internal_before := True
				internal_after := False
			end
		ensure then
			at_last: not is_empty implies islast
			empty_convention: is_empty implies before
			model_contract: model_sequence.is_empty implies model_index = 0
			model_contract: not model_sequence.is_empty implies model_index = 1
		end

	forth is
			-- Move cursor to next position.
		require
			not_after: not after
			model_contract: model_index <= model_sequence.count
		local
			old_active: like first_element
		do
			if before then
				internal_before := False
				if is_empty then
					internal_after := True
				end
			else
				old_active := active
				active := active.right
				if active = Void then
					active := old_active
					internal_after := True
				end
			end
		ensure then
			moved_forth: index = old index + 1
			model_contract: model_index = old model_index + 1
		end

	go_i_th (i: INTEGER) is
			-- Move cursor to `i'-th position.
		require
			valid_cursor_index: valid_cursor_index (i)
			model_contract: model_index >= 0
			model_contract: model_index <= model_sequence.count + 1
		do
			if i = 0 then
				internal_before := True
				internal_after := False
				active := first_element
			elseif i = count + 1 then
				internal_before := False
				internal_after := True
				active := last_element
			else
				move (i - index)
			end
		ensure
			position_expected: index = i
			model_contract: model_index = i
			model_invariant: equal_value (model_sequence, old model_sequence)
		end

	go_to (p: CURSOR) is
			-- Move cursor to position `p'.
		require
			cursor_position_valid: valid_cursor (p)
		local
			ll_c: like cursor
		do
			ll_c ?= p
			check
				ll_c /= Void
			end
			internal_after := ll_c.after
			internal_before := ll_c.before
			if before then
				active := first_element
			elseif after then
				active := last_element
			else
				active := ll_c.active
			end
		ensure
			model_invariant: equal_value (model_sequence, old model_sequence)
		end

	move (i: INTEGER) is
			-- Move cursor `i' positions. The cursor
			-- may end up `off' if the offset is too big.
		local
			counter, new_index: INTEGER
			p: like first_element
		do
			if i > 0 then
				if before then
					internal_before := False
					counter := 1
				end
				from
					p := active
				until
					(counter = i) or else (p = Void)
				loop
					active := p
					p := p.right
					counter := counter + 1
				end
				if p = Void then
					internal_after := True
				else
					active := p
				end
			elseif i < 0 then
				new_index := index + i
				internal_before := True
				internal_after := False
				active := first_element
				if (new_index > 0) then
					move (new_index)
				end
			end
		ensure
			too_far_right: (old index + i > count) implies exhausted
			too_far_left: (old index + i < 1) implies exhausted
			expected_index: (not exhausted) implies (index = old index + i)
			moved_if_inbounds: ((old index + i) >= 0 and (old index + i) <= (count + 1)) implies index = (old index + i)
			before_set: (old index + i) <= 0 implies before
			after_set: (old index + i) >= (count + 1) implies after
			model_invariant: equal_value (model_sequence, old model_sequence)
			model_contract: (old(model_index)+i > model_sequence.count) implies model_index = model_sequence.count + 1
			model_contract: (old(model_index)+i < 1) implies model_index = 0
			model_contract: (old(model_index)+i >= 1 and model_index+i <= model_sequence.count) implies (model_index = old(model_index)+i)
		end

	search (v: like item) is
			-- Move to first position (at or after current
			-- position) where `item' and `v' are equal.
			-- If structure does not include `v' ensure that
			-- `exhausted' will be true.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		do
			if before and not is_empty then
				forth
			end
			sequential_search (v)
		ensure
			object_found: (not exhausted and object_comparison) implies equal (v, item)
			item_found: (not exhausted and not object_comparison) implies v = item
			model_invariant: equal_value (model_sequence, old model_sequence)
			model_contract: (not (model_index = model_sequence.count + 1) or (model_index = 0))
				implies equal_value (v, model_sequence.item (model_index))
			model_contract: (not (model_index = model_sequence.count + 1) or (model_index = 0))
				implies (not model_sequence.interval (old model_index, model_index-1).is_member (v))
		end

	start is
			-- Move cursor to first position.
		do
			if first_element /= Void then
				active := first_element
				internal_after := False
			else
				internal_after := True
			end
			internal_before := False
		ensure then
			at_first: not is_empty implies isfirst
			empty_convention: is_empty implies after
			model_invariant: equal_value (model_sequence, old model_sequence)
			model_contract: model_index = 1
		end

feature -- Element change

	append (s: FLAT_LINKED_LIST [G]) is
			-- Append a copy of `s'.
		require
			argument_not_void: s /= Void
		local
			l: like s
			l_cursor: CURSOR
		do
			if s = Current then
				l := s.twin
			else
				l := s
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
		ensure
			new_count: count >= old count
			model_contract: equal_value (model_sequence, old model_sequence.concatenated (s.model_sequence))
		end

	extend (v: like item) is
			-- Add `v' to end.
			-- Do not move cursor.
		require
			extendible: extendible
		local
			p: like first_element
		do
			p := new_cell (v)
			if is_empty then
				first_element := p
				active := p
			else
				last_element.put_right (p)
				if after then
					active := p
				end
			end
			internal_count := internal_count + 1
		ensure
			item_inserted: is_inserted (v)
			one_more_occurrence: occurrences (v) = old (occurrences (v)) + 1
			model_invariant: model_index = old model_index
			model_contract: equal_value (model_sequence, old model_sequence.extended (v))
		end

	force (v: like item) is
			-- Add `v' to end.
		require
			extendible: extendible
		do
			extend (v)
		ensure then
			new_count: count = old count + 1
			item_inserted: has (v)
			model_invariant: model_index = old model_index
			model_contract: equal_value (model_sequence, old model_sequence.extended (v))
		end

	merge_left (other: like Current) is
			-- Merge `other' into current structure before cursor
			-- position. Do not move cursor. Empty `other'.
		require
			extendible: extendible
			not_before: not before
			other_exists: other /= Void
			not_current: other /= Current
		local
			other_first_element: like first_element
			other_last_element: like first_element
			p: like first_element
			other_count: INTEGER
		do
			if not other.is_empty then
				other_first_element := other.first_element
				other_last_element := other.last_element
				other_count := other.count
				check
					other_first_element /= Void
					other_last_element /= Void
				end
				if is_empty then
					first_element := other_first_element
					active := first_element
				elseif isfirst then
					p := first_element
					other_last_element.put_right (p)
					first_element := other_first_element
				else
					p := previous
					if p /= Void then
						p.put_right (other_first_element)
					end
					other_last_element.put_right (active)
				end
				internal_count := count + other_count
				other.wipe_out
			end
		ensure
			new_count: count = old count + old other.count
			new_index: index = old index + old other.count
			other_is_empty: other.is_empty
			model_contract: model_index = old model_index + old other.model_sequence.count
			model_contract: equal_value (model_sequence, old model_sequence.interval (1, model_index-1).
				concatenated (other.model_sequence).concatenated (model_sequence.interval (model_index, model_sequence.count)))
		end

	merge_right (other: like Current) is
			-- Merge `other' into current structure after cursor
			-- position. Do not move cursor. Empty `other'.
		require
			extendible: extendible
			not_after: not after
			other_exists: other /= Void
			not_current: other /= Current
		local
			other_first_element: like first_element
			other_last_element: like first_element
			other_count: INTEGER
		do
			if not other.is_empty then
				other_first_element := other.first_element
				other_last_element := other.last_element
				other_count := other.count
				check
					other_first_element /= Void
					other_last_element /= Void
				end
				if is_empty then
					first_element := other_first_element
					active := first_element
				else
					if not islast then
						other_last_element.put_right (active.right)
					end
					active.put_right (other_first_element)
				end
				internal_count := count + other_count
				other.wipe_out
			end
		ensure
			new_count: count = old count + old other.count
			same_index: index = old index
			other_is_empty: other.is_empty
			model_invariant: model_index = old model_index
			model_contract: equal_value (model_sequence, old model_sequence.interval (1, model_index).
				concatenated (other.model_sequence).concatenated (model_sequence.interval (model_index+1, model_sequence.count)))
		end

	put (v: like item) is
			-- Replace current item by `v'.
			-- (Synonym for `replace')
		require
			writable: writable
		do
			replace (v)
		ensure
			item_inserted: is_inserted (v)
			same_count: count = old count
			model_invariant: model_index = old model_index
			model_contract: equal_value (model_sequence, old model_sequence.replaced_at (v, model_index))
		end

	put_front (v: like item) is
			-- Add `v' to beginning.
			-- Do not move cursor.
		local
			p: like first_element
		do
			p := new_cell (v)
			p.put_right (first_element)
			first_element := p
			if before or is_empty then
				active := p
			end
			internal_count := count + 1
		ensure
			new_count: count = old count + 1
			item_inserted: first = v
			model_contract: model_index = old model_index + 1
			model_contract: equal_value (model_sequence, old model_sequence.prepended (v))
		end

	put_i_th (v: like item; i: INTEGER) is
			-- Put `v' at `i'-th position.
		require
			valid_key: valid_index (i)
			model_contract: i >= 1
			model_contract: i <= model_sequence.count
		local
			pos: CURSOR
		do
			pos := cursor
			go_i_th (i)
			replace (v)
			go_to (pos)
		ensure then
			insertion_done: i_th (i) = v
			model_contract: equal_value (model_sequence, old model_sequence.replaced_at (v, i))
		end

	put_left (v: like item) is
			-- Add `v' to the left of cursor position.
			-- Do not move cursor.
		require
			extendible: extendible
			not_before: not before
			model_contract: model_index >= 0
		local
			p: like first_element
		do
			if is_empty then
				put_front (v)
			elseif after then
				back
				put_right (v)
				move (2)
			else
				p := new_cell (active.item)
				p.put_right (active.right)
				active.put (v)
				active.put_right (p)
				active := p
				internal_count := count + 1
			end
		ensure
			new_count: count = old count + 1
			new_index: index = old index + 1
			previous_exists: previous /= Void
			item_inserted: previous.item = v
			model_contract: model_index = old model_index + 1
		end

	put_right (v: like item) is
			-- Add `v' to the right of cursor position.
			-- Do not move cursor.
		require
			extendible: extendible
			not_after: not after
			model_contract: model_index <= model_sequence.count + 1
		local
			p: like first_element
		do
			p := new_cell (v)
			check
				is_empty implies before
			end
			if before then
				p.put_right (first_element)
				first_element := p
				active := p
			else
				p.put_right (active.right)
				active.put_right (p)
			end
			internal_count := count + 1
		ensure
			new_count: count = old count + 1
			same_index: index = old index
			next_exists: next /= Void
			item_inserted: not old before implies next.item = v
			item_inserted_before: old before implies active.item = v
			model_invariant: model_index = old model_index
		end

	replace (v: like item) is
			-- Replace current item by `v'.
		require
			writable: writable
		do
			active.put (v)
		ensure
			item_replaced: item = v
			model_invariant: model_index = old model_index
			model_contract: equal_value (model_sequence, old model_sequence.replaced_at (v, model_index))
		end

feature {NONE} -- Element change

	sequence_put (v: like item) is
			-- Add `v' to end.
		require
			extendible: extendible
		do
			extend (v)
		ensure
			item_inserted: is_inserted (v)
			new_count: count = old count + 1
		end

feature -- Removal

	prune (v: like item) is
			-- Remove first occurrence of `v', if any,
			-- after cursor position.
			-- If found, move cursor to right neighbor;
			-- if not, make structure `exhausted'.
		require
			prunable: prunable
		do
			search (v)
			if not exhausted then
				remove
			end
		end

	prune_all (v: like item) is
			-- Remove all occurrences of `v'.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
			-- Leave structure `exhausted'.
		require
			prunable: prunable
		do
			from
				start
				search (v)
			until
				exhausted
			loop
				remove
				search (v)
			end
		ensure
			no_more_occurrences: not has (v)
			is_exhausted: exhausted
			model_contract: equal_value (model_sequence, old model_sequence.pruned (v))
		end

	remove is
			-- Remove current item.
			-- Move cursor to right neighbor
			-- (or `after' if no right neighbor).
		require
			prunable: prunable
			writable: writable
			model_contract: model_index >= 1
			model_contract: model_index <= model_sequence.count
		local
			removed, succ: like first_element
		do
			removed := active
			if isfirst then
				first_element := first_element.right
				active.forget_right
				active := first_element
				if count = 1 then
					check
						no_active: active = Void
					end
					internal_after := True
				end
			elseif islast then
				active := previous
				if active /= Void then
					active.forget_right
				end
				internal_after := True
			else
				succ := active.right
				previous.put_right (succ)
				active.forget_right
				active := succ
			end
			internal_count := count - 1
			cleanup_after_remove (removed)
		ensure then
			after_when_empty: is_empty implies after
			model_invairant: model_index = old model_index
			model_contract: equal_value (model_sequence, old model_sequence.pruned_at (model_index))
		end

	remove_left is
			-- Remove item to the left of cursor position.
			-- Do not move cursor.
		require
			left_exists: index > 1
			model_contract: model_index >= 2
		do
			move (-2)
			remove_right
			forth
		ensure
			new_count: count = old count - 1
			new_index: index = old index - 1
			model_contract: model_index = old model_index - 1
			model_contract: equal_value (model_sequence,old model_sequence.pruned_at (model_index-1))
		end

	remove_right is
			-- Remove item to the right of cursor position.
			-- Do not move cursor.
		require
			right_exists: index < count
			model_contract: model_index < model_sequence.count
		local
			removed, succ: like first_element
		do
			if before then
				removed := first_element
				first_element := first_element.right
				active.forget_right
				active := first_element
			else
				succ := active.right
				removed := succ
				active.put_right (succ.right)
				succ.forget_right
			end
			internal_count := count - 1
			cleanup_after_remove (removed)
		ensure
			new_count: count = old count - 1
			same_index: index = old index
			model_invariant: model_index = old model_index
			model_contract: equal_value (model_sequence, old model_sequence.pruned_at (model_index+1))
		end

	wipe_out is
			-- Remove all items.
		require
			prunable: prunable
		do
			internal_wipe_out
		ensure
			wiped_out: is_empty
			is_before: before
			model_contract: model_index = 0
			model_contract: model_sequence.is_empty
		end

feature {NONE} -- Removal

	chain_wipe_out is
			-- Remove all items.
		require
			prunable: prunable
		do
			from
				start
			until
				is_empty
			loop
				remove
			end
		ensure
			wiped_out: is_empty
		end

feature -- Transformation

	swap (i: INTEGER) is
			-- Exchange item at `i'-th position with item
			-- at cursor position.
		require
			not_off: not off
			valid_index: valid_index (i)
			model_contract: model_index >= 1
			model_contract: model_index <= model_sequence.count
			model_contract: i >= 1
			model_contract: i <= model_sequence.count
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
			model_invariant: model_index = old model_index
			-- TODO
		end

feature -- Duplication

	copy (other: like Current) is
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		local
			cur: FLAT_LINKED_LIST_CURSOR [G]
			obj_comparison: BOOLEAN
		do
			obj_comparison := other.object_comparison
			standard_copy (other)
			if not other.is_empty then
				internal_wipe_out
				cur ?= other.cursor
				from
					other.start
				until
					other.off
				loop
					extend (other.item)
					finish
					other.forth
				end
				other.go_to (cur)
			end
			object_comparison := obj_comparison
		ensure then
			model_contract: equal_value (model, other.model)
		end

	duplicate (n: INTEGER): like Current is
			-- Copy of sub-chain beginning at current position
			-- and having min (`n', `from_here') items,
			-- where `from_here' is the number of items
			-- at or to the right of current position.
		require
			not_off_unless_after: off implies after
			valid_subchain: n >= 0
		local
			pos: CURSOR
			counter: INTEGER
		do
			from
				Result := new_chain
				if object_comparison then
					Result.compare_objects
				end
				pos := cursor
			until
				(counter = n) or else exhausted
			loop
				Result.extend (item)
				forth
				counter := counter + 1
			end
			go_to (pos)
		end

feature {FLAT_LINKED_LIST} -- Implementation

	active: like first_element
			-- Element at cursor position

	cleanup_after_remove (v: like first_element) is
			-- Clean-up a just removed cell.
		require
			non_void_cell: v /= Void
		do
		end

	first_element: FLAT_LINKABLE [like item]
			-- Head of list

	last_element: like first_element is
			-- Tail of list
		local
			p: like first_element
		do
			if not is_empty then
				from
					Result := active
					p := active.right
				until
					p = Void
				loop
					Result := p
					p := p.right
				end
			end
		end

	new_cell (v: like item): like first_element is
			-- A newly created instance of the same type as `first_element'.
			-- This feature may be redefined in descendants so as to
			-- produce an adequately allocated and initialized object.
		do
			create Result
			Result.put (v)
		ensure
			result_exists: Result /= Void
		end

	new_chain: like Current is
			-- A newly created instance of the same type.
			-- This feature may be redefined in descendants so as to
			-- produce an adequately allocated and initialized object.
		do
			create Result.make
		ensure
			result_exists: Result /= Void
		end

	next: like first_element is
			-- Element right of cursor
		do
			if before then
				Result := active
			elseif active /= Void then
				Result := active.right
			end
		end

	previous: like first_element is
			-- Element left of cursor
		local
			p: like first_element
		do
			if after then
				Result := active
			elseif not (isfirst or before) then
				from
					p := first_element
				until
					p.right = active
				loop
					p := p.right
				end
				Result := p
			end
		end

feature {NONE} -- Implementation

	frozen internal_wipe_out is
			-- Remove all items.
		require
			prunable
		do
			active := Void
			first_element := Void
			internal_before := True
			internal_after := False
			internal_count := 0
		ensure
			wiped_out: is_empty
			is_before: before
		end

feature -- Iteration

	do_all (action: PROCEDURE [ANY, TUPLE [G]]) is
			-- Apply `action' to every item.
			-- Semantics not guaranteed if `action' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		require
			action_exists: action /= Void
		local
			t: TUPLE [G]
			cs: CURSOR_STRUCTURE [G]
			c: CURSOR
		do
			cs ?= Current
			if cs /= Void then
				c := cs.cursor
			end
			create t
			from
				start
			until
				after
			loop
				t.put (item, 1)
				action.call (t)
				forth
			end
			if cs /= Void then
				cs.go_to (c)
			end
		end

	do_if (action: PROCEDURE [ANY, TUPLE [G]]; test: FUNCTION [ANY, TUPLE [G], BOOLEAN]) is
			-- Apply `action' to every item that satisfies `test'.
			-- Semantics not guaranteed if `action' or `test' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		require
			action_exists: action /= Void
			test_exits: test /= Void
		local
			t: TUPLE [G]
			cs: CURSOR_STRUCTURE [G]
			c: CURSOR
		do
			cs ?= Current
			if cs /= Void then
				c := cs.cursor
			end
			create t
			from
				start
			until
				after
			loop
				t.put (item, 1)
				if test.item (t) then
					action.call (t)
				end
				forth
			end
			if cs /= Void then
				cs.go_to (c)
			end
		end

	for_all (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Is `test' true for all items?
		require
			test_exits: test /= Void
		local
			cs: CURSOR_STRUCTURE [G]
			c: CURSOR
			t: TUPLE [G]
		do
			create t
			cs ?= Current
			if cs /= Void then
				c := cs.cursor
			end
			from
				start
				Result := True
			until
				after or not Result
			loop
				t.put (item, 1)
				Result := test.item (t)
				forth
			end
			if cs /= Void then
				cs.go_to (c)
			end
		ensure then
			empty: is_empty implies Result
			model_invariant: equal_value (model, old model)
		end

	there_exists (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN is
			-- Is `test' true for at least one item?
		require
			test_exits: test /= Void
		local
			cs: CURSOR_STRUCTURE [G]
			c: CURSOR
			t: TUPLE [G]
		do
			create t
			cs ?= Current
			if cs /= Void then
				c := cs.cursor
			end
			from
				start
			until
				after or Result
			loop
				t.put (item, 1)
				Result := test.item (t)
				forth
			end
			if cs /= Void then
				cs.go_to (c)
			end
		ensure
			model_invariant: equal_value (model, old model)
		end

feature{NONE} -- State Implementation

	internal_count: INTEGER
			-- Number of items	

	internal_after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?

	internal_before: BOOLEAN
			-- Is there no valid cursor position to the left of cursor?

invariant
	-- Model Invariant
	model_index_definition: model_index >= 0
	model_index_definition: model_index <= model_sequence.count + 1

	-- Regular Invariant
	prunable: prunable
	empty_constraint: is_empty implies ((first_element = Void) and (active = Void))
	not_void_unless_empty: (active = Void) implies is_empty
	before_constraint: before implies (active = first_element)
	after_constraint: after implies (active = last_element)
	before_definition: before = (index = 0)
	after_definition: after = (index = count + 1)
	non_negative_index: index >= 0
	index_small_enough: index <= count + 1
	off_definition: off = ((index = 0) or (index = count + 1))
	isfirst_definition: isfirst = ((not is_empty) and (index = 1))
	islast_definition: islast = ((not is_empty) and (index = count))
	item_corresponds_to_index: (not off) implies (item = i_th (index))
	index_set_has_same_count: index_set.count = count
	writable_constraint: writable implies readable
	empty_constraint: is_empty implies (not readable) and (not writable)
	reflexive_equality: standard_is_equal (Current)
	reflexive_conformance: conforms_to (Current)
	index_set_not_void: index_set /= Void
	not_both: not (after and before)
	before_constraint: before implies off
	after_constraint: after implies off
	empty_constraint: is_empty implies off
	empty_definition: is_empty = (count = 0)
	non_negative_count: count >= 0
	extendible: extendible
end
