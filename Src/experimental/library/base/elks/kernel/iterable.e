note
	description: "[
		Augments data strcutures and then like with an external interation cursor, specification
		according to ECMA 3.5.1.1, for compatibility across...loop...end loop construct.
		]"
	library: "Free implementation of ELKS library"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ITERABLE [G]

feature -- Access

	new_cursor: ITERATION_CURSOR [G]
			-- Fresh cursor associated with current structure.
		deferred
		ensure
			result_attached: attached Result
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
