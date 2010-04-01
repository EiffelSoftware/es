note
	description: "Refinement of application profile, for display with EiffelVision."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_EV_APPLICATION_PROFILE

inherit
	SCOOP_PROFILER_APPLICATION_PROFILE
		redefine
			new_class_profile,
			new_processor_profile,
			new_feature_profile,
			new_feature_call_application_profile,
			new_profiling_profile,
			classes,
			ordered_processors,
			make
		end

	SCOOP_PROFILER_EV_PROFILE
		redefine
			widget
		end

	SCOOP_PROFILER_EV_HELPER
		export
			{NONE} all
		end

	SCOOP_PROFILER_EV_HOTSPOTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Creation

	make
			-- Creation procedure
		do
			Precursor {SCOOP_PROFILER_APPLICATION_PROFILE}
			zoom := 0.1
		ensure then
			zoom_valid: zoom > 0
		end

feature -- Access

	zoom: REAL
			-- Zoom factor

	classes: HASH_TABLE [like new_class_profile, STRING]
			-- Reference to class profiles

	ordered_processors: ARRAYED_LIST [like new_processor_profile]
			-- Ordered list of processors
		do
			Result := Precursor
		end

feature -- Basic Operations

	set_zoom (a_zoom: like zoom)
			-- Set `zoom` to `a_zoom`.
		require
			zoom_valid: zoom > 0
		do
			zoom := a_zoom
		ensure
			zoom_set: zoom = a_zoom
		end

	enable_hotspots
			-- Enable hotspots.
		do
			are_hotspots_enabled := True
		ensure
			enabled: are_hotspots_enabled
		end

	disable_hotspots
			-- Disabled hotspots.
		do
			are_hotspots_enabled := False
		ensure
			disabled: not are_hotspots_enabled
		end

