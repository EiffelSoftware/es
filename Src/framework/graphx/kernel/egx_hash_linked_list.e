indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision: 1 $"

class
	EGX_HASH_LINKED_LIST [N -> HASHABLE]

inherit
	EGX_EQUALITY_TESTER [N]
		redefine
			default_create,
			set_equality_tester
		end

	BILINEAR [N]
		undefine
			has, off
		redefine
			default_create
		end

create
	default_create

feature{NONE} -- Iniitalization

	default_create is
			-- Initialize.
		do
			create list.make
			create items.make (1000)
			index_count := 0
		end

feature -- Access

	count: INTEGER is
			-- Number of items in Current
		do
			Result := items.count
		ensure
			good_result: Result = items.count
		end

	item: N is
			-- Item at Current cursor position
		do
			Result := list.item.item
		ensure then
			good_result: Result = list.item.item
		end

feature -- Status report

	is_empty: BOOLEAN is
			-- Is Current empty?
		do
			Result := count = 0
		ensure then
			good_result: Result = (count = 0)
		end

	has (v: N): BOOLEAN is
			-- Is `v' in Current?
		do
			check v_attached: v /= Void end
			Result := items.has (v)
		ensure then
			good_result: Result = items.has (v)
		end

	index: INTEGER
			-- 1-based index of cursor

	before: BOOLEAN is
			-- Is there no valid position to the left of current one?
		do
			Result := list.before
		ensure then
			good_result: Result = list.before
		end

	after: BOOLEAN is
			-- Is there no valid position to the right of current one?
		do
			Result := list.after
		ensure then
			good_result: Result = list.after
		end

	off: BOOLEAN is
			-- Is there no current item?
		do
			Result := list.off
		ensure then
			good_result: Result = list.off
		end

feature -- Setting

	set_equality_tester (a_tester: like equality_tester) is
			-- Set `equality_tester' with `a_tester'.
		do
			Precursor (a_tester)
			items.set_key_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [N]}.make (equality_tester))
		end

feature -- Cursor movement

	start is
			-- Move cursor to the first position.
		do
			list.start
			forth_to_next
		end

	forth is
			-- Move cursor to the next position.
		do
			list.forth
			forth_to_next
		end

	back is
			-- Move cursor to the previous position.
		local
			l_list: like list
		do
			l_list := list
			from
				l_list.back
			until
				l_list.before or else l_list.item /= Void
			loop
				l_list.back
			end
		end

	finish is
			-- Move to last position.
		do
			list.finish
		end

feature -- Element change

	extend (v: N) is
			-- Extend `v' at the end of Current list.
		require
			v_attached: v /= Void
			v_not_extended: not has (v)
		local
			l_new_cell: like new_cell
			l_index_count: INTEGER
		do
			l_new_cell := new_cell (v)
			list.extend (l_new_cell)
			l_index_count := index_count + 1
			items.put (l_index_count, v)
			index_count := l_index_count
		end

	put_front (v: N) is
			-- Put `v' in front of the whole list.
		do
			check do_not_use: False end
		end

	remove is
			-- Remove item at current position.
		local
			l_item: like new_cell
		do
			l_item := list.item
			items.remove (l_item.item)
			list.replace (Void)
		end

	remove_by_item (v: N) is
			-- Remove `v' from Current list.
		require
			v_attached: v /= Void
			v_exists: has (v)
		local
			l_items: like items
			l_list: like list
			l_index: INTEGER
			l_cursor: CURSOR
		do
			l_items := items
			l_index := l_items.item (v)
			l_items.remove (v)

			l_list := list
			l_cursor := l_list.cursor
			l_list.go_i_th (l_index)
			l_list.replace (Void)
			l_list.go_to (l_cursor)
			if l_index = l_list.index then
				forth_to_next
			end
		end

	wipe_out is
			-- Wipe out the whole list.
		do
			list.wipe_out
			items.wipe_out
		ensure
			is_empty: is_empty
		end

feature{NONE} -- Implementation

	index_count: INTEGER
			-- Index count

	items: DS_HASH_TABLE [INTEGER, N]
			-- Table used to store items and its corresponding cell.

	list: LINKED_LIST [CELL [N]]
			-- List implementing basic traversal

	new_cell (v: N): CELL [N] is
			-- New cell to contain `v'.
		require
			v_attached: v /= Void
		do
			create Result.put (v)
		ensure
			result_attached: Result /= Void
		end

	forth_to_next is
			-- Forth to next non-Void item.
		local
			l_list: like list
		do
			from
				l_list := list
			until
				l_list.after or else l_list.item /= Void
			loop
				l_list.forth
			end
		end

end
