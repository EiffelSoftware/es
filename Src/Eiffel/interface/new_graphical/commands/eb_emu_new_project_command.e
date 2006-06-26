indexing
	description: "Create a new emu-project[Button to open external new_project-wizard]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_EMU_NEW_PROJECT_COMMAND
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
			--open external server wizard
		do
			create external_execution
			external_execution.launch ("~/project_wizard ~")
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
			Result := Interface_names.e_emu_new_project_class
		end

	tooltip: STRING is
			-- Tooltip for `Current's toolbar button.
		do
			Result := Interface_names.e_emu_new_project_class
		end

	tooltext: STRING is
			-- Text for `Current's toolbar button.
		do
			Result := Interface_names.b_emu_new_project_class
		end

	name: STRING is "Open_Emu_New_Project_tool"
			-- Internal textual representation.

	pixmap: EV_PIXMAP is
			-- Image used for `Current's toolbar buttons.
		do
			Result := Pixmaps.Icon_emu_new_project_class_icon
		end

	menu_name: STRING is
			-- Text used for menu items for `Current'.
		do
			Result := Interface_names.m_emu_new_project_class
		end

	new_toolbar_item (display_text: BOOLEAN): EB_COMMAND_TOOL_BAR_BUTTON is
			-- Create a new toolbar button for this command.
			-- Call `recycle' on the result when you don't need it anymore otherwise
			-- it will never be garbage collected.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND} (display_text)
		end


	external_execution: EXECUTION_ENVIRONMENT
			-- to launch external wizard

feature {NONE} -- Implementation



end
