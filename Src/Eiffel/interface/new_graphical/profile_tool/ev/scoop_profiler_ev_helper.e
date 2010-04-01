note
	description: "Helper for drawing with EiffelVision."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCOOP_PROFILER_EV_HELPER

feature -- Measures

	Call_width: INTEGER = 1
			-- Minimum width of external calls

	Execution_width: INTEGER = 3
			-- Minimum width of execution part

	Idle_call_width: INTEGER = 1
			-- Minimum width of idle between calls

	Idle_wait_condition_width: INTEGER = 1
			-- Minimum width of idle between wait condition tries

	Feature_height: INTEGER = 16
			-- Height of labels

	Wait_condition_width: INTEGER = 1
			-- Minimum width of wait condition tries

	Wait_condition_height: INTEGER = 8
			-- Height of wait condition tries labels

feature -- Color

	Class_color: EV_COLOR
			-- Color for class name labels
		once
			create Result.make_with_8_bit_rgb (0, 0, 255)
		ensure
			result_not_void: Result /= Void
		end

	Feature_color: EV_COLOR
			-- Color for feature name labels
		once
			create Result.make_with_8_bit_rgb (0, 128, 0)
		ensure
			result_not_void: Result /= Void
		end

	Profiling_color: EV_COLOR
			-- Profiling labels color
		once
			create Result.make_with_8_bit_rgb (255, 200, 200)
		ensure
			result_not_void: Result /= Void
		end

	Sync_color: EV_COLOR
			-- Sync labels color
		once
			create Result.make_with_8_bit_rgb (244, 244, 0)
		ensure
			result_not_void: Result /= Void
		end

	Execution_color: EV_COLOR
			-- Execution labels color
		once
			create Result.make_with_8_bit_rgb (0, 255, 150)
		ensure
			result_not_void: Result /= Void
		end

	Execution_highlight_color: EV_COLOR
			-- Execution labels highlight color
		once
			create Result.make_with_8_bit_rgb (0, 255, 0)
		ensure
			result_not_void: Result /= Void
		end

	Processor_highlight_color: EV_COLOR
			-- Processor labels highlight color
		once
			create Result.make_with_8_bit_rgb (100, 100, 255)
		ensure
			result_not_void: Result /= Void
		end

	Wait_condition_color: EV_COLOR
			-- Wait condition try labels color
		once
			create Result.make_with_8_bit_rgb (0, 0, 255)
		ensure
			result_not_void: Result /= Void
		end

	Call_color: EV_COLOR
			-- External call labels color
		once
			create Result.make_with_8_bit_rgb (255, 0, 0)
		ensure
			result_not_void: Result /= Void
		end

	Call_wait_color: EV_COLOR
			-- External call wait labels color
		once
			create Result.make_with_8_bit_rgb (255, 100, 100)
		ensure
			result_not_void: Result /= Void
		end

feature -- Times

	Millisecond_suffix: STRING = " ms"
			-- Suffix for times

	Percentage_suffix: STRING = "%%"
			-- Suffix for percentages

feature -- Columns

	Column_name_id: INTEGER = 1
	Column_name_label: STRING = "Feature"
	Column_name_width: INTEGER = 140

	Column_calls_id: INTEGER = 2
	Column_calls_label: STRING = "Calls"
	Column_calls_width: INTEGER = 50

	Column_average_wc_id: INTEGER = 4
	Column_average_wc_label: STRING = "Avg wc tries"
	Column_average_wc_width: INTEGER = 50

	Column_total_wc_id: INTEGER = 3
	Column_total_wc_label: STRING = "Total wc tries"
	Column_total_wc_width: INTEGER = 70

	Column_stddev_queue_id: INTEGER = 7
	Column_stddev_queue_label: STRING = "Stddev queue"
	Column_stddev_queue_width: INTEGER = 70

	Column_average_queue_id: INTEGER = 6
	Column_average_queue_label: STRING = "Avg queue time"
	Column_average_queue_width: INTEGER = 70

	Column_total_queue_id: INTEGER = 5
	Column_total_queue_label: STRING = "Total queue time"
	Column_total_queue_width: INTEGER = 90

	Column_stddev_sync_id: INTEGER = 10
	Column_stddev_sync_label: STRING = "Stddev sync"
	Column_stddev_sync_width: INTEGER = 70

	Column_average_sync_id: INTEGER = 9
	Column_average_sync_label: STRING = "Avg sync time (wc, lock)"
	Column_average_sync_width: INTEGER = 70

	Column_total_sync_id: INTEGER = 8
	Column_total_sync_label: STRING = "Total sync time (wc, lock)"
	Column_total_sync_width: INTEGER = 90

	Column_stddev_execution_id: INTEGER = 13
	Column_stddev_execution_label: STRING = "Stddev exec"
	Column_stddev_execution_width: INTEGER = 70

	Column_average_execution_id: INTEGER = 12
	Column_average_execution_label: STRING = "Avg exec time"
	Column_average_execution_width: INTEGER = 70

	Column_total_execution_id: INTEGER = 11
	Column_total_execution_label: STRING = "Total exec time"
	Column_total_execution_width: INTEGER = 90

	Column_percentage_wait_id: INTEGER = 14
	Column_percentage_wait_label: STRING = "%% Useful time"
	Column_percentage_wait_width: INTEGER = 60

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
