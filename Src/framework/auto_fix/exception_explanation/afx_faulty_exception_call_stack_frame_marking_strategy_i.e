note
	description: "Summary description for {AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_FAULTY_EXCEPTION_CALL_STACK_FRAME_MARKING_STRATEGY_I

feature -- Operation

	mark (an_exception: EQA_TEST_INVOCATION_EXCEPTION; a_frame_list: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I])
			-- mark relevant frames in the list, which indicated the range for fixing
		require
		    list_not_empty: not a_frame_list.is_empty
		deferred
		end

feature -- Access

	last_marking_result: DS_LINEAR [AFX_EXCEPTION_CALL_STACK_FRAME_I]
			-- the result of last marking process
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
