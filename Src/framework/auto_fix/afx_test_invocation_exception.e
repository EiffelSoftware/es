note
	description: "TODO: recheck the inheritance relation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_TEST_INVOCATION_EXCEPTION

inherit

	EQA_TEST_INVOCATION_EXCEPTION
		rename
		    make as make_exception
		end

create
    make

feature

    make (an_exception: like exception)
    		-- initialization
    	do
    	    exception := an_exception
    	end

feature -- Access

	exception: EQA_TEST_INVOCATION_EXCEPTION
			-- the exception object

feature -- Status report

	is_analysable: BOOLEAN
			-- is exception ready for analysis?
		do
		    Result := exception.trace /= Void and then not exception.trace.is_empty
		end

feature -- Operation

	get_exception_position (a_fix_positions: DS_ARRAYED_LIST[detachable AFX_EXCEPTION_POSITION])
			-- analyze the exception trace and save the exception positions into the list `a_fix_positions'
		require
		    is_analysable: is_analysable
		    fix_positions_empty: a_fix_positions.is_empty
		local
	    	l_exception: like exception
			i: INTEGER	-- index inside the trace
			l_trace: READABLE_STRING_8	-- trace of the exception
			l_fix_position: AFX_EXCEPTION_POSITION
		do
		    l_exception := exception
			l_trace := l_exception.trace

				-- skip the header of the trace
			i := go_after_next_dash_line (l_trace, 1)
			i := go_after_next_dash_line (l_trace, i)

			from
			until i = 0
			loop
			    parse_frame (l_trace, i)
			    if attached last_class_name as l_cn then
			        create l_fix_position.make (last_class_name, last_routine_name, last_break_point_slot)
			        a_fix_positions.force_last (l_fix_position)

			        i:=go_after_next_dash_line(l_trace, i)
			    else
			        i:=0
			    end
			end
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
