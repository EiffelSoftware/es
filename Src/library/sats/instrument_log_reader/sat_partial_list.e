indexing
	description: "Summary description for {SAT_PARTIAL_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_PARTIAL_LIST [G->?ANY]

inherit
	DS_INDEXABLE [G]
		rename
			make_default as make
		redefine
			count
		end

create
	make

feature {NONE} -- Initialization

	make is
			-- Create an empty container.
		do
			create storage.make (10)
			count := 0
		ensure then
			is_empty: is_empty
		end

feature -- Status report

	has (v: G): BOOLEAN is
			-- Does container include `v'?
			-- (Use `equality_tester''s comparison criterion
			-- if not void, use `=' criterion otherwise.)
		do
			if equality_tester /= Void then
				Result := there_exists (agent (a_tester: like equality_tester; a, b: G): BOOLEAN do Result := a_tester.test (a, b) end (equality_tester, v, ?))
			else
				Result := there_exists (agent (a, b: G): BOOLEAN do Result := (a = b) end (v, ?))
			end
		end

	is_equal (other: like Current): BOOLEAN is
			-- Is current container equal to `other'?
		do
			check to_implement: False end
		end

	extendible (n: INTEGER): BOOLEAN is
			-- May container be extended with `n' items?
		do
			Result := True
		end

feature -- Measurement

	count: INTEGER
			-- Number of items in container

	occurrences (v: G): INTEGER is
			-- Number of times `v' appears in container
			-- (Use `equality_tester''s comparison criterion
			-- if not void, use `=' criterion otherwise.)
		do
			check to_implement: False end
		end

feature -- Access

	infix "@", item (i: INTEGER): G is
			-- Item at index `i'
			-- If `i' is a valid key in `storage', return the element associated with that key,
			-- otherwise return the value returned by `default_item_agent'.
			-- If `default_item_agent' is Void, return Void.
		do
			if storage.has (i) then
				Result ?= storage.item (i)
			elseif default_item_agent /= Void then
				Result := default_item_agent.item (Void)
			end
		end

	first: G is
			-- First item in container
		do
			Result := item (1)
		end

	last: G is
			-- Last item in container
		do
			Result := item (count)
		end

	default_item_agent: FUNCTION [ANY, TUPLE, G]
			-- Agent to return an element used for `item' for undefined indexes

feature -- Setting

	set_default_item_agent (a_agent: like default_item_agent) is
			-- Set `default_item_agent' with `a_agent'.
		do
			default_item_agent := a_agent
		ensure
			default_item_agent_set: default_item_agent = a_agent
		end

feature -- Clone

	copy (other: like Current) is
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
		do
			check to_implement: False end
		end

feature -- Element change

	put_first (v: G) is
			-- Add `v' to beginning of container.
		do
			check to_implement: False end
		end

	put_last (v: G) is
			-- Add `v' to end of container.
		do
			count := count + 1
			storage.force (v, count)
		end

	put (v: G; i: INTEGER) is
			-- Add `v' at `i'-th position.
		do
			storage.force (v, i)
			if i > count then
				count := i
			end
		end

	force_first (v: G) is
			-- Add `v' to beginning of container.
		do
			check to_implement: False end
		end

	force_last (v: G) is
			-- Add `v' to end of container.
		do
			put_last (v)
		end

	force (v: G; i: INTEGER) is
			-- Add `v' at `i'-th position.
		do
			put (v, i)
		end

	replace (v: G; i: INTEGER) is
			-- Replace item at `i'-th position by `v'.
		do
			put (v, i)
		end

	force_i_th (v: G; i: INTEGER) is
			-- Add `'v' at `i'-th position.
		require
			valid_index: 1 <= i
		do
			if i <= (count + 1) then
				force (v, i)
			else
				storage.put (v, i)
				count := i
			end
		end

feature -- Removal

	wipe_out is
			-- Remove all items from container.
		do
			storage.wipe_out
			count := 0
		end

	remove_first is
			-- Remove first item from container.
		do
			check to_implement: False end
		end

	remove_last is
			-- Remove last item from container.
		do
			check to_implement: False end
		end

	remove (i: INTEGER) is
			-- Remove item at `i'-th position.
		do
			check to_implement: False end
		end

	prune_first (n: INTEGER) is
			-- Remove `n' first items from container.
		do
			check to_implement: False end
		end

	prune_last (n: INTEGER) is
			-- Remove `n' last items from container.
		do
			check to_implement: False end
		end

	prune (n: INTEGER; i: INTEGER) is
			-- Remove `n' items at and after `i'-th position.
		do
			check to_implement: False end
		end

	keep_first (n: INTEGER) is
			-- Keep `n' first items in container.
		do
			check to_implement: False end
		end

	keep_last (n: INTEGER) is
			-- Keep `n' last items in container.
		do
			check to_implement: False end
		end

feature -- Element extension

	extend_first (other: DS_LINEAR [G]) is
			-- Add items of `other' to beginning of container.
			-- Keep items of `other' in the same order.
		do
			check to_implement: False end
		end

	extend_last (other: DS_LINEAR [G]) is
			-- Add items of `other' to end of container.
			-- Keep items of `other' in the same order.
		do
			check to_implement: False end
		end

	extend (other: DS_LINEAR [G]; i: INTEGER) is
			-- Add items of `other' at `i'-th position.
			-- Keep items of `other' in the same order.
		do
			check to_implement: False end
		end

	append_first (other: DS_LINEAR [G]) is
			-- Add items of `other' to beginning of container.
			-- Keep items of `other' in the same order.
		do
			check to_implement: False end
		end

	append_last (other: DS_LINEAR [G]) is
			-- Add items of `other' to end of container.
			-- Keep items of `other' in the same order.
		do
			check to_implement: False end
		end

	append (other: DS_LINEAR [G]; i: INTEGER) is
			-- Add items of `other' at `i'-th position.
			-- Keep items of `other' in the same order.
		do
			check to_implement: False end
		end

feature{NONE} -- Implementation

	storage: HASH_TABLE [G, INTEGER]
			-- Internal storage for elements in the list
			-- [Element, index]
			-- The key of this table is the index where the element is stored.

invariant
	storage_attached: storage /= Void

indexing
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			 Eiffel Software
			 5949 Hollister Ave., Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
end
