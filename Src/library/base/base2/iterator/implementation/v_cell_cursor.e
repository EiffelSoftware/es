note
	description: "Cursors storing a position in a linked container."
	author: "Nadia Polikarpova"
	model: box

deferred class
	V_CELL_CURSOR [G]

feature -- Access

	item: G
			-- Item at current position.
		require
			not_off: not off
			closed: closed
			reads (ownership_domain)
		do
			check inv end
			Result := active.item
		ensure
			defintion: Result = box.any_item
		end

feature -- Status report

	off: BOOLEAN
			-- Is current position off scope?
		require
			closed
		do
			check inv end
			Result := active = Void
		ensure
			definition: Result = box.is_empty
		end

feature -- Replacement

	put (v: G)
			-- Replace item at current position with `v'.
		require
			not_off: not off
			modify_model ("box", Current)
		do
			active.put (v)
		ensure
			box_effect: box.any_item = v
		end

feature {V_CELL_CURSOR} -- Implementation

	active: V_CELL [G]
			-- Cell at current position.
		deferred
		end

feature -- Specification

	box: MML_SET [G]
			-- Element the cursor is pointing to.
		note
			status: ghost
		attribute
		end

invariant
	box_count_constraint: box.count <= 1
	owns = [active]
	box_defintion_empty: active = Void implies box.is_empty
	box_defintion_non_empty: active /= Void implies box = (create {MML_SET [G]}.singleton (active.item))

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
