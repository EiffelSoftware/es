indexing

	description:
		"Linkable cells containing a reference to their right neighbor"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: linkable, cell;
	representation: linked;
	contents: generic;
	model_links: item, right;
	date: "$Date$"
	revision: "$Revision$"

class LINKABLE [G] inherit

	CELL [G]
		export
			{CELL, CHAIN}
				put
			{ANY}
				item
		end

create {CHAIN}
	put

feature -- Access

	right: ?like Current
			-- Right neighbor

feature {CELL, CHAIN} -- Implementation

	put_right (other: ?like Current) is
			-- Put `other' to the right of current cell.
		do
			right := other
		ensure
			chained: right = other
		-- ensure: model
			right_effect: right = other
		end

	forget_right is
			-- Remove right link.
		do
			right := Void
		ensure
			not_chained: right = Void
		-- ensure: model
			right_effect: right = Void
		end

feature -- Model
	distance (other: LINKABLE [G]): INTEGER
			-- Distance between `Current' and `other'
			-- (-1 if `other' is not reachable from `Current')
			-- ToDo: process cycles?
		local
			temp: like Current
		do
			from
				temp := Current
			until
				temp = Void or temp = other
			loop
				if temp.right = Void and other /= Void then
					Result := -1
				else
					Result := Result + 1
				end
				temp := temp.right
			end
		ensure
			definition_base: Current = other implies Result = 0
			definition_step_non_void: Current /= other and (right /= Void or other = Void) implies Result = right.distance (other) + 1
			definition_step_void: Current /= other and right = Void and other /= Void implies Result = -1
		end

	i_th_cell (i: INTEGER): LINKABLE [G]
			-- Cell that is in `i' cells from `Current'
			-- Void if no such cell
		require
			i_non_negative: i >= 0
		local
			j: INTEGER
		do
			from
				Result := Current
				j := 0
			until
				j = i or Result = Void
			loop
				Result := Result.right
				j := j + 1
			end
		ensure
			definition_base: i = 0 implies Result = Current
			definition_step_non_void: i > 0 and right /= Void implies Result = right.i_th_cell (i - 1)
			definition_step_void: i > 0 and right = Void implies Result = Void
		end

indexing
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

end -- class LINKABLE
