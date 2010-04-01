note
	description: "Refinement of feature call-application profile, for display with EiffelVision."
	author: "Martino Trosi, ETH Zürich"
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROFILER_EV_FEATURE_CALL_APPLICATION_PROFILE

inherit
	SCOOP_PROFILER_FEATURE_CALL_APPLICATION_PROFILE
		rename
			processor as processor_old
		undefine
			default_create,
			copy,
			is_equal
		redefine
			call_tree,
			feature_definition,
			requested_processors
		end

	SCOOP_PROFILER_EV_ACTION_PROFILE
		rename
			start_time as sync_time,
			stop_time as return_time,
			set_start_time as set_sync_time,
			set_stop_time as set_return_time
		undefine
			default_create,
			copy,
			is_equal
		redefine
			widget
		select
			processor
		end

	SCOOP_PROFILER_EV_HELPER
		undefine
			default_create,
			copy,
			is_equal
		end

	COMPARABLE

create {SCOOP_PROFILER_EV_APPLICATION_PROFILE}
	make

feature -- Access

	feature_definition: SCOOP_PROFILER_EV_FEATURE_PROFILE
			-- Reference to feature profile

	requested_processors: LINKED_LIST [SCOOP_PROFILER_EV_PROCESSOR_PROFILE]
			-- References to requested processors' profiles

	call_tree: LINKED_LIST [SCOOP_PROFILER_EV_ACTION_PROFILE]
			-- References to internal calls'/profiling actions' profiles

	is_expanded, is_external_expanded: BOOLEAN
			-- Is expanded?
			-- Is external expanded?

feature -- Display

	are_widgets_initialized: BOOLEAN
			-- Are widgets initialized?

	initialize_widgets
			-- Initialize widgets.
		require
			not_initialized: not are_widgets_initialized
		do
			build_tooltip
			build_external_tooltip
			are_widgets_initialized := True
		ensure
			initialized: are_widgets_initialized
		end

	widget: EV_HORIZONTAL_BOX
			-- What's the widget to display?
		local
			l_vertical: EV_VERTICAL_BOX
		do
			if not are_widgets_initialized then
				initialize_widgets
			end
			create Result

			-- Set wait label information
			create wait_label
			wait_label.set_background_color (Sync_color)
			wait_label.set_text (" " + feature_definition.name)
			wait_label.align_text_left
			wait_label.set_tooltip (tooltip)
			wait_label.set_minimum_size ((duration_to_milliseconds (sync_duration) * feature_definition.class_definition.application.zoom).truncated_to_integer, feature_height)
			wait_label.pointer_enter_actions.extend (agent on_mouse_sync_enter)
			wait_label.pointer_leave_actions.extend (agent on_mouse_sync_leave)
			wait_label.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?))

			-- Create wait conditions box
			create wbox
			if is_expanded then
				build_wait_conditions
			else
				wbox.hide
			end

			-- Build vertical box for waiting
			create l_vertical
			l_vertical.extend (wait_label)
			l_vertical.disable_item_expand (l_vertical.last)
			l_vertical.extend (wbox)
			l_vertical.disable_item_expand (l_vertical.last)
			Result.extend (l_vertical)
			Result.disable_item_expand (Result.last)

			-- Set exec label information
			create exec_label
			exec_label.set_background_color (Execution_color)
			exec_label.set_text (" " + feature_definition.name)
			exec_label.align_text_left
			exec_label.set_tooltip (tooltip)
			exec_label.set_minimum_size (execution_width.max ((duration_to_milliseconds (execution_duration) * feature_definition.class_definition.application.zoom).truncated_to_integer), feature_height)
			exec_label.pointer_enter_actions.extend (agent on_mouse_enter)
			exec_label.pointer_leave_actions.extend (agent on_mouse_leave)
			exec_label.pointer_button_press_actions.extend (agent on_click (?, ?, ?, ?, ?, ?, ?, ?))

			-- Create calls box
			create box
			if is_expanded then
				build_calls
			else
				box.hide
			end

			-- Build vertical box for execution
			create l_vertical
			l_vertical.extend (exec_label)
			l_vertical.disable_item_expand (l_vertical.last)
			l_vertical.extend (box)
			l_vertical.disable_item_expand (l_vertical.last)
			Result.extend (l_vertical)
			Result.disable_item_expand (Result.last)
		end

	widget_external: EV_HORIZONTAL_BOX
			-- What's the widget to display on other features?
		local
			l_label: EV_LABEL
			l_box: EV_VERTICAL_BOX
		do
			if not are_widgets_initialized then
				initialize_widgets
			end
			create Result

			-- Call
			create l_label
			l_label.set_background_color (Call_color)
			l_label.set_tooltip (external_tooltip)
			l_label.set_minimum_size (call_width, feature_height)
			l_label.pointer_enter_actions.extend (agent highlight)
			l_label.pointer_leave_actions.extend (agent remove_highlight)

			create l_box
			l_box.extend (l_label)
			l_box.disable_item_expand (l_box.last)
			l_box.extend (create {EV_CELL})

			Result.extend (l_box)

			-- Synchronous execution
			if synchronous then
				create l_label
				l_label.set_background_color (Call_wait_color)
				l_label.set_tooltip (external_tooltip)
				l_label.set_minimum_size ((duration_to_milliseconds (total_duration) * processor.application.zoom).truncated_to_integer, feature_height)
				l_label.pointer_enter_actions.extend (agent highlight)
				l_label.pointer_leave_actions.extend (agent remove_highlight)
				l_label.pointer_button_press_actions.extend (agent on_external_click (?, ?, ?, ?, ?, ?, ?, ?))

				create ebox
				if is_external_expanded then
					build_external_calls
				else
					ebox.hide
				end

				create l_box
				l_box.extend (l_label)
				l_box.disable_item_expand (l_box.last)
				l_box.extend (ebox)
				l_box.disable_item_expand (l_box.last)

				Result.extend (l_box)
			end
		ensure
			result_not_void: Result /= Void
		end

