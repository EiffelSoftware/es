indexing
	description	: "Window containing several tools"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"
	author		: "Arnaud PICHERY [ aranud@mail.dotcom.fr ]"

deferred class
	EB_TOOL_MANAGER

inherit
	EB_WINDOW
		rename
			destroy_recyclable_items as recycle
		redefine
			destroy_imp,
			recycle
		end

	EB_EXPLORER_BAR_MANAGER
		undefine
			default_create
		end

	EB_SHARED_DEBUG_TOOLS
		undefine
			default_create
		end

	EB_HISTORY_OWNER
		undefine
			default_create
		redefine
			recycle
		end

	EB_SHARED_PREFERENCES
		undefine
			default_create
		end

	ES_TOOLBAR_PREFERENCE
		undefine
			default_create
		end

feature {NONE} -- Initialization

	init_tools_list is
			-- Create and set up the list of tools that can be put on the left
			-- and on the bottom-right.
		do
		end

feature -- Access

	status_bar: EB_DEVELOPMENT_WINDOW_STATUS_BAR
			-- Status bar.

feature -- Status setting

	hide_tools is
			-- Hide all tools.
			--| Used for optimization purposes, to avoid computing a lot
			--| when changing completely the display of the window.
		do
			status_bar.widget.hide
			panel.hide
		end

	show_tools is
			-- Show all tools.
		do
			panel.show
			status_bar.widget.show
		end

feature -- Memory management

	destroy_imp is
			-- Recycle `Current', and leave it in an unstable state,
			-- so that we know whether we are really not referenced any more.
		do
			toolbars_area.wipe_out
			panel.wipe_out
			container.wipe_out
			--	All these components are automatically recycled through add_recyclable.
			--			favorites_manager.recycle
			--			cluster_manager.recycle
			--			favorites_menu.recycle
			--			general_customizable_toolbar.recycle
			--			project_customizable_toolbar.recycle
			--			refactoring_customizable_toolbar.recycle

				-- Recycle the history manager.
				-- This is called polymorphically by EV_WINDOW.
			--			recycle
			--			history_manager.recycle

			--			Precursor {EB_WINDOW}
			--			refactoring_toolbar.destroy
			toolbars_area.destroy
			panel.destroy
			container.destroy

			general_customizable_toolbar := Void
			project_customizable_toolbar := Void
			refactoring_customizable_toolbar := Void

			--			address_toolbar := Void
			--			project_toolbar := Void
			--			refactoring_toolbar := Void
		end

feature {EB_DEBUGGER_MANAGER, EB_TOOL, EB_DEVELOPMENT_WINDOW_BUILDER,
			EB_DEVELOPMENT_WINDOW_DIRECTOR} -- Explorer bars

	panel: EV_CELL
			-- Main panel. It can be either a EV_HORIZONTAL_SPLIT_AREA or an EV_CELL.
			-- It depends whether the left explorer bar is displayed or not.
			--
			-- Panel contains `left_panel' and `right_panel' if it's a split area,
			-- `right_panel' only if it's a cell.

feature {EB_DEVELOPMENT_WINDOW_BUILDER, EB_DEVELOPMENT_WINDOW_MENU_BUILDER} -- Vision2 architechture

	container: EV_VERTICAL_BOX
			-- Main container. It contains everything that appears in the window:
			-- The toolbars area and the panel.

	toolbars_area: EV_VERTICAL_BOX
			-- Area where toolbars will be displayed.

	general_customizable_toolbar: EB_TOOLBAR
			-- Customizable part of `general_toolbar'.

	project_customizable_toolbar: EB_TOOLBAR
			-- Customizable part of `project_toolbar'.

	refactoring_customizable_toolbar: EB_TOOLBAR
			-- Customizable part of `refactoring_toolbar'.

feature -- Favorites & History handling.

	favorites_manager: EB_FAVORITES_MANAGER
			-- Graphical manager for favorites, contains the favorites
			-- tree (`favorites_window') and the favorites menu.

	cluster_manager: EB_CLUSTER_MANAGER
			-- Graphical manager for clusters and classes, contains the cluster tree.

	set_favorites_manager (a_favorites_manager: EB_FAVORITES_MANAGER) is
			-- Set `favorites_manager' to `a_favorites_manager'.
		do
			favorites_manager := a_favorites_manager
		end

	set_cluster_manager (a_cluster_manager: EB_CLUSTER_MANAGER) is
			-- Set `cluster_manager' to `a_cluster_manager'.
		do
			cluster_manager := a_cluster_manager
		end

feature -- Explorer bar handling.

	splitter_position: INTEGER
			-- Position of the main splitter.

	display_bar (a_bar: EB_EXPLORER_BAR) is
			-- Switch the current view to `a_bar'.
		do
		end

	force_display_bar (a_bar: EB_EXPLORER_BAR) is
			-- Switch the current view to `a_bar', even if the other bar is maximized.
		do
		end

	update_expanded_state_of_panel is
			-- If `panel' `is_full', update expanded status of widgets
			-- based on `editor_left_side_cell'. This must be performed
			-- after insertions or updates to `panel', ensuring that the
			-- non editor side does not resize when `panel' is enlarged.
		do
		end

	close_bar (a_bar: EB_EXPLORER_BAR) is
			-- An explorer bar asks to be closed.
		do
		end

	close_all_bars_except (a_bar: EB_EXPLORER_BAR) is
			-- An explorer bar item asks to be maximized.
		do
			close_bar (other_bar (a_bar))
		end

	restore_bars is
			-- A maximized item has been restored.
		do
				-- Do not force the bar to be shown if it is empty, as
				-- in that state it should be hidden.
		end

	other_bar (a_bar: EB_EXPLORER_BAR): EB_EXPLORER_BAR is
			-- If `a_bar' is `left_panel', return `right_panel' and vice versa.
		do
		end

feature {NONE} -- Initialization flags

	tools_initialized: BOOLEAN
			-- Are the tools initialized?

	recycle is
			-- Destroy `Current'.
		do
			Precursor {EB_HISTORY_OWNER}
			Precursor {EB_WINDOW}
		end

feature {NONE} -- Constants

	Frame_constants: EV_FRAME_CONSTANTS is
			-- Default constants for Frame look.
		once
			create Result
		end

	Default_colors: EV_STOCK_COLORS is
			-- Default Vision2 colors.
		once
			create Result
		end

	editor_left_side_cell: CELL [BOOLEAN] is
			-- Is Editor and associated tools displayed on left side of window?
		once
			create Result.put (preferences.misc_data.editor_left_side)
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

end -- class EB_TOOL_MANAGER
