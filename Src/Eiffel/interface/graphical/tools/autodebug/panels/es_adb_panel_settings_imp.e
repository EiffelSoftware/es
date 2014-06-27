note
	description: "Summary description for {ES_ADB_SETTINGS_PANEL_IMP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ES_ADB_PANEL_SETTINGS_IMP

inherit
	EV_HORIZONTAL_BOX
		redefine
			initialize
		end

	ES_ADB_PANEL_ABSTRACT

	ES_ADB_INTERFACE_STRINGS

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		local
			l_frame: EV_FRAME
			l_v_box, l_internal_v_box, l_v_space: EV_VERTICAL_BOX
			l_h_box, l_internal_h_box, l_h_space: EV_HORIZONTAL_BOX
			l_label: EV_LABEL
			l_font, l_font_larger: EV_FONT
		do
			Precursor {EV_HORIZONTAL_BOX}
			set_padding({ES_UI_CONSTANTS}.horizontal_padding)

			-- Left
			create l_v_box
			l_v_box.set_minimum_size (300, 300)
			l_v_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create evtext_group_to_add
			l_internal_h_box.extend (evtext_group_to_add)
			create evbutton_add.make_with_text (Button_text_add)
			evbutton_add.set_minimum_width (40)
			l_internal_h_box.extend (evbutton_add)
			l_internal_h_box.disable_item_expand (evbutton_add)
			l_v_box.extend (l_internal_h_box)
			l_v_box.disable_item_expand (l_internal_h_box)

			create evlist_groups_to_debug
			l_v_box.extend (evlist_groups_to_debug)

			create evlist_classes_in_group
			evlist_classes_in_group.set_minimum_height (100)
			l_v_box.extend (evlist_classes_in_group)
			l_v_box.disable_item_expand (evlist_classes_in_group)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label.make_with_text ("")
			l_internal_h_box.extend (l_label)
			create evbutton_remove.make_with_text (Button_text_remove)
			evbutton_remove.set_minimum_width (80)
			l_internal_h_box.extend (evbutton_remove)
			l_internal_h_box.disable_item_expand (evbutton_remove)
			create evbutton_remove_all.make_with_text (Button_text_remove_all)
			evbutton_remove_all.set_minimum_width (80)
			l_internal_h_box.extend (evbutton_remove_all)
			l_internal_h_box.disable_item_expand (evbutton_remove_all)
			l_v_box.extend (l_internal_h_box)
			l_v_box.disable_item_expand (l_internal_h_box)

			create l_frame
			l_frame.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			l_frame.set_text (Frame_text_classes_to_debug)
			l_frame.extend (l_v_box)
			extend (l_frame)

				-- Middle
			create l_v_box
			l_v_box.set_minimum_size (300, 300)
			l_v_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)

					-- General
			create l_internal_v_box
			l_internal_v_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)
			create l_label.make_with_text (Label_text_working_directory)
			l_label.align_text_left
			l_internal_v_box.extend (l_label)
			l_internal_v_box.disable_item_expand (l_label)
			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create evtext_working_directory
			l_internal_h_box.extend (evtext_working_directory)
			create evbutton_browse.make_with_text ("...")
			evbutton_browse.set_minimum_width (40)
			l_internal_h_box.extend (evbutton_browse)
			l_internal_h_box.disable_item_expand (evbutton_browse)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_frame.make_with_text (Frame_text_general)
			l_frame.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			l_frame.extend (l_internal_v_box)
			l_v_box.extend (l_frame)
			l_v_box.disable_item_expand (l_frame)
			create l_v_space
			l_v_box.extend (l_v_space)

					-- Testing
			create l_internal_v_box
			l_internal_v_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)
			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label.make_with_text (label_text_maximum_session_length_for_testing)
			l_label.align_text_left
			l_internal_h_box.extend (l_label)
			create evtext_testing_cutoff_time
			evtext_testing_cutoff_time.set_minimum_width (40)
			l_internal_h_box.extend (evtext_testing_cutoff_time)
			l_internal_h_box.disable_item_expand (evtext_testing_cutoff_time)

			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label.make_with_text (Label_text_each_session_tests)
			l_label.align_text_left
			l_internal_h_box.extend (l_label)
			create evcombo_testing_session_type.make_with_strings (<<combobox_text_test_session_type_one_class, combobox_text_test_session_type_one_group, combobox_text_test_session_type_all_classes>>)
			evcombo_testing_session_type.disable_edit
			evcombo_testing_session_type.set_minimum_width (200)
			l_internal_h_box.extend (evcombo_testing_session_type)
			l_internal_h_box.disable_item_expand (evcombo_testing_session_type)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create evcheckbutton_testing_use_fixed_seed.make_with_text (Checkbutton_text_testing_use_fixed_seed)
			l_internal_h_box.extend (evcheckbutton_testing_use_fixed_seed)
			create evtext_testing_seed
			evtext_testing_seed.set_minimum_width (40)
			l_internal_h_box.extend (evtext_testing_seed)
			l_internal_h_box.disable_item_expand (evtext_testing_seed)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)
			create l_frame.make_with_text (Frame_text_testing)
			l_frame.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			l_frame.extend (l_internal_v_box)
			l_v_box.extend (l_frame)
			l_v_box.disable_item_expand (l_frame)
			create l_v_space
			l_v_box.extend (l_v_space)

					-- Fixing
			create l_internal_v_box
			l_internal_v_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label.make_with_text (Label_text_start_fixing)
			l_label.align_text_left
			l_internal_h_box.extend (l_label)
			create evcombo_start_fixing_type.make_with_strings (<<Combobox_text_start_fixing_type_after_each_testing_session, Combobox_text_start_fixing_type_after_all_testing_sessions, Combobox_text_start_fixing_type_manually>>)
			evcombo_start_fixing_type.disable_edit
			evcombo_start_fixing_type.set_minimum_width (200)
			l_internal_h_box.extend (evcombo_start_fixing_type)
			l_internal_h_box.disable_item_expand (evcombo_start_fixing_type)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label.make_with_text (label_text_maximum_session_length_for_fixing)
			l_label.align_text_left
			l_internal_h_box.extend (l_label)
			create evtext_fixing_cutoff_time
			evtext_fixing_cutoff_time.set_minimum_width (40)
			l_internal_h_box.extend (evtext_fixing_cutoff_time)
			l_internal_h_box.disable_item_expand (evtext_fixing_cutoff_time)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label.make_with_text (Label_text_fixing_number_of_fixes)
			l_label.align_text_left
			l_internal_h_box.extend (l_label)
			create evtext_fixing_number_of_fixes
			evtext_fixing_number_of_fixes.set_minimum_width (40)
			l_internal_h_box.extend (evtext_fixing_number_of_fixes)
			l_internal_h_box.disable_item_expand (evtext_fixing_number_of_fixes)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label
			l_label.set_minimum_width ({ES_UI_CONSTANTS}.sub_widget_indent_width)
			l_internal_h_box.extend (l_label)
			l_internal_h_box.disable_item_expand (l_label)
			create evcheckbutton_fixing_implementation.make_with_text (Checkbutton_text_fixing_implementation)
			l_internal_h_box.extend (evcheckbutton_fixing_implementation)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label
			l_label.set_minimum_width ({ES_UI_CONSTANTS}.sub_widget_indent_width)
			l_internal_h_box.extend (l_label)
			l_internal_h_box.disable_item_expand (l_label)
			create evcheckbutton_fixing_contracts.make_with_text (checkbutton_text_fixing_contracts)
			l_internal_h_box.extend (evcheckbutton_fixing_contracts)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_label.make_with_text (Label_text_fixing_number_of_tests)
			l_label.align_text_left
			l_internal_v_box.extend (l_label)
			l_internal_v_box.disable_item_expand (l_label)

			create l_internal_h_box
			l_internal_h_box.set_padding ({ES_UI_CONSTANTS}.horizontal_padding)
			create l_label
			l_label.set_minimum_width ({ES_UI_CONSTANTS}.sub_widget_indent_width)
			l_internal_h_box.extend (l_label)
			l_internal_h_box.disable_item_expand (l_label)

			create l_h_box
			create l_label.make_with_text (Label_text_fixing_passing_tests)
			l_label.align_text_left
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			create evtext_fixing_passing_tests
			evtext_fixing_passing_tests.set_minimum_width (40)
			l_h_box.extend (evtext_fixing_passing_tests)
			l_h_box.disable_item_expand (evtext_fixing_passing_tests)
			l_internal_h_box.extend (l_h_box)

			create l_h_box
			create l_label.make_with_text (Label_text_fixing_failing_tests)
			l_label.align_text_left
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			create evtext_fixing_failing_tests
			evtext_fixing_failing_tests.set_minimum_width (40)
			l_h_box.extend (evtext_fixing_failing_tests)
			l_h_box.disable_item_expand (evtext_fixing_failing_tests)
			l_internal_h_box.extend (l_h_box)
			l_internal_v_box.extend (l_internal_h_box)
			l_internal_v_box.disable_item_expand (l_internal_h_box)

			create l_frame.make_with_text (Frame_text_fixing)
			l_frame.set_border_width ({ES_UI_CONSTANTS}.frame_border)
			l_frame.extend (l_internal_v_box)
			l_v_box.extend (l_frame)
			l_v_box.disable_item_expand (l_frame)
			extend (l_v_box)

				-- Right
			create l_v_box
			l_v_box.set_minimum_width (150)
			l_v_box.set_padding ({ES_UI_CONSTANTS}.vertical_padding)
			l_v_box.set_border_width ({ES_UI_CONSTANTS}.frame_border)

			create l_h_box
			create l_label.make_with_text ("")
			l_label.set_minimum_width (10)
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			create evbutton_load_config.make_with_text (Button_text_load_config)
			evbutton_load_config.set_minimum_width (130)
			l_h_box.extend (evbutton_load_config)
			l_h_box.disable_item_expand (evbutton_load_config)
			create l_label.make_with_text ("")
			l_label.set_minimum_width (10)
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			l_v_box.extend (l_h_box)
			l_v_box.disable_item_expand (l_h_box)

			create l_h_box
			create l_label.make_with_text ("")
			l_label.set_minimum_width (10)
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			create evbutton_save_config.make_with_text (Button_text_save_config)
			evbutton_save_config.set_minimum_width (130)
			l_h_box.extend (evbutton_save_config)
			l_h_box.disable_item_expand (evbutton_save_config)
			create l_label.make_with_text ("")
			l_label.set_minimum_width (10)
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			l_v_box.extend (l_h_box)
			l_v_box.disable_item_expand (l_h_box)

			create l_v_space
			l_v_box.extend (l_v_space)

			create l_h_box
			create l_label.make_with_text ("")
			l_label.set_minimum_width (10)
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			create evbutton_start.make_with_text (Button_text_start)
			evbutton_start.set_minimum_width (130)
			l_font := evbutton_start.font
			create l_font_larger.make_with_values (l_font.family, l_font.weight, l_font.shape, l_font.height)
			l_font_larger.set_weight ({EV_FONT_CONSTANTS}.Weight_bold)
			l_font_larger.set_height (l_font.height + 2)
			evbutton_start.set_font (l_font_larger)
			l_h_box.extend (evbutton_start)
			l_h_box.disable_item_expand (evbutton_start)
			create l_label.make_with_text ("")
			l_label.set_minimum_width (10)
			l_h_box.extend (l_label)
			l_h_box.disable_item_expand (l_label)
			l_v_box.extend (l_h_box)
			l_v_box.disable_item_expand (l_h_box)

			extend (l_v_box)
			disable_item_expand (l_v_box)
		end

