note
	description: "Summary description for {AFX_STATE_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_STATE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_STATE]
		redefine
			test
		end

create
    default_create

feature -- status report

	test (u, v: AFX_STATE): BOOLEAN
			-- test if `u' and `v' are considered to be equal
		do
		    if u = v then
		        Result := True
		    elseif u = Void then
		    	Result := False
		    elseif v = Void then
		    	Result := False
		    elseif u.class_.class_id = v.class_.class_id then
		        if u.is_chaos and then v.is_chaos then
		            Result := True
		        elseif (not u.is_chaos and not v.is_chaos) and then u.hash_code = v.hash_code and then u.count = v.count then
    		        Result := True
    		        from
    		            u.start
    		            v.start
    		        until
    		            u.after or not Result
    		        loop
    		            Result := predicate_equality_tester.test (u.item_for_iteration, v.item_for_iteration)
    		            u.forth
    		            v.forth
    		        end
				end
		    end
		end

feature{NONE} -- implementation

	predicate_equality_tester: AFX_PREDICATE_EQUALITY_TESTER
			-- equality tester for predicates
		once
		    create Result
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
