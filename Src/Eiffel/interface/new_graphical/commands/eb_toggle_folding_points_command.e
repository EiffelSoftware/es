indexing
	description: "Toggle folding points in editors"
	author: "bherlig"
	date: "$06/18/2006$"
	revision: "$0.3$"

class
	EB_TOGGLE_FOLDING_POINTS_COMMAND

inherit
	EB_MENUABLE_COMMAND

	EB_SHARED_PREFERENCES
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make is
			-- New command
		do
			initialize
		end

feature -- Execution

	initialize is
			-- Initialize
		do
			create accelerator.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.key_p), True, False, True)
			accelerator.actions.extend (agent execute)
			enable_sensitive
		end

	execute is
			-- Execute the command.
		do
			preferences.editor_data.show_folding_points_preference.set_value (not preferences.editor_data.show_folding_points)
		end

feature {NONE} -- Implementation

	menu_name: STRING is
			-- Name as it appears in the menu (with & symbol).
		do
			Result := Interface_names.m_Folding_points
		end

end -- Class EB_TOGGLE_FOLDING_POINTS_COMMAND
