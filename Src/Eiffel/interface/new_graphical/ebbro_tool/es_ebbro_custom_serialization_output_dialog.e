indexing
	description: "Dialog which outputs the generated code for the custom serialization feature."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_CUSTOM_SERIALIZATION_OUTPUT_DIALOG

inherit
	ES_DIALOG

	ES_EBBRO_NAMES


create
	make_with_attributes

feature --init

	make_with_attributes (an_attribute_list: ARRAYED_LIST [STRING_8]; a_class_name: STRING) is
			-- init - provide attribute list and class name
		require
			valid_attributes:an_attribute_list /= void and then not an_attribute_list.is_empty
			valid_name:a_class_name /= void and then not a_class_name.is_empty
		do
			attribute_list := an_attribute_list
			class_name := a_class_name
			make
		end


feature -- Access

	default_button: INTEGER
			-- <Precursor>
		do
			Result := dialog_buttons.ok_button
		end

	icon: EV_PIXEL_BUFFER
			-- <Precursor>
		do
			Result := stock_pixmaps.class_normal_icon_buffer
		end

	default_cancel_button: INTEGER
			-- <Precursor>
		do
			Result := dialog_buttons.cancel_button
		end

	title: STRING_32
			-- <Precursor>
		do
			Result := t_custom_serialization_output_dialog
		end

	buttons: DS_SET [INTEGER]
			-- <Precursor>
		do
			Result := dialog_buttons.ok_cancel_buttons
		end

	default_confirm_button: INTEGER
			-- <Precursor>
		do
			Result := dialog_buttons.ok_button
		end

feature {NONE} -- Initialization

	build_dialog_interface (a_container: EV_VERTICAL_BOX)
			-- <Precursor>
		local

		do
			prepare (a_container)

		ensure then
		end

	prepare (a_container: EV_VERTICAL_BOX) is
			-- Create the controls and setup the layout
		local
			controls_box: EV_VERTICAL_BOX
			selection_box:EV_HORIZONTAL_BOX
			l_layouts: EV_LAYOUT_CONSTANTS
			l_name,l_label: EV_LABEL
			l_button: EV_BUTTON
			code_generator: ES_EBBRO_CODE_GENERATOR
		do
			create l_layouts

			set_button_action_before_close ({ES_DIALOG_BUTTONS}.ok_button, agent on_ok)
			set_button_action ({ES_DIALOG_BUTTONS}.cancel_button, agent on_cancel)

			create controls_box
			controls_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)
			controls_box.set_border_width ({ES_UI_CONSTANTS}.dialog_border)


			create l_name.make_with_text (class_name)
			controls_box.extend (l_name)
			l_name.set_minimum_height (30)
			controls_box.disable_item_expand (l_name)

			create l_label.make_with_text (l_custom_serialization_output_copy)
			controls_box.extend (l_label)
			controls_box.disable_item_expand (l_label)

			-- controls
			create code_generator.make
			create output_widget.make_with_text (code_generator.custom_form_feature (attribute_list, class_name))
			output_widget.set_minimum_height (300)
			output_widget.set_minimum_width (500)
			output_widget.select_all
			controls_box.extend (output_widget)

			-- selection box
			create selection_box
			create l_button.make_with_text_and_action (b_custom_serialization_copy, agent on_copy)
			l_button.set_pixmap (stock_pixmaps.general_copy_icon)
			l_button.set_tooltip (tt_custom_serialization_copy)
			selection_box.extend (l_button)
			selection_box.disable_item_expand (l_button)
			controls_box.extend (selection_box)
			controls_box.disable_item_expand (selection_box)

			a_container.extend (controls_box)
		end

feature -- Access

	selected: BOOLEAN
			-- Has the user selected a class (True) or pushed
			-- the cancel button (False)?

feature {NONE} -- Implementation

	attribute_list: ARRAYED_LIST [STRING]
			-- attributes which were selected

	class_name: STRING
			-- the class name for which the custom serialization is outputed


feature {NONE} -- actions

	on_copy is
			-- copy code to clipboard
		do
			output_widget.select_all
			output_widget.copy_selection
		end




feature {NONE} -- Vision2 events

	on_ok is
			-- Terminate the dialog.
		do
			selected := true
		end

	on_cancel is
			-- Terminate the dialog and clear the selection.
		do
			selected := False
			dialog.destroy
		end


feature {NONE} -- Controls

	output_widget: EV_TEXT


invariant

indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