feature -- GUI elements

	evtext_group_to_add: EV_TEXT_FIELD

	evlist_groups_to_debug: EV_LIST

	evlist_classes_in_group: EV_LIST

	evbutton_add: EV_BUTTON

	evbutton_remove: EV_BUTTON

	evbutton_remove_all: EV_BUTTON

	evtext_working_directory: EV_TEXT_FIELD

	evbutton_browse: EV_BUTTON

	evtext_testing_cutoff_time: EV_TEXT_FIELD

	evcombo_testing_session_type: EV_COMBO_BOX

	evcheckbutton_testing_use_fixed_seed: EV_CHECK_BUTTON

	evtext_testing_seed: EV_TEXT_FIELD

	evcombo_start_fixing_type: EV_COMBO_BOX

	evtext_fixing_cutoff_time: EV_TEXT_FIELD

	evtext_fixing_number_of_fixes: EV_TEXT_FIELD

	evcheckbutton_fixing_implementation: EV_CHECK_BUTTON

	evcheckbutton_fixing_contracts: EV_CHECK_BUTTON

	evtext_fixing_passing_tests: EV_TEXT_FIELD

	evtext_fixing_failing_tests: EV_TEXT_FIELD

	evbutton_load_config: EV_BUTTON

	evbutton_save_config: EV_BUTTON

	evbutton_start: EV_BUTTON

;note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
