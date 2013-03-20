note
	description: "Unbounded queues, implemented by resizable arrays"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	names: dispenser, array;
	representation: array;
	access: fixed, fifo, membership;
	size: fixed;
	contents: generic;
	date: "$Date$"
	revision: "$Revision$"

class ARRAYED_QUEUE [G]

inherit
	QUEUE [G]
		redefine
			linear_representation, has, is_empty,
			is_equal, copy, prune_all
		end

	RESIZABLE [G]
		redefine
			is_equal, copy, is_empty
		end

create
	make

feature -- Initialization

	make (n: INTEGER)
			-- Create queue for at most `n' items.
		require
			non_negative_argument: n >= 0
		do
			create area.make_empty (n)
			in_index := 1
			out_index := 1
				-- One entry is kept free
		ensure
			capacity_expected: capacity = n
		end

feature -- Access

	item: G
			-- Oldest item.
		do
			Result := area.item (out_index - lower)
		end

	has (v: like item): BOOLEAN
			-- Does queue include `v'?
 			-- (Reference or object equality,
			-- based on `object_comparison'.)
		local
			i, j, nb: INTEGER
		do
			i := out_index - lower
			j := in_index - lower
			nb := area.capacity
			if object_comparison then
				from
				until
					i = j or v ~ area.item (i)
				loop
					i := i + 1
					if i = nb then
						i := 0
					end
				end
			else
				from
				until
					i = j or v = area.item (i)
				loop
					i := i + 1
					if i = nb then
						i := 0
					end
				end
			end
			Result := (i /= j)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		local
			i, j: INTEGER
			nb, other_nb: INTEGER
		do
			if count = other.count and object_comparison = other.object_comparison then
				i := out_index - lower
				j := other.out_index - lower
				nb := area.capacity
				other_nb := other.area.capacity
				Result := True
				if object_comparison then
					from
					until
						i = (in_index - lower) or not Result
					loop
						Result := area.item (i) ~ other.area.item (j)
						j := j + 1
						if j > other_nb then
							j := 0
						end
						i := i + 1
						if i = nb then
							i := 0
						end
					end
				else
					from
					until
						i = (in_index - lower) or not Result
					loop
						Result := area.item (i) = other.area.item (j)
						j := j + 1
						if j > other_nb then
							j := 0
						end
						i := i + 1
						if i = nb then
							i := 0
						end
					end
				end
			end
		end

feature -- Measurement

	count: INTEGER
			-- Number of items.
		local
			l_capacity: like capacity
		do
			l_capacity := capacity
			if l_capacity > 0 then
				Result := (in_index - out_index + l_capacity) \\ l_capacity
			end
		end

	capacity: INTEGER
		do
			Result := area.capacity
		end

	occurrences (v: G): INTEGER
		local
			i, j, nb: INTEGER
		do
			i := out_index - lower
			j := in_index - lower
			nb := area.capacity
			if object_comparison then
				from
				until
					i = j
				loop
					if area.item (i) ~ v then
						Result := Result + 1
					end
					i := i + 1
					if i = nb then
						i := 0
					end
				end
			else
				from
				until
					i = j
				loop
					if area.item (i) = v then
						Result := Result + 1
					end
					i := i + 1
					if i = nb then
						i := 0
					end
				end
			end
		end

	index_set: INTEGER_INTERVAL
			-- Range of acceptable indexes
		do
			create Result.make (1, count)
		ensure then
			count_definition: Result.count = count
		end

feature -- Status report

	is_empty, off: BOOLEAN
			-- Is the structure empty?
		do
			Result := (in_index = out_index)
		end

	extendible: BOOLEAN
			-- May items be added? (Answer: yes.)
		do
			Result := True
		end

	prunable: BOOLEAN
			-- May items be removed? (Answer: yes.)
		do
			Result := False
		end

feature -- Element change

	extend, put, force (v: G)
			-- Add `v' as newest item.
		local
			l_in_index: like in_index
			l_capacity: like capacity
		do
			l_capacity := capacity
			if count >= l_capacity - 1 then
				grow (l_capacity + additional_space)
				l_capacity := capacity
			end
			l_in_index := in_index
			area.force (v, l_in_index - lower)
			l_in_index := (l_in_index + 1) \\ l_capacity
			if l_in_index = 0 then
				l_in_index := l_capacity
			end
			in_index := l_in_index
		end

	replace (v: like item)
			-- Replace oldest item by `v'.
		do
			area.put (v, out_index - lower)
		end

feature -- Duplication

	copy (other: like Current)
		do
			if other /= Current then
				standard_copy (other)
				area := area.twin
			end
		end

feature -- Removal

	remove
			-- Remove oldest item.
		require else
			writable: writable
		local
			l_out_index: like out_index
			l_removed_index: like out_index
			l_capacity: like capacity
		do
			l_removed_index := out_index
			l_capacity := capacity
			l_out_index := (l_removed_index + 1) \\ l_capacity
			if l_out_index = 0 then
				l_out_index := l_capacity
			end
			out_index := l_out_index
			if in_index = l_out_index then
					-- No more elements in the queue, simply reset Current to its default state.
				wipe_out
			else
					-- We put the newest element of the queue in place of the
					-- just removed element.
				area.put (newest_item, l_removed_index - lower)
			end
		end

	prune (v: G)
			-- <Precursor>
		do

		end

	prune_all (v: G)
			-- <Precursor>
		do

		end

	wipe_out
			-- Remove all items.
		require else
			prunable: True
		do
			area.wipe_out
			out_index := 1
			in_index := 1
		end

feature -- Conversion

	linear_representation: ARRAYED_LIST [G]
			-- Representation as a linear structure
			-- (in the original insertion order)
		local
			i, j, nb: INTEGER
		do
			from
				i := out_index - lower
				j := in_index - lower
				nb := area.capacity
				create Result.make (count)
			until
				i = j
			loop
				Result.extend (area.item (i))
				i := i + 1
				if i = nb then
					i := 0
				end
			end
		end

feature {ARRAYED_QUEUE} -- Implementation

	area: SPECIAL [G]
			-- Storage for queue

	out_index: INTEGER
			-- Position of oldest item

	in_index: INTEGER
			-- Position for next insertion

	grow (n: INTEGER)
		local
			old_count, new_capacity: like capacity
			nb: INTEGER
		do
			new_capacity := area.capacity.max (n)
			if in_index >= out_index then
					-- Case were queue is not full and data is contiguous from
					-- oldest item to the newest one.
				area := area.aliased_resized_area (new_capacity)
			else
				old_count := area.count
					-- Fill the empty space with the most recent added item.
				area := area.aliased_resized_area_with_default (newest_item, new_capacity)
				nb := old_count - out_index + 1
				area.move_data (out_index - lower, new_capacity - nb, nb)
				out_index := new_capacity - nb + 1
			end
		end

feature {NONE} -- Implementation

	lower: INTEGER = 1
			-- Lower bound for accessing list items via indexes

	upper: INTEGER
			-- Upper bound for accessing list items via indexes
		do
			Result := area.count
		end

	newest_item: G
			-- Most recently added item.
		local
			l_pos: INTEGER
		do
			l_pos := in_index - 1
			if l_pos = 0 then
					-- Next element is at the beginning of the area, so previous
					-- one is at `area.upper'.
				Result :=  area.item (area.upper)
			else
				Result :=  area.item (l_pos - lower)
			end
		end

invariant
	not_full: not full
	extendible: extendible

note
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

end -- class ARRAYED_QUEUE
