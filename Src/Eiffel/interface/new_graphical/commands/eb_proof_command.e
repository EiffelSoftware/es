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
			new_mini_sd_toolbar_item,
			initialize_sd_toolbar_item
		end

	COMPILER_EXPORTER
		export {NONE} all end

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_ERROR_HANDLER
		export {NONE} all end

	SHARED_EIFFEL_PROJECT
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
			text_output_cell.put (output_manager)
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
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT) is
			-- Execute with `a_stone'.
		local
			l_save_confirm: ES_DISCARDABLE_COMPILE_SAVE_FILES_PROMPT
			l_classes: DS_ARRAYED_LIST [CLASS_I]
		do
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
			if eiffel_project.successful then
				verify (a_stone)
			end
		end

	verify (a_stone: STONE)
			-- Verify `a_stone'.
		local
			l_class_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
			l_data_stone: DATA_STONE
			l_cluster: CLUSTER_I
			l_groups: LIST [CONF_GROUP]
		do
			eve_proofs.reset

			l_class_stone ?= a_stone
			l_cluster_stone ?= a_stone
			l_data_stone ?= a_stone
			if a_stone = Void then
					-- Verify system
				from
					l_groups := eiffel_universe.groups
					l_groups.start
				until
					l_groups.after
				loop
					l_cluster ?= l_groups.item_for_iteration
						-- Only load top-level clusters, as they are loaded recursively afterwards
					if l_cluster /= Void and then l_cluster.parent_cluster = Void then
						load_cluster (l_cluster)
					end
					l_groups.forth
				end
			elseif l_class_stone /= Void then
				load_class (l_class_stone.class_i)
			elseif l_cluster_stone /= Void then
				if l_cluster_stone.is_cluster then
					load_cluster (l_cluster_stone.cluster_i)
				else
					load_group (l_cluster_stone.group)
				end
			elseif l_data_stone /= Void then
				from
					l_groups ?= l_data_stone.data
					check l_groups /= Void end
					l_groups.start
				until
					l_groups.after
				loop
					l_cluster ?= l_groups.item_for_iteration
					if l_cluster /= Void then
						load_cluster (l_cluster)
					end
					l_groups.forth
				end
			end

				-- Do verification
			output_manager.clear
			if eve_proofs.classes_to_verify.is_empty then
					-- TODO: internationalization
				output_manager.add ("No classes to verify")
				output_manager.add_new_line
			else
				eve_proofs.execute_verification
			end
			output_manager.end_processing

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

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON
			-- <Precursor>
		do
			create Result.make (Current)
			initialize_sd_toolbar_item (Result, display_text)
			Result.select_actions.extend (agent execute)

			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- <Precursor>
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	initialize_sd_toolbar_item (a_item: EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON; display_text: BOOLEAN) is
			-- <Precursor>
		do
			Precursor (a_item, display_text)
			a_item.set_menu_function (agent drop_down_menu)
		end

feature -- Context menu

	class_context_menu_name (a_name: STRING_GENERAL): STRING_32
			-- Name of context menu for class `a_name'
		do
			Result := names.verify_class_context_menu_name (a_name)
		end

	cluster_context_menu_name (a_cluster_stone: CLUSTER_STONE; a_name: STRING_GENERAL): STRING_32
			-- Name of context menu for cluster `a_name' and stone `a_cluster_stone'
		do
			if a_cluster_stone.group.is_library then
				Result := names.verify_library_context_menu_name (a_name)
			else
				Result := names.verify_cluster_context_menu_name (a_name)
			end
		end

feature -- TODO

	droppable (a_pebble: ANY): BOOLEAN is
			-- Can user drop `a_pebble' on `Current'?
		local
			l_class_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
			l_data_stone: DATA_STONE
			l_list: LIST [CONF_GROUP]
		do
			l_class_stone ?= a_pebble
			l_cluster_stone ?= a_pebble
			l_data_stone ?= a_pebble
			if l_data_stone /= Void then
				l_list ?= l_data_stone.data
			end
			Result := l_class_stone /= Void or else l_cluster_stone /= Void or else l_list /= Void
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

	drop_down_menu: EV_MENU is
			-- Drop down menu for `new_sd_toolbar_item'.
		local
			l_item: EV_MENU_ITEM
		do
			create Result
				-- TODO: internationalization
			create l_item.make_with_text_and_action ("Proof current item", agent execute)
			Result.extend (l_item)
			create l_item.make_with_text_and_action ("Proof parent cluster of current item", agent execute_proof_parent_cluster)
			Result.extend (l_item)
			create l_item.make_with_text_and_action ("Proof system", agent execute_proof_system)
			Result.extend (l_item)
		ensure
			not_void: Result /= Void
		end

	execute_proof_parent_cluster is
			-- Proof parent cluster of window item.
		local
			l_window: EB_DEVELOPMENT_WINDOW
			l_class_stone: CLASSC_STONE
			l_cluster_stone: CLUSTER_STONE
		do
			if window /= Void then
				l_window := window
			else
				l_window := window_manager.last_focused_development_window
			end
			l_class_stone ?= l_window.stone
			l_cluster_stone ?= l_window.stone
			if l_class_stone /= Void then
				create l_cluster_stone.make (l_class_stone.group)
				execute_with_stone (l_cluster_stone)
			elseif l_cluster_stone /= Void then
				if l_cluster_stone.cluster_i.parent_cluster /= Void then
					create l_cluster_stone.make (l_cluster_stone.cluster_i.parent_cluster)
				end
				execute_with_stone (l_cluster_stone)
			end
		end

	execute_proof_system is
			-- Proof whole system (excluding libraries).
		do
			execute_with_stone (Void)
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
			-- TODO: internationalization
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

indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			 Eiffel Software
			 5949 Hollister Ave., Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"
end
