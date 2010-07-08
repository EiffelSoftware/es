note
	description: "Concrete of an external iteration cursor for {HASH_TABLE}."
	library: "EiffelBase: Library of reusable components for Eiffel."
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class
	HASH_TABLE_ITERATION_CURSOR [G, K -> detachable HASHABLE]

inherit
	INDEXABLE_ITERATION_CURSOR [G]
		rename
			target_index as iteration_position
		redefine
			item,
			after,
			forth,
			target
		end

create
	make

feature -- Access

	item: G
			-- <Precursor>
		do
			Result := target.content [iteration_position]
		end

	key: K
			-- Key at current cursor position
		require
			is_valid: is_valid
			is_set: is_set
			valid_position: not after
		do
			Result := target.keys [iteration_position]
		end

feature -- Status report

	after: BOOLEAN
			-- <Precursor>
		local
			l_pos: like iteration_position
		do
			l_pos := iteration_position
			Result := l_pos < 0 or else l_pos >= target.keys.count
		end

feature -- Cursor movement

	forth
			-- <Precursor>
		local
			i, nb: like step
			l_pos: like iteration_position
		do
			cursor_index := cursor_index + 1
			l_pos := iteration_position
			nb := step
			if is_reversed then
				from
					i := 1
				until
					i > nb or else l_pos < 0
				loop
					l_pos := target.previous_iteration_position (l_pos)
					i := i + 1
				end
			else
				from
					i := 1
				until
					i > nb or else l_pos >= target.keys.count
				loop
					l_pos := target.next_iteration_position (l_pos)
					i := i + 1
				end
			end
			iteration_position := l_pos
		end

feature {NONE} -- Implementation

	target: HASH_TABLE [G, K]
			-- <Precursor>

end
