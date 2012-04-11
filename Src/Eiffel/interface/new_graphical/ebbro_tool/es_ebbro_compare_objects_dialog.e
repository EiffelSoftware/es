indexing
	description: "Dialog to let user select two object files."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_COMPARE_OBJECTS_DIALOG

inherit
	ES_DIALOG

	ES_EBBRO_NAMES

create
	make

feature --init


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
			Result := t_object_comparer_dialog
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
			controls_box,vb: EV_VERTICAL_BOX
			l_layouts: EV_LAYOUT_CONSTANTS
			hb: EV_HORIZONTAL_BOX
			b: EV_BUTTON
			project_directory_frame: EV_FRAME
		do
			create l_layouts

			set_button_action_before_close ({ES_DIALOG_BUTTONS}.ok_button, agent on_ok)
			set_button_action ({ES_DIALOG_BUTTONS}.cancel_button, agent on_cancel)

			create controls_box
			controls_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)
			controls_box.set_border_width ({ES_UI_CONSTANTS}.dialog_border)


			-- Object 1
			create project_directory_frame.make_with_text (l_object_comparer_1)
			create vb
			vb.set_border_width (l_layouts.Small_border_size)
			vb.set_padding ({ES_UI_CONSTANTS}.vertical_padding)

			create object1_field
			object1_field.set_minimum_width (400)

			create b.make_with_text_and_action (Interface_names.b_Browse, agent browse_object(true))
			create hb
			hb.set_padding_width ({ES_UI_CONSTANTS}.horizontal_padding)
			hb.extend (object1_field)
			hb.extend (b)
			hb.disable_item_expand (b)
			vb.extend (hb)
			vb.disable_item_expand (hb)
			project_directory_frame.extend (vb)
			controls_box.extend (project_directory_frame)

			-- Object 2
			create project_directory_frame.make_with_text (l_object_comparer_2)
			create vb
			vb.set_border_width (l_layouts.Small_border_size)
			vb.set_padding ({ES_UI_CONSTANTS}.vertical_padding)

			create object2_field
			object2_field.set_minimum_width (400)

			create b.make_with_text_and_action (Interface_names.b_Browse, agent browse_object(false))
			create hb
			hb.set_padding_width ({ES_UI_CONSTANTS}.horizontal_padding)
			hb.extend (object2_field)
			hb.extend (b)
			hb.disable_item_expand (b)
			vb.extend (hb)
			vb.disable_item_expand (hb)
			project_directory_frame.extend (vb)
			controls_box.extend (project_directory_frame)


			a_container.extend (controls_box)
		end

feature -- Access

	selected: BOOLEAN
			-- Has the user selected a class (True) or pushed
			-- the cancel button (False)?

	object1_file_name: STRING

	object2_file_name: STRING

feature {NONE} -- Implementation


feature {NONE} -- actions

	browse_object (is_first_object: BOOLEAN) is
			-- open browse for object dialog
		local
			l_dialog: EB_FILE_OPEN_DIALOG
			l_diag_fact: ES_EBBRO_DIALOG_FACTORY
		do
			create l_diag_fact
			l_dialog := l_diag_fact.open_object_dialog

			l_dialog.show_modal_to_window (dialog)
			if l_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_open) then
				if is_first_object then
					object1_field.set_text (l_dialog.file_name)
				else
					object2_field.set_text (l_dialog.file_name)
				end
			end
		end



feature {NONE} -- Vision2 events

	on_ok is
			-- Terminate the dialog.
		local
			l_file1,l_file2: RAW_FILE
		do
			selected := true

			if object1_field.text_length > 0 and object2_field.text_length > 0 then

				create l_file1.make (object1_field.text)
				create l_file2.make (object2_field.text)
				if l_file1.exists and l_file2.exists then
					create object1_file_name.make_from_string (object1_field.text)
					create object2_file_name.make_from_string (object2_field.text)
				else
					veto_close
				end
			else
				veto_close
			end

		end

	on_cancel is
			-- Terminate the dialog and clear the selection.
		do
			selected := False
			dialog.destroy
		end


feature {NONE} -- Controls

	object1_field: EV_TEXT_FIELD

	object2_field: EV_TEXT_FIELD


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
