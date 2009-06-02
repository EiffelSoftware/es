note
	description: "Summary description for {AUT_BASIC_WITNESS_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_BASIC_WITNESS_OBSERVER

inherit
	AUT_WITNESS_OBSERVER

create
	make

feature{NONE} -- Initialization

	make (a_system: like system) is
			-- Initialize `system' with `a_system'.
		do
			create witnesses.make (100)
			witnesses.set_key_equality_tester (create {AUT_FEATURE_OF_TYPE_EQUALITY_TESTER}.make)
		end


feature -- Access

	witnesses: DS_HASH_TABLE [like type_anchor, AUT_FEATURE_OF_TYPE]
			-- Table of testing statistics for features
			-- key is the feature under test, value is a tuple
			-- `pass' is the number of times when the feature under test
			-- passed a test case. Similar meanings for `fail', `invalid' and `bad'

feature -- handler

	process_witness (a_witness: AUT_WITNESS) is
			-- Handle `a_witness'.
		local
			l_data: like type_anchor
			l_feature: AUT_FEATURE_OF_TYPE
			l_request: AUT_REQUEST
		do
			l_feature := feature_under_test (a_witness)
			if witnesses.has (l_feature) then
				l_data := witnesses.item (l_feature)
			else
				l_data := [0, 0, 0, 0, 0, 0, 0, 0, -1]
			end
			l_request := a_witness.item (a_witness.count)
			if a_witness.is_pass then
				l_data.put_integer (l_data.pass + 1, 1)
				l_data.put_integer (l_data.pass_time + l_request.duration, 5)
			elseif a_witness.is_fail then
				l_data.put_integer (l_data.fail + 1, 2)
				l_data.put_integer (l_data.fail_time + l_request.duration, 6)
			elseif a_witness.is_invalid then
				l_data.put_integer (l_data.invalid + 1, 3)
				l_data.put_integer (l_data.invalid_time + l_request.duration, 7)
			elseif a_witness.is_bad_response then
				l_data.put_integer (l_data.bad + 1, 4)
				l_data.put_integer (l_data.bad_time + l_request.duration, 8)
			end

				-- Store time to first valid test case.
			if (a_witness.is_pass or a_witness.is_fail or a_witness.is_bad_response) and then l_data.time_of_first_valid_test_case = -1 then
				l_data.put_integer (l_request.start_time, 9)
			end

			witnesses.force_last (l_data, l_feature)
		end

feature{NONE} -- Implementation

	type_anchor: TUPLE [pass: INTEGER; fail: INTEGER; invalid: INTEGER; bad: INTEGER; pass_time: INTEGER; fail_time: INTEGER; invalid_time: INTEGER; bad_time: INTEGER; time_of_first_valid_test_case: INTEGER]
			-- Type anchor

	system: SYSTEM_I;
			-- System under which the tests are performed

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
