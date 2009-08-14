note
	description: "Summary description for {AFX_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_TASK

feature -- execution

	start
			-- start task
		require
		    not_is_executing: not is_executing
		deferred
		ensure
		    is_executing: is_executing
		end

	step
			-- step further
		require
		    is_executing: is_executing
		deferred
		end

	stop
			-- stop task
		require
		    is_finished: is_finished
		deferred
		end

	cancel
			-- cancel executing task
		require
		    is_executing: is_executing
		deferred
		ensure
		    is_cancel_requested: is_cancel_requested
		end

feature -- Status report

	is_finished: BOOLEAN
			-- is task finished?
		deferred
		end

	is_cancel_requested: BOOLEAN
			-- should task be cancelled?
		deferred
		end

	is_successful: BOOLEAN
			-- is the execution successful?
		deferred
		end

	is_executing: BOOLEAN
			-- is the task executing?
		deferred
		end



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
