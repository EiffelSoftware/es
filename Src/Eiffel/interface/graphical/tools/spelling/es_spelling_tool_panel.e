note
	description: "Graphical panel for spelling tool"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_SPELLING_TOOL_PANEL

inherit

	ES_DOCKABLE_TOOL_PANEL [EV_HORIZONTAL_BOX]
		redefine
			on_after_initialized
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	build_tool_interface (a_widget: like user_widget)
			-- <Precursor>
		do
			create panel
			a_widget.extend (panel)
		end

	on_after_initialized
			-- <Precursor>
		do
			Precursor {ES_DOCKABLE_TOOL_PANEL}
		end

feature -- Access

	panel: EV_TEXT
			-- Display panel.

feature {NONE} -- Factory

	create_widget: EV_HORIZONTAL_BOX
			-- <Precursor>
		do
			create Result
		end

	create_tool_bar_items: ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		do
			create Result.make (1)
			Result.extend ((create {ES_SPELL_CHECK_COMMAND}.make).new_sd_toolbar_item (True))
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
