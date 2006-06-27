indexing
	description: "Command to lock a class on the emu server[EMU-TOOLBAR BUTTON]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_EMU_CLASS_LOCK_COMMAND
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
			-- Lock current class in editor window on emu server
		local
			lock_done: BOOLEAN
			status_bar: EB_DEVELOPMENT_WINDOW_STATUS_BAR
			window:EB_DEVELOPMENT_WINDOW
			class_name: STRING
		do
			window := Window_manager.last_focused_development_window
			status_bar := window.status_bar
			current_file_in_editor := window.file_name
			class_name := window.class_name

			if (emu_client.is_class_unlocked (class_name)) then
				status_bar.display_message ("Locking class on emu_server...")
				lock_done := emu_client.lock (current_file_in_editor,class_name)
				if (lock_done) then
					status_bar.display_message ("Locking done")
					window.managed_main_formatters.first.disable_sensitive
					window.editor_tool.text_area.set_read_only (true)
					window_manager.synchronize_all --that clusters-display refreshes class display
				else
					show_emu_error (emu_lock_error_text)
				end
			else
				show_emu_error (emu_class_locked_text)
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
			Result := Interface_names.e_emu_lock_class
		end

	tooltip: STRING is
			-- Tooltip for `Current's toolbar button.
		do
			Result := Interface_names.e_emu_lock_class
		end

	tooltext: STRING is
			-- Text for `Current's toolbar button.
		do
			Result := Interface_names.b_emu_lock_class
		end

	name: STRING is "Open_Emu_Lock_tool"
			-- Internal textual representation.

	pixmap: EV_PIXMAP is
			-- Image used for `Current's toolbar buttons.
		do
			Result := Pixmaps.Icon_emu_lock_class_icon
		end

	menu_name: STRING is
			-- Text used for menu items for `Current'.
		do
			Result := Interface_names.m_emu_lock_class
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

	emu_lock_error_text: STRING is "Locking crashed"
			-- text if emu_client unlocking failed

	emu_class_locked_text: STRING is "Class is not unlocked"
			-- text if class in not unlocked warning

feature {NONE} -- Implementation

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
			wd.show_modal_to_window (window_manager.last_focused_development_window.window)
		end

end
