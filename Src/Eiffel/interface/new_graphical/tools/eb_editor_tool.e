indexing
	description	: "Tool where editable files are displayed (Class and Ace files)."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"

class
	EB_EDITOR_TOOL

inherit
	EB_TEXTABLE_TOOL
		rename
			text_area as textable_tool_text_area
		export
			{NONE} textable_tool_text_area
		redefine
			make,
			menu_name,
			refresh,
			build_text_area,
			pixmap,
			widget,
			changed,
			set_stone,
			stone,
			build_docking_content
		end

	EXEC_MODES

	SHARED_EIFFEL_PROJECT

create
	make

feature {NONE} -- Initialization

	make (a_manager: EB_DEVELOPMENT_WINDOW) is
			--
		do
			create editors_manager.make (a_manager)
			develop_window := a_manager
			widget_internal := a_manager.uis.editors_widget
			build_interface
			editors_manager.editor_switched_actions.extend (agent editor_switched)
		end

	build_docking_content (a_docking_manager:SD_DOCKING_MANAGER) is
--	build_explorer_bar_item (explorer_bar: EB_EXPLORER_BAR) is
			-- Build the associated explorer bar item and
			-- Add it to `explorer_bar'
		do
			create content.make_with_widget (widget, title)
			content.set_type ({SD_ENUMERATION}.editor)
			content.set_long_title (title)
			content.set_short_title (title)

--			create docking_content_that_wiil_be_removed_by_larry.make (a_docking_manager, widget, title, true)
--			docking_content_that_wiil_be_removed_by_larry.set_menu_name (menu_name)
--			docking_content_that_wiil_be_removed_by_larry.set_pixmap (pixmap)
--			explorer_bar.add (explorer_bar_item)
		end

feature -- Access

	title: STRING is
			-- Title of the tool
		do
			Result := Interface_names.t_Editor
		end

	menu_name: STRING is
			-- Name as it may appear in a menu.
		do
			Result := Interface_names.m_Editor
		end

	text_area: EB_SMART_EDITOR is
			-- Current editor
		do
			Result := editors_manager.current_editor
		end

	widget: EV_WIDGET is
			-- Widget representing Current
		do
			Result := widget_internal
		end

	editors_manager: EB_EDITORS_MANAGER
			-- Editors manager

	pixmap: EV_PIXMAP is
			-- Pixmap as it may appear in toolbars and menus.
		do
			Result := pixmaps.icon_pixmaps.view_editor_icon
		end

	stone: STONE is
			-- Stone for Current
		do
			Result := text_area.stone
		end

feature -- Status Report

	edited_file_is_up_to_date: BOOLEAN is
			-- is the edited file up to date ?
		do
			Result := text_area.file_is_up_to_date
		end

	changed: BOOLEAN is
			-- Any text changed since last save?
			-- False by default.
		do
			Result := editors_manager.changed
		end

feature -- Status setting

	set_changed (value: BOOLEAN) is
		require
			text_not_empty: not text_area.is_empty
		do
			text_area.set_changed (value)
		end

	set_focus is
			-- Set the focus
		do
			text_area.set_focus
		end

	set_stone (a_stone: STONE) is
			--
		do
--			Precursor {EB_TEXTABLE_TOOL} (a_stone)
			text_area.set_stone (a_stone)
		end

feature -- Basic operation

	refresh is
			-- Synchronize display with current stone
		do
			text_area.set_stone (stone)
			text_area.load_file (development_window.file_name)
		end

	on_text_saved is
		do
			text_area.on_text_saved
		end

	save_text is
			-- Save current text.
		do
			--|FIXME
		end

	save_as_text is
			-- Save current text as...
		do
			--|FIXME
		end

	reload is
			-- reload the edited file
		do
			text_area.reload
		end

feature -- Memory management

	recycle is
			-- Recycle `Current', but leave `Current' in an unstable state,
			-- so that we know whether we're still referenced or not.
		do
			if docking_content_that_wiil_be_removed_by_larry /= Void then
				docking_content_that_wiil_be_removed_by_larry.recycle
			end
			editors_manager.recycle
			develop_window := Void
		end

feature {NONE} -- Implementation

	development_window: EB_DEVELOPMENT_WINDOW is
			-- Development window where the editor tool is located.
		do
			Result ?= develop_window
		end

	widget_internal: EV_WIDGET

	build_text_area is
			-- Create the text component where the information will be displayed.
		do
		end

	editor_switched (a_editor: like text_area) is
			-- Editor is switched.
		do
			development_window.set_stone (a_editor.stone)
			development_window.refresh
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EB_EDITOR_TOOL
