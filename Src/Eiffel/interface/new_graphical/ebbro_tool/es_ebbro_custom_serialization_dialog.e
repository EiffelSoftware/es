note
	description: "Dialog to let user select attributes for custom serialized form feature."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_CUSTOM_SERIALIZATION_DIALOG

inherit
	ES_DIALOG

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		undefine
			default_create, copy
		end

	ES_EBBRO_NAMES

create
	make_with_name

feature --init

	make_with_name (a_class_name: STRING)
			-- init
		require
			valid_name:a_class_name /= void and not a_class_name.is_empty
		do
			create class_name.make_from_string (a_class_name)
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
			Result := t_custom_serialization_dialog
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

	prepare (a_container: EV_VERTICAL_BOX)
			-- Create the controls and setup the layout
		local
			controls_box: EV_VERTICAL_BOX
			selection_box:EV_HORIZONTAL_BOX
			l_layouts: EV_LAYOUT_CONSTANTS
			l_name,l_label:EV_LABEL
			l_button:EV_BUTTON
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

			create l_label.make_with_text (l_custom_serialization_selection)
			controls_box.extend (l_label)
			controls_box.disable_item_expand (l_label)


				-- Create the controls.
			create feature_check_list
			fill_feature_check_list
			controls_box.extend(feature_check_list)

			-- selection box
			create selection_box
			create l_label.make_with_text (l_custom_serialization_selection_2)
			selection_box.extend (l_label)
			selection_box.disable_item_expand (l_label)

			create l_button.make_with_text_and_action (button_custom_selection_all, agent on_select_all)
			l_button.set_tooltip (tt_custom_selection_all)
			selection_box.extend(l_button)
			selection_box.disable_item_expand (l_button)

			create l_button.make_with_text_and_action (button_custom_selection_none, agent on_select_none)
			l_button.set_tooltip (tt_custom_selection_none)
			selection_box.extend(l_button)
			selection_box.disable_item_expand (l_button)

			create l_button.make_with_text_and_action (button_custom_selection_invert, agent on_select_invert)
			l_button.set_tooltip (tt_custom_selection_invert)
			selection_box.extend(l_button)
			selection_box.disable_item_expand (l_button)

			controls_box.extend (selection_box)
			controls_box.disable_item_expand (selection_box)
			a_container.extend (controls_box)
		end

feature -- Access

	selected: BOOLEAN
			-- Has the user selected a class (True) or pushed
			-- the cancel button (False)?

	attribute_list: ARRAYED_LIST [STRING]
			-- attributes which were selected

	is_valid: BOOLEAN
			-- checks whether the selection can be generated or not
		do
			Result := get_class_i.compiled_class /= void
		end


feature {NONE} -- Implementation

	class_name: STRING
			-- name of the class

	fill_feature_check_list
			-- fill the feature_check_list control with the attributes from 'class_name'
		local
			l_internal: INTERNAL
			l_class: CLASS_C
			l_table: COMPUTED_FEATURE_TABLE
			l_feature: FEATURE_I
			l_item: EV_LIST_ITEM
		do
			create l_internal
			l_class := get_class_i.compiled_class
			if l_class /= void then

				l_table := l_class.feature_table.features
				from
					l_table.start
				until
					l_table.after
				loop
					l_feature := l_table.item
					if l_feature.is_attribute then
						create l_item.make_with_text (l_feature.feature_name+" ("+l_feature.type.name+")")
						l_item.set_data (l_feature.feature_name)
						l_item.set_tooltip (generate_item_tooltip(l_feature.type.name,l_feature.e_feature.feature_signature))
						feature_check_list.extend(l_item)
					end
					l_table.forth
				end
			else
				-- class not yet compiled
			end

		end

	get_class_i: CLASS_I
			-- Find the corresponding class_i, depending on the name.
		local
			loc_list: LIST [CLASS_I]
		do
			if eiffel_universe.target /= Void then
				loc_list := Eiffel_universe.classes_with_name (class_name)
			end

				-- Return the first element of the list.
			if loc_list /= Void and then not loc_list.is_empty then
				Result := loc_list.first
			end
		end

	generate_item_tooltip (a_type_str:STRING;a_signature:STRING): STRING
			-- create the tooltip for a ev_item -> which is holding an attribtue
		do
			create Result.make_empty
			Result.append ("Type: "+a_type_str+"%N")
			Result.append ("Signature: "+a_signature+"%N")
		end



feature {NONE} -- actions

	on_select_all
			-- select all attributes
		do
			feature_check_list.do_all (agent select_item(?))
		end

	select_item (a_item: EV_LIST_ITEM)
			-- select item in feature_check_list
		do
			feature_check_list.check_item (a_item)
		end

	on_select_none
			-- select all attributes
		do
			feature_check_list.do_all (agent unselect_item(?))
		end

	unselect_item (a_item: EV_LIST_ITEM)
			-- unselect selection
		do
			feature_check_list.uncheck_item (a_item)
		end

	on_select_invert
			-- select all attributes
		do
			feature_check_list.do_all (agent invert_item(?))
		end

	invert_item (a_item: EV_LIST_ITEM)
			-- invert selection
		do
			if feature_check_list.is_item_checked (a_item) then
				feature_check_list.uncheck_item (a_item)
			else
				feature_check_list.check_item (a_item)
			end

		end


feature {NONE} -- Vision2 events

	on_ok
			-- Terminate the dialog.
		local
			l_list: DYNAMIC_LIST [EV_LIST_ITEM]
		do
			l_list := feature_check_list.checked_items
			selected := true
			if not l_list.is_empty then
				create attribute_list.make (l_list.count)

				from
					l_list.start
				until
					l_list.after
				loop
					attribute_list.extend (l_list.item.data.out)
					l_list.forth
				end
			else
				-- no attribute is selected
				veto_close
			end

		end

	on_cancel
			-- Terminate the dialog and clear the selection.
		do
			selected := False
			dialog.destroy
		end


feature {NONE} -- Controls

	feature_check_list: EV_CHECKABLE_LIST
			-- list with the attributes corresponding to a class_name


invariant

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