feature -- Display

	widget: EV_HORIZONTAL_BOX
			-- What's the widget to display?
		local
			list: like ordered_processors
			l_box: EV_VERTICAL_BOX
		do
			-- Prepare base structure
			create Result
			create l_box

			l_box.extend (create {EV_HORIZONTAL_SEPARATOR})
			l_box.disable_item_expand (l_box.last)

			from
				list := ordered_processors
				list.start
			until
				list.after
			loop
				-- Add each processor widget
				l_box.extend (list.item.widget)
				l_box.disable_item_expand (l_box.last)
				l_box.extend (create {EV_HORIZONTAL_SEPARATOR})
				l_box.disable_item_expand (l_box.last)
				list.forth
			variant
				list.count - list.index + 1
			end
			l_box.extend (create {EV_CELL})
			Result.extend (l_box)
			Result.disable_item_expand (Result.last)
			Result.extend (create {EV_CELL})
		end

	grid_widget: EV_GRID
			-- What's the grid widget to display?
		local
			grid: EV_GRID
			l_i_row, l_i_class, l_i_feature: INTEGER
			l_class: SCOOP_PROFILER_EV_CLASS_PROFILE
			l_feature: SCOOP_PROFILER_EV_FEATURE_PROFILE
			l_call: SCOOP_PROFILER_EV_FEATURE_CALL_APPLICATION_PROFILE
			g_label: EV_GRID_LABEL_ITEM
			l_some_feature_exist: BOOLEAN
			f_wc: FORMAT_DOUBLE
		do
			create f_wc.make (1, 1)

			-- Display features information
			create grid
			grid.enable_tree

			from
				classes.start
				l_i_row := 1
			until
				classes.after
			loop
				l_class := classes.item_for_iteration

				-- Row for class
				l_i_class := l_i_row
				create g_label.make_with_text (l_class.name)
				g_label.set_foreground_color (class_color)
				grid.set_item (column_name_id, l_i_row, g_label)
				l_i_row := l_i_row + 1

				-- Features
				from
					l_class.features.start
				until
					l_class.features.after
				loop
					l_feature := l_class.features.item_for_iteration
					if not l_feature.calls.is_empty then
						l_some_feature_exist := True
						-- Feature
						create g_label.make_with_text (l_feature.name)
						g_label.set_foreground_color (feature_color)
						grid.set_item (column_name_id, l_i_row, g_label)
						-- Calls
						create g_label.make_with_text (l_feature.calls.count.out)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_calls_id, l_i_row, g_label)
						-- Wait condition tries
						create g_label.make_with_text (l_feature.total_wait_condition_tries.out)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_total_wc_id, l_i_row, g_label)
						create g_label.make_with_text (f_wc.formatted (l_feature.average_wait_condition_tries))
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_average_wc_id, l_i_row, g_label)
						-- Queue time
						create g_label.make_with_text (l_feature.stddev_queue_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_stddev_queue_id, l_i_row, g_label)
						create g_label.make_with_text (l_feature.total_queue_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_total_queue_id, l_i_row, g_label)
						create g_label.make_with_text (l_feature.average_queue_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_average_queue_id, l_i_row, g_label)
						-- Sync time
						create g_label.make_with_text (l_feature.stddev_sync_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_stddev_sync_id, l_i_row, g_label)
						create g_label.make_with_text (l_feature.total_sync_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_total_sync_id, l_i_row, g_label)
						create g_label.make_with_text (l_feature.average_sync_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_average_sync_id, l_i_row, g_label)
						-- Execution time
						create g_label.make_with_text (l_feature.stddev_execution_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_stddev_execution_id, l_i_row, g_label)
						create g_label.make_with_text (l_feature.total_execution_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_total_execution_id, l_i_row, g_label)
						create g_label.make_with_text (l_feature.average_execution_time.out + millisecond_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_average_execution_id, l_i_row, g_label)
						-- Percentage
						create g_label.make_with_text ((100 - integer_percentage (l_feature.total_wait_time, l_feature.total_execution_time)).out + percentage_suffix)
						g_label.align_text_right
						g_label.set_data (l_feature)
						grid.set_item (column_percentage_wait_id, l_i_row, g_label)

						-- Set parent row
						grid.row (l_i_class).add_subrow (grid.row (l_i_row))

						-- Single calls
						if l_feature.calls.count > 1 then
							l_i_feature := l_i_row
							from
								l_feature.calls.start
							until
								l_feature.calls.after
							loop
								l_call := l_feature.calls.item
								l_i_row := l_i_row + 1

								-- Feature
								create g_label.make_with_text ("#" + (l_i_row - l_i_feature).out)
								grid.set_item (column_name_id, l_i_row, g_label)
								-- Wait condition tries
								create g_label.make_with_text (l_call.wait_conditions.count.out)
								g_label.align_text_right
								grid.set_item (column_total_wc_id, l_i_row, g_label)
								-- Timings
								create g_label.make_with_text (duration_to_milliseconds (l_call.queue_duration).out + millisecond_suffix)
								g_label.align_text_right
								grid.set_item (column_total_queue_id, l_i_row, g_label)
								create g_label.make_with_text (duration_to_milliseconds (l_call.sync_duration).out + millisecond_suffix)
								g_label.align_text_right
								grid.set_item (column_total_sync_id, l_i_row, g_label)
								create g_label.make_with_text (duration_to_milliseconds (l_call.execution_duration).out + millisecond_suffix)
								g_label.align_text_right
								grid.set_item (column_total_execution_id, l_i_row, g_label)
								-- Percentage
								create g_label.make_with_text ((100 - duration_percentage (l_call.wait_duration, l_call.execution_duration)).out + percentage_suffix)
								g_label.align_text_right
								grid.set_item (column_percentage_wait_id, l_i_row, g_label)

								-- Set parent row
								grid.row (l_i_feature).add_subrow (grid.row (l_i_row))

								l_feature.calls.forth
							variant
								l_feature.calls.count - l_feature.calls.index + 1
							end
						end
						l_i_row := l_i_row + 1
					end

					l_class.features.forth
				end
				if grid.row (l_i_class).subrow_count > 0 then
					grid.row (l_i_class).expand
				end
				classes.forth
			end

			-- Column headers
			grid.column (column_name_id).set_title (column_name_label)
			if l_some_feature_exist then
				grid.column (column_calls_id).set_title (column_calls_label)
				grid.column (column_total_wc_id).set_title (column_total_wc_label)
				grid.column (column_average_wc_id).set_title (column_average_wc_label)
				grid.column (column_total_queue_id).set_title (column_total_queue_label)
				grid.column (column_average_queue_id).set_title (column_average_queue_label)
				grid.column (column_stddev_queue_id).set_title (column_stddev_queue_label)
				grid.column (column_total_sync_id).set_title (column_total_sync_label)
				grid.column (column_average_sync_id).set_title (column_average_sync_label)
				grid.column (column_stddev_sync_id).set_title (column_stddev_sync_label)
				grid.column (column_total_execution_id).set_title (column_total_execution_label)
				grid.column (column_average_execution_id).set_title (column_average_execution_label)
				grid.column (column_stddev_execution_id).set_title (column_stddev_execution_label)
				grid.column (column_percentage_wait_id).set_title (column_percentage_wait_label)
			end

			-- Column width
			grid.column (column_name_id).set_width (column_name_width)
			grid.column (column_name_id).resize_to_content
			if l_some_feature_exist then
				grid.column (column_calls_id).set_width (column_calls_width)
				grid.column (column_total_wc_id).set_width (column_total_wc_width)
				grid.column (column_average_wc_id).set_width (column_average_wc_width)
				grid.column (column_total_queue_id).set_width (column_total_queue_width)
				grid.column (column_average_queue_id).set_width (column_average_queue_width)
				grid.column (column_stddev_queue_id).set_width (column_stddev_queue_width)
				grid.column (column_total_sync_id).set_width (column_total_sync_width)
				grid.column (column_average_sync_id).set_width (column_average_sync_width)
				grid.column (column_stddev_sync_id).set_width (column_stddev_sync_width)
				grid.column (column_total_execution_id).set_width (column_total_execution_width)
				grid.column (column_average_execution_id).set_width (column_average_execution_width)
				grid.column (column_stddev_execution_id).set_width (column_stddev_execution_width)
				grid.column (column_percentage_wait_id).set_width (column_percentage_wait_width)
			end

			--| Hotspots |--
			if l_some_feature_exist and are_hotspots_enabled then
				highlight_hotspots (grid)
			end

			Result := grid
		ensure
			result_not_void: Result /= Void
		end

