note
	description: "Summary description for {AUT_PRECONDITION_FAILURE_OBESERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PRECONDITION_FAILURE_OBESERVER
	inherit
	AUT_WITNESS_OBSERVER


create
	make

feature{NONE} -- Initialization

	make (a_system: like system) is
			-- Initialize `system' with `a_system'.
		do
			system := a_system
			create precondition_table.make(200)

		end


	system: SYSTEM_I;
			-- Current system



feature
	precondition_table: DS_HASH_TABLE [REAL,STRING]

	process_witness (a_witness: AUT_ABS_WITNESS) is
		-- Handle `a_witness'.
		local
			l_request: AUT_REQUEST
			l_response: AUT_NORMAL_RESPONSE
			l_feature: AUT_FEATURE_OF_TYPE
			tmp :REAL
			preconditions_passed: REAL
			strs : LIST[READABLE_STRING_8]
			str :STRING
		do


			l_request := a_witness.request
			l_response ?= l_request.response
			preconditions_passed := 0

			if  a_witness.is_invalid then

				l_feature := feature_under_test (a_witness)
				if l_response.is_precondition_violation	then

					strs := l_response.exception.trace.split('@')
					str := (strs.i_th (2).split (' ')).i_th (1)
					preconditions_passed := str.to_real

				--	io.put_string ("Feature name = "+ l_feature.feature_name + " %N")
				--	io.put_string ("Preconditions passed = " + preconditions_passed.out + " %N")
					--io.put_string ("TRACE "+l_response.exception.trace +" %N")
					--io.put_string ("PART 1: " + strs.i_th (1) +" %N")
					--io.put_string ("PART 2: " +  +" %N")

					if precondition_table.has (l_feature.feature_name) then
					    tmp := precondition_table.item (l_feature.feature_name)
					    tmp := (tmp + preconditions_passed) / 2
						precondition_table.put (tmp,l_feature.feature_name)
					else
						precondition_table.put (preconditions_passed,l_feature.feature_name)
					end


				else
				--	io.put_string ("There is something wrong %N")

				end

			end



		end

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
