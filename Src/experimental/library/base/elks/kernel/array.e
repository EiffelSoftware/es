note

	description: "[
		Sequences of values, all of the same type or of a conforming one,
		accessible through integer indices in a contiguous interval.
		]"

	library: "Free implementation of ELKS library"
	copyright: "Copyright (c) 1986-2008, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class ARRAY [G] inherit

	RESIZABLE [G]
		redefine
			full, copy, is_equal, resizable
		end

	INDEXABLE [G, INTEGER]
		rename
			item as item alias "[]"
		redefine
			copy, is_equal
		end

	TO_SPECIAL [G]
		export
			{ARRAY} set_area
		redefine
			copy, is_equal, item, put, at, valid_index
		end

create
	make,
	make_filled,
	make_from_array,
	make_from_special,
	make_from_cil

convert
	to_cil: {NATIVE_ARRAY [G], detachable NATIVE_ARRAY [G]},
	to_special: {SPECIAL [G]},
	make_from_cil ({NATIVE_ARRAY [G]})

feature -- Initialization

	make_filled (a_default_value: G; min_index, max_index: INTEGER)
			-- Allocate array; set index interval to
			-- `min_index' .. `max_index'; set all values to default.
			-- (Make array empty if `min_index' = `max_index' + 1).
		require
			valid_bounds: min_index <= max_index + 1
		local
			n: INTEGER
		do
			lower := min_index
			upper := max_index
			if min_index <= max_index then
				n := max_index - min_index + 1
			end
			make_filled_area (a_default_value, n)
		ensure
			lower_set: lower = min_index
			upper_set: upper = max_index
			items_set: filled_with (a_default_value)
		end

	make (min_index, max_index: INTEGER)
			-- Allocate array; set index interval to
			-- `min_index' .. `max_index'; set all values to default.
			-- (Make array empty if `min_index' = `max_index' + 1).
		require
			valid_bounds: min_index <= max_index + 1
			has_default: ({G}).has_default
		local
			n: INTEGER
		do
			lower := min_index
			upper := max_index
			if min_index <= max_index then
				n := max_index - min_index + 1
			end
			make_filled_area (({G}).default, n)
		ensure
			lower_set: lower = min_index
			upper_set: upper = max_index
			items_set: all_default
		end

	make_from_array (a: ARRAY [G])
			-- Initialize from the items of `a'.
			-- (Useful in proper descendants of class `ARRAY',
			-- to initialize an array-like object from a manifest array.)
		require
			array_exists: a /= Void
		do
			set_area (a.area)
			lower := a.lower
			upper := a.upper
		end

	make_from_special (a: SPECIAL [G])
			-- Initialize Current from items of `a'.
		require
			special_attached: a /= Void
		do
			set_area (a)
			lower := 1
			upper := a.count
		ensure
			shared: area = a
			lower_set: lower = 1
			upper_set: upper = a.count
		end

	make_from_cil (na: NATIVE_ARRAY [like item])
			-- Initialize array from `na'.
		require
			is_dotnet: {PLATFORM}.is_dotnet
			na_not_void: na /= Void
		do
			create area.make_from_native_array (na)
			lower := 1
			upper := area.count
		end

feature -- Access

	item alias "[]", at alias "@" (i: INTEGER): G assign put
			-- Entry at index `i', if in index interval
		do
			Result := area.item (i - lower)
		end

	entry (i: INTEGER): G
			-- Entry at index `i', if in index interval
		require
			valid_key: valid_index (i)
		do
			Result := item (i)
		end

	has (v: G): BOOLEAN
			-- Does `v' appear in array?
 			-- (Reference or object equality,
			-- based on `object_comparison'.)
		local
			i, nb: INTEGER
			l_area: like area
		do
			l_area := area
			nb := upper - lower
			if object_comparison and v /= Void then
				from
				until
					i > nb or Result
				loop
					Result := l_area.item (i) ~ v
					i := i + 1
				end
			else
				from
				until
					i > nb or Result
				loop
					Result := l_area.item (i) = v
					i := i + 1
				end
			end
		end

feature -- Measurement

	lower: INTEGER
			-- Minimum index

	upper: INTEGER
			-- Maximum index

	count, capacity: INTEGER
			-- Number of available indices
		do
			Result := upper - lower + 1
		ensure then
			consistent_with_bounds: Result = upper - lower + 1
		end

	occurrences (v: G): INTEGER
			-- Number of times `v' appears in structure
		local
			i: INTEGER
		do
			if object_comparison then
				from
					i := lower
				until
					i > upper
				loop
					if item (i) ~ v then
						Result := Result + 1
					end
					i := i + 1
				end
			else
				from
					i := lower
				until
					i > upper
				loop
					if item (i) = v then
						Result := Result + 1
					end
					i := i + 1
				end
			end
		end

	index_set: INTEGER_INTERVAL
			-- Range of acceptable indexes
		do
			create Result.make (lower, upper)
		ensure then
			same_count: Result.count = count
			same_bounds:
				((Result.lower = lower) and (Result.upper = upper))
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is array made of the same items as `other'?
		local
			i: INTEGER
		do
			if other = Current then
				Result := True
			elseif lower = other.lower and then upper = other.upper and then
				object_comparison = other.object_comparison
			then
				if object_comparison then
					from
						Result := True
						i := lower
					until
						not Result or i > upper
					loop
						Result := item (i) ~ other.item (i)
						i := i + 1
					end
				else
					Result := area.same_items (other.area, 0, 0, count)
				end
			end
		end

feature -- Status report

	all_default: BOOLEAN
			-- Are all items set to default values?
		do
			Result := ({G}).has_default and then area.filled_with (({G}).default, 0, upper - lower)
		ensure
			definition: Result = (count = 0 or else
				((not attached item (upper) as i or else i = i.default) and
				subarray (lower, upper - 1).all_default))
		end

	filled_with (v: G): BOOLEAN
			-- Are all itms set to `v'?
		do
			Result := area.filled_with (v, 0, upper - lower)
		ensure
			definition: Result = (count = 0 or else
				(item (upper) = v and subarray (lower, upper - 1).filled_with (v)))
		end

	full: BOOLEAN
			-- Is structure filled to capacity? (Answer: yes)
		do
			Result := True
		end

	same_items (other: like Current): BOOLEAN
			-- Do `other' and Current have same items?
		require
			other_not_void: other /= Void
		do
			if count = other.count then
				Result := area.same_items (other.area, 0, 0, count)
			end
		ensure
			definition: Result = ((count = other.count) and then
				(count = 0 or else (item (upper) = other.item (other.upper)
				and subarray (lower, upper - 1).same_items
				(other.subarray (other.lower, other.upper - 1)))))
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' within the bounds of the array?
		do
			Result := (lower <= i) and then (i <= upper)
		end

	extendible: BOOLEAN
			-- May items be added?
			-- (Answer: no, although array may be resized.)
		do
			Result := False
		end

	prunable: BOOLEAN
			-- May items be removed? (Answer: no.)
		do
			Result := False
		end

	resizable: BOOLEAN
			-- Can array be resized automatically?
		do
			Result := ({G}).has_default
		end

	valid_index_set: BOOLEAN
		do
			Result := index_set.count = count
		end

feature -- Element change

	put (v: like item; i: INTEGER)
			-- Replace `i'-th entry, if in index interval, by `v'.
		do
			area.put (v, i - lower)
		end

	enter (v: like item; i: INTEGER)
			-- Replace `i'-th entry, if in index interval, by `v'.
		require
			valid_key: valid_index (i)
		do
			area.put (v, i - lower)
		end

	force (v: like item; i: INTEGER)
			-- Assign item `v' to `i'-th entry.
			-- Always applicable: resize the array if `i' falls out of
			-- currently defined bounds; preserve existing items.
		require
			has_default: ({G}).has_default
		local
			old_size, new_size: INTEGER
			new_lower, new_upper: INTEGER
			offset: INTEGER
		do
			new_lower := lower.min (i)
			new_upper := upper.max (i)
			new_size := new_upper - new_lower + 1
			if not empty_area then
				old_size := area.count
				if new_size > old_size and new_size - old_size < additional_space then
					new_size := old_size + additional_space
				end
			end
			if empty_area then
				make_filled_area (({G}).default, new_size)
			else
				if new_size > old_size then
					set_area (area.aliased_resized_area_with_default (({G}).default, new_size))
				end
				if new_lower < lower then
					offset := lower - new_lower
					area.move_data (0, offset, capacity)
					area.fill_with (({G}).default, 0, offset - 2)
				end
			end
			lower := new_lower
			upper := new_upper
			put (v, i)
		ensure
			inserted: item (i) = v
			higher_count: count >= old count
			lower_set: lower = (old lower).min (i)
			upper_set: upper = (old upper).max (i)
		end

	subcopy (other: ARRAY [like item]; start_pos, end_pos, index_pos: INTEGER)
			-- Copy items of `other' within bounds `start_pos' and `end_pos'
			-- to current array starting at index `index_pos'.
		require
			other_not_void: other /= Void
			valid_start_pos: other.valid_index (start_pos)
			valid_end_pos: other.valid_index (end_pos)
			valid_bounds: (start_pos <= end_pos) or (start_pos = end_pos + 1)
			valid_index_pos: valid_index (index_pos)
			enough_space: (upper - index_pos) >= (end_pos - start_pos)
		do
			area.copy_data (other.area, start_pos - other.lower, index_pos - lower, end_pos - start_pos + 1)
		ensure
			-- copied: forall `i' in 0 .. (`end_pos'-`start_pos'),
			--     item (index_pos + i) = other.item (start_pos + i)
		end

