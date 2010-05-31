note
	description: "Summary description for {EPA_STATE_TRANSITION_MODEL_STATE_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STATE_TRANSITION_MODEL_STATE_EQUALITY_TESTER

inherit
    KL_EQUALITY_TESTER [EPA_STATE_TRANSITION_MODEL_STATE]
    	redefine
    		test
    	select
    		test
    	end

    EPA_STATE_EQUALITY_TESTER
    	rename
    		test as test_epa_state
    	end

create
    default_create

feature -- Equality

	test (u, v: EPA_STATE_TRANSITION_MODEL_STATE): BOOLEAN
			-- <Precurosr>
		do
			Result := test_epa_state (u, v)
--		    if u = v then
--		        Result := True
--		    elseif u = Void or else v = Void then
--		    	Result := False
--		    elseif u.class_.class_id = v.class_.class_id then
--		        if u.hash_code = v.hash_code and then u.count = v.count then
--    		        Result := True
--    		        from
--    		            u.start
--    		            v.start
--    		        until
--    		            u.after or not Result
--    		        loop
--    		            Result := equation_equality_tester.test (u.item_for_iteration, v.item_for_iteration)
--    		            u.forth
--    		            v.forth
--    		        end
--				end
--		    end
		end

--feature{NONE} -- implementation

--	equation_equality_tester: EPA_EQUATION_EQUALITY_TESTER
--			-- equality tester for predicates
--		once
--		    create Result
--		end

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
