indexing
	description:
		"[
			Command to launch EVE Proofs.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EB_PROOF_COMMAND

inherit

	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item,
			new_mini_sd_toolbar_item
		end

	COMPILER_EXPORTER
		export {NONE} all end

inherit {NONE}

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_ERROR_HANDLER
		export {NONE} all end

	SHARED_EIFFEL_PROJECT
		export {NONE} all end

	EB_SHARED_PREFERENCES
		export {NONE} all end

	EB_SHARED_MANAGERS
		export {NONE} all end

create
	make,
	make_with_window

feature {NONE} -- Initialization

	make
			-- Creation method.
		do
			enable_sensitive
		end

	make_with_window (a_window: EB_DEVELOPMENT_WINDOW)
			-- Creation method.
		require
			a_window /= Void
		do
			window := a_window
			make
		ensure
			window_set: window = a_window
		end

feature -- Execution

	execute is
			-- Execute menu command.
		local
			l_window: EB_DEVELOPMENT_WINDOW
		do
			if window /= Void then
				l_window := window
			else
				l_window := window_manager.last_focused_development_window
			end
			if l_window /= Void and then droppable (l_window.stone) then
				execute_with_stone (l_window.stone)
			end
		end

	execute_with_stone (a_stone: STONE)
			-- Execute with `a_stone'.
		do
			check droppable (a_stone) end
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT) is
			-- Create a new tab which stone is `a_stone' and create at side of `a_content' if exists.
		local
			l_save_confirm: ES_DISCARDABLE_COMPILE_SAVE_FILES_PROMPT
			l_classes: DS_ARRAYED_LIST [CLASS_I]
		do
			check droppable (a_stone) end
			if not eiffel_project.is_compiling then
				if window_manager.has_modified_windows then
					create l_classes.make_default
					window_manager.all_modified_classes.do_all (agent l_classes.force_last)
					create l_save_confirm.make (l_classes)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.yes_button, agent save_compile_and_verify (a_stone))
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.no_button, agent compile_and_verify (a_stone))
					l_save_confirm.show_on_active_window
				else
					compile_and_verify (a_stone)
				end
			end
		end

feature -- Basic operations

	save_compile_and_verify (a_stone: STONE)
			-- Save modified windows, compile project and start verification.
		do
			window_manager.save_all_before_compiling
			compile_and_verify (a_stone)
		end

	compile_and_verify (a_stone: STONE)
			-- Compile project and start verification.
		do
				-- Compile the project and only verify if it was succesfull
			eiffel_project.quick_melt
			if workbench.successful then
				verify (a_stone)
			end
		end

	verify (a_stone: STONE)
			-- Verify `a_stone'.
		require
			a_stone_not_void: a_stone /= Void
		local
			l_class_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
		do
			eve_proofs.reset

			if eve_proofs.is_ready then
				l_class_stone ?= a_stone
				l_cluster_stone ?= a_stone
				if l_class_stone /= Void then
					load_class (l_class_stone.class_i)
				elseif l_cluster_stone /= Void then
					if l_cluster_stone.is_cluster then
						load_cluster (l_cluster_stone.cluster_i)
					else
						load_group (l_cluster_stone.group)
					end
				end
			end

			if eve_proofs.classes_to_verify.is_empty then
					-- TODO: internationalization
				output_manager.clear
				output_manager.add ("No classes to verify")
				output_manager.add_new_line
				output_manager.end_processing
			else
				eve_proofs.execute_verification
			end

				-- Add warninigs and errors
			error_handler.warning_list.append (warnings)
			error_handler.warning_list.finish
			error_handler.error_list.append (errors)
			error_handler.error_list.finish
			error_handler.trace

			if not errors.is_empty then
				error_handler.error_displayer.force_display
			else
				output_manager.force_display
			end
		end

	load_class (a_class: CLASS_I)
			-- Load `a_class' for verification.
		local
			l_class_c: CLASS_C
		do
			if a_class.is_compiled then
				l_class_c := a_class.compiled_class
				check l_class_c /= Void end
				eve_proofs.add_class_to_verify (l_class_c)
			end
		end

	load_cluster (a_cluster: CLUSTER_I)
			-- Load `a_cluster' for verification.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
		do
			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_conf_class := a_cluster.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_cluster)
				load_class (l_class_i)
				a_cluster.classes.forth
			end
			if a_cluster.sub_clusters /= Void then
				from
					a_cluster.sub_clusters.start
				until
					a_cluster.sub_clusters.after
				loop
					load_cluster (a_cluster.sub_clusters.item_for_iteration)
					a_cluster.sub_clusters.forth
				end
			end
		end

	load_group (a_group: CONF_GROUP)
			-- Load `a_group' for verification.
		require
			a_group_not_void: a_group /= Void
		local
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
		do
			from
				a_group.classes.start
			until
				a_group.classes.after
			loop
				l_conf_class := a_group.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_group)
				load_class (l_class_i)
				a_group.classes.forth
			end
		end

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- New toolbar item for dockable toolbar.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}(display_text)
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- New mini toolbar item.
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

feature -- Context menu

	class_context_menu_name (a_name: STRING_GENERAL): STRING_32
			-- Name of context menu for `a_cluster_stone'
		do
			Result := names.verify_class_context_menu_name (a_name)
		end

	cluster_context_menu_name (a_cluster_stone: CLUSTER_STONE; a_name: STRING_GENERAL): STRING_32
			-- Name of context menu for `a_cluster_stone'
		do
			if a_cluster_stone.group.is_library then
				Result := names.verify_library_context_menu_name (a_name)
			else
				Result := names.verify_cluster_context_menu_name (a_name)
			end
		end

feature {NONE} -- Implementation

	window: EB_DEVELOPMENT_WINDOW
			-- Associated development window (if any)

	pixmap: EV_PIXMAP
			-- Pixmap representing the command.
		do
			Result := pixmaps.icon_pixmaps.general_tick_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.general_tick_icon_buffer
		end

	droppable (a_pebble: ANY): BOOLEAN is
			-- Can user drop `a_pebble' on `Current'?
		local
			l_class_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
		do
			l_class_stone ?= a_pebble
			l_cluster_stone ?= a_pebble
			Result := l_class_stone /= Void or else l_cluster_stone /= Void
		end

feature {NONE} -- Implementation

	menu_name: STRING_GENERAL
			-- Name as it appears in the menu (with & symbol).
		do
			-- TODO: internationalization
			Result := "Proof Current Item"
		end

	tooltip: STRING_GENERAL
			-- Tooltip for the toolbar button.
		do
			-- TODO: internationalization
			Result := "Proof class or cluster"
		end

	tooltext: STRING_GENERAL
			-- Text for the toolbar button.
		do
			Result := "Proof"
		end

	description: STRING_GENERAL
			-- Description for this command.
		do
			-- TODO: internationalization
			Result := "Proof class or cluster"
		end

	name: STRING_GENERAL
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "Proof"
		end

end
