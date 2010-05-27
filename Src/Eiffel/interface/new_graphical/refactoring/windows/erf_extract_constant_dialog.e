note
	description: "Dialog for the extract constant refactoring."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_CONSTANT_DIALOG
inherit
	EV_DIALOG
		redefine
			initialize
		end

	EB_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end

	EB_VISION2_FACILITIES
		export
			{NONE} all
		undefine
			default_create, copy
		end

feature {NONE} -- Initialization

	initialize
			-- Build interface.
		local
			vb: EV_VERTICAL_BOX
			l: EV_LABEL

			hb_buttons, hb_temp: EV_HORIZONTAL_BOX
		do
			Precursor
			set_title ("Extract constant")
			set_icon_pixmap (pixmaps.icon_pixmaps.general_dialog_icon)

			create vb
			vb.set_padding (Layout_constants.small_padding_size)
			vb.set_border_width (Layout_constants.default_border_size)

			create constant_value_field
			constant_value_field.disable_edit
			create l.make_with_text ("Constant value:")
			create hb_temp
			hb_temp.set_padding (Layout_constants.small_padding_size)
			hb_temp.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_temp.disable_item_expand (l)
			hb_temp.extend (constant_value_field)
			vb.extend (hb_temp)

			create constant_name_field
			create l.make_with_text ("Constant name:")
			create hb_temp
			hb_temp.set_padding (Layout_constants.small_padding_size)
			hb_temp.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_temp.disable_item_expand (l)
			hb_temp.extend (constant_name_field)
			vb.extend (hb_temp)

			create class_flag_checkbox
			class_flag_checkbox.set_text ("Process whole class")
			class_flag_checkbox.select_actions.extend (agent on_class_flag_changed)
			vb.extend (class_flag_checkbox)
			create ancestors_flag_checkbox
			ancestors_flag_checkbox.set_text ("Process ancestors")
			vb.extend (ancestors_flag_checkbox)
			create descendants_flag_checkbox
			descendants_flag_checkbox.set_text ("Process descendants")
			vb.extend (descendants_flag_checkbox)

			create hb_buttons
			vb.extend (hb_buttons)

			extend (vb)
			hb_buttons.set_padding (Layout_constants.small_padding_size)
			hb_buttons.extend (create {EV_CELL})

			create ok_button.make_with_text_and_action (Interface_names.b_ok, agent on_ok_pressed)
			create cancel_button.make_with_text_and_action (Interface_names.b_cancel, agent on_cancel_pressed)
			extend_button (hb_buttons, ok_button)
			extend_button (hb_buttons, cancel_button)

			set_default_push_button (ok_button)
			set_default_cancel_button (cancel_button)
			show_actions.extend (agent on_show)

			set_minimum_width (400)
		end

feature -- Status report

	ok_pressed: BOOLEAN
			-- Did the user confirm the action?

feature -- Access

	ok_button: EV_BUTTON
			-- Button with label "OK".

	cancel_button: EV_BUTTON
			-- Button with label "Cancel".

	constant_name: STRING
			-- Name of constant to extract
		do
			Result := constant_name_field.text
		end

	ancestors_flag: BOOLEAN
			-- Ancestors flag
		do
			Result := ancestors_flag_checkbox.is_selected
		end

	descendants_flag: BOOLEAN
			-- Descendants flag
		do
			Result := descendants_flag_checkbox.is_selected
		end

	class_flag: BOOLEAN
			-- Descendants flag
		do
			Result := class_flag_checkbox.is_selected
		end

feature -- Element change

	set_constant_value(a_value: STRING)
			-- Set value of constant to `a_value'
		require
			not_void: a_value /= void
		do
			constant_value_field.set_text (a_value)
		end

	set_constant_name(a_name: STRING)
			-- Set value of constant to `a_name'
		require
			not_void: a_name /= void
		do
			constant_name_field.set_text (a_name)
		end

	set_descendants_flag(a_state: BOOLEAN)
			-- set descendants flag
		do
			if descendants_flag_checkbox.is_selected /= a_state then
				descendants_flag_checkbox.toggle
			end
		end

	set_ancestors_flag(a_state: BOOLEAN)
			-- set ancestors flag
		do
			if ancestors_flag_checkbox.is_selected /= a_state then
				ancestors_flag_checkbox.toggle
			end
		end

	set_class_flag(a_state: BOOLEAN)
			-- set class flag
		do
			if class_flag_checkbox.is_selected /= a_state then
				class_flag_checkbox.toggle
			end
		end

feature {NONE} -- Implementation

	on_class_flag_changed
			-- "Process class" checkbox changed
		do
			if class_flag_checkbox.is_selected then
				ancestors_flag_checkbox.enable_sensitive
				descendants_flag_checkbox.enable_sensitive
			else
				ancestors_flag_checkbox.disable_select
				descendants_flag_checkbox.disable_select
				ancestors_flag_checkbox.disable_sensitive
				descendants_flag_checkbox.disable_sensitive
			end
		end

	on_show
			-- Triggered when the dialog is shown.
		do
			constant_value_field.set_focus
			on_class_flag_changed
		end

	constant_name_field: EV_TEXT_FIELD
	constant_value_field: EV_TEXT_FIELD
	ancestors_flag_checkbox: EV_CHECK_BUTTON
	descendants_flag_checkbox: EV_CHECK_BUTTON
	class_flag_checkbox: EV_CHECK_BUTTON

	on_ok_pressed
			-- The user pressed OK.
		do
			ok_pressed := True
			destroy
		end

	on_cancel_pressed
			-- The user pressed Cancel.
		do
			ok_pressed := False
			destroy
		end
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
