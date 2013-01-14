note
	description:
		"Graphical panel for AutoFix tool"
	date: "$Date$"
	revision: "$Revision$"

class ES_EVE_AUTOFIX_TOOL_PANEL

inherit
	ES_DOCKABLE_TOOL_PANEL [ES_AUTOFIX_WIDGET]
		redefine
			on_after_initialized,
			create_mini_tool_bar_items
		end

	ES_HELP_CONTEXT
		export
			{NONE} all
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

	SHARED_EIFFEL_PROJECT

create
	make

feature -- Access

	autofix_results: HASH_TABLE [ES_EVE_AUTOFIX_RESULT, STRING]
			-- Mapping from fault signatures to AutoFix results .
			-- Key: fault signatures
			-- Val: results from fixing
		do
			if autofix_results_cache = Void then
				create autofix_results_cache.make (30)
				autofix_results_cache.compare_objects
			end
			Result := autofix_results_cache
		end

feature {NONE} -- Initialization

    build_tool_interface (a_widget: like user_widget)
            -- <Precursor>
		do
		end

	on_after_initialized
			-- <Precursor>
		do
			Precursor {ES_DOCKABLE_TOOL_PANEL}

			reload_all_from_result_directory
			user_widget.refresh_all
		end

feature -- Basic operation

	reload (a_fault_signature: STRING)
			-- Reload the result for `a_fault_signature'.
		require
			signature_not_empty: a_fault_signature /= Void and then not a_fault_signature.is_empty
		local
			l_result: ES_EVE_AUTOFIX_RESULT
		do
			if autofix_results.has (a_fault_signature) then
				l_result := autofix_results.item (a_fault_signature)
				l_result.reload
			else
				create l_result.make (a_fault_signature)
				autofix_results.force (l_result, a_fault_signature)
			end
			user_widget.refresh (a_fault_signature)
		end

	reload_all
			-- Reload all autofix results from AutoFix result directory.
		do
			reload_all_from_result_directory
			user_widget.refresh_all
		end

feature {NONE} -- Implementation

	reload_all_from_result_directory
			-- Load all autofix_results from the default output directory of AutoFix.
		local
			l_result_dir: DIRECTORY
			l_entry_name: STRING
			l_fault_signature: STRING
			l_result: ES_EVE_AUTOFIX_RESULT
		do
			autofix_results.wipe_out
			if attached eiffel_project as lt_prj and then attached lt_prj.project_directory as lt_dir then
				create l_result_dir.make_with_path (lt_dir.fixing_results_path)
				if l_result_dir.exists then
					l_result_dir.open_read
					if not l_result_dir.is_closed then
						from
							l_result_dir.start
							l_result_dir.readentry
						until
							l_result_dir.lastentry = Void
						loop
							l_entry_name := l_result_dir.lastentry.twin
							if l_entry_name.ends_with (".afr") then
								l_fault_signature := l_entry_name.substring (1, l_entry_name.count -4)
								create l_result.make (l_fault_signature)
								autofix_results.force (l_result, l_fault_signature)
							end

							l_result_dir.readentry
						end
					end
				end
			end
		end

feature -- Access: Help

	help_context_id: STRING_32
			-- <Precursor>
		once
			Result := "26E2C799-B48A-C588-CDF1-DD47B1994B09"
		end

feature {NONE} -- Cache

	autofix_results_cache: like autofix_results
			-- Cache for `autofix_results'.

feature {NONE} -- Factory

    create_widget: ES_AUTOFIX_WIDGET
            -- <Precursor>
		do
			create Result.make (Current)
		end

    create_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
            -- <Precursor>
		do
			--| No tool bar
		end

    create_mini_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
            -- <Precursor>
		local
			l_item: SD_TOOL_BAR_BUTTON
        do
  			create Result.make (10)
        end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
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
