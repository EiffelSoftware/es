note
	description: "Panel allowing configuration of the blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_BLACKBOARD_CONFIGURATION_PANEL

inherit

	EBB_SHARED_BLACKBOARD

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize panel.
		local
			l_horziontal_box: EV_HORIZONTAL_BOX
			l_label: EV_LABEL
		do
			create panel

			create l_horziontal_box
			create l_label.make_with_text ("Blackboard service: ")
			create state_label.make_with_text ("")
			create start_stop_button.make_with_text ("")
			start_stop_button.select_actions.extend (agent on_start_stop_button_pressed)
			blackboard.blackboard_started_event.subscribe (agent update_display)
			blackboard.blackboard_stopped_event.subscribe (agent update_display)

			l_horziontal_box.extend (l_label)
			l_horziontal_box.extend (state_label)
			l_horziontal_box.extend (start_stop_button)
			panel.extend (l_horziontal_box)

			create l_horziontal_box
			create l_label.make_with_text ("Control: ")
			create control_box
			control_box.extend (create {EV_LIST_ITEM}.make_with_text ("Idle"))
			control_box.extend (create {EV_LIST_ITEM}.make_with_text ("Basic"))
			control_box.extend (create {EV_LIST_ITEM}.make_with_text ("Random"))
			control_box.change_actions.extend (agent on_control_change)

			l_horziontal_box.extend (l_label)
			l_horziontal_box.extend (control_box)
			panel.extend (l_horziontal_box)

			update_display
		end

feature -- Access

	panel: EV_VERTICAL_BOX
			-- Configuration panel.

feature {NONE} -- Implementation

	state_label: EV_LABEL
			-- Blackboard state label.

	start_stop_button: EV_BUTTON
			-- Button to start/stop blackboard service.

	control_box: EV_COMBO_BOX
			-- Box to select controller.

	on_start_stop_button_pressed
			-- Handle event that start/stop button is pressed.
		do
			if blackboard.is_running then
				blackboard.stop
			else
				blackboard.start
			end
		end

	on_control_change
			-- Handle event that control selection changed.
		local
			l_running: BOOLEAN
		do
			l_running := blackboard.is_running
			blackboard.stop
			if control_box.text.is_equal ("Idle") then
				blackboard.set_control (create {EBB_IDLE_CONTROL}.make)
			elseif control_box.text.is_equal ("Basic") then
				blackboard.set_control (create {EBB_BASIC_CONTROL}.make)
			elseif control_box.text.is_equal ("Random") then
				blackboard.set_control (create {EBB_RANDOM_CONTROL}.make)
			end
			if l_running then
				blackboard.start
			end
		end

	update_display
			-- Update display.
		do
			if blackboard.is_running then
				state_label.set_text ("Running")
				start_stop_button.set_text ("Stop")
			else
				state_label.set_text ("Stopped")
				start_stop_button.set_text ("Start")
			end
		end

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
