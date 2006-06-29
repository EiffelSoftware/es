indexing
	description: "Command to display the AutoTest dialog."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"
	info: "Modified copy of EB_ABOUT_COMMAND and EB_NEW_CLUSTER_COMMAND"

class
	AT_COMMAND

inherit
	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			mini_pixmap,
			tooltext
		end

	EB_DEVELOPMENT_WINDOW_COMMAND
		redefine
			initialize
		end

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	initialize is
			-- Initialize default values.
		do
			-- make shortcut with Ctrl+Shift+A
			create accelerator.make_with_key_combination (
				create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.key_a),
				True, False, True)
			accelerator.actions.extend (agent execute)
		end

feature -- Execution

	execute is
			-- Popup the AutoTest dialog.
		do
			create auto_test_dialog.make_default (target)
			auto_test_dialog.call_default
		end

feature -- Access

	mini_pixmap: EV_PIXMAP is
			-- Pixmap representing the command for mini toolbars.
		do
			--Result := pixmaps.small_pixmaps.icon_new_cluster
		end

feature {NONE} -- Implementation

	auto_test_dialog: AT_SETTINGS_DIALOG
			-- dialog for the autotest settings

	menu_name: STRING is
			-- Name as it appears in the menu (with & symbol).
		do
			Result := "&AutoTest..." --Interface_names.m_Create_new_cluster
		end

	pixmap: EV_PIXMAP is
			-- Pixmaps representing the command.
		once
			Result := (create {AT_SHARED_PIXMAPS}).icon_auto_test
		end

	tooltip: STRING is
			-- Tooltip for the toolbar button.
		do
			Result := "AutoTest" -- Interface_names.f_Create_new_cluster
		end

	tooltext: STRING is
			-- Text for the toolbar button.
		do
			Result := "AutoTest" -- Interface_names.b_Create_new_cluster
		end

	description: STRING is
			-- Description for this command.
		do
			Result := "AutoTest runs automatic checks if postconditions can be " +
					  "violated with correct input matching the preconditions."
			--Interface_names.f_Create_new_cluster
		end

	name: STRING is "AutoTest";
			-- Name of the command. Used to store the command in the
			-- preferences.


indexing
	copyright:	"Copyright (c) 2006, The AECCS Team"
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
			The AECCS Team
			Website: https://eiffelsoftware.origo.ethz.ch/index.php/AutoTest_Integration
		]"

end -- class AT_COMMAND