feature {NONE} -- Display elements

	tooltip, external_tooltip: STRING
			-- Tooltip
			-- External tooltip

	build_tooltip
			-- Build tooltip.
		do
			-- Create tooltip
			create tooltip.make_empty
			if is_incomplete then
				tooltip.append ("! INCOMPLETE DATA !%N")
			end
			tooltip.append (feature_definition.class_definition.name + " " + feature_definition.name + "%N")
			tooltip.append ("Duration: " + duration_to_milliseconds (sync_duration.plus (execution_duration)).out + millisecond_suffix + "%N")
			tooltip.append ("Queue duration: " + duration_to_milliseconds (queue_duration).out + millisecond_suffix + "%N")
			tooltip.append ("Sync duration: " + duration_to_milliseconds (sync_duration).out + millisecond_suffix + "%N")
			tooltip.append ("Exec duration: " + duration_to_milliseconds (execution_duration).out + millisecond_suffix + "%N")
			tooltip.append ("Call time: " + call_time.out + "%N")
			tooltip.append ("Start: " + sync_time.out + "%NEnd: " + return_time.out + "%N")
			if not requested_processors.is_empty then
				tooltip.append ("Requested processors: ")
				from
					requested_processors.start
				until
					requested_processors.after
				loop
					tooltip.append (requested_processors.item.id.out + " ")
					requested_processors.forth
				end
				tooltip.append ("%N")
			end
			if not wait_conditions.is_empty then
				tooltip.append ("Wait condition tries: " + wait_conditions.count.out + "%N")
			end
		ensure
			tooltip_set: tooltip /= Void and then not tooltip.is_empty
		end

	build_external_tooltip
			-- Build external tooltip.
		do
			create external_tooltip.make_empty
			if is_incomplete then
				external_tooltip.append ("! INCOMPLETE DATA !%N")
			end
			external_tooltip.append ("Called processor: " + processor.id.out + "%N")
			external_tooltip.append (feature_definition.class_definition.name + " " + feature_definition.name + "%N")
			external_tooltip.append ("Duration: " + duration_to_milliseconds (sync_duration.plus (execution_duration)).out + millisecond_suffix + "%N")
			external_tooltip.append ("Queue duration: " + duration_to_milliseconds (queue_duration).out + millisecond_suffix + "%N")
			external_tooltip.append ("Sync duration: " + duration_to_milliseconds (sync_duration).out + millisecond_suffix + "%N")
			external_tooltip.append ("Exec duration: " + duration_to_milliseconds (execution_duration).out + millisecond_suffix + "%N")
			external_tooltip.append ("Call time: " + call_time.out + "%N")
			external_tooltip.append ("Start: " + sync_time.out + "%NEnd: " + return_time.out + "%N")
		ensure
			external_tooltip_set: external_tooltip /= Void and then not external_tooltip.is_empty
		end

	build_wait_conditions
			-- Build wait conditions.
		require
			wbox_empty: wbox /= Void and then wbox.is_empty
		local
			l_time: DATE_TIME
			l_label: EV_LABEL
			l_idle, l_wc, l_adjust, l_duration: INTEGER
		do
			-- Process wait condition tries
			from
				wait_conditions.start
				l_time := sync_time
				l_wc := 2
			until
				wait_conditions.after
			loop
				-- Idle label
				l_duration := (duration_to_milliseconds (wait_conditions.item.duration.minus (l_time.duration)) * processor.application.zoom).truncated_to_integer
				if l_duration < idle_wait_condition_width then
					if wait_conditions.index /= 1 then
						l_idle := l_idle + 1
					else
						l_wc := l_wc - 1
					end
				end

				create l_label
				if wait_conditions.index /= 1 then
					l_label.set_minimum_size (idle_wait_condition_width.max (l_duration), wait_condition_height)
				else
					l_label.set_minimum_size (l_duration, wait_condition_height)
				end
				-- Adjust wait conditions
				l_adjust := l_wc.min ((l_label.minimum_width - idle_wait_condition_width) // wait_condition_width)
				if l_adjust > 0 then
					l_label.set_minimum_width (l_label.minimum_width - (l_adjust * wait_condition_width))
					l_wc := l_wc - l_adjust
				elseif wait_conditions.index > 1 then
					l_wc := l_wc + 1
				end
				-- Adjust idles
				l_adjust := l_idle.min ((l_label.minimum_width - idle_wait_condition_width) // idle_wait_condition_width)
				if l_adjust > 0 then
					l_label.set_minimum_width (l_label.minimum_width - (l_adjust * idle_wait_condition_width))
					l_idle := l_idle - l_adjust
				end
				wbox.extend (l_label)
				wbox.disable_item_expand (wbox.last)

				-- Wait condition label
				create l_label
				l_label.set_background_color (wait_condition_color)
				l_label.set_minimum_size (wait_condition_width, wait_condition_height)
				wbox.extend (l_label)
				wbox.disable_item_expand (wbox.last)
				l_time := wait_conditions.item
				wait_conditions.forth
			variant
				wait_conditions.count - wait_conditions.index + 1
			end
		end

	build_calls
			-- Build calls.
		require
			box_empty: box /= Void and then box.is_empty
		local
			l_label: EV_LABEL
			l_time: DATE_TIME
			l_diff, l_adjust, l_duration: INTEGER
		do
			-- Process calls
			from
				call_tree.start
				l_time := application_time
			until
				call_tree.after
			loop
				if attached {SCOOP_PROFILER_EV_PROFILING_PROFILE} call_tree.item as t_prof then
					-- Profiling
					l_duration := (duration_to_milliseconds (t_prof.start_time.duration.minus (l_time.duration)) * processor.application.zoom).truncated_to_integer
					create l_label
					if l_duration > idle_call_width then
						l_adjust := l_diff.min (l_duration - idle_call_width)
						l_duration := l_duration - l_adjust
						l_diff := l_diff - l_adjust
					elseif call_tree.index /= 1 then
						l_diff := l_diff + (idle_call_width - l_duration)
						l_duration := idle_call_width
					end
					l_label.set_minimum_size (l_duration, feature_height)

					box.extend (l_label)
					box.disable_item_expand (box.last)

					box.extend (t_prof.widget)

					l_time := t_prof.stop_time
				elseif attached {SCOOP_PROFILER_EV_FEATURE_CALL_APPLICATION_PROFILE} call_tree.item as t_call then
					if t_call.is_local then
						--| This is a local call     |--

						-- Account for adjustement
						l_duration := (duration_to_milliseconds (t_call.return_time.duration.minus (t_call.application_time.duration)) * processor.application.zoom).truncated_to_integer
						if l_duration < execution_width then
							l_diff := l_diff + (execution_width - l_duration)
						end

						l_duration := (duration_to_milliseconds (t_call.sync_time.duration.minus (l_time.duration)) * processor.application.zoom).truncated_to_integer
						create l_label
						if l_duration > idle_call_width then
							l_adjust := l_diff.min (l_duration - idle_call_width)
							l_duration := l_duration - l_adjust
							l_diff := l_diff - l_adjust
						elseif call_tree.index /= 1 then
							l_diff := l_diff + (idle_call_width - l_duration)
							l_duration := idle_call_width
						end
						l_label.set_minimum_size (l_duration, feature_height)

						box.extend (l_label)
						box.disable_item_expand (box.last)

						box.extend (t_call.widget)

						l_time := t_call.return_time
					else
						--| This is an external call |--

						-- Account for adjustement
						l_diff := l_diff + call_width

						if l_time <= t_call.call_time then
							l_duration := (duration_to_milliseconds (t_call.call_time.duration.minus (l_time.duration)) * processor.application.zoom).truncated_to_integer
							create l_label
							if l_duration > idle_call_width then
								l_adjust := l_diff.min (l_duration - idle_call_width)
								l_duration := l_duration - l_adjust
								l_diff := l_diff - l_adjust
							elseif call_tree.index /= 1 then
								l_diff := l_diff + (idle_call_width - l_duration)
								l_duration := idle_call_width
							end
							l_label.set_minimum_size (l_duration, feature_height)

							box.extend (l_label)
							box.disable_item_expand (box.last)
						end

						box.extend (t_call.widget_external)

						if t_call.synchronous then
							l_time := t_call.return_time
						else
							l_time := t_call.call_time
						end
					end
				end
				box.disable_item_expand (box.last)
				call_tree.forth
			variant
				call_tree.count - call_tree.index + 1
			end
		end

	build_external_calls
			--
		require
			ebox_empty: ebox /= Void and then ebox.is_empty
		local
			l_time: DATE_TIME
			l_label: EV_LABEL
			l_diff, l_adjust, l_duration: INTEGER
		do
			-- Add internal calls
			from
				call_tree.start
				l_time := call_time
			until
				call_tree.after
			loop
				if attached {SCOOP_PROFILER_EV_FEATURE_CALL_APPLICATION_PROFILE} call_tree.item as t_call and then t_call.processor.id = caller_processor.id then
					if l_time <= t_call.call_time then
						-- Account for adjustement
						l_duration := (duration_to_milliseconds (t_call.return_time.duration.minus (t_call.application_time.duration)) * processor.application.zoom).truncated_to_integer
						if l_duration < execution_width then
							l_diff := l_diff + (execution_width - l_duration)
						end

						l_duration := (duration_to_milliseconds (t_call.call_time.duration.minus (l_time.duration)) * processor.application.zoom).truncated_to_integer
						create l_label
						if l_duration > idle_call_width then
							l_adjust := l_diff.min (l_duration - idle_call_width)
							l_duration := l_duration - l_adjust
							l_diff := l_diff - l_adjust
						elseif call_tree.index /= 1 then
							l_diff := l_diff + (idle_call_width - l_duration)
							l_duration := idle_call_width
						end
						l_label.set_minimum_size (l_duration, feature_height)

						ebox.extend (l_label)
						ebox.disable_item_expand (ebox.last)
					end

					ebox.extend (t_call.widget)
					ebox.disable_item_expand (ebox.last)

					l_time := t_call.return_time
				end
				call_tree.forth
			variant
				call_tree.count - call_tree.index + 1
			end
		end

feature -- State Change

	highlight
			-- Highlight.
		do
			if exec_label /= Void then
				exec_label.set_background_color (Execution_highlight_color)
			end
		end

	remove_highlight
			-- Remove highlight.
		do
			if exec_label /= Void then
				exec_label.set_background_color (Execution_color)
			end
		end

	expand
			-- Expand.
		require
			not_expanded: not is_expanded
		do
			if box.is_empty and wbox.is_empty then
				build_wait_conditions
				build_calls
			end
			box.show
			wbox.show
			is_expanded := True
		ensure
			is_expanded: is_expanded
		end

	collapse
			-- Collapse.
		require
			is_expanded: is_expanded
		do
			box.hide
			wbox.hide
			is_expanded := False
		ensure
			not_expanded: not is_expanded
		end

	expand_external
			-- Expand external.
		require
			not_expanded: not is_external_expanded
		do
			if ebox.is_empty then
				build_external_calls
			end
			ebox.show
			is_external_expanded := True
		ensure
			is_expanded: is_external_expanded
		end

	collapse_external
			-- Collapse external.
		require
			is_expanded: is_external_expanded
		do
			ebox.hide
			is_external_expanded := False
		ensure
			not_expanded: not is_external_expanded
		end

feature {NONE} -- Events

	on_mouse_enter
			-- Process on mouse enter.
		do
--			if not is_expanded then
--				exec_label.set_background_color (Execution_highlight_color)
--			end
		end

	on_mouse_leave
			-- Process on mouse leave.
		do
--			if not is_expanded then
--				exec_label.set_background_color (Execution_color)
--			end
		end

	on_mouse_sync_enter
			-- Process on mouse sync enter.
		do
			requested_processors.do_all (agent {SCOOP_PROFILER_EV_PROCESSOR_PROFILE}.highlight)
		end

	on_mouse_sync_leave
			-- Process on mouse sync leave.
		do
			requested_processors.do_all (agent {SCOOP_PROFILER_EV_PROCESSOR_PROFILE}.remove_highlight)
		end

	on_click (x, y, button: INTEGER; x_tilt, y_tilt, pressure: REAL_64; x_screen, y_screen: INTEGER)
			-- Process click.
		do
			if button = 1 and not (wait_conditions.is_empty and call_tree.is_empty) then
				if is_expanded then
					collapse
				else
					expand
				end
			end
		end

	on_external_click (x, y, button: INTEGER; x_tilt, y_tilt, pressure: REAL_64; x_screen, y_screen: INTEGER)
			-- Process external click.
		do
			if button = 1 then
				if is_external_expanded then
					collapse_external
				else
					expand_external
				end
			end
		end

feature {NONE} -- Implementation

	wait_label, exec_label: EV_LABEL
			-- Wait label
			-- Exec label

	box, wbox, ebox: EV_HORIZONTAL_BOX
			-- Box for drawing internal features
			-- Box for drawing wait condition tries
			-- Box for drawing internal features (when called from external processors)

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
