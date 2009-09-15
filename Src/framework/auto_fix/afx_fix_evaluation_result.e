note
	description: "Summary description for {AFX_FIX_EVALUATION_RESULT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIX_EVALUATION_RESULT

inherit
	ARRAY2[detachable EQA_TEST_RESULT]
		rename
		    height as fix_count,
		    width as test_count
		end

	SHARED_AFX_EVALUATION_ID_CODEC
		undefine
		    is_equal,
		    copy
		end

create
    make

feature -- Access

	last_good_fix_collection:DS_LINEAR [AFX_FIX_INFO_I]
			-- collection of good fixes during last collcting
		do
		    if internal_good_fix_collection = Void then
		        create internal_good_fix_collection.make_default
		    end

		    Result := internal_good_fix_collection
		end

feature -- Status report

	is_fix_good_for_tests (a_fix: AFX_FIX_INFO_I; a_tests: DS_LINEAR [AFX_TEST]): BOOLEAN
			-- did `a_fix' passed all tests in `a_tests'?
		local
		    l_test_id: INTEGER
		    l_fix_id: INTEGER
		    l_result: detachable EQA_TEST_RESULT
		do
		    Result := True
		    l_fix_id := a_fix.fix_id

		    from a_tests.start
		    until a_tests.after or not Result
		    loop
		        l_test_id := a_tests.item_for_iteration.test_id

		        l_result := item (l_fix_id, l_test_id)
		        if l_result = Void or else not l_result.is_pass then
		            Result := False
		        end

		        a_tests.forth
		    end
		end

	collect_fixes_good_for_tests (a_fixes: DS_LINEAR [AFX_FIX_INFO_I]; a_tests: DS_LINEAR [AFX_TEST])
			-- select from `a_fixes' the fixes that passed all tests in `a_tests'
		local
		    l_list: DS_ARRAYED_LIST[AFX_FIX_INFO_I]
		    l_fix: AFX_FIX_INFO_I
		    l_fix_id: INTEGER
		    l_test_id: INTEGER
		    l_is_good: BOOLEAN
		    l_result: detachable EQA_TEST_RESULT

--		    l_test: AFX_TEST
--		    l_test_index, l_fix_index: NATURAL_32
		do
		    create l_list.make_default

		    from a_fixes.start
		    until a_fixes.after
		    loop
		        l_fix := a_fixes.item_for_iteration
		        l_fix_id := l_fix.fix_id

		        l_is_good := True

		        from a_tests.start
		        until a_tests.after or not l_is_good
		        loop
		            l_test_id := a_tests.item_for_iteration.test_id

    		        l_result := item(l_fix_id, l_test_id)
    		        if l_result = Void or else not l_result.is_pass then
    		            l_is_good := False
    		        end

    		        a_tests.forth
		        end

		        if l_is_good then
		            l_list.force_last (l_fix)
		        end

		        a_fixes.forth
		    end

		    internal_good_fix_collection := l_list
		end

feature{NONE} -- Implementation

	internal_good_fix_collection: detachable DS_ARRAYED_LIST [AFX_FIX_INFO_I]
			-- internal storage for fix collection

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
