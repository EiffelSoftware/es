indexing
	description: "Command to download class from emu server[EMU-TOOLBAR BUTTON]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_EMU_CLASS_DOWNLOAD_COMMAND
inherit
	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			new_toolbar_item,
			tooltext,
			is_tooltext_important
		end

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize `Current'.
		do
		end

feature -- Status setting

	execute is
			--Download current class in editor window from emu server
		local
			download_done: BOOLEAN
			status_bar: EB_DEVELOPMENT_WINDOW_STATUS_BAR
		do
			status_bar := window_manager.last_focused_development_window.status_bar
			current_file_in_editor := Window_manager.last_focused_development_window.file_name

			if(current_file_in_editor /= void) then
				status_bar.display_message ("Downloading class from emu_server...")

				download_done := emu_client.download (current_file_in_editor,window_manager.last_focused_development_window.class_name)

				if (download_done) then
					status_bar.display_message ("Download done")
				else
					show_emu_error (emu_download_error_text)
				end
			else
				show_emu_error (emu_no_class_warning_text) --shouldn't happen,button is disabled anyway
			end
		end

feature -- Status

	is_tooltext_important: BOOLEAN is
			-- Is the tooltext important shown when view is 'Selective Text'
		do
			Result := True
		end

feature -- Status report

	description: STRING is
			-- Explanatory text for this command.
		do
			Result := Interface_names.e_emu_download_class
		end

	tooltip: STRING is
			-- Tooltip for `Current's toolbar button.
		do
			Result := Interface_names.e_emu_download_class
		end

	tooltext: STRING is
			-- Text for `Current's toolbar button.
		do
			Result := Interface_names.b_emu_download_class
		end

	name: STRING is "Open_Emu_Download_tool"
			-- Internal textual representation.

	pixmap: EV_PIXMAP is
			-- Image used for `Current's toolbar buttons.
		do
			Result := Pixmaps.Icon_emu_download_class_icon
		end

	menu_name: STRING is
			-- Text used for menu items for `Current'.
		do
			Result := Interface_names.m_emu_download_class
		end

	new_toolbar_item (display_text: BOOLEAN): EB_COMMAND_TOOL_BAR_BUTTON is
			-- Create a new toolbar button for this command.
			-- Call `recycle' on the result when you don't need it anymore otherwise
			-- it will never be garbage collected.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND} (display_text)
		end


	current_file_in_editor: STRING
			-- filename of class in editor

	emu_client: EMU_CLIENT is
			-- associated emu_client
		do
			Result := window_manager.last_focused_development_window.project_manager.emu_client
		end

feature -- constants

	emu_dialog_width: INTEGER is 280
			-- width of dialog
	emu_dialog_hight: INTEGER is 80
			-- hight of dialog
	emu_dialog_titel: STRING is "Downloading Class from EMU-SERVER"
			-- titel of dialog window
	emu_label_text: STRING is "downloading..."
			-- label for dialog window
	emu_cancel_button_text: STRING is "Abort"
			-- text for cancel operation button in dialog
	emu_no_class_warning_text: STRING is "No class in Editor Window"
			-- text for warning message
	emu_download_error_text: STRING is "Download crashed"
			-- text if emu_client upload didn't go well

feature {NONE} -- Implementation

	current_dialog: EV_DIALOG
			-- Dialog used to display that uploading is running.

	show_download_dialog is
			-- Pop up a new dialog and display `a_text' inside it.
		do
			create_new_dialog
			current_dialog.show_modal_to_window (Window_manager.last_focused_development_window.window)
			current_dialog := Void
		end

	show_emu_error (error_text: STRING) is
			-- little popup  with error msg
		do
			show_warning_message (error_text)
		end

	show_warning_message (a_message: STRING) is
			-- show `a_message' in a dialog window		
			-- (from TEXT_PANEL)
		local
			wd: EV_WARNING_DIALOG
		do
			create wd.make_with_text (a_message)
			wd.pointer_button_release_actions.force_extend (agent wd.destroy)
			wd.key_press_actions.force_extend (agent wd.destroy)
			wd.show_modal_to_window (Window_manager.last_focused_development_window.window)
		end

	create_new_dialog is
			-- Fill `current_dialog' with a newly created dialog.
		local
			but: EV_BUTTON
			vb: EV_VERTICAL_BOX
			hb: EV_HORIZONTAL_BOX
			hb2: EV_HORIZONTAL_BOX
			emu_image: EV_PIXMAP
			emu_label: EV_LABEL
		do
				-- Build the layout.
			create vb
			vb.set_padding (Layout_constants.small_padding_size)
			vb.set_border_width (Layout_constants.small_border_size)
			create hb
			create hb2
			create current_dialog
			current_dialog.set_title (emu_dialog_titel)
			current_dialog.set_icon_pixmap (pixmap)


			create but.make_with_text (emu_cancel_button_text)
			Layout_constants.set_default_size_for_button (but)

			--logo --uploading

			emu_image := Pixmaps.bm_Borland.twin --to be changed to appropriate emu-image
			emu_image.set_minimum_size (emu_image.width, emu_image.height)

			--text...replace later with logo--progress bar?
			create emu_label.make_with_text (emu_label_text)
			emu_label.align_text_center

			--hb.extend (emu_image)
			--hb.disable_item_expand (emu_image)
			hb.extend(emu_label)
			hb.disable_item_expand(emu_label)

			vb.extend (hb)
			vb.disable_item_expand (hb)
			hb2.extend(create {EV_CELL})
			hb2.extend (but)
			hb2.disable_item_expand (but)
			hb2.extend(create {EV_CELL})
			vb.extend(hb2)
			vb.disable_item_expand (hb2)

			current_dialog.extend (vb)

				-- Set up the event handlers.
			current_dialog.set_default_cancel_button (but)
			but.select_actions.extend (agent abort_current_download)

			current_dialog.set_size (emu_dialog_width,emu_dialog_hight)
		ensure
			valid_dialog: current_dialog /= Void and then not current_dialog.is_destroyed
		end

		abort_current_download is
				-- user abort from download_dialog
			do
				--notify emu-client that aborted

				current_dialog.destroy

			end



end
