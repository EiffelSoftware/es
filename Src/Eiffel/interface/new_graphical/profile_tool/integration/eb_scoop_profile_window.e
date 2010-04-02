note
	description: "Summary description for {EB_SCOOP_PROFILE_WINDOW}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_SCOOP_PROFILE_WINDOW

inherit
	EV_TITLED_WINDOW

	EB_VISION2_FACILITIES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	make_with_profile

feature {NONE} -- Initialization

	make_with_profile (a_profile: EB_SCOOP_APPLICATION_PROFILE)
			-- Create Current.
		require
			a_profile /= Void
		do
			profile := a_profile

			default_create
			set_title (interface_names.t_Scoop_profile_window)
			set_icon_pixmap (Pixmaps.icon_pixmaps.general_dialog_icon)
			set_size (Layout_constants.Dialog_unit_to_pixels(600), Layout_constants.Dialog_unit_to_pixels(500))
			close_request_actions.extend (agent destroy)

			build_toolbar
			build_interface
		ensure
			profile_set: profile = a_profile
		end

	build_interface
			-- Build the user interfac			-- Initialize the commands
		local
			split: EV_VERTICAL_SPLIT_AREA
			container: EV_VERTICAL_BOX			-- Widget containing all others
			button_box: EV_HORIZONTAL_BOX		-- Box for the buttons
			close_button: EV_BUTTON				-- Button to close Current
		do
			-- Display processor rows information
			create scrollable
			scrollable.extend (profile.widget)
			scrollable.resize_actions.extend (agent on_resize)

				--| Build button bar
			create close_button.make_with_text_and_action (Interface_names.b_Close, agent destroy)
			create button_box
			button_box.set_border_width (Layout_constants.Small_border_size)
			button_box.set_padding (Layout_constants.Small_border_size)
			--| FIXME extend_button (button_box, help_button)
			button_box.extend (create {EV_CELL}) -- expandable item
			extend_button (button_box, close_button)

				--| Split area
			create split
			split.set_proportion (0.6)
			split.extend (scrollable)
			split.disable_item_expand (split.first)
			split.extend (profile.grid_widget)
			split.disable_item_expand (split.second)

				--| Build forms
			create container
			container.set_padding (Layout_constants.Small_padding_size)
			container.set_border_width (Layout_constants.Small_border_size)

			extend_no_expand (container, toolbar)

			container.extend (split)
--			container.disable_item_expand (container.last)

			extend_no_expand (container, button_box)

			extend (container)
		end

feature {NONE} -- ToolBar Implementation

	toolbar: EV_TOOL_BAR
			-- Standard toolbar for this window

	build_toolbar
			-- Create and populate the standard toolbar.
		require
			toolbar = Void
		local
			toolbar_item: EV_TOOL_BAR_BUTTON
		do
				-- Create the toolbar.
			create toolbar

			create toolbar_item
			toolbar_item.set_pixmap (Pixmaps.configuration_pixmaps.diagram_zoom_in_icon)
			toolbar_item.select_actions.extend (agent zoom_in)
			toolbar.extend (toolbar_item)

			create toolbar_item
			toolbar_item.set_pixmap (Pixmaps.configuration_pixmaps.diagram_zoom_out_icon)
			toolbar_item.select_actions.extend (agent zoom_out)
			toolbar.extend (toolbar_item)
		ensure
			toolbar /= Void and then not toolbar.is_empty
		end

feature {NONE} -- Agents

	zoom_in
			-- Zoom in.
		do
			lock_update
			profile.set_zoom (profile.zoom * 2)
			scrollable.wipe_out
			scrollable.extend (profile.widget)
			unlock_update
			resize_diagram
		end

	zoom_out
			-- Zoom out.
		do
			lock_update
			profile.set_zoom (profile.zoom / 2)
			scrollable.wipe_out
			scrollable.extend (profile.widget)
			unlock_update
			resize_diagram
		end

	on_resize (a_x, a_y, a_width, a_height: INTEGER)
			-- Process on resize.
		do
			resize_diagram
		end

	resize_diagram
			-- Resize diagram.
		do
			if not scrollable.is_empty then
				if scrollable.client_width > scrollable.item.width then
					scrollable.item.set_minimum_width (scrollable.client_width)
				end
				if scrollable.client_height > scrollable.item.height then
					scrollable.item.set_minimum_height (scrollable.client_height)
				end
			end
		end

feature {NONE} -- Implementation

	profile: SCOOP_PROFILER_EV_APPLICATION_PROFILE
			-- Reference to application profile

	scrollable: EV_SCROLLABLE_AREA
			-- Scrollable area

invariant
	profile_not_void: profile /= Void

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
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

end -- class SCOOP_PROFILER_WIZARD_WINDOW
