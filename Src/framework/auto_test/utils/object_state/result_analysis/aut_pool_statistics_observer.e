note
	description: "Summary description for {AUT_POOL_STATISTICS_OBSERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_POOL_STATISTICS_OBSERVER

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
			create object_pool.make (1000)
			create predicate_pool.make (1000)
		ensure
			system_set: system = a_system
		end

feature -- Access

	object_pool: DS_ARRAYED_LIST [like object_pool_anchor_type]
			-- Data for object pool

	object_pool_anchor_type: TUPLE [type_name: STRING; time: INTEGER; size: INTEGER]
			-- Type anchor for data for object pool

	predicate_pool: DS_ARRAYED_LIST [like predicate_pool_anchor_type]
			-- Data for predicate pool

	predicate_pool_anchor_type: TUPLE [predicate_name: STRING; time: INTEGER; size: INTEGER]
			-- Type anchor for data for predicate pool

	last_time: INTEGER
			-- Last time in millisecond when the pool statistics was logged.

	sorted_object_pool_data (a_tester: like type_time_tester): like object_pool is
			-- Sorted data from `object_pool' using `a_test'
		local
			l_sorter: DS_QUICK_SORTER [like object_pool_anchor_type]
		do
			create l_sorter.make (a_tester)
			Result := object_pool.twin
			l_sorter.sort (Result)
		end

	sorted_predicate_pool_data (a_tester: like type_time_tester): like predicate_pool is
			-- Sorted data from `predicate_pool' using `a_test'
		local
			l_sorter: DS_QUICK_SORTER [like predicate_pool_anchor_type]
		do
			create l_sorter.make (a_tester)
			Result := predicate_pool.twin
			l_sorter.sort (Result)
		end

	type_time_tester: AGENT_BASED_EQUALITY_TESTER [like object_pool_anchor_type] is
			-- Tester to decide the order for `object_pool_anchor_type'
			-- First type name, and then access time.
		do
			create Result.make (agent (a, b: like object_pool_anchor_type): BOOLEAN
				do
					if a.type_name.is_equal (b.type_name) then
						Result := a.time <= b.time
					else
						Result := a.type_name < b.type_name
					end
				end)
		end

	time_type_tester: AGENT_BASED_EQUALITY_TESTER [like object_pool_anchor_type] is
			-- Tester to decide the order for `object_pool_anchor_type'
			-- First access time and then type name.
		do
			create Result.make (agent (a, b: like object_pool_anchor_type): BOOLEAN
				do
					if a.time = b.time then
						Result := a.type_name < b.type_name
					else
						Result := a.time <= b.time
					end
				end)
		end

	predicate_time_tester: AGENT_BASED_EQUALITY_TESTER [like predicate_pool_anchor_type] is
			-- Tester to decide the order for `predicate_pool_anchor_type'
			-- First predicate name and then access time.
		do
			create Result.make (agent (a, b: like predicate_pool_anchor_type): BOOLEAN
				do
					if a.predicate_name.is_equal (b.predicate_name) then
						Result := a.time <= b.time
					else
						Result := a.predicate_name <= b.predicate_name
					end
				end)
		end

	time_predicate_tester: AGENT_BASED_EQUALITY_TESTER [like predicate_pool_anchor_type] is
			-- Tester to decide the order for `predicate_pool_anchor_type'
			-- First access time and then predicate name.
		do
			create Result.make (agent (a, b: like predicate_pool_anchor_type): BOOLEAN
				do
					if a.time = b.time then
						Result := a.predicate_name < b.predicate_name
					else
						Result := a.time <= b.time
					end
				end)
		end


feature -- Process

	process_comment_line (a_line: STRING) is
			-- Process `a_line'.
		local
			l_header: STRING
			l_count: INTEGER
			l_parts: LIST [STRING]
			l_str: STRING
			i: INTEGER
			l_part_str: STRING
			l_type_name: STRING
			l_size: INTEGER
			l_predicate_name: STRING
		do
			l_header := pool_statistics_header
			l_count := l_header.count
			if a_line.substring (1, l_count).is_equal (l_header) then
					-- We are in the starting line of a pool statistics logging section.
				l_parts := a_line.split (':')
				l_parts.i_th (2).left_adjust
				last_time := l_parts.i_th (2).to_integer
			else
				l_header := object_pool_header
				l_count := l_header.count
				if a_line.substring (1, l_count).is_equal (l_header) then
						-- We are in a object pool logging line.
					l_str := a_line.twin
					l_str.replace_substring_all ("%T", " ")
					l_parts := l_str.split (':')
					l_parts.i_th (2).left_adjust
					l_parts.i_th (2).right_adjust
					l_type_name := l_parts.i_th (2)

					l_parts.i_th (3).left_adjust
					l_parts.i_th (3).right_justify
					l_size := l_parts.i_th (3).to_integer
					object_pool.force_last ([l_type_name, last_time, l_size])
				else
					l_header := predicate_pool_header
					l_count := l_header.count
					if a_line.substring (1, l_count).is_equal (l_header) then
							-- We are in a predicate pool logging line.
						l_str := a_line.twin
						l_str.replace_substring_all ("%T", " ")
						l_parts := l_str.split (':')
						l_parts.i_th (2).left_adjust
						l_parts.i_th (2).right_adjust
						l_predicate_name := l_parts.i_th (2)

						l_parts.i_th (3).left_adjust
						l_parts.i_th (3).right_justify
						l_size := l_parts.i_th (3).to_integer
						predicate_pool.force_last ([l_predicate_name, last_time, l_size])
					end
				end
			end
		end

	process_witness (a_witness: AUT_ABS_WITNESS) is
			-- Handle `a_witness'.
		do
		end

feature{NONE} -- Implementation

	precondition_eval_header: STRING is "-- Precondition_evaluation: "
			-- Header of precondition evaluation comment

	pool_statistics_header: STRING is "-- Pool statistics: "
			-- Header of pool statistics logging

	object_pool_header: STRING is "-- object_pool: "
			-- Header for object pool logging

	predicate_pool_header: STRING is "-- predicate_pool: "
			-- Header for predicate pool logging

	system: SYSTEM_I;
			-- System under which the tests are performed



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
