note
	description: "The tool panel factory. The implementation is in the SCHEMA_EVOLUTION_TOOL class"
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	ES_SCHEMA_EVOLUTION_TOOL_PANEL

inherit
	EB_TOOL
		redefine
		--	attach_to_docking_manager,
			internal_recycle
		end

	EB_SHARED_MANAGERS

--	EB_RECYCLABLE

	EB_CONSTANTS

	SHARED_DEBUGGER_MANAGER

	SHARED_EIFFEL_PROJECT

	EB_TEXT_OUTPUT_FACTORY

create
	make

feature {NONE} -- Initialization

	make_with_tool
			-- Create the SCHEMA_EVOLUTION_TOOL as a new tool.
		local
			tmp: SCHEMA_EVOLUTION_TOOL
		do
			create tmp.make
			widget := tmp
			create output_display_factory
		end

	build_interface
			-- Build interface
		do
			make_with_tool
		end

feature {EB_DEVELOPMENT_WINDOW_BUILDER} -- Initialization
--  removed in new eve on the assumption that is not needed because of void safety
--	attach_to_docking_manager (a_docking_manager: SD_DOCKING_MANAGER) is
--			-- Attach to docking manager.
--		do
--			build_docking_content (a_docking_manager)
--			check not_already_has: not a_docking_manager.has_content (content) end
--			a_docking_manager.contents.extend (content)
--		end

feature -- Clean up

	internal_recycle
			 -- To be called before destroying this objects.
		do
			Precursor {EB_TOOL}
		end

feature -- Status setting

	set_parent_notebook (a_notebook: EV_NOTEBOOK)
			-- Set `parent_notebok' to `a_notebook'.
		require
			a_notebook_non_void: a_notebook /= Void
			a_notebook_really_parent: a_notebook.has (widget)
		do
			parent_notebook := a_notebook
		end

	force_display
			-- Jump to this tab and display `explorer_parent'.
			-- Only if `Current' is in the focused window.
		do
			if develop_window = Window_manager.last_focused_window then
				if not is_shown or else is_auto_hide then
					show_with_setting
				end
				content.set_focus
			end
		end

	on_select
			-- Display information from the selected formatter.
		do
			visible := True
		end

	on_deselect
			-- This view is hidden.
		do
			visible := False
		end

	set_focus
			-- Give the focus to the editor.
		require
			focusable: widget.is_displayed and widget.is_sensitive
		do
			--text_area.set_focus
		end

feature -- Status report

	is_general: BOOLEAN
			-- Is general output tool?
		do
			Result := true
		end

feature -- Access

	widget: EV_WIDGET
			-- Graphical representation for Current.

	parent_notebook: EV_NOTEBOOK
			-- Needed to pop up when corresponding menus are selected.
			--| Not in implementation because it is used in a precondition.

	output_display_factory: EB_TEXT_OUTPUT_FACTORY
			-- Output display factory.

feature {NONE} -- Implementation

	visible: BOOLEAN
			-- Are we displayed by `parent_notebook'?

	drop_breakable (st: BREAKABLE_STONE)
			-- Inform `Current's manager that a stone concerning breakpoints has been dropped.
		do

		end

	drop_class (st: CLASSI_STONE)
			-- Drop `st' in the context tool and pop the `class info' tab.
		require
			st_valid: st /= Void
		local
			l_class_tool: ES_CLASS_TOOL_PANEL
			l_feature_tool: ES_FEATURES_RELATION_TOOL_PANEL
			l_feature_stone: FEATURE_STONE
		do
			l_feature_stone ?= st
			if l_feature_stone /= Void then
				l_feature_tool := develop_window.tools.features_relation_tool
				l_feature_tool.set_stone (st)
				l_feature_tool.show
				l_feature_tool.set_focus
			else
				l_class_tool := develop_window.tools.class_tool
				l_class_tool.set_stone (st)
				l_class_tool.show
				l_class_tool.set_focus
			end
		end

	drop_feature (st: FEATURE_STONE)
			-- Drop `st' in the context tool and pop the `feature info' tab.
		require
			st_valid: st /= Void
		local
			l_feature_tool: ES_FEATURES_RELATION_TOOL_PANEL
		do
			l_feature_tool := develop_window.tools.features_relation_tool
			l_feature_tool.set_stone (st)
			l_feature_tool.show
	--	new escher: I had to remove this because feature {ES_FEATURES_RELATION_TOOL_PANEL}.content is not visible anymore
	--		l_feature_tool.content.set_focus
			l_feature_tool.set_focus
		end

	drop_cluster (st: CLUSTER_STONE)
			-- Drop `st' in the context tool.
		require
			st_valid: st /= Void
		do
			develop_window.tools.launch_stone (st)
		end
invariant
	-- Insert invariant here
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
