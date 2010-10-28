note
	description: "Gui for the filter-related actions."
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SET_FILTER_GUI

feature{NONE} -- Implementation

	dialog: SET_DIALOG_FACTORY
		-- Dialog to show.
	fields: DS_ARRAYED_LIST[TUPLE[EV_TEXT_FIELD,EV_CHECK_BUTTON,STRING]]
		-- List of attributes and corresponding values.
	tree: EV_TREE
		-- The class tree.

feature -- Gui implementation

	filter
			-- First filter window, used to select the class
		local
			version, clas: EV_TREE_ITEM
				-- Current tree items.
			tmp: DS_ARRAYED_LIST[DIRECTORY]
				-- Temporary dirs.
			dir,root_dir: DIRECTORY
				-- Current and root dirs.
			v_panel: EV_VERTICAL_BOX
			h_panel: EV_HORIZONTAL_BOX
			class_name: STRING
			i: INTEGER
			const: SET_UTILITY_AND_CONSTANTS
		do
			create h_panel
			create v_panel
			create const
			create dialog.make ("Please select the class to filter.")
			h_panel.extend (create {EV_BUTTON}.make_with_text_and_action ("Ok", agent create_filter))
			h_panel.extend (create {EV_BUTTON}.make_with_text_and_action ("Cancel", agent dialog.destroy))
			create tree
			from i := 1 until i >= const.releases_count loop
				create version.make_with_text ("release " + (i).out)
				-- TODO: refactor to obey the command-query separation. Is it needed here to copy everything again?
				tmp := const.copy_system_classes(i)
				create root_dir.make (const.repo_dir + const.separator + const.Release_dir_prefix + i.out)
				from tmp.start until tmp.after loop
					dir := tmp.item_for_iteration
					class_name := dir.name.split (const.separator.item (1)).last
					class_name := class_name.substring (1, class_name.count-2).as_upper
					create clas.make_with_text (class_name)
					clas.set_data ([root_dir,dir])
					version.extend (clas)
					tmp.forth
				end
				tree.extend (version)
				i := i + 1
			end
				-- tree creation.
			v_panel.extend(tree)
			v_panel.extend (h_panel)
			v_panel.disable_item_expand (h_panel)
			dialog.extend (v_panel)
			dialog.set_width (200)
			dialog.set_height (300)
			dialog.show
		end

feature{NONE} -- GUI implementation

	create_filter
			-- Second panel, to write the default field value.
		local
			table: DS_HASH_TABLE[STRING,STRING]
				-- Attributes names and types.
			existents: DS_HASH_TABLE[STRING,STRING]
				-- Existing set attributes.
			name: STRING
				-- Attribute name.
			v_box_1, v_box_2, v_box_3: EV_VERTICAL_BOX
			h_box_1, h_box_2: EV_HORIZONTAL_BOX
				-- Panels.
			check_button: EV_CHECK_BUTTON
				-- Check button.
			text_field: EV_TEXT_FIELD
				-- Text field for the default value.
			scroll: EV_SCROLLABLE_AREA
				-- Scroll bar.
			dir, root_dir: DIRECTORY
				-- Current and root dirs.
			tmp: TUPLE [DIRECTORY,DIRECTORY]
			filter_name: STRING
				-- Filter file name.

			const: SET_UTILITY_AND_CONSTANTS
		do
			tmp?=tree.selected_item.data
			dir?=tmp[2]
			root_dir?=tmp[1]
			create const
			if tmp/=Void and root_dir/=Void and dir/=Void then
				dialog.destroy
				create v_box_1
				create v_box_2
				create fields.make_default
				filter_name := dir.name.split (const.separator.item (1)).last
				filter_name.remove_tail (2)
				filter_name.to_upper
				create dialog.make ("Please select fields and values for the class " + filter_name + ".")
				table := const.attributes_from_file (create {PLAIN_TEXT_FILE}.make (dir.name))
				existents := const.filtered_fields_defaults (root_dir, filter_name)
				from table.start until table.after loop
					name := table.key_for_iteration
					create check_button.make_with_text (name)
					create text_field
					text_field.enable_edit
					text_field.set_minimum_width (100)
					-- Read the existent filter and get the default values
					if existents.has (name) then
						check_button.enable_select
						text_field.set_text (existents.item (name))
					else
						if table.item_for_iteration.is_equal ("INTEGER") or table.item_for_iteration.is_equal ("REAL") or table.item_for_iteration.is_equal ("DOUBLE") then
							text_field.set_text ("0")
						elseif not table.item_for_iteration.is_equal ("STRING") then
							text_field.set_text ("Void")
						end
					end
					fields.put_last ([text_field,check_button,name])
					v_box_1.extend (check_button)
					v_box_2.extend (text_field)
					table.forth
				end
				create h_box_1
				h_box_1.extend (v_box_1)
				h_box_1.extend (v_box_2)
				create scroll
				scroll.extend (h_box_1)
				scroll.hide_vertical_scroll_bar
				create h_box_2
				h_box_2.extend (create {EV_BUTTON}.make_with_text_and_action ("Ok", agent generate_filter))
				h_box_2.extend (create {EV_BUTTON}.make_with_text_and_action ("Cancel", agent dialog.destroy))
				create v_box_3
				v_box_3.extend (scroll)
				v_box_3.extend (h_box_2)
				v_box_3.disable_item_expand (h_box_2)
				dialog.extend (v_box_3)
				dialog.set_width (200)
				dialog.set_height (300)
				dialog.show
			end
		end

feature{NONE} -- Actions.

	generate_filter
			-- Helps in writing the filter class
		local
			tuple: TUPLE[EV_TEXT_FIELD,EV_CHECK_BUTTON,STRING]
				--value of iteration
			text: EV_TEXT_FIELD
				--text field of iteration
			button: EV_CHECK_BUTTON
				--button of iteration
			name: STRING
				--attribute name
			table: DS_HASH_TABLE[STRING,STRING]
			dirs: TUPLE[DIRECTORY,DIRECTORY]
				--the dirs
			file_manager: SET_FILE_MANAGER
		do
			dialog.destroy
			create table.make_default
			from fields.start until fields.after loop
				if fields.item_for_iteration /= Void then
					tuple := fields.item_for_iteration
					text ?= tuple[1]
					button ?= tuple[2]
					name ?= tuple[3]
					if button.is_selected then
						table.force (text.text,name)
					end
				end
				fields.forth
			end
			dirs ?= tree.selected_item.data
			create file_manager.make
			file_manager.generate_filter_file (dirs, table)
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
