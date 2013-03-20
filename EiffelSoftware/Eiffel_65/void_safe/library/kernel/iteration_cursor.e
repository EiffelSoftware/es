note
	description: "[
		External interation cursor specification according to ECMA 3.5.1.2., for compatibility
		across...loop...end loop construct.
		]"
	library: "Free implementation of ELKS library"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ITERATION_CURSOR [G]

feature -- Access

	item: G
			-- Item at current cursor position.
		require
			valid_position: not after
		deferred
		end

	index: INTEGER
			-- Index position of cursor in the iteration.
		deferred
		ensure
			positive_index: Result > 0
		end

feature -- Status report

	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?
		deferred
		end

feature -- Cursor movement

	start
			-- Move to first position.
		deferred
		ensure
			index_set_to_one: index = 1
		end

	forth
			-- Move to next position.
		require
			not_after: not after
		deferred
		ensure
			index_advanced: index = old index + 1
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
