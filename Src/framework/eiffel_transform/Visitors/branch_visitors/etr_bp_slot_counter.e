note
	description: "Calculates the number of breakpoints in a code fragment."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_BP_SLOT_COUNTER
inherit
	ETR_BP_SLOT_INITIALIZER
		redefine
			assign_current_slot
		end

feature -- Access

	break_point_count: like current_breakpoint_slot
			-- Number of breakpoints in the processed fragment
		do
			Result := current_breakpoint_slot-1
		end

feature {NONE} -- Implementation

	assign_current_slot (l_as: AST_EIFFEL)
			-- <precursor>
		do
			-- Don't actually assign it
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
