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

	AFX_SHARED_TEST_ID_CODEC
		undefine
		    is_equal,
		    copy
		end

create
    make

feature -- Status report

	get_test_index (n: NATURAL_32): NATURAL_32
			-- get the test index of the `n'-th element
		local
		    l_test_count: NATURAL_32
		do
		    if n \\ l_test_count = 0 then
		        Result := l_test_count
		    else
		        Result := n \\ l_test_count
		    end
		end

	get_fix_index (n:NATURAL_32): NATURAL_32
			-- get the fix index of the `n'-th element
		local
		    l_test_count: NATURAL_32
		do
		    l_test_count := test_count.to_natural_32

		    if n \\ l_test_count = 0 then
		        Result := n // l_test_count
		    else
		        Result := n // l_test_count + 1
		    end
		end

	is_fix_good_for_test (a_fix_index: NATURAL_32; a_min_test_id, a_max_test_id: NATURAL_32): BOOLEAN
			-- did fix at position `a_fix_index' passed all the tests with their id in the range [`a_min_test_id', `a_max_test_id']?
		require
		    valid_test_id: a_min_test_id > 0 and a_max_test_id <= test_count.to_natural_32
		    correct_order: a_min_test_id <= a_max_test_id
		local
		    l_test_index: NATURAL_32
		    l_result: detachable EQA_TEST_RESULT
		do
		    Result := True
		    from l_test_index := a_min_test_id
		    until l_test_index > a_max_test_id or not Result
		    loop
		        l_result := item(a_fix_index.to_integer_32, l_test_index.to_integer_32)
		        if l_result = Void or else not l_result.is_pass then
		            Result := False
		        end
		    end
		end

	collect_fixes_good_for_tests (a_fix_set: DS_LINEAR [AFX_FIX_INFO_I]; a_min_test_id, a_max_test_id: NATURAL_32): DS_LINEAR [AFX_FIX_INFO_I]
			-- select from `a_fix_set' the fixes that passed all tests in the range of [a_min_test_id, a_max_test_id],
			-- put the selected fixes in the result list
		require
		    fix_set_not_empty: not a_fix_set.is_empty
		    valid_test_id: a_min_test_id > 0 and a_max_test_id <= test_count.to_natural_32
		    correct_order: a_min_test_id <= a_max_test_id
		local
		    l_fix: AFX_FIX_INFO_I
		    l_test_index, l_fix_index: NATURAL_32
		    l_is_good: BOOLEAN
		    l_result: detachable EQA_TEST_RESULT
		    l_list: DS_ARRAYED_LIST[AFX_FIX_INFO_I]
		do
		    create l_list.make_default

		    from a_fix_set.start
		    until a_fix_set.after
		    loop
		        l_fix := a_fix_set.item_for_iteration
		        l_fix_index := l_fix.id.to_natural_32
		        l_is_good := True

		        from
		            l_test_index := a_min_test_id
		        until
		            l_test_index > a_max_test_id or not l_is_good
		        loop
    		        l_result := item(l_fix_index.to_integer_32, l_test_index.to_integer_32)
    		        if l_result = Void or else not l_result.is_pass then
    		            l_is_good := False
    		        end

    		        l_test_index := l_test_index + 1
		        end

		        if l_is_good then
		            l_list.force_last (l_fix)
		        end

		        a_fix_set.forth
		    end

		    Result := l_list
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
