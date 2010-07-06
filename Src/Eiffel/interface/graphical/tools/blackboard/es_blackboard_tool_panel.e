note
	description:
		"Graphical panel for blackboard."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_BLACKBOARD_TOOL_PANEL

inherit
	ES_DOCKABLE_STONABLE_TOOL_PANEL [EV_NOTEBOOK]
		redefine
			on_before_initialize,
			on_after_initialized,
			internal_recycle
		end

	EBB_SHARED_BLACKBOARD
		export {NONE} all end

	EB_CLUSTER_MANAGER_OBSERVER
		export {NONE} all end

create {ES_BLACKBOARD_TOOL}
	make

feature {NONE} -- Initialization

	on_before_initialize
			-- <Precursor>
		do
			manager.extend (Current)
			propagate_drop_actions (Void)
		end

	on_after_initialized
			-- <Precursor>
		do

		end

	create_widget: EV_NOTEBOOK
			-- <Precursor>
		do
			create Result

--			create {ES_EDITOR_TOKEN_GRID} Result
--			Result.enable_single_row_selection
--			Result.enable_column_separators
--			Result.enable_row_separators
--			Result.set_separator_color (colors.grid_line_color)
--			Result.enable_default_tree_navigation_behavior (True, True, True, True)
--			Result.enable_row_height_fixed
--			Result.disable_vertical_scrolling_per_item
----			Result.pointer_double_press_item_actions.extend (agent on_grid_events_item_pointer_double_press)
		end

	create_tool_bar_items: DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		local
			l_button: SD_TOOL_BAR_BUTTON
		do
			create Result.make (10)

			create l_button.make
			l_button.set_text ("Initalize")
			l_button.select_actions.extend (agent on_initialize)
			Result.put (l_button, 1)

			create l_button.make
			l_button.set_text ("Update")
			l_button.select_actions.extend (agent on_update)
			Result.put (l_button, 2)

			create l_button.make
			l_button.set_text ("Print state")
			l_button.select_actions.extend (agent on_print_state)
			Result.put (l_button, 3)

			create l_button.make
			l_button.set_text ("Run tool")
			l_button.select_actions.extend (agent on_run_tool)
			Result.put (l_button, 4)
		end

	build_tool_interface (root_widget: EV_NOTEBOOK)
			-- <Precursor>
		do
			create system_panel.make
			create class_panel
			create feature_panel
			create tools_panel
			create progress_panel
			create debug_output_panel

			user_widget.extend (system_panel)
			user_widget.extend (class_panel)
			user_widget.extend (feature_panel)
			user_widget.extend (tools_panel)
			user_widget.extend (progress_panel)
			user_widget.extend (debug_output_panel)

			user_widget.set_item_text (system_panel, "System")
			user_widget.set_item_text (class_panel, "Class")
			user_widget.set_item_text (feature_panel, "Feature")
			user_widget.set_item_text (tools_panel, "Tools")
			user_widget.set_item_text (progress_panel, "Progress")
			user_widget.set_item_text (debug_output_panel, "Debug")
		end

feature -- Access

	system_panel: ES_BLACKBOARD_SYSTEM_GRID
			-- Panel for system overview.

	class_panel: EV_TEXT
			-- Panel for class overview.

	feature_panel: EV_TEXT
			-- Panel for feature overview.

	tools_panel: EV_TEXT
			-- Panel for tool list.

	progress_panel: EV_TEXT
			-- Panel displaying current progress.

	debug_output_panel: EV_TEXT
			-- Panel for debug output.

feature -- Status report


feature {NONE} -- User interface items


feature {NONE} -- Events

	on_initialize
			-- Initialize blackboard.
		do
			blackboard.data.update_from_universe

			blackboard.tools.extend (create {EVE_PROOFS}.make)

			system_panel.update_from_blackboard

			append_debug_text ("initialized.%N")
		end

	on_update
			-- Update blackboard data.
		do
			system_panel.update_from_blackboard
			append_debug_text ("updated.%N")
		end

	on_run_tool
			-- Run tool.
		do
			blackboard.control.execute_action
		end

	on_print_state
			-- Print blackboard state.
		do
--			print_clusters_state
			print_classes_state
			print_features_state
		end

	print_clusters_state
			-- Print cluster state.
		local
			l_list: LIST [EBB_CLUSTER_DATA]
		do
			from
				l_list := blackboard.data.clusters
				l_list.start
			until
				l_list.after
			loop

				l_list.forth
			end
		end

	print_classes_state
			-- Print state of all classes.
		do
			across blackboard.data.classes as l_classes loop
				print_class_state (l_classes.item)
			end
		end

	print_class_state (a_class: EBB_CLASS_DATA)
			-- Print state of `a_class'.
		do
			append_debug_text ("Class " + a_class.class_name + "%N")
			append_debug_text ("Confidence: " + a_class.verification_state.correctness_confidence.out + "%N")
			append_debug_text ("Features:%N")
			across a_class.features as l_features loop
				print_feature_state (l_features.item)
			end
			append_debug_text ("%N%N")
		end

	print_feature_state (a_feature: EBB_FEATURE_DATA)
			-- Print state of `a_feature'.
		do
			append_debug_text ("Feature " + a_feature.qualified_feature_name + "%N")
			append_debug_text ("Confidence: " + a_feature.verification_state.correctness_confidence.out + "%N")
			append_debug_text (a_feature.verification_state.out)
			append_debug_text ("%N")
		end

	print_features_state
			-- Print feature state.
		local
			l_list: LIST [EBB_FEATURE_DATA]
			l_item: EBB_FEATURE_DATA
		do
			from
				l_list := blackboard.data.features
				l_list.start
			until
				l_list.after
			loop
				l_item := l_list.item
				append_debug_text (l_item.verification_state.out)

				append_debug_text ("%N")
				l_list.forth
			end
		end

	print_feature_history (a_feature: EBB_FEATURE_DATA)
			-- Print feature history.
		local
			l_item: EBB_FEATURE_VERIFICATION_STATE
		do
			append_debug_text ("History:%N")
			across a_feature.verification_history as l_history loop
				l_item := l_history.item
				append_debug_text ("Time: " + l_item.time.out)
				append_debug_text (l_item.out)
				append_debug_text ("%N")
			end
			append_debug_text ("END history")
		end

	on_stone_changed (a_old_stone: like stone)
			-- <Precursor>
		local
		do
			if attached {FEATURE_STONE} a_old_stone as l_feature_stone then
				clear_debug_output
				print_feature_state (blackboard.data.feature_data (l_feature_stone.e_feature.associated_feature_i))
				print_feature_history (blackboard.data.feature_data (l_feature_stone.e_feature.associated_feature_i))
			elseif attached {CLASSC_STONE} a_old_stone as l_class_stone then
				clear_debug_output
				print_class_state (blackboard.data.class_data (l_class_stone.e_class))
			end
		end

feature {NONE} -- Clean up

	internal_recycle
			-- <Precursor>
		do
			manager.prune (Current)
			Precursor
		end

feature {NONE} -- Debug output

	clear_debug_output
			-- Clear debug output.
		do
			debug_output_panel.remove_text
		end

	append_debug_text (a_text: STRING)
			-- Append `a_text' to debug output.
		do
			debug_output_panel.append_text (a_text)
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
