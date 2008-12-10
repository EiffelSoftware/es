indexing
	description: "Summary description for {SAT_RESULT_ANALYZER_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_RESULT_ANALYZER_UTILITY

feature -- Status report

	is_array_increasing (a_array: ARRAY [COMPARABLE]; a_strict: BOOLEAN): BOOLEAN is
			-- Is `a_array' increasing?
			-- If `a_strict' is True, check if `a_array' is strictly increasing.
		require
			a_array_attached: a_array /= Void
		local
			i: INTEGER
		do
			if a_array.count > 1 then
				from
					Result := True
					i := a_array.lower + 1
				until
					i > a_array.upper or not Result
				loop
					if a_strict then
						Result := a_array.item (i - 1) < a_array.item (i)
					else
						Result := a_array.item (i - 1) <= a_array.item (i)
					end
					i := i + 1
				end
			else
				Result := True
			end
		end

feature -- Basic operations

	accumulated_time_table (a_start_time: INTEGER; a_end_time: INTEGER; a_time_unit: INTEGER; a_data: ARRAY [INTEGER]): ARRAY [INTEGER] is
			-- Table of events that happesn over time.
			-- Index of `a_data' is index for different things that happened. For example, slot index, fault index.
			-- Value of `a_data' is the time that the corresponding thing that happened. -1 means that the particular event didn't happen.
			-- Index of the result array is time, value of the array is the number of faults that are found until that time.
			-- `a_start_time' is the starting time related to `test_session_start_time',
			-- `a_end_time' is the end time related to `test_session_start_time'.
			-- `a_start_time' and `a_end_time' points are included in the result.
			-- `a_time_unit' is the unit of `a_start_time', `a_end_time' and the time index used in the result array.
			-- `a_time_unit' is in the unit of second. For example, if you want to see fault time table in minute time unit,
			-- the `a_time_unit' should be 60.
		require
			a_start_time_non_negative: a_start_time >= 0
			a_end_time_non_negative: a_end_time >= 0
			a_end_time_valid: a_end_time >= a_start_time
			a_time_unit_positive: a_time_unit > 0
			a_data_attached: a_data /= Void
		local
			l_time_point: INTEGER
			l_sorted: like sorted_array
			i: INTEGER
			l_checkpoint: INTEGER
			l_count: INTEGER
		do
			l_sorted := sorted_array (a_data)
			create Result.make (a_start_time, a_end_time)
			initialize_array (Result, -1)
			from
				l_checkpoint := a_end_time - a_start_time + 1
				i := 0
				l_time_point := a_start_time * a_time_unit
				l_sorted.start
			until
				i = l_checkpoint
			loop
				from

				until
					l_sorted.after or else l_sorted.item_for_iteration.time > l_time_point
				loop
					if l_sorted.item_for_iteration.time >= 0 then
						l_count := l_count + 1
					end
					l_sorted.forth
				end
				Result.put (l_count, a_start_time + i)
				i := i + 1
				l_time_point := l_time_point + a_time_unit
			end
		ensure
			result_attached: Result /= Void
			result_valid: Result.lower = a_start_time and Result.upper = a_end_time
			result_increasing: is_array_increasing (Result, False)
		end

	sorted_array (a_array: ARRAY [INTEGER]): DS_ARRAYED_LIST [TUPLE [index: INTEGER; time: INTEGER]] is
			-- Sorted value
		require
			a_array_attached: a_array /= Void
		local
			i: INTEGER
			l_sorter: DS_QUICK_SORTER [TUPLE [fault_index: INTEGER; time: INTEGER]]
		do
			create Result.make (a_array.count)
			from
				i := a_array.lower
			until
				i > a_array.upper
			loop
				Result.force_last ([i, a_array.item (i)])
				i := i + 1
			end
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [TUPLE [fault_index: INTEGER; time: INTEGER]]}.make (
				agent (a, b: TUPLE [fault_index: INTEGER; time: INTEGER]): BOOLEAN
					do
						Result := a.time < b.time
					end))

			l_sorter.sort (Result)
		ensure
			result_attached: Result /= Void
		end

	initialize_array (a_array: ARRAY [INTEGER]; a_value: INTEGER) is
			-- Fill `a_array' with `a_value'.
		require
			a_array_attached: a_array /= Void
		local
			i: INTEGER
		do
			from
				i := a_array.lower
			until
				i > a_array.upper
			loop
				a_array.put (a_value, i)
				i := i + 1
			end
		end

end
