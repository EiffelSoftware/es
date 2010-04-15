note
	description: "State to select profile options."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_PROFILER_WIZARD_OPTIONS_STATE

inherit
	EB_WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			update_state_information,
			proceed_with_current_info,
			build,
			is_final_state
		end

	EB_PROFILER_WIZARD_SHARED_INFORMATION
		export
			{NONE} all
		end

	EB_CONSTANTS
		export
			{NONE} all
		end

	EB_VISION2_FACILITIES

create
	make

feature -- Basic Operation

	build
			-- Build entries.
		local
			l_frame: EV_FRAME
			l_range: INTEGER_INTERVAL
			l_epoch: DATE_TIME
			l_min_duration, l_max_duration: DATE_TIME_DURATION
			l_box: EV_VERTICAL_BOX
			l_label: EV_LABEL
		do
			--| Timing frame
			create l_epoch.make_from_epoch (0)
			l_min_duration := information.loader.start.duration.minus (l_epoch.duration)
			l_min_duration.set_origin_date_time (l_epoch)
			l_max_duration := information.loader.stop.duration.minus (l_epoch.duration)
			l_max_duration.set_origin_date_time (l_epoch)

			create l_range.make (l_min_duration.fine_seconds_count.truncated_to_integer, l_max_duration.fine_seconds_count.truncated_to_integer)
			create l_box
			l_box.set_padding (tiny_padding_size)

			-- Start range
			create l_label.make_with_text (interface_names.l_scoop_start_time + information.loader.start.out)
			create start_slider.make_with_value_range (l_range)
			start_slider.set_value (l_range.lower)
			start_slider.change_actions.extend (agent update_label (start_slider, l_label, interface_names.l_scoop_start_time, ?))

			extend_no_expand (l_box, start_slider)
			extend_no_expand (l_box, l_label)
			extend_no_expand (l_box, create {EV_HORIZONTAL_SEPARATOR})

			-- Stop range
			create l_label.make_with_text (interface_names.l_scoop_stop_time + information.loader.stop.out)
			create stop_slider.make_with_value_range (l_range)
			stop_slider.set_value (l_range.upper)
			stop_slider.change_actions.extend (agent update_label (stop_slider, l_label, interface_names.l_scoop_stop_time, ?))

			extend_no_expand (l_box, stop_slider)
			extend_no_expand (l_box, l_label)

			create l_frame.make_with_text (interface_names.t_Scoop_time_span)
			l_frame.align_text_left
			l_frame.extend (l_box)

			extend_no_expand (choice_box, l_frame)

			--| Hotspots frame
			create l_box
			l_box.set_padding (small_padding_size)
			l_box.set_border_width (small_border_size)

			create hotspot_check.make_with_text (interface_names.l_scoop_enable_hotspots)
			extend_no_expand (l_box, hotspot_check)

			create l_frame.make_with_text (interface_names.t_Scoop_hotspots)
			l_frame.align_text_left
			l_frame.extend (l_box)

			extend_no_expand (choice_box, l_frame)

			--| Loading frame
			create progress_bar
			create l_label.make_with_text (interface_names.l_loading)
			l_label.align_text_left

			extend_with_size (choice_box, create {EV_CELL}, 0, 20)
			extend_no_expand (choice_box, l_label)
			extend_no_expand (choice_box, progress_bar)

			--| General
			choice_box.set_padding (tiny_padding_size)
			first_window.set_final_state (Interface_names.b_Finish)
		end

	proceed_with_current_info
			-- Proceed with current info.
		local
			old_cursor: EV_POINTER_STYLE
			l_window: EB_SCOOP_PROFILE_WINDOW
			l_profile: EB_SCOOP_APPLICATION_PROFILE
			l_visitor: SCOOP_PROFILER_PARTIAL_EVENT_VISITOR
		do
			old_cursor := first_window.pointer_style
			first_window.set_pointer_style (pixmaps.stock_pixmaps.busy_cursor)

			-- Create profile
			create l_profile.make_with_interface_names (interface_names)
			create l_visitor.make_with_profile (l_profile)

			information.loader.set_progress_action (agent update_loading)
			information.loader.load (l_profile, l_visitor)
			information.loader.set_progress_action (Void)

			if information.scoop_hotspots then
				l_profile.enable_hotspots
			else
				l_profile.disable_hotspots
			end

			-- Show window
			create l_window.make_with_profile (l_profile)
			l_window.raise

			first_window.set_pointer_style (old_cursor)
			first_window.destroy
		end

	update_state_information
			-- Update state information.
		do
			Precursor

			information.loader.set_min (create {DATE_TIME}.make_from_epoch (start_slider.value))
			information.loader.set_max (create {DATE_TIME}.make_from_epoch (stop_slider.value))

			if hotspot_check.is_selected then
				information.enable_hotspots
			else
				information.disable_hotspots
			end

			duration := information.loader.max.duration.minus (information.loader.min.duration)
			duration.set_origin_date_time (create {DATE_TIME}.make_from_epoch (0))
		end

feature {NONE} -- Update

	update_loading (a_value: DATE_TIME)
			-- Update loading with `a_value`.
		require
			a_value /= Void
		local
			l_duration: like duration
		do
			l_duration := a_value.duration.minus (information.loader.min.duration)
			l_duration.set_origin_date_time (create {DATE_TIME}.make_from_epoch (0))
			progress_bar.set_proportion (l_duration.fine_seconds_count / duration.fine_seconds_count)
			progress_bar.refresh_now
		end

	update_label (a_slider: like start_slider; a_label: EV_LABEL; a_prefix: STRING; a_val: INTEGER)
			-- Update label `a_label`, with value `a_val` and prefix `a_prefix`. Pay attention at other slider `a_slider`.
		require
			a_slider /= Void
			a_label /= Void
			a_prefix /= Void
		local
			l_time: DATE_TIME
		do
			if a_slider = start_slider then
				if stop_slider.value < a_val then
					start_slider.set_value (stop_slider.value)
				end
			else
				if start_slider.value > a_val then
					stop_slider.set_value (start_slider.value)
				end
			end
			create l_time.make_from_epoch (a_slider.value)
			a_label.set_text (a_prefix + l_time.out)
		end

feature {NONE} -- Implementation

	display_state_text
			-- Display state text.
		do
			title.set_text (interface_names.wt_Profile_options)
			subtitle.set_text (interface_names.ws_Profile_options)
			message_box.hide
		end

	duration: DATE_TIME_DURATION
			-- Profiling duration

	progress_bar: EV_HORIZONTAL_PROGRESS_BAR
			-- Progress bar

	is_final_state: BOOLEAN = True
			-- This is the last state of this wizard.

	start_slider, stop_slider: EV_HORIZONTAL_RANGE
			-- Start and stop sliders

	hotspot_check: EV_CHECK_BUTTON
			-- Hotspot check button

invariant
	True

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
end -- class SCOOP_PROFILER_WIZARD_OPTIONS_STATE
