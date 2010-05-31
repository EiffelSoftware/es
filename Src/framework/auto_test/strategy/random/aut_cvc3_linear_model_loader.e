note
	description: "Summary description for {AUT_CVC3_SOLVED_LINEAR_MODEL_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_CVC3_LINEAR_MODEL_LOADER

inherit
	AUT_SAT_BASED_LINEAR_MODEL_LOADER

create
	make

feature -- Basic operations

	load_model is
			-- Load model from `input_stream'.
			-- If there is a model for `constrained_operands', set `has_model' to True,
			-- and then load valuations of constrained arguments into `valuation'.
		local
			l_line: detachable STRING
			l_assumption_str: STRING
			l_count: INTEGER
			l_parts: LIST [STRING]
			l_variable_name: STRING
			l_value: INTEGER
		do
			create valuation.make (2)
			valuation.compare_objects

			input_stream.read_line
			l_line := input_stream.last_string

			has_model := l_line /= Void and then l_line.is_equal (sat_string)
			if has_model then
				l_assumption_str := sat_assumption
				l_count := l_assumption_str.count
				from
					input_stream.read_line
				until
					input_stream.end_of_input
				loop
					l_line := input_stream.last_string.twin
					l_line.left_adjust
					if l_line.substring (1, l_count).is_equal (l_assumption_str) then
						l_line := l_line.substring (l_count + 1, l_line.count - 1)
						l_parts := l_line.split (' ')
						check l_parts.count = 2 end

						l_variable_name := l_parts.first
						l_value := l_parts.last.to_integer

						if constrained_operands.has (l_variable_name) then
							valuation.force (l_value, l_variable_name)
						end
					end
					input_stream.read_line
				end
			end
		end

feature{NONE} -- Implementation

	sat_string: STRING is "sat"

	sat_assumption: STRING is ":assumption (= "

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
