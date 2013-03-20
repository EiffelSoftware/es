note
	description: "Concrete of an external iteration cursor for {TWO_WAY_LIST}."
	library: "EiffelBase: Library of reusable components for Eiffel."
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
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
		do
				-- Required because `start' sets `active' and `active' can become detached
				-- when falling off the end of the list.
			check
				active_attached: attached active as a
			then
				Result := a.item
			end
		end

feature -- Status report

	after: BOOLEAN
			-- <Precursor>
		do
			Result := not is_valid or active = Void
		end

feature -- Cursor movement

	start
			-- <Precursor>
		local
			l_list: like target
		do
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

feature {ITERABLE, ITERATION_CURSOR} -- Access

	target: TWO_WAY_LIST [G]
			-- <Precursor>

feature {NONE} -- Access

	active: detachable BI_LINKABLE [G]
			-- Currrently active linkable node for ascending traversal

end
