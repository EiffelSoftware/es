note
	description: "Summary description for {SCOOP_CLIENT_POSTCONDITIONS}."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_POSTCONDITIONS

inherit
	SCOOP_CLIENT_ASSERTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			create immediate_postconditions.make
			create non_separate_postconditions.make
			create separate_postconditions.make
		end

feature -- Access postcondition lists

	immediate_postconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- postconditions contain reference to 'old' or 'Result'

	non_separate_postconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- postcondition contains at least one non separate call
		-- and no reference to 'old' or 'Result'

	separate_postconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
		-- postcondition contain no non-separate calls
		-- and no reference to 'old' or 'Result'

invariant
	immediate_postconditions_not_void: immediate_postconditions /= Void
	non_separate_postconditions_not_void: non_separate_postconditions /= Void
	separate_postconditions_not_void: separate_postconditions /= Void

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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

end -- class SCOOP_CLIENT_POSTCONDITIONS
