note
	description: "Summary description for {ERF_EXTRACT_METHOD_DIALOG}."
	author: ""
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
			fvb, vb_top, vb_label, vb_text_field: EV_VERTICAL_BOX
			hb, hb_name, hb_old: EV_HORIZONTAL_BOX
			f_top, f_bottom: EV_FRAME
			l: EV_LABEL
			sep: EV_HORIZONTAL_SEPARATOR

			vb: EV_VERTICAL_BOX
		do
			Precursor
			set_title (interface_names.t_refactoring_extract_method)
			set_icon_pixmap (pixmaps.icon_pixmaps.general_dialog_icon)

			create vb
			vb.set_padding (Layout_constants.small_padding_size)
			vb.set_border_width (Layout_constants.default_border_size)

			create start_line_field
			vb.extend (start_line_field)
			vb.disable_item_expand (start_line_field)
			create end_line_field
			vb.extend (end_line_field)
			vb.disable_item_expand (end_line_field)
			create extracted_method_name_field
			vb.extend (extracted_method_name_field)
			vb.disable_item_expand (extracted_method_name_field)


--			create f_top
--			create vb_top
----			vb_top.set_padding (Layout_constants.small_padding_size)
--			create current_name
--			create hb_old
----			hb_old.extend (current_name)
----			hb_old.disable_item_expand (current_name)
----			vb_top.extend (create {EV_CELL})
----			vb_top.extend (hb_old)
--			create sep
----			vb_top.extend (sep)
----			vb_top.disable_item_expand (sep)
--			create vb_label
----			vb_label.set_padding (Layout_constants.small_padding_size)
----			vb_label.set_border_width (Layout_constants.default_border_size)
--			create hb_name
--			create l.make_with_text (interface_names.l_new_name)
----			vb_label.extend (l)
----			vb_label.disable_item_expand (l)
----			vb_label.extend (create {EV_CELL})
----			hb_name.extend (vb_label)
----			hb_name.disable_item_expand (vb_label)
--			create vb_text_field
----			vb_text_field.set_padding (Layout_constants.small_padding_size)
----			vb_text_field.set_border_width (Layout_constants.default_border_size)
--			create name_field
----			vb_text_field.extend (name_field)
----			vb_text_field.disable_item_expand (name_field)
----			hb_name.extend (vb_text_field)
----			vb_top.extend (hb_name)
----			vb_top.disable_item_expand (hb_name)
----			f_top.extend (vb_top)
----			vb.extend (f_top)

--			create f_middle
--			create fvb
----			fvb.set_padding (Layout_constants.small_padding_size)
----			fvb.set_border_width (Layout_constants.default_border_size)
----			f_middle.extend (fvb)
--			create compiled_classes_button.make_with_text (interface_names.l_compiled_classes)
----			compiled_classes_button.set_tooltip (interface_names.h_refactoring_compiled)
----			compiled_classes_button.enable_select
----			fvb.extend (compiled_classes_button)
--			create all_classes_button.make_with_text (interface_names.l_all_classes)
----			all_classes_button.set_tooltip (interface_names.h_refactoring_all_classes)
----			fvb.extend (all_classes_button)
----			vb.extend (f_middle)

--			create f_bottom
--			create fvb
----			fvb.set_padding (Layout_constants.small_padding_size)
----			fvb.set_border_width (Layout_constants.default_border_size)
----			f_bottom.extend (fvb)
--			create rename_file_button.make_with_text (interface_names.l_rename_file)
----			fvb.extend (rename_file_button)
--			create comments_button.make_with_text (interface_names.l_replace_comments)
----			fvb.extend (comments_button)
--			create strings_button.make_with_text (interface_names.l_replace_strings)
----			fvb.extend (strings_button)
----			vb.extend (f_bottom)

			create hb
			vb.extend (hb)
			vb.disable_item_expand (hb)
			extend (vb)
			hb.set_padding (Layout_constants.small_padding_size)
			hb.extend (create {EV_CELL})

			create ok_button.make_with_text_and_action (Interface_names.b_ok, agent on_ok_pressed)
			create cancel_button.make_with_text_and_action (Interface_names.b_cancel, agent on_cancel_pressed)
			extend_button (hb, ok_button)
			extend_button (hb, cancel_button)

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

feature {NONE} -- Implementation

	on_show
			-- Triggered when the dialog is shown.
		do
			start_line_field.set_focus
		end

	start_line_field: EV_TEXT_FIELD
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
