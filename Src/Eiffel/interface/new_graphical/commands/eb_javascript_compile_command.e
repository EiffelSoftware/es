note
	description: "Command to launch JavaScript compilation."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_JAVASCRIPT_COMPILE_COMMAND

inherit

	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item
		end

	COMPILER_EXPORTER
		export {NONE} all end

	SHARED_JSC_ENVIRONMENT
		export {NONE} all end

	SHARED_ERROR_HANDLER
		export {NONE} all end

	SHARED_EIFFEL_PROJECT
		export {NONE} all end

	ES_SHARED_OUTPUTS
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Creation method.
		do
			enable_sensitive
			javascript_compiler.register_message_callbacks (agent put_output_message, agent put_window_message)
		end

feature -- Execution

	execute
			-- Execute menu command.
		local
			l_save_confirm: ES_DISCARDABLE_COMPILE_SAVE_FILES_PROMPT
			l_classes: DS_ARRAYED_LIST [CLASS_I]
		do
			if not eiffel_project.is_compiling then
				if window_manager.has_modified_windows then
					create l_classes.make_default
					window_manager.all_modified_classes.do_all (agent l_classes.force_last)
					create l_save_confirm.make (l_classes)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.yes_button, agent save_compile_and_translate)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.no_button, agent compile_and_translate)
					l_save_confirm.show_on_active_window
				else
					compile_and_translate
				end
			end
		end

feature {NONE} -- Basic operations

	save_compile_and_translate
			-- Save modified windows, compile & translate project.
		do
			window_manager.save_all_before_compiling
			compile_and_translate
		end

	compile_and_translate
			-- Compile & translate project.
		do
				-- Compile the project and only translate if it was succesfull
			eiffel_project.quick_melt (True, True, True)
			if eiffel_project.successful then
				translate
			end
		end

	translate
			-- Translate `a_stone'.
		local
			l_cluster: CLUSTER_I
			l_groups: LIST [CONF_GROUP]
		do
			javascript_compiler.reset

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

				-- Do translation
			general_output.clear
			javascript_compiler.execute_compilation
			general_formatter.end_processing

				-- Add warninigs and errors
			error_handler.warning_list.append (warnings)
			error_handler.warning_list.finish
			error_handler.error_list.append (errors)
			error_handler.error_list.finish
			error_handler.trace
		end

	load_class (a_class: CLASS_I)
			-- Load `a_class' for translation.
		do
			if a_class.is_compiled and then attached a_class.compiled_class as safe_compiled_class then
				javascript_compiler.add_class_to_compile (safe_compiled_class)
			end
		end

	load_cluster (a_cluster: CLUSTER_I)
			-- Load `a_cluster' recursively for translation.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_class_i: CLASS_I
		do
			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_class_i := eiffel_universe.class_named (a_cluster.classes.item_for_iteration.name, a_cluster)
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

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_BUTTON --EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON
			-- <Precursor>
		do
			create Result.make (Current)
			initialize_sd_toolbar_item (Result, display_text)
			Result.select_actions.extend (agent execute)
		end

feature {NONE} -- Implementation

	pixmap: EV_PIXMAP
			-- Pixmap representing the command.
		do
			Result := pixmaps.icon_pixmaps.project_finalize_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.project_finalize_icon_buffer
		end

	put_output_message (a_string: STRING)
			-- Put `a_string' to output panel.
		do
			general_formatter.add_string (a_string)
			general_formatter.add_new_line
			general_formatter.end_processing
		end

	put_window_message (a_string: STRING)
			-- Put `a_string' to window status bar.
		do
			window_manager.display_message (a_string)
		end

feature {NONE} -- Implementation

	menu_name: STRING_GENERAL
			-- Name as it appears in the menu (with & symbol).
		do
			Result := "Compile system to JavaScript"
		end

	tooltip: STRING_GENERAL
			-- Tooltip for the toolbar button.
		do
			Result := "Compile system to JavaScript"
		end

	tooltext: STRING_GENERAL
			-- Text for the toolbar button.
		do
			Result := "JavaScript Compile"
		end

	description: STRING_GENERAL
			-- Description for this command.
		do
			Result := "Compile system to JavaScript"
		end

	name: STRING_GENERAL
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "JavaScript Compile"
		end

feature {NONE} -- Implementation

	javascript_compiler: JAVASCRIPT_COMPILER
		once
			create Result.make
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software"
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
