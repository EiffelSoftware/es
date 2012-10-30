note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_AUTOPROOF_COMMAND

inherit

	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item,
			new_mini_sd_toolbar_item,
			initialize_sd_toolbar_item
		end

	SHARED_EIFFEL_PROJECT

	SHARED_ERROR_HANDLER

	COMPILER_EXPORTER

create
	make

feature {NONE} -- Initialization

	make
			-- Creation method.
		do
			enable_sensitive
			set_up_menu_items
		end

feature -- Execution

	execute
			-- Execute menu command.
		do
			execute_proof_current_item
		end

	execute_with_stone (a_stone: STONE)
			-- Execute with `a_stone'.
		do
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT)
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

feature {NONE} -- Basic operations

	save_compile_and_verify (a_stone: STONE)
			-- Save modified windows, compile project and start verification.
		do
			window_manager.save_all_before_compiling
			compile_and_verify (a_stone)
		end

	compile_and_verify (a_stone: STONE)
			-- Compile project and start verification.
		local
			l_helper: ES_AUTOPROOF_BENCH_HELPER
			l_dialog: ES_INFORMATION_PROMPT
		do
				-- Compile the project and only verify if it was succesfull
			eiffel_project.quick_melt (True, True, True)
			if eiffel_project.successful then
				create l_helper
				if l_helper.autoproof.is_running then
					create l_dialog.make_standard ("AutoProof is already running.%NPlease wait until previous verification is finished.")
					l_dialog.show_on_active_window
				else
					verify (a_stone)
				end
			end
		end

	verify (a_stone: STONE)
			-- Verify `a_stone'.
		local
			l_cluster: CLUSTER_I
			l_helper: ES_AUTOPROOF_BENCH_HELPER
		do
			create l_helper
			autoproof := l_helper.autoproof
			autoproof.reset

			if attached {FEATURE_STONE} a_stone as s then
				autoproof.add_feature (s.e_feature.associated_feature_i)
			elseif attached {CLASSI_STONE} a_stone as s then
				load_class (s.class_i)
			elseif attached {CLUSTER_STONE} a_stone as s then
				if s.is_cluster then
					load_cluster (s.cluster_i)
				else
					load_group (s.group)
				end
			elseif attached {DATA_STONE} a_stone as s then
				if attached {LIST [CONF_GROUP]} s.data as g then
					from
						g.start
					until
						g.after
					loop
						if attached {CLUSTER_I} g.item_for_iteration as c then
							load_cluster (c)
						end
						g.forth
					end
				end
			else
				across eiffel_universe.groups as g loop
					if attached {CLUSTER_I} g.item as c then
							-- Only load top-level clusters, as they are loaded recursively afterwards
						if c.parent_cluster = Void then
							load_cluster (c)
						end
					end
				end
			end
			autoproof.add_notification (agent process_result)
			autoproof.verify

			show_proof_tool
		end

	process_result (a_result: E2B_RESULT)
			-- Process verification result.
		local
			w: WARNING
			s: E2B_SUCCESSFUL_VERIFICATION
			e: EP_VERIFICATION_ERROR
		do
			error_handler.wipe_out
			across a_result.verified_procedures as i loop
				create s.make (i.item)
				error_handler.insert_error (s)
			end
			across a_result.verification_errors as i loop
				if i.item.is_attached_violation then
					create e.make ("Attachment check failed")
				elseif i.item.is_check_violation then
					create e.make ("Check instruction failed")
				elseif i.item.is_frame_condition_violation then
					create e.make ("Frame condition failed")
				elseif i.item.is_invariant_violation then
					create e.make ("Invariant violated")
				elseif i.item.is_loop_invariant_violation then
					create e.make ("Loop invariant violated")
				elseif i.item.is_loop_variant_violation then
					create e.make ("Loop variant violated")
				elseif i.item.is_overflow_violation then
					create e.make ("Possible arithmetic overflow")
				elseif i.item.is_postcondition_violation then
					create e.make ("Postcondition violated")
				elseif i.item.is_precondition_violation then
					create e.make ("Precondition vioalted")
				else
					create e.make (i.item.message)
				end

				e.set_class (i.item.eiffel_class)
				e.set_feature (i.item.eiffel_feature)
				e.set_position (i.item.eiffel_line_number, 0)
				if attached i.item.tag then
					e.set_tag (i.item.tag)
				end
				error_handler.insert_error (e)
			end
			error_handler.trace
			error_handler.force_display
		end

	show_proof_tool
			-- Shows the proof tool
		local
			l_tool: ES_TOOL [EB_TOOL]
			l_window: EB_DEVELOPMENT_WINDOW
		do
			l_window := window_manager.last_focused_development_window
			if not l_window.is_recycled and then l_window.is_visible and then l_window = window_manager.last_focused_development_window then
				l_tool := l_window.shell_tools.tool ({ES_AUTOPROOF_TOOL})
				if l_tool /= Void and then not l_tool.is_recycled then
						-- Force tool to be shown
					l_tool.show (True)
				end
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
				autoproof.add_class (l_class_c)
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
			Result.select_actions.extend (agent execute_last_action)

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

	initialize_sd_toolbar_item (a_item: EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON; display_text: BOOLEAN)
			-- <Precursor>
		do
			Precursor (a_item, display_text)
			a_item.set_menu_function (agent drop_down_menu)
		end

