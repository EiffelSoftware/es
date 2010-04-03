note
	description: "Refinement of processor profile, for display with EiffelVision."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_EV_PROCESSOR_PROFILE

inherit
	SCOOP_PROFILER_PROCESSOR_PROFILE
		redefine
			calls,
			application
		end

	SCOOP_PROFILER_EV_HELPER
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	SCOOP_PROFILER_EV_PROFILE
		undefine
			default_create,
			copy,
			is_equal
		redefine
			widget
		end

create {SCOOP_PROFILER_EV_APPLICATION_PROFILE}
	make

feature -- Access

	calls: LINKED_LIST [SCOOP_PROFILER_EV_ACTION_PROFILE]
			-- References to calls/profiling profiles

	application: SCOOP_PROFILER_EV_APPLICATION_PROFILE
			-- Reference to application profile

feature -- Display

	widget: EV_HORIZONTAL_BOX
			-- Widget to display
		local
			l_label: EV_LABEL
			l_box: EV_VERTICAL_BOX
			l_time: DATE_TIME
			l_diff, l_adjust, l_duration: INTEGER
		do
			-- Create base structure
			create Result
			create idle_list.make
			if tooltip = Void then
				build_tooltip
			end

			create label
			label.align_text_left
			label.set_minimum_size (110, feature_height)
			label.set_text (label_name + id.out)

			create l_box
			l_box.extend (label)
			l_box.disable_item_expand (label)
			l_box.extend (create {EV_CELL})

			Result.extend (l_box)
			Result.disable_item_expand (Result.last)
			Result.extend (create {EV_VERTICAL_SEPARATOR})
			Result.disable_item_expand (Result.last)

			-- Add tooltip
			label.set_tooltip (tooltip)

			-- Add calls (with idle)
			from
				calls.start
				l_time := application.start_time
			until
				calls.after
			loop
				if attached {SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE} calls.item as t_call and then t_call.synchronous then
					l_duration := (duration_to_milliseconds (t_call.return_time.duration.minus (t_call.application_time.duration)) * application.zoom).truncated_to_integer
					if l_duration < execution_width then
						l_diff := l_diff + (execution_width - l_duration)
					end
				end

				-- Add idle
				l_duration := (duration_to_milliseconds (calls.item.start_time.duration.minus (l_time.duration)) * application.zoom).truncated_to_integer
				create l_label
				if l_duration > idle_call_width then
					l_adjust := l_diff.min (l_duration - idle_call_width)
					l_label.set_minimum_size (l_duration - l_adjust, feature_height)
					l_diff := l_diff - l_adjust
				else
					l_diff := l_diff + (idle_call_width - l_duration)
					l_label.set_minimum_size (idle_call_width, feature_height)
				end
				idle_list.extend (l_label)

				create l_box
				l_box.extend (l_label)
				l_box.disable_item_expand (l_box.last)
				l_box.extend (create {EV_CELL})

				Result.extend (l_box)
				Result.disable_item_expand (Result.last)

				-- Add calls
				if attached {SCOOP_PROFILER_EV_FEATURE_CALL_APPLICATION_PROFILE} calls.item as t_call and then t_call.processor /= Current then
					Result.extend (t_call.widget_external)
				else
					Result.extend (calls.item.widget)
				end
				Result.disable_item_expand (Result.last)

				l_time := calls.item.stop_time
				calls.forth
			end

			-- Add idle to processor end
			if l_time < application.stop_time then

				l_duration := (duration_to_milliseconds (application.stop_time.duration.minus (l_time.duration)) * application.zoom).truncated_to_integer
				create l_label
				l_label.set_minimum_size (l_duration, feature_height)

				idle_list.extend (l_label)
				if l_label.minimum_width > 0 then
					l_label.set_minimum_size ((l_label.minimum_width - l_diff).max (0), feature_height)
				end

				create l_box
				l_box.extend (l_label)
				l_box.disable_item_expand (l_box.last)
				l_box.extend (create {EV_CELL})

				Result.extend (l_box)
				Result.disable_item_expand (Result.last)
			end
		end

	highlight
			-- Highlight.
		do
			label.set_background_color (Processor_highlight_color)
			from
				idle_list.start
			until
				idle_list.after
			loop
				idle_list.item.set_background_color (Processor_highlight_color)
				idle_list.forth
			variant
				idle_list.count - idle_list.index + 1
			end
		end

	remove_highlight
			-- Remove highlight.
		do
			label.set_default_colors
			from
				idle_list.start
			until
				idle_list.after
			loop
				idle_list.item.set_default_colors
				idle_list.forth
			variant
				idle_list.count - idle_list.index + 1
			end
		end

feature {NONE} -- Display elements

	label_name: STRING
			-- Label name
		do
			Result := "Processor "
		ensure
			result_not_void: Result /= Void
		end

	build_tooltip
			-- Build tooltip.
		do
			create tooltip.make_empty
			tooltip.append ("Processor: " + id.out + "%N")
			tooltip.append ("Execution time: " + execution_time.out + millisecond_suffix + "%N")
			tooltip.append ("Wait time: " + wait_time.out + millisecond_suffix + "%N")
			tooltip.append ("Profile time: " + profile_time.out + millisecond_suffix + "%N")
		ensure
			tooltip_not_void: tooltip /= Void and then not tooltip.is_empty
		end

feature {NONE} -- Implementation

	tooltip: STRING
			-- Tooltip

	label: EV_LABEL
			-- Label

	idle_list: LINKED_LIST [EV_LABEL]
			-- List of idle labels

;note
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
