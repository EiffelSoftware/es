note
	description: "Summary description for {AFX_EVALUATION_ID_CODEC}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_EVALUATION_ID_CODEC

feature -- Access

	test_count: NATURAL_32 assign set_test_count
			-- total number of tests

	fix_count: NATURAL_32 assign set_fix_count
			-- total number of fixes

	last_test_id: NATURAL_32
			-- last decoded test index

	last_fix_id: NATURAL_32
			-- last decoded fix index

	last_evaluation_id: NATURAL_32
			-- last encoded evaluation id

feature -- Status report

	is_valid: BOOLEAN
			-- is the codec a valid one?
		do
		    Result := test_count > 0 and fix_count > 0
		end

feature{AFX_FIX_PROPOSER_I} -- Set

	set_test_count (a_test_count: NATURAL_32)
		require
		    test_count_greater_than_zero: a_test_count > 0
		do
		    test_count := a_test_count
		end

	set_fix_count (a_fix_count: NATURAL_32)
		require
		    fix_count_greater_than_zero: a_fix_count > 0
		do
		    fix_count := a_fix_count
		end

feature -- Operation

	decode_evaluation_id (a_evaluation_id: NATURAL_32)
			-- get test case index and fix index from `a_evaluation_id'
		require
		    codec_is_valid: is_valid
		    test_id_in_range: a_evaluation_id > 0 and a_evaluation_id <= test_count * fix_count
		do
		    if a_evaluation_id \\ test_count = 0 then
		        last_test_id := test_count
		        last_fix_id := a_evaluation_id // test_count
		    else
		        last_test_id := a_evaluation_id \\ test_count
		        last_fix_id := a_evaluation_id // test_count + 1
		    end
		end

	encode_evaluation_id (a_test_id, a_fix_id: NATURAL_32)
		require
		    codec_is_valid: is_valid
		    index_in_range: 0 < a_test_id and a_test_id <= test_count
		    			and 0 < a_fix_id and a_fix_id <= fix_count
		do
		    last_evaluation_id := (a_fix_id - 1) * test_count + a_test_id
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
