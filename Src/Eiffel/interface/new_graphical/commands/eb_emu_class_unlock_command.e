indexing
	description: "Command to unlock a class on the emu server[EMU-TOOLBAR BUTTON]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_EMU_CLASS_UNLOCK_COMMAND
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
			-- Unlock current class in editor window on emu server
		do
			current_file_in_editor := Window_manager.last_focused_development_window.file_name
			if(current_file_in_editor /= void) then
				Window_manager.last_focused_development_window.managed_main_formatters.first.enable_sensitive
				Window_manager.last_focused_development_window.editor_tool.text_area.set_read_only (false)
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
			Result := Interface_names.e_emu_unlock_class
		end

	tooltip: STRING is
			-- Tooltip for `Current's toolbar button.
		do
			Result := Interface_names.e_emu_unlock_class
		end

	tooltext: STRING is
			-- Text for `Current's toolbar button.
		do
			Result := Interface_names.b_emu_unlock_class
		end

	name: STRING is "Open_Emu_Unlock_tool"
			-- Internal textual representation.

	pixmap: EV_PIXMAP is
			-- Image used for `Current's toolbar buttons.
		do
			Result := Pixmaps.Icon_emu_unlock_class_icon
		end

	menu_name: STRING is
			-- Text used for menu items for `Current'.
		do
			Result := Interface_names.m_emu_unlock_class
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

feature {NONE} -- Implementation



end
