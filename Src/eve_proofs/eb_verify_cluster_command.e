indexing
	description: "Command to statically verify a class with Ballet."
	date: "$Date$"
	revision: "$Revision$"

class EB_VERIFY_CLUSTER_COMMAND

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

	COMPILER_EXPORTER
		export {NONE} all end

inherit {NONE}

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_BPL_ENVIRONMENT
		export {NONE} all end

	SHARED_ERROR_HANDLER
		export {NONE} all end

	SHARED_EIFFEL_PROJECT
		export {NONE} all end

	EB_SHARED_PREFERENCES
		export {NONE} all end

	EB_SHARED_WINDOW_MANAGER
		export {NONE} all end

create
	make

feature -- Initialization

	make (dev_window: EB_DEVELOPMENT_WINDOW) is
			-- Creation method.
		require
			dev_window_attached: dev_window /= Void
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
			execute_with_stone_content (Void, Void)
		end

	execute_with_stone (a_stone: STONE) is
			-- Execute with `a_stone'.
		do
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT) is
			-- Create a new tab which stone is `a_stone' and create at side of `a_content' if exists.
		local
			l_cluster_stone: CLUSTER_STONE
		do
				-- Check for a valid stone and start verification
			l_cluster_stone ?= a_stone
			if l_cluster_stone /= Void then

					-- Compile the project and only verify if it was succesfull
				eiffel_project.quick_melt
				if workbench.successful then
					verify_cluster (l_cluster_stone.group)
				end
			end
		end

	verify_cluster (a_group: CONF_GROUP)
			-- Verify `a_group' with Boogie.
		require
			a_group_not_void: a_group /= Void
		local
			l_eve_proofs: EVE_PROOFS
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
			l_class_c: CLASS_C
		do
			create l_eve_proofs.make
			check l_eve_proofs.is_ready end

			from
				a_group.classes.start
			until
				a_group.classes.after
			loop
				l_conf_class := a_group.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_group)
				if l_class_i.is_compiled then
					l_class_c := l_class_i.compiled_class
					check l_class_c /= Void end
					l_eve_proofs.add_class_to_verify (l_class_c)
				end
				a_group.classes.forth
			end

			l_eve_proofs.execute_verification

			-- TODO: check for errors
		end

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_BUTTON is
			-- New toolbar item for dockable toolbar.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}(display_text)
			Result.drop_actions.extend (agent execute_with_stone)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON is
			-- New mini toolbar item.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
		end

feature {NONE} -- Implementation

	menu_name: STRING_GENERAL is
			-- Name as it appears in the menu (with & symbol).
		do
				-- TODO: internationalization
			Result := "Verify cluster"
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
			Result := "Verify cluster"
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
			Result := "Statically verify the cluster using Ballet"
		end

	name: STRING_GENERAL is
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "Verify_cluster"
		end

end