feature -- Status report

	droppable (a_pebble: ANY): BOOLEAN
			-- Can user drop `a_pebble' on `Current'?
		local
			l_class_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
			l_data_stone: DATA_STONE
			l_list: LIST [CONF_GROUP]
		do
			Result :=
				(attached {FEATURE_STONE} a_pebble) or else
				(attached {CLASSI_STONE} a_pebble as s and then s.class_i.is_compiled) or else
				(attached {CLUSTER_STONE} a_pebble) or else
				(attached {DATA_STONE} a_pebble as s and then attached {LIST [CONF_GROUP]} s.data)
		end

feature {NONE} -- Implementation

	autoproof: E2B_AUTOPROOF
			-- AutoProof instance.

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

	execute_proof_current_item
			-- Proof current item
		local
			l_window: EB_DEVELOPMENT_WINDOW
		do
			last_execution := agent execute_proof_current_item
			proof_current_item_item.enable_select
			proof_parent_item_item.disable_select
			proof_system_item.disable_select

			l_window := window_manager.last_focused_development_window
			if droppable (l_window.stone) then
				execute_with_stone (l_window.stone)
			end
		end

	execute_proof_parent_cluster
			-- Proof parent cluster of window item.
		local
			l_window: EB_DEVELOPMENT_WINDOW
			l_cluster_stone: CLUSTER_STONE
		do
			last_execution := agent execute_proof_parent_cluster
			proof_current_item_item.disable_select
			proof_parent_item_item.enable_select
			proof_system_item.disable_select

			l_window := window_manager.last_focused_development_window
			if attached {CLASSC_STONE} l_window.stone as l_stone then
				create l_cluster_stone.make (l_stone.group)
				execute_with_stone (l_cluster_stone)
			elseif attached {CLUSTER_STONE} l_window.stone as l_stone then
				if l_stone.cluster_i.parent_cluster /= Void then
					create l_cluster_stone.make (l_stone.cluster_i.parent_cluster)
				end
				execute_with_stone (l_cluster_stone)
			end
		end

	execute_proof_system
			-- Proof whole system (excluding libraries).
		do
			last_execution := agent execute_proof_system
			proof_current_item_item.disable_select
			proof_parent_item_item.disable_select
			proof_system_item.enable_select

			execute_with_stone (Void)
		end

	execute_last_action
			-- Execute same action as last time.
		do
			last_execution.call ([])
		end

feature {NONE} -- Implementation

	set_up_menu_items
			-- Set up menu items of proof button
		do
			last_execution := agent execute_proof_current_item
			create proof_current_item_item.make_with_text_and_action ("Prove current item", agent execute_proof_current_item)
			proof_current_item_item.toggle
			create proof_parent_item_item.make_with_text_and_action ("Prove parent cluster of current item", agent execute_proof_parent_cluster)
			create proof_system_item.make_with_text_and_action ("Prove system", agent execute_proof_system)
		end

	drop_down_menu: EV_MENU is
			-- Drop down menu for `new_sd_toolbar_item'.
		local
			l_item: EV_CHECK_MENU_ITEM
		once
			create Result
			Result.extend (proof_current_item_item)
			Result.extend (proof_parent_item_item)
			Result.extend (proof_system_item)
		ensure
			not_void: Result /= Void
		end

	last_execution: PROCEDURE [ANY, TUPLE []]
			-- Last executed actions

	proof_current_item_item: EV_CHECK_MENU_ITEM
			-- Menu item to proof current item

	proof_parent_item_item: EV_CHECK_MENU_ITEM
			-- Menu item to proof parent item

	proof_system_item: EV_CHECK_MENU_ITEM
			-- Menu item to proof system

	menu_name: STRING_GENERAL
			-- Name as it appears in the menu (with & symbol).
		do
			Result := "Prove"
		end

	tooltip: STRING_GENERAL
			-- Tooltip for the toolbar button.
		do
			Result := "Prove class or cluster"
		end

	tooltext: STRING_GENERAL
			-- Text for the toolbar button.
		do
			Result := "Prove"
		end

	description: STRING_GENERAL
			-- Description for this command.
		do
			Result := "Prove class or cluster"
		end

	name: STRING_GENERAL
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "AutoProof"
		end

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
