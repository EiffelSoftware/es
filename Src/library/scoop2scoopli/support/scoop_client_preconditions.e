note
	description: "Representation of precondition of a client feature."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_PRECONDITIONS

inherit
	SCOOP_CLIENT_ASSERTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize
		do
			create wait_conditions.make
			create non_separate_preconditions.make
		end

feature -- Access postcondition lists

	wait_conditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
			-- Preconditions containing at least one separate call.

	non_separate_preconditions: LINKED_LIST[SCOOP_CLIENT_ASSERTION_OBJECT]
			-- Preconditions containing no separate call.

invariant
	wait_conditions_not_void: wait_conditions /= Void
	non_separate_preconditions_not_void: non_separate_preconditions /= Void

note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_CLIENT_PRECONDITIONS
