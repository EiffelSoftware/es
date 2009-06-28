note
	description: "Summary description for {AUT_PREDICATION_EVALUATION_FAILURE_RATE_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATION_EVALUATION_FAILURE_RATE_OBSERVER

inherit
	AUT_WITNESS_OBSERVER
		redefine
			process_comment_line
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system) is
			-- Initialize `system' with `a_system'.
		do
			system := a_system
			create statistics.make
		ensure
			system_set: system = a_system
		end

feature -- Access

	statistics: DS_LINKED_LIST [like data_anchor_type]
			-- Precondition evaluation statistics

	data_anchor_type: TUPLE [time_in_second: INTEGER; full_suggested: INTEGER; full_failed: INTEGER; partial_suggested: INTEGER; partial_failed: INTEGER]
			-- Anchor type for data describing precondition evaluation overhead

feature -- Process

	process_comment_line (a_line: STRING) is
			-- Process `a_line'.
		local
			l_header: STRING
			l_count: INTEGER
			l_class_name: STRING
			l_feature_name: STRING
			l_parts: LIST [STRING]
			l_str: STRING
			l_data: like data_anchor_type
			i: INTEGER
			l_part_str: STRING
		do
			l_header := precondition_eval_header
			l_count := l_header.count

			if a_line.substring (1, l_count).is_equal (l_header) then
				l_str := a_line.substring (l_count + 1, a_line.count)
				l_str.right_justify
				l_parts := l_str.split (';')

				l_data := [0, 0, 0, 0, 0]
				from
					i := 1
				until
					i > 5
				loop
					l_part_str := l_parts.i_th (i).twin
					l_part_str.remove_head (l_part_str.index_of (':', 1))
					l_part_str.left_adjust
					l_part_str.right_adjust
					l_data.put_integer (l_part_str.to_integer, i)
					i := i + 1
				end
				statistics.force_last (l_data)
			end
		end

	process_witness (a_witness: AUT_WITNESS) is
			-- Handle `a_witness'.
		do
		end

feature{NONE} -- Implementation

	precondition_eval_header: STRING is
			-- Header of precondition evaluation comment
		do
			Result := {AUT_INTERPRETER_PROXY}.precondition_satisfaction_failure_rate_header
		end

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
