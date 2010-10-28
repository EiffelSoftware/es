note
	description: "Dialog for handlig configuration file"
	author: "Teseo Schneider, Marco Piccioni"
	date: "7.04.09"

class
	SET_CONFIG_FILE_CREATOR

	create
		make

feature -- Creation

	make (a: PROCEDURE [ANY, TUPLE])
			-- Assign action to be performed.
		do
			action := a
		end

feature -- Display

	display (path: STRING)
			-- Display dialog.
		local
			v_panel: EV_VERTICAL_BOX
			h_panel: EV_HORIZONTAL_BOX
			but: EV_BUTTON
		do
			create dialog.make ("Config file not found. A new one will be created.")
			create v_panel
			create h_panel
			v_panel.extend (create {EV_LABEL}.make_with_text ("Please insert the repository path."))
			create text.default_create
			text.set_minimum_width (200)
			text.set_text (path)
			h_panel.extend (text)
			h_panel.disable_item_expand (text)
			create but.make_with_text_and_action ("Browse...", agent browse)
			h_panel.extend (but)
			v_panel.extend (h_panel)
			v_panel.disable_item_expand (h_panel)
			create but.make_with_text_and_action ("Ok", agent main_ok)
			but.set_minimum_width (100)
			create h_panel
			h_panel.extend (create {EV_CELL})
			h_panel.extend (but)
			h_panel.disable_item_expand (but)
			h_panel.extend (create {EV_CELL})
			h_panel.set_minimum_width (100)
			v_panel.extend (h_panel)
			v_panel.disable_item_expand (h_panel)
			dialog.extend (v_panel)
			dialog.set_size (300, 150)
			dialog.show
		end

feature {NONE} --implementation

	dialog: SET_DIALOG_FACTORY
		-- Dialog box.
	text: EV_TEXT_FIELD
		-- Main text field.
	action: PROCEDURE [ANY, TUPLE]
		-- Agent wrapping the action to execute after creation.

	create_folder_dialog
			-- Create folder dialog.
		local
			h_panel: EV_HORIZONTAL_BOX
			v_panel: EV_VERTICAL_BOX
			butt: EV_BUTTON
		do
			create dialog.make ("Directory not found.")
			create v_panel
			v_panel.extend (create {EV_LABEL}.make_with_text ("The specified directory: %""+text.text+"%" does not exist. Please press Cancel and insert a valid directory."))
			create h_panel
			h_panel.extend (create {EV_CELL})
	--		NOTE (MARCO): 	this triggers a system exception because the dir does not exist. I have removed the code
	--		because it does not make sense in this case to have an `OK' button.
	--		create butt.make_with_text_and_action ("Ok", agent folder_creation_ok(text.text))
	--		h_panel.extend (butt)
	--		h_panel.disable_item_expand (butt)
			create butt.make_with_text_and_action ("Cancel", agent folder_creation_cancel)
			h_panel.extend (butt)
			h_panel.disable_item_expand (butt)
			h_panel.extend (create {EV_CELL})
			v_panel.extend (h_panel)
			v_panel.disable_item_expand (h_panel)
			dialog.extend (v_panel)
			dialog.set_size (200, 100)
			dialog.show
		end

	create_config_file
			-- Create configuration file dialog.
		local
			path: STRING
			dir: DIRECTORY
			h_panel: EV_HORIZONTAL_BOX
			v_panel: EV_VERTICAL_BOX
			butt: EV_BUTTON
			file_manager: SET_FILE_MANAGER
		do
			path:=text.text
			create dir.make (path)
			create file_manager.make
			file_manager.make
			if dir.is_empty then
				file_manager.create_config_file(path)
				action.call (Void)
			else
				create dialog.make ("The repository directory is not empty. Please press Ok and clean it up or use another one.")
				create v_panel
				v_panel.extend (create {EV_LABEL}.make_with_text ("The repository directory: %""+path+"%" is not empty."))
				create h_panel
				create butt.make_with_text_and_action ("Ok", agent folder_creation_cancel)
				h_panel.extend (create {EV_CELL})
				h_panel.extend (butt)
				h_panel.disable_item_expand (butt)
				h_panel.extend (create {EV_CELL})
				v_panel.extend (h_panel)
				v_panel.disable_item_expand (h_panel)
				dialog.extend (v_panel)
				dialog.set_size (200, 100)
				dialog.show
			end
		end

feature {NONE} -- Actions

	main_ok
			-- Reaction to the main ok button pressed.
		local
			dir: DIRECTORY
		do
			dialog.destroy
			create dir.make (text.text)
			if dir.exists then
				create_config_file
			else
				create_folder_dialog
			end
		end

	browse
			-- Reaction to the browse button pressed.
		local
			open: EV_DIRECTORY_DIALOG
		do
			create open.make_with_title ("Select the repo dir")
			open.show_modal_to_window (dialog)
			text.set_text (open.directory)
		end

	folder_creation_ok (path:STRING)
			-- Reaction to the folder creation ok button pressed.
		local
			dir: DIRECTORY
		do
			create dir.make (path)
			dir.create_dir
			create_config_file
		end

	folder_creation_cancel
			--  Reaction to the folder creation cancel button pressed.
		do
			dialog.destroy
			display("")
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
