note
	description: "Summary description for {ERF_EXTRACT_METHOD_DIALOG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_CREATE_SETTER_DIALOG
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
	EB_SHARED_PREFERENCES
		rename
			preferences as es_preferences
		undefine
			copy, default_create
		end
	SHARED_EDITOR_FONT
		undefine
			copy, default_create
		end

feature {NONE} -- Initialization

	initialize
			-- Build interface.
		local
			l: EV_LABEL
			hb_setter_name, hb_arg_name, hb_buttons, hb_middle: EV_HORIZONTAL_BOX
			vb, vb_radio, vb_predef: EV_VERTICAL_BOX
			space: EV_CELL
		do
			Precursor
			set_title ("Create custom setter")
			set_icon_pixmap (pixmaps.icon_pixmaps.general_dialog_icon)

			-- VB's
			create vb
			vb.set_padding (Layout_constants.small_padding_size)
			vb.set_border_width (Layout_constants.default_border_size)
			create vb_radio
			vb_radio.set_padding (Layout_constants.small_padding_size)
			create vb_predef
			vb_predef.set_padding (Layout_constants.small_padding_size)

			-- HB's
			create hb_setter_name
			hb_setter_name.set_padding (Layout_constants.small_padding_size)
			create hb_arg_name
			hb_arg_name.set_padding (Layout_constants.small_padding_size)
			create hb_middle
			hb_middle.set_padding (Layout_constants.small_padding_size)

			-- Controls
			create assignment_field
			assignment_field.set_minimum_width (200)
			create postcondition_field
			postcondition_field.set_minimum_width (200)
			create setter_name_field
			create argument_name_field
			create direct_assignment_radio
			direct_assignment_radio.set_text ("Direct assignment")
			create twin_assignment_radio
			twin_assignment_radio.set_text ("Twin assignment")
			create deep_twin_assignment_radio
			deep_twin_assignment_radio.set_text ("Deep twin assignment")
			create custom_assignment_radio
			custom_assignment_radio.set_text ("Custom assignment")
			create preview_text
			preview_text.disable_edit
			preview_text.set_current_format (text_format_normal)
			preview_text.set_tab_width (es_preferences.editor_data.tabulation_spaces*preview_text.font.width)
			preview_text.set_minimum_height (150)
			preview_text.disable_word_wrapping
			create use_as_assigner_checkbox
			use_as_assigner_checkbox.set_text ("Use as assigner")

			-- Layout
			create l.make_with_text ("Setter name:")
			hb_setter_name.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_setter_name.disable_item_expand (l)
			hb_setter_name.extend (setter_name_field)
			vb.extend (hb_setter_name)

			create l.make_with_text ("Argument name:")
			hb_arg_name.extend (l)
			l.set_minimum_width (150)
			l.align_text_left
			hb_arg_name.disable_item_expand (l)
			hb_arg_name.extend (argument_name_field)
			vb.extend (hb_arg_name)

			create space
			space.set_minimum_height (10)
			vb.extend (space)

			vb_radio.extend (direct_assignment_radio)
			vb_radio.extend (twin_assignment_radio)
			vb_radio.extend (deep_twin_assignment_radio)
			vb_radio.extend (custom_assignment_radio)
			vb_radio.set_minimum_width (150)

			create l.make_with_text ("Assignment:")
			vb_predef.extend (l)
			vb_predef.extend (assignment_field)
			create l.make_with_text ("Postcondition:")
			vb_predef.extend (l)
			vb_predef.extend (postcondition_field)

			hb_middle.extend (vb_radio)
			hb_middle.disable_item_expand (vb_radio)
			hb_middle.extend (vb_predef)
			vb.extend (hb_middle)

			create l.make_with_text ("Preview")
			l.align_text_left
			vb.extend (l)
			vb.extend (preview_text)

			create space
			space.set_minimum_height (10)
			vb.extend (space)
			vb.extend (use_as_assigner_checkbox)

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

	setter_name: STRING
		do
			Result := setter_name_field.text
		end

	argument_name: STRING
		do
			Result := argument_name_field.text
		end

	postcondition: STRING
		do
			Result := postcondition_field.text
		end

	assignment: STRING
		do
			Result := assignment_field.text
		end

	use_as_assigner: BOOLEAN
		do
			Result := use_as_assigner_checkbox.is_selected
		end

feature -- Element change

	set_use_as_assigner(a_val: BOOLEAN)
		do
			if use_as_assigner_checkbox.is_selected /= a_val then
				use_as_assigner_checkbox.toggle
			end
		end

	set_setter_name(a_str: STRING)
		do
			setter_name_field.set_text (a_str)
		end

	set_argument_name(a_str: STRING)
		do
			argument_name_field.set_text (a_str)
		end

	set_postcondition(a_str: STRING)
		do
			postcondition_field.set_text (a_str)
		end

	set_assignment(a_str: STRING)
		do
			assignment_field.set_text (a_str)
		end

	set_feature_name(a_name: STRING)
		do
			feature_name := a_name
		end