feature -- Iteration

feature -- Iteration

	do_all (action: PROCEDURE [ANY, TUPLE [G]])
			-- Apply `action' to every item, from first to last.
			-- Semantics not guaranteed if `action' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		require
			action_not_void: action /= Void
		do
			area.do_all_in_bounds (action, 0, count - 1)
		end

	do_if (action: PROCEDURE [ANY, TUPLE [G]]; test: FUNCTION [ANY, TUPLE [G], BOOLEAN])
			-- Apply `action' to every item that satisfies `test', from first to last.
			-- Semantics not guaranteed if `action' or `test' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		require
			action_not_void: action /= Void
			test_not_void: test /= Void
		do
			area.do_if_in_bounds (action, test, 0, count - 1)
		end

	there_exists (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN
			-- Is `test' true for at least one item?
		require
			test_not_void: test /= Void
		do
			Result := area.there_exists_in_bounds (test, 0, count - 1)
		end

	for_all (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]): BOOLEAN
			-- Is `test' true for all items?
		require
			test_not_void: test /= Void
		do
			Result := area.for_all_in_bounds (test, 0, count - 1)
		end

	do_all_with_index (action: PROCEDURE [ANY, TUPLE [G, INTEGER]])
			-- Apply `action' to every item, from first to last.
			-- `action' receives item and its index.
			-- Semantics not guaranteed if `action' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		local
			i, j, nb: INTEGER
			l_area: like area
		do
			from
				i := 0
				j := lower
				nb := count - 1
				l_area := area
			until
				i > nb
			loop
				action.call ([l_area.item (i), j])
				j := j + 1
				i := i + 1
			end
		end

	do_if_with_index (action: PROCEDURE [ANY, TUPLE [G, INTEGER]]; test: FUNCTION [ANY, TUPLE [G, INTEGER], BOOLEAN])
			-- Apply `action' to every item that satisfies `test', from first to last.
			-- `action' and `test' receive the item and its index.
			-- Semantics not guaranteed if `action' or `test' changes the structure;
			-- in such a case, apply iterator to clone of structure instead.
		local
			i, j, nb: INTEGER
			l_area: like area
		do
			from
				i := 0
				j := lower
				nb := count - 1
				l_area := area
			until
				i > nb
			loop
				if test.item ([l_area.item (i), j]) then
					action.call ([l_area.item (i), j])
				end
				j := j + 1
				i := i + 1
			end
		end

feature -- Removal

	wipe_out
			-- Make array empty.
		obsolete
			"Not applicable since not `prunable'. Use `discard_items' instead."
		do
			discard_items
		end

	discard_items
			-- Reset all items to default values with reallocation.
		require
			has_default: ({G}).has_default
		do
			create area.make_filled (({G}).default, capacity)
		ensure
			default_items: all_default
		end

	clear_all
			-- Reset all items to default values.
		require
			has_default: ({G}).has_default
		do
			area.fill_with (({G}).default, 0, area.count - 1)
		ensure
			stable_lower: lower = old lower
			stable_upper: upper = old upper
			default_items: all_default
		end

feature -- Resizing

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		do
			if i > capacity then
				conservative_resize (lower, upper + i - capacity)
			end
		end

	conservative_resize (min_index, max_index: INTEGER)
			-- Rearrange array so that it can accommodate
			-- indices down to `min_index' and up to `max_index'.
			-- Do not lose any previously entered item.
		require
			good_indices: min_index <= max_index
			has_default: ({G}).has_default
		do
			conservative_resize_with_default (({G}).default, min_index, max_index)
		ensure
			no_low_lost: lower = min_index or else lower = old lower
			no_high_lost: upper = max_index or else upper = old upper
		end

	conservative_resize_with_default (a_default_value: G; min_index, max_index: INTEGER)
			-- Rearrange array so that it can accommodate
			-- indices down to `min_index' and up to `max_index'.
			-- Do not lose any previously entered item.
		require
			good_indices: min_index <= max_index
		local
			new_size: INTEGER
			new_lower, new_upper: INTEGER
			offset: INTEGER
		do
			if empty_area then
				set_area (area.aliased_resized_area_with_default (a_default_value, max_index - min_index + 1))
				lower := min_index
				upper := max_index
			else
				new_lower := min_index.min (lower)
				new_upper := max_index.max (upper)
				new_size := new_upper - new_lower + 1
				if new_size > area.count then
					set_area (area.aliased_resized_area_with_default (a_default_value, new_size))
				end
				if new_lower < lower then
					offset := lower - new_lower
					area.move_data (0, offset, upper - lower + 1)
					area.fill_with (a_default_value, 0, offset - 1)
				end
				lower := new_lower
				upper := new_upper
			end
		ensure
			no_low_lost: lower = min_index or else lower = old lower
			no_high_lost: upper = max_index or else upper = old upper
		end

	resize (min_index, max_index: INTEGER)
			-- Rearrange array so that it can accommodate
			-- indices down to `min_index' and up to `max_index'.
			-- Do not lose any previously entered item.
		obsolete
			"Use `conservative_resize' instead as future versions will implement `resize' as specified in ELKS."
		require
			good_indices: min_index <= max_index
			has_default: ({G}).has_default
		do
			conservative_resize_with_default (({G}).default, min_index, max_index)
		ensure
			no_low_lost: lower = min_index or else lower = old lower
			no_high_lost: upper = max_index or else upper = old upper
		end

feature -- Conversion

	to_c: ANY
			-- Address of actual sequence of values,
			-- for passing to external (non-Eiffel) routines.
		require
			not_is_dotnet: not {PLATFORM}.is_dotnet
		do
			Result := area
		end

	to_cil: NATIVE_ARRAY [G]
			-- Address of actual sequence of values,
			-- for passing to external (non-Eiffel) routines.
		require
			is_dotnet: {PLATFORM}.is_dotnet
		do
			Result := area.native_array
		ensure
			to_cil_not_void: Result /= Void
		end

	to_special: SPECIAL [G]
			-- 'area'.
		do
			Result := area
		ensure
			to_special_not_void: Result /= Void
		end

	linear_representation: LINEAR [G]
			-- Representation as a linear structure
		local
			temp: ARRAYED_LIST [G]
			i: INTEGER
		do
			create temp.make (capacity)
			from
				i := lower
			until
				i > upper
			loop
				temp.extend (item (i))
				i := i + 1
			end
			Result := temp
		end

feature -- Duplication

	copy (other: like Current)
			-- Reinitialize by copying all the items of `other'.
			-- (This is also used by `clone'.)
		do
			if other /= Current then
				standard_copy (other)
				set_area (other.area.twin)
			end
		ensure then
			equal_areas: area ~ other.area
		end

	subarray (start_pos, end_pos: INTEGER): ARRAY [G]
			-- Array made of items of current array within
			-- bounds `start_pos' and `end_pos'.
		require
			valid_start_pos: valid_index (start_pos)
			valid_end_pos: end_pos <= upper
			valid_bounds: (start_pos <= end_pos) or (start_pos = end_pos + 1)
		do
			create Result.make (start_pos, end_pos)
			if start_pos <= end_pos then
					-- Only copy elements if needed.
				Result.subcopy (Current, start_pos, end_pos, start_pos)
			end
		ensure
			lower: Result.lower = start_pos
			upper: Result.upper = end_pos
			-- copied: forall `i' in `start_pos' .. `end_pos',
			--     Result.item (i) = item (i)
		end

feature {NONE} -- Inapplicable

	prune (v: G)
			-- Remove first occurrence of `v' if any.
			-- (Precondition is False.)
		do
		end

	extend (v: G)
			-- Add `v' to structure.
			-- (Precondition is False.)
		do
		end

feature {NONE} -- Implementation

	empty_area: BOOLEAN
			-- Is `area' empty?
		do
			Result := area = Void or else area.count = 0
		end

invariant

	area_exists: area /= Void
	consistent_size: capacity = upper - lower + 1
	non_negative_count: count >= 0
	index_set_has_same_count: valid_index_set
-- Internal discussion haven't reached an agreement on this invariant
--	index_set_has_same_bounds: ((index_set.lower = lower) and
--				(index_set.upper = lower + count - 1))

end
