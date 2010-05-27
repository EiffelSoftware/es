note
	description: "Dialog for the extract method refactoring."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_METHOD_DIALOG
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

			hb_class, hb_start, hb_end, hb_name, hb_buttons: EV_HORIZONTAL_BOX
		do
			Precursor
			set_title (interface_names.t_refactoring_extract_method)
			set_icon_pixmap (pixmaps.icon_pixmaps.general_dialog_icon)

			create vb
			vb.set_padding (Layout_constants.small_padding_size)
			vb.set_border_width (Layout_constants.default_border_size)

			create class_field
			class_field.disable_edit
			create l.make_with_text (interface_names.l_class_name_text)
			create hb_class
			hb_class.set_padding (Layout_constants.small_padding_size)
			hb_class.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_class.disable_item_expand (l)
			hb_class.extend (class_field)

			create start_line_field
			create l.make_with_text (interface_names.l_start_line)
			create hb_start
			hb_start.set_padding (Layout_constants.small_padding_size)
			hb_start.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_start.disable_item_expand (l)
			hb_start.extend (start_line_field)

			create end_line_field
			create l.make_with_text (interface_names.l_end_line)
			create hb_end
			hb_end.set_padding (Layout_constants.small_padding_size)
			hb_end.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_end.disable_item_expand (l)
			hb_end.extend (end_line_field)

			create extracted_method_name_field
			create l.make_with_text (interface_names.l_extracted_method_name)
			create hb_name
			hb_name.set_padding (Layout_constants.small_padding_size)
			hb_name.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_name.disable_item_expand (l)
			hb_name.extend (extracted_method_name_field)

			vb.extend (hb_class)
			vb.extend (hb_start)
			vb.extend (hb_end)
			vb.extend (hb_name)

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

	start_line: INTEGER
			-- Start line as typed in by the user
		do
			if start_line_field.text.is_integer then
				Result := start_line_field.text.to_integer
			else
				-- fixme: show error
			end
		end

	end_line: INTEGER
			-- End line as typed in by the user
		do
			if end_line_field.text.is_integer then
				Result := end_line_field.text.to_integer
			else
				-- fixme: show error
			end
		end

	extracted_method_name: STRING
			-- Name of extracted method
		do
			Result := extracted_method_name_field.text
		end

feature -- Element change

	set_start_line(a_line: INTEGER)
			-- set start line to `a_line'
		do
			start_line_field.set_text (a_line.out)
		end

	set_end_line(a_line: INTEGER)
			-- set end line to `a_line'
		do
			end_line_field.set_text (a_line.out)
		end

	set_extracted_method_name(a_name: STRING)
			-- set name of extracted method to `a_name'
		require
			not_void: a_name /= void
		do
			extracted_method_name_field.set_text (a_name)
		end

	set_class(a_name: STRING)
			-- set name of class to `a_name'
		require
			not_void: a_name /= void
		do
			class_field.set_text (a_name)
		end

feature {NONE} -- Implementation

	on_show
			-- Triggered when the dialog is shown.
		do
			start_line_field.set_focus
		end

	start_line_field: EV_TEXT_FIELD
	class_field: EV_TEXT_FIELD
	end_line_field: EV_TEXT_FIELD
	extracted_method_name_field: EV_TEXT_FIELD

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
