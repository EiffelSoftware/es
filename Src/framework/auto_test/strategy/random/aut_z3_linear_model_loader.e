note
	description: "Summary description for {AUT_Z3_SOLVED_LINEAR_MODEL_LOADER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_Z3_LINEAR_MODEL_LOADER

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
			l_line: STRING
			l_args: HASH_TABLE [STRING, STRING]
			l_done: BOOLEAN
			l_arg_name: STRING
			l_index: INTEGER
			l_sections: LIST [STRING]
			l_values: HASH_TABLE [STRING, STRING]
			l_lcurly_index: INTEGER
			l_rcurly_index: INTEGER
			l_arrow_index: INTEGER
			l_vars: LIST [STRING]
			l_value_str: STRING
			l_value: INTEGER
		do
			create valuation.make (2)
			valuation.compare_objects

			input_stream.read_line
			l_line := input_stream.last_string

				-- if the first line is `partitions_line', there is a model for `constrained_operands'.
			has_model := l_line.is_equal (partitions_line)

			if has_model then
				create l_values.make (5)

				from

				until
					input_stream.end_of_input
				loop
					input_stream.read_line
					l_line := input_stream.last_string
					if not l_line.is_empty and then l_line.item (1) = '*' then
							-- `l_line' describes a partition.
						l_lcurly_index := l_line.index_of ('{', 1)
						l_rcurly_index := l_line.index_of ('}', l_lcurly_index + 1)
						l_arrow_index := l_line.substring_index (arrow_string, l_rcurly_index + 1)

						l_value_str := l_line.substring (l_arrow_index + arrow_string.count, l_line.count)
						l_value_str.left_adjust
						l_value_str.right_adjust
						l_value := l_value_str.split (':').first.to_integer

						l_vars := l_line.substring (l_lcurly_index + 1, l_rcurly_index - 1).split (' ')
						from
							l_vars.start
						until
							l_vars.after
						loop
							if not l_vars.item_for_iteration.is_empty and then constrained_operands.has (l_vars.item_for_iteration) then
								valuation.force (l_value, l_vars.item_for_iteration)
							end
							l_vars.forth
						end

					end
				end
			end
		end

feature{NONE} -- Implementation

	partitions_line: STRING is "partitions:"

	arrow_string: STRING is "->"



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
