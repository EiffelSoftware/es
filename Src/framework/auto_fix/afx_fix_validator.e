note
	description: "Summary description for {AFX_FIX_VALIDATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_VALIDATOR

inherit
	AFX_TASK

	AFX_SHARED_SESSION

	SHARED_AFX_FIX_REPOSITORY

create
	make

feature -- Creation

	make
			-- initialization
		do

		end

feature -- execution

	start
			-- <Precursor>
		require else
		    fix_repository_healthy: repository.is_healthy
		do
				-- collect relevant classes
				-- backup relevant classes
				-- write root class
				-- compile project
				-- write void root class
				-- restore relevant class
		end

	step
			-- <Precursor>
		do
		    	--

		end

	stop
			-- <Precursor>
		do

		end

	cancel
			-- <Precursor>
		do
		    is_cancel_requested := True
		end

feature -- Status report

	is_finished: BOOLEAN
			-- is task finished?

	is_cancel_requested: BOOLEAN
			-- should task be cancelled?

	is_successful: BOOLEAN
			-- is the execution successful?

	is_executing: BOOLEAN
			-- is the task executing?


;note
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