feature {NONE} -- Hotspots

	are_hotspots_enabled: BOOLEAN
			-- Are hotspots enabled?

	highlight_hotspots (grid: EV_GRID)
			-- Highlight hotspots on `grid`.
		require
			grid_not_void: grid /= Void
		do
			-- Max calls
			hotspot_integer_max (grid.column (column_calls_id), agent hs_calls, agent hs_highlight_error)
			-- Wait condition tries
			hotspot_double_not (grid.column (column_total_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_warn, 1)
			hotspot_double_not (grid.column (column_average_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_warn, 1)
			hotspot_double_max (grid.column (column_total_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_error)
			hotspot_double_max (grid.column (column_average_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_error)
			hotspot_double (grid.column (column_total_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_ok, 1)
			hotspot_double (grid.column (column_average_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_ok, 1)
			hotspot_double (grid.column (column_total_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_ok, 0)
			hotspot_double (grid.column (column_average_wc_id), agent hs_direct_double (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.average_wait_condition_tries), agent hs_highlight_ok, 0)
			-- Useful percentage
			hotspot_integer (grid.column (column_percentage_wait_id), agent hs_useful_percentage, agent hs_highlight_ok, 100)
			hotspot_integer_not (grid.column (column_percentage_wait_id), agent hs_useful_percentage, agent hs_highlight_warn, 100)
			hotspot_integer_min (grid.column (column_percentage_wait_id), agent hs_useful_percentage, agent hs_highlight_error)
			-- Queue time = 0
			hotspot_integer (grid.column (column_total_queue_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_queue_time), agent hs_highlight_ok, 0)
			hotspot_integer (grid.column (column_average_queue_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_queue_time), agent hs_highlight_ok, 0)
			hotspot_integer (grid.column (column_stddev_queue_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_queue_time), agent hs_highlight_ok, 0)
			hotspot_integer_not (grid.column (column_total_queue_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_queue_time), agent hs_highlight_warn, 0)
			hotspot_integer_not (grid.column (column_average_queue_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_queue_time), agent hs_highlight_warn, 0)
			hotspot_integer_not (grid.column (column_stddev_queue_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_queue_time), agent hs_highlight_warn, 0)
			-- Sync time = 0
			hotspot_integer (grid.column (column_total_sync_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_sync_time), agent hs_highlight_ok, 0)
			hotspot_integer (grid.column (column_average_sync_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_sync_time), agent hs_highlight_ok, 0)
			hotspot_integer (grid.column (column_stddev_sync_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_sync_time), agent hs_highlight_ok, 0)
			hotspot_integer_not (grid.column (column_total_sync_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_sync_time), agent hs_highlight_warn, 0)
			hotspot_integer_not (grid.column (column_average_sync_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_sync_time), agent hs_highlight_warn, 0)
			hotspot_integer_not (grid.column (column_stddev_sync_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_sync_time), agent hs_highlight_warn, 0)
			-- Exec time = 0
			hotspot_integer (grid.column (column_total_execution_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_execution_time), agent hs_highlight_ok, 0)
			hotspot_integer (grid.column (column_average_execution_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_execution_time), agent hs_highlight_ok, 0)
			hotspot_integer (grid.column (column_stddev_execution_id), agent hs_direct_integer (?,  agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_execution_time), agent hs_highlight_ok, 0)
			hotspot_integer_not (grid.column (column_total_execution_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_execution_time), agent hs_highlight_warn, 0)
			hotspot_integer_not (grid.column (column_average_execution_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_execution_time), agent hs_highlight_warn, 0)
			hotspot_integer_not (grid.column (column_stddev_execution_id), agent hs_direct_integer (?, agent {SCOOP_PROFILER_FEATURE_PROFILE}.total_execution_time), agent hs_highlight_warn, 0)
		end

	hs_calls (a_feature: SCOOP_PROFILER_FEATURE_PROFILE): INTEGER
			-- How many calls for `a_feature`?
		require
			feature_not_void: a_feature /= Void
		do
			Result := a_feature.calls.count
		ensure
			result_non_negative: Result >= 0
		end

	hs_useful_percentage (a_feature: SCOOP_PROFILER_FEATURE_PROFILE): INTEGER
			-- What's the useful time percentage of `a_feature`?
		require
			feature_not_void: a_feature /= Void
		do
			Result := 100 - integer_percentage (a_feature.total_wait_time, a_feature.total_execution_time)
		ensure
			result_max: Result <= 100
			result_min: Result >= 0
		end

feature -- Factory

	new_class_profile: SCOOP_PROFILER_EV_CLASS_PROFILE
			-- New class profile
		do
			create Result.make
		end

	new_processor_profile: SCOOP_PROFILER_EV_PROCESSOR_PROFILE
			-- New processor profile
		do
			create Result.make
		end

	new_feature_profile: SCOOP_PROFILER_EV_FEATURE_PROFILE
			-- New feature profile
		do
			create Result.make
		end

	new_feature_call_application_profile: SCOOP_PROFILER_EV_FEATURE_CALL_APPLICATION_PROFILE
			-- New feature call-application profile
		do
			create Result.make
		end

	new_profiling_profile: SCOOP_PROFILER_EV_PROFILING_PROFILE
			-- New profiling profile
		do
			create Result.make
		end

invariant
	classes_not_void: classes /= Void
	zoom_positive: zoom > 0

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
