indexing
	description: "Summary description for {ES_EBBRO_NAMES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_NAMES

feature -- Constants - labels

	label_object_decoded:STRING is "Object decoded."

	label_decoding_object:STRING is "Decoding object..."

	label_decoding_error:STRING is "Decoding error."

	label_startup:STRING is ""

	label_filter:STRING is "Filter "

	label_out_filter:STRING is "[OUT]"

	label_in_filter:STRING is "[IN]"

	label_none_filter:STRING is "None"

	label_void_filter:STRING is "Void"

	label_cycle_filter:STRING is "Cycle"

	l_custom_serialization_selection:STRING is "Select attributes to serialize:"

	l_custom_serialization_selection_2:STRING is "Select:"

	l_custom_serialization_output_copy:STRING is "Copy the following source code:"

	l_object_comparer_1:STRING is "Object 1"

	l_object_comparer_2:STRING is "Object 2"

feature -- Constants - Messages

	m_overwrite_object_file:STRING is "Do you really want to overwrite the original object file?"

	m_custom_serialization_stone:STRING is "Custom serialization generator only works with compiled classes."



feature -- Constants - Interface Names

	t_custom_serialization_dialog:STRING is "Custom Serialization"

	t_custom_serialization_output_dialog:STRING is "Custom Serialization - Output"

	t_object_comparer_dialog:STRING is "Select two Object Files to compare"


	Menu_view_item: STRING is "&View"
			-- String for menu "View"

	Menu_view_addr_item: STRING is "&Show Address Column"
			-- String for menu "Help/show addr"

	Menu_advanced_item: STRING is "&Preferences"
			-- String for menu "Advanced"

	Menu_advanced_addr_item: STRING is "&Update addresses"
			-- String for menu "Advanced/update addresses"

	Menu_advanced_cyclic_item:STRING is "&Enable cyclic browsing"
			-- String for menu "Advanced/Enable cyclic browsing"

	menu_view_split_item:STRING is "&Split screen"
			-- string for menu "View/split screen"

	menu_advanced_filter_options:STRING is "&Filter Options"
			-- string for menu advanced/filter options

	menu_advanced_filter_in:STRING is "&Filter In"
			--string filter options/filter in

	menu_advanced_filter_out:STRING is "&Filter Out"
			--string filter options/filter out

	button_custom_selection_all:STRING is "All"

	button_custom_selection_none:STRING is "None"

	button_custom_selection_invert:STRING is "Invert"

	b_custom_serialization_copy:STRING is "Copy All"

feature -- tooltips

	tt_custom_selection_all: !STRING = "Select all attributes"
	tt_custom_selection_none: !STRING = "Select none"
	tt_custom_selection_invert: !STRING = "Invert current selection"
	tt_custom_serialization_copy:!STRING = "Copy all code to clipboard"

feature -- Internationalization

	f_open_button: !STRING = "Open an Object File"
	f_move_right_button: !STRING = "Move selected root-object to the right"
	f_move_left_button: !STRING = "Move selected root-object to the left"
	f_delete_button: !STRING = "Remove selected root-object (Del)"
	f_custom_serialization_button: !STRING = "Create custom serialization [Click or drop class on this button]"
	f_object_compare_button:!STRING = "Compare two Object Files"
	f_redo_button:!STRING = "Redo edit operation on selected root-object"
	f_undo_button:!STRING = "Undo edit operation on selected root-object"



;indexing
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