feature {NONE} -- Event handling

	update_disabled: BOOLEAN

	update_fields
			-- updates pre & postcondition fields
		do
			update_disabled := true
			if direct_assignment_radio.is_selected then
				set_assignment (feature_name + " := " + argument_name)
				set_postcondition (feature_name + " = " + argument_name)
				assignment_field.disable_edit
				postcondition_field.disable_edit
			elseif twin_assignment_radio.is_selected then
				set_assignment (feature_name + " := " + argument_name + ".twin")
				set_postcondition (feature_name + " ~ " + argument_name)
				assignment_field.disable_edit
				postcondition_field.disable_edit
			elseif deep_twin_assignment_radio.is_selected then
				set_assignment (feature_name + " := " + argument_name + ".deep_twin")
				set_postcondition (feature_name + ".is_deep_equal(" + argument_name + ")")
				assignment_field.disable_edit
				postcondition_field.disable_edit
			else -- custom
				assignment_field.enable_edit
				postcondition_field.enable_edit
			end

			update_disabled := false
			update_preview
		end

	update_preview
			-- updates the preview-window
		do
			if not update_disabled then
				preview_text.remove_text

				add_preview_normal (setter_name + " (" + argument_name + ": ")
				add_preview_keyword ("like")
				add_preview_normal (" "+feature_name+")%N%T%T")
				add_preview_comment ("-- Set ")
				add_preview_normal ("`"+feature_name+"'")
				add_preview_comment (" to ")
				add_preview_normal ("`"+argument_name+"'")
				add_preview_comment (".")
				add_preview_normal ("%N%T")
				add_preview_keyword ("do")
				add_preview_normal ("%N%T%T"+assignment+"%N%T")
				add_preview_keyword ("ensure")
				add_preview_normal ("%N%T%T"+feature_name+"_set: "+postcondition+"%N%T")
				add_preview_keyword ("end")
			end
		end

feature {NONE} -- Formats

	add_with_format(a_text: STRING; a_format: EV_CHARACTER_FORMAT)
		local
			l_start: INTEGER
		do
			l_start := preview_text.caret_position
			preview_text.append_text (a_text)
			preview_text.set_caret_position (preview_text.text_length)
			preview_text.select_region (l_start, preview_text.caret_position)
			preview_text.set_current_format (a_format)
		end

	add_preview_keyword(a_text: STRING)
		do
			add_with_format(a_text, text_format_keyword)
		end

	add_preview_comment(a_text: STRING)
		do
			add_with_format(a_text, text_format_comment)
		end

	add_preview_normal(a_text: STRING)
		do
			add_with_format(a_text, text_format_normal)
		end

	text_format_normal: EV_CHARACTER_FORMAT
		once
			create Result

			Result.set_color (es_preferences.editor_data.normal_text_color)
			Result.set_background_color (es_preferences.editor_data.normal_background_color)
			Result.set_font (calculate_font_with_zoom_factor)
		end

	text_format_comment: EV_CHARACTER_FORMAT
		once
			create Result
			Result.set_color (es_preferences.editor_data.comments_text_color)
			Result.set_background_color (es_preferences.editor_data.comments_background_color)
			Result.set_font (calculate_font_with_zoom_factor)
		end

	text_format_keyword: EV_CHARACTER_FORMAT
		once
			create Result
			Result.set_color (es_preferences.editor_data.keyword_text_color)
			Result.set_background_color (es_preferences.editor_data.keyword_background_color)
			Result.set_font (calculate_keyword_font_with_zoom_factor)
		end

feature {NONE} -- Implementation

	ok_button: EV_BUTTON
			-- Button with label "OK".

	cancel_button: EV_BUTTON
			-- Button with label "Cancel".

	feature_name: STRING
			-- name of the attribute

	direct_assignment_radio: EV_RADIO_BUTTON
	twin_assignment_radio: EV_RADIO_BUTTON
	deep_twin_assignment_radio: EV_RADIO_BUTTON
	custom_assignment_radio: EV_RADIO_BUTTON

	setter_name_field: EV_TEXT_FIELD
	argument_name_field: EV_TEXT_FIELD
	assignment_field: EV_TEXT_FIELD
	postcondition_field: EV_TEXT_FIELD

	use_as_assigner_checkbox: EV_CHECK_BUTTON

	preview_text: EV_RICH_TEXT

	on_show
			-- Triggered when the dialog is shown.
		do
			set_argument_name ("a_"+feature_name)
			set_setter_name ("set_"+feature_name)

			twin_assignment_radio.select_actions.extend (agent update_fields)
			direct_assignment_radio.select_actions.extend (agent update_fields)
			deep_twin_assignment_radio.select_actions.extend (agent update_fields)
			custom_assignment_radio.select_actions.extend (agent update_fields)

			setter_name_field.change_actions.extend (agent update_preview)

			argument_name_field.change_actions.extend (agent update_fields)
			assignment_field.change_actions.extend (agent update_preview)
			postcondition_field.change_actions.extend (agent update_preview)

			setter_name_field.set_focus
			direct_assignment_radio.enable_select
		end

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
