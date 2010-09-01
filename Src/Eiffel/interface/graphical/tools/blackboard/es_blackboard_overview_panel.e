note
	description: "Summary description for {ES_BLACKBOARD_SYSTEM_PANEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_BLACKBOARD_OVERVIEW_PANEL
	
create
	make

feature {NONE} -- Initialization

	make
			-- Initialize panel.
		do
			create grid

			grid_token_support.synchronize_color_or_font_change_with_editor
			grid_token_support.enable_grid_item_pnd_support
			grid_token_support.enable_ctrl_right_click_to_open_new_window
--			grid_token_support.set_context_menu_factory_function (agent (develop_window.menus).context_menu_factory)
		end

feature -- Access

	grid: ES_GRID
			-- Grid to display system data.

feature {NONE} -- Helpers

	token_generator: EB_EDITOR_TOKEN_GENERATOR
			-- An editor token generator for generating editor token on grid items
		once
			Result := (create {EB_SHARED_WRITER}).token_writer
		end

	frozen grid_token_support: EB_EDITOR_TOKEN_GRID_SUPPORT
			-- Support for using `grid_events' with editor token-based items
		do
			Result := internal_grid_token_support
			if Result = Void then
				create Result.make_with_grid (grid)
				internal_grid_token_support := Result
--				auto_recycle (internal_grid_token_support)
			end
		ensure
			result_attached: Result /= Void
			result_consistent: Result = grid_token_support
		end

feature {NONE} -- Implementation: Internal cache

	internal_grid_token_support: like grid_token_support
			-- Cached version of `grid_token_support'
			-- Note: Do not use directly!

;note
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
