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
		do
			current_file_in_editor := Window_manager.last_focused_development_window.file_name
			if(current_file_in_editor /= void) then
				Window_manager.last_focused_development_window.managed_main_formatters.first.disable_sensitive
				Window_manager.last_focused_development_window.editor_tool.text_area.set_read_only (true)
			end
		end

	execute_with_stone (st: ERROR_STONE) is
			-- Pop up a new dialog and display the help text of `st' inside it.
		do

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
			Result.drop_actions.extend (agent execute_with_stone)
		end

	current_file_in_editor: STRING
			-- filename of class in editor

feature {NONE} -- Implementation


	set_stone (editor: SELECTABLE_TEXT_PANEL; st: ERROR_STONE) is
			-- Display the help text associated with `st' in `editor'.
		require
			valid_stone: st /= Void
			valid_editor: editor /= Void
		do
			editor.load_text (st.help_text)
		end

end
