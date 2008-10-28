indexing
	description	: "Command to statically verify a class with Ballet"
	date		: "$Date$"
	revision	: "$Revision$"

class
	EB_VERIFY_CLASS_COMMAND

inherit
	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item,
			new_mini_sd_toolbar_item
		end

	EB_DEVELOPMENT_WINDOW_COMMAND
		rename
			target as development_window,
			make as make_old
		end

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

	EB_SHARED_WINDOW_MANAGER

	EB_CONSTANTS

create
	make

feature -- Initialization

	make (dev_window: EB_DEVELOPMENT_WINDOW) is
			-- Creation method.
		require
			dev_window_attached: dev_window /= Void
		local
			l_shortcut: SHORTCUT_PREFERENCE
		do
			development_window := dev_window
			enable_sensitive
		ensure
			development_window_attached: development_window = dev_window
		end

feature -- Execution

	execute is
			-- Create new tab.
		do
			creating_empty_tab := True
			execute_with_stone_content (Void, Void)
			creating_empty_tab := False
		end

	execute_with_stone (a_stone: STONE) is
			-- Execute with `a_stone'.
		do
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT) is
			-- Create a new tab which stone is `a_stone' and create at side of `a_content' if exists.
		local
			l_editor : EB_SMART_EDITOR
		do
				-- Check for a valid stone and start verification
		end

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_BUTTON is
			-- New toolbar item for dockable toolbar.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}(display_text)
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent editors_manager.stone_acceptable)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON is
			-- New mini toolbar item.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent editors_manager.stone_acceptable)
		end

feature {NONE} -- Implementation

	menu_name: STRING_GENERAL is
			-- Name as it appears in the menu (with & symbol).
		do
				-- TODO: internationalization
			Result := "Verify class"
		end

	pixmap: EV_PIXMAP is
			-- Pixmap representing the command.
		do
			Result := pixmaps.icon_pixmaps.general_tick_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER is
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.general_tick_icon_buffer
		end

	tooltip: STRING_GENERAL is
			-- Tooltip for the toolbar button.
		do
				-- TODO: internationalization
			Result := "Verify class"
		end

	tooltext: STRING_GENERAL is
			-- Text for the toolbar button.
		do
				-- TODO: internationalization
			Result := "Verify"
		end

	description: STRING_GENERAL is
			-- Description for this command.
		do
				-- TODO: internationalization
			Result := "Statically verify the class using Ballet"
		end

	name: STRING_GENERAL is
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "Verify_class"
		end

feature {NONE} -- Implementation

	creating_empty_tab: BOOLEAN
			-- Creating empty tab?

	editors_manager: EB_EDITORS_MANAGER is
			-- Editors manager.
		do
			Result := development_window.editors_manager
		end

end
