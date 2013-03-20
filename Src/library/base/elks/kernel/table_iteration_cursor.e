note
	description: "[
		External iteration cursor used by `across...loop...end' 
		using `key' and `item'.
		]"
	library: "EiffelBase: Library of reusable components for Eiffel."
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TABLE_ITERATION_CURSOR [G, K]

inherit
	ITERATION_CURSOR [G]

feature -- Access

	key: K
			-- Key at current cursor position
		require
			valid_position: not after
		deferred
		end

end
