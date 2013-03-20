note
	description: "Concrete of an external iteration cursor for {TWO_WAY_LIST}."
	library: "EiffelBase: Library of reusable components for Eiffel."
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

class
	TWO_WAY_LIST_ITERATION_CURSOR [G]

inherit
	LINKED_LIST_ITERATION_CURSOR [G]
		redefine
			start,
			item,
			after,
			forth,
			target,
			active
		end

create
	make

feature -- Access

	item: G
			-- <Precursor>
		local
			l_active: like active
		do
			l_active := active
				-- Required because `start' sets `active' and `active' can become detached
				-- when falling off the end of the list.
			check l_active_attached: attached l_active end
			Result := l_active.item
		end

feature -- Status report

	after: BOOLEAN
			-- <Precursor>
		do
			Result := active = Void
		end

feature -- Cursor movement

	start
			-- <Precursor>
		local
			l_list: like target
		do
			cursor_index := 1
			is_set := True
			if is_reversed then
				target_index := index_set.upper
			else
				target_index := index_set.lower
			end
			l_list := target
			if is_reversed then
				active := l_list.last_element
			else
				active := l_list.first_element
			end
		end

	forth
			-- <Precursor>
		local
			i: like step
		do
			cursor_index := cursor_index + 1
			if is_reversed then
				target_index := target_index - step
				from
					i := 1
				until
					i > step or else not attached active as l_active
				loop
					active := l_active.left
					i := i + 1
				end
			else
				target_index := target_index + step
				from
					i := 1
				until
					i > step or else not attached active as l_active
				loop
					active := l_active.right
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	active: detachable BI_LINKABLE [G]
			-- Currrently active linkable node for ascending traversal

	target: TWO_WAY_LIST [G]
			-- <Precursor>

end
