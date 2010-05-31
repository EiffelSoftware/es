note
	description: "Summary description for {AUT_RANDOM_UNARY_PREDICATE_VALUATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_RANDOM_UNARY_PREDICATE_VALUATION_CURSOR

inherit
	AUT_PREDICATE_VALUATION_CURSOR
		redefine
			container
		end

	AUT_SHARED_RANDOM

create
	make

feature -- Status report

	after: BOOLEAN
			-- Is there no valid position to right of cursor?

feature -- Access

	container: AUT_UNARY_PREDICATE_VALUATION
			-- Predicate valuation associated with current cursor

feature -- Cursor movement

	start is
			-- Move cursor to first position.
		local
			l_index: INTEGER
		do
			before := False
			if free_variables.is_empty then
				after := not container.item (<<variable_in_candidate (bound_variables.item (1))>>)
			else
				create cursor.make (container.array_represention, random)
				cursor.start
				after := cursor.after
			end
		end

	forth is
			-- Move cursor to next position.
		do
			if free_variables.is_empty then
				after := True
			else
				check not free_variables.is_empty end
				check cursor /= Void end
				cursor.forth
				after := cursor.after
			end
		end

feature -- Basic operations

	update_candidate_with_item is
			-- Update `candidate' with objects at the position of current cursor.
		do
			if not free_variables.is_empty then
				candidate.put (variable_from_index (cursor.item), free_variables.item (1))
			end
		end

feature{NONE} -- Implementation

	cursor: AUT_RANDOM_CURSOR [INTEGER]
			-- Random cursor

invariant
	free_variables_valid: free_variables.count = 0 or free_variables.count = 1

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
