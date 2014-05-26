
class ES_ADB_PANEL_FIXES

inherit

	ES_ADB_PANEL_FIXES_IMP

	ES_ADB_ACTIONS
		undefine
			copy,
			default_create,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_tool: like tool_panel)
			-- Initialization
		require
			a_tool /= Void
		do
			set_tool_panel (a_tool)
			default_create

			reset_info_widgets (False)
			reset_command_widgets (False)
			register_event_handlers

			Info_center.extend (Current)
		end

	reset_info_widgets (a_flag: BOOLEAN)
			--
		local
		do
			if a_flag then
				evgrid_fixes.enable_sensitive
			else
				evgrid_fixes.disable_sensitive
			end
		end

	reset_command_widgets (a_flag: BOOLEAN)
			--
		do
			if a_flag then
				evbutton_apply.enable_sensitive
			else
				evbutton_apply.disable_sensitive
			end
		end

	register_event_handlers
		do
			evgrid_fixes.row_select_actions.extend (agent on_row_select)
			evgrid_fixes.row_deselect_actions.extend (agent on_row_deselect)
		end

feature -- GUI actions

	on_row_select (a_row: EV_GRID_ROW)
			--
		local
		do
			if attached {ES_ADB_FIX} a_row.data as lt_fix then

			end
		end

	on_row_deselect (a_row: EV_GRID_ROW)
			--
		local
		do
			ebsmart_source.clear_window
			ebsmart_target.clear_window
		end



feature -- Actions

	on_project_loaded
			-- Action to be performed when project loaded
		do
		end

	on_project_unloaded
			-- Action to be performed when project unloaded
		do
		end

	on_compile_start
			-- Action to be performed when Eiffel compilation starts
		do
		end

	on_compile_stop
			-- Action to be performed when Eiffel compilation stops
		do
		end

	on_debugging_start
			-- Action to be performed when debugging starts
		do

		end

	on_debugging_stop
			-- Action to be performed when debugging stops.
		do
		end

	on_testing_start
			-- Action to be performed when debugging starts
		do
		end

	on_test_case_generated (a_test: ES_ADB_TEST)
			-- Action to be performed when a new test case is generated
		do
		end

	on_testing_stop
		do
		end

	on_fixing_start (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_valid_fix_found (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_fault: ES_ADB_FAULT
			l_row, l_row_for_fault, l_row_for_fix: EV_GRID_ROW
			l_index, l_count, l_insertion_position: INTEGER
		do
			l_fault := a_fix.fault
				-- Locate the row for the fault.
			from
				l_index := 1
				l_count := evgrid_fixes.row_count
				l_insertion_position := 0
			until
				l_index > l_count or else l_row_for_fault /= Void or else l_insertion_position > 0
			loop
				l_row := evgrid_fixes.row (l_index)
				if attached {ES_ADB_FAULT} l_row.data as lt_fault then
					if lt_fault ~ l_fault then
						l_row_for_fault := l_row
					elseif lt_fault.signature.id.is_greater (l_fault.signature.id) then
						l_insertion_position := l_index
					end
				end
				l_index := l_index + 1
			end
				-- If not present, add the row at the right position and initialize it
			if l_row_for_fault = Void then
				evgrid_fixes.set_row_count_to (l_count + 1)
				if l_insertion_position = 0 then
					l_insertion_position := l_count + 1
				else
					evgrid_fixes.move_row (l_count + 1, l_insertion_position)
				end
				l_row_for_fault := evgrid_fixes.row (l_insertion_position)
				l_row_for_fault.set_data (l_fault)
				l_row_for_fault.set_item (column_fault, create {EV_GRID_LABEL_ITEM})
			end
				-- Locate where to insert the new fix
			from
				l_index := 1
				l_count := l_row_for_fault.subrow_count
				l_insertion_position := 0
			until
				l_index > l_count or else l_insertion_position > 0
			loop
				if attached {ES_ADB_FIX} (l_row_for_fault.subrow (l_index).data) as lt_fix then
					if lt_fix.ranking >= a_fix.ranking then
						l_insertion_position := l_index
					end
				end
				l_index := l_index + 1
			end
			if l_insertion_position = 0 then
				l_insertion_position := l_row_for_fault.subrow_count + 1
			end
			l_row_for_fault.insert_subrow (l_insertion_position)
			l_row_for_fix := l_row_for_fault.subrow (l_insertion_position)
			l_row_for_fix.set_item (column_type, create {EV_GRID_LABEL_ITEM}.make_with_text (a_fix.type))
			l_row_for_fix.set_item (column_nature, create {EV_GRID_LABEL_ITEM}.make_with_text (a_fix.nature_of_change_string))
			l_row_for_fix.set_item (column_status, create {EV_GRID_LABEL_ITEM})
			if a_fix.has_been_applied then
				on_fix_applied (a_fix)
			end

		end

	on_fix_applied (a_fix: ES_ADB_FIX)
			-- <Precursor>
		local
			l_fault: ES_ADB_FAULT
			l_row, l_row_for_fault, l_row_for_fix: EV_GRID_ROW
			l_index, l_count, l_insertion_position: INTEGER
		do
			l_fault := a_fix.fault
				-- Locate the row for the fault.
			from
				l_index := 1
				l_count := evgrid_fixes.row_count
			until
				l_index > l_count or else l_row_for_fault /= Void
			loop
				l_row := evgrid_fixes.row (l_index)
				if attached {ES_ADB_FAULT} l_row.data as lt_fault and then lt_fault ~ l_fault then
					l_row_for_fault := l_row
				end
				l_index := l_index + 1
			end
			check l_row_for_fault /= Void end
			l_row_for_fault.set_item (column_status, create {EV_GRID_LABEL_ITEM}.make_with_text (l_fault.status_string))

				-- Locate the fix
			from
				l_index := 1
				l_count := l_row_for_fault.subrow_count
			until
				l_index > l_count or else l_row_for_fix /= Void
			loop
				if attached {ES_ADB_FIX} (l_row_for_fault.subrow (l_index).data) as lt_fix and then lt_fix ~ a_fix then
					l_row_for_fix := l_row_for_fault.subrow (l_index)
				end
				l_index := l_index + 1
			end
			l_row_for_fix.set_item (column_status, create {EV_GRID_LABEL_ITEM}.make_with_text ("Applied"))

		end

	on_fixing_stop (a_fault: ES_ADB_FAULT)
			-- <Precursor>
		do
		end

	on_output (a_line: STRING)
		do
		end

feature {NONE} -- Recycle

	internal_recycle
			-- To be called when the button has became useless.
		do
--			preferences.metric_tool_data.unit_order_preference.change_actions.prune_all (on_unit_order_change_agent)
--			uninstall_agents (metric_tool)
--			domain_selector.recycle
--			metric_selector.recycle
		end

feature{NONE} -- Implementation

	update_ui
			-- <Precursor>
		do
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
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
