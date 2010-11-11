note
	description: "Summary description for {ES_BLACKBOARD_BENCH_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_BLACKBOARD_BENCH_HELPER

inherit

	EBB_SHARED_BLACKBOARD

feature

	style_feature_grid_item (a_grid_item: EV_GRID_ITEM; a_feature: E_FEATURE)
			-- Style `a_grid_item' which represents `a_feature'.
		local
			l_feature_data: EBB_FEATURE_DATA
		do
			if blackboard.data.has_feature (a_feature.associated_feature_i) then
				l_feature_data := blackboard.data.feature_data (a_feature.associated_feature_i)
				if l_feature_data.has_verification_score then
					if l_feature_data.is_stale then
						a_grid_item.set_background_color (light_color_for_stale_correctness (l_feature_data.verification_score))
					else
						a_grid_item.set_background_color (light_color_for_correctness (l_feature_data.verification_score))
					end
					a_grid_item.set_tooltip ("statically verified")
				end
			end
		end

	refresh_features_grid_verification_status (a_grid: ES_FEATURES_GRID)
			-- Refresh `a_grid'.
		do
			a_grid.recursive_do_all (
				agent (a_row: EV_GRID_ROW)
					do
						if a_row.count > 0 and then attached {E_FEATURE} a_row.data as l_ef then
							style_feature_grid_item (a_row.item (1), l_ef)
						end
					end
			)
		end

	connect_features_tool (a_grid: ES_FEATURES_GRID)
			-- Connect update of features grid with blackboard.
		do
			blackboard.data_changed_event.subscribe (agent a_grid.update_verification_status)
		end

	build_context_menu_for_class_stone (a_menu: EV_MENU; a_stone: CLASSC_STONE)
			-- Build context menu for class stone `a_stone' and add it to `a_menu'.
			--
			-- Added to {EB_CONTEXT_MENU_FACTORY}.extend_standard_compiler_item_menu
		require
			a_menu_not_void: a_menu /= Void
			a_stone_not_void: a_stone /= Void
		local
			l_menu: EV_MENU
			l_item: EV_MENU_ITEM
			l_tool: EBB_TOOL
		do
			create l_menu.make_with_text ("Verification assistant")
			a_menu.extend (l_menu)

			from
				blackboard.tools.start
			until
				blackboard.tools.after
			loop
				l_tool := blackboard.tools.item

				from
					l_tool.configurations.start
				until
					l_tool.configurations.after
				loop
					create l_item.make_with_text ("Launch " + l_tool.name + " - " + l_tool.configurations.item.name)
					l_item.select_actions.extend (agent launch_tool (l_tool, l_tool.configurations.item, a_stone.e_class))
					l_tool.configurations.forth
					l_menu.extend (l_item)
				end

				blackboard.tools.forth
			end
		end

	launch_tool (a_tool: EBB_TOOL; a_configuration: EBB_TOOL_CONFIGURATION; a_class: CLASS_C)
		local
			l_input: EBB_TOOL_INPUT
			l_execution: EBB_TOOL_EXECUTION
		do
			create l_input.make
			l_input.add_class (a_class)

			create l_execution.make (a_tool, a_configuration, l_input)
			blackboard.executions.queue_tool_execution (l_execution)
		end

feature -- Helper

	light_color_for_correctness (a_value: REAL): EV_COLOR
		do
			Result := gradient_color_hsv (a_value, 0.0, 0.32, 0.1, 1.0)
		end

	light_color_for_stale_correctness (a_value: REAL): EV_COLOR
		do
			Result := gradient_color_hsv (a_value, 0.0, 0.32, 0.1, 0.8)
		end

	color_for_correctness (a_value: REAL): EV_COLOR
		do
			Result := gradient_color_hsv (a_value, 0.0, 0.32, 0.4, 1.0)
		end

	color_for_stale_correctness (a_value: REAL): EV_COLOR
		do
			Result := gradient_color_hsv (a_value, 0.0, 0.32, 0.4, 0.8)
		end

	gradient_color_hsv (a_gradient, a_start, a_end, a_saturation, a_value: REAL): EV_COLOR
			-- Gradient color.
			-- all values are between 0 and 1.
		local
			l_hue, l_saturation, l_value, m, n, f: REAL
			i: INTEGER
		do
			l_hue := (a_start + (a_gradient * (a_end - a_start))) * 6
			l_saturation := a_saturation
			l_value := a_value

			i := l_hue.floor
			f := l_hue - i
			if i \\ 2 = 0 then
				f := 1 - f
			end
			m := l_value * (1 - l_saturation)
			n := l_value * (1 - (l_saturation * f))
			inspect i
			when 0 then
				create Result.make_with_rgb (l_value, n, m)
			when 1 then
				create Result.make_with_rgb (n, l_value, m)
			when 2 then
				create Result.make_with_rgb (m, l_value, n)
			when 3 then
				create Result.make_with_rgb (m, n, l_value)
			when 4 then
				create Result.make_with_rgb (n, m, l_value)
			when 5 then
				create Result.make_with_rgb (l_value, m, n)
			when 6 then
				create Result.make_with_rgb (l_value, n, m)
			end
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
