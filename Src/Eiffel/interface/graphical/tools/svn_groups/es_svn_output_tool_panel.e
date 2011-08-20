note
	description: "Graphical panel for EiffelStudio's Subversion output."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_SVN_OUTPUT_TOOL_PANEL

inherit
	ES_DOCKABLE_TOOL_PANEL [EV_VERTICAL_BOX]

create
	make

feature {NONE} -- Initialization

	build_tool_interface (a_widget: EV_VERTICAL_BOX)
			-- <Precursor>
		do
			create text_output
			text_output.disable_edit
			text_output.scroll_to_end
			a_widget.extend (text_output)
		end

feature {ES_SVN_OUTPUT_TOOL} -- Element change

	append_output (a_output: STRING_8)
		do
			text_output.append_text (a_output)
		end

feature {NONE} -- Factory

	create_tool_bar_items: detachable DS_ARRAYED_LIST [SD_TOOL_BAR_ITEM]
			-- <Precursor>
		local
			l_button: SD_TOOL_BAR_BUTTON
		do
			create Result.make (1)

				-- Add button `clear' to the toolbar
			create l_button.make
			l_button.set_tooltip ("Clear SVN output")
			l_button.select_actions.extend (agent clear_text)
			l_button.set_pixel_buffer (stock_pixmaps.general_reset_icon_buffer)
			l_button.set_pixmap (stock_pixmaps.general_reset_icon)
			clear_text_button := l_button

			Result.put_last (l_button)
		end

	create_widget: EV_VERTICAL_BOX
			-- <Precursor>
		do
			create Result
		end

feature {NONE} -- Access

	text_output: EV_TEXT

	clear_text_button: SD_TOOL_BAR_BUTTON

	clear_text
		do
			text_output.remove_text
		end

feature {NONE} -- Internationalization

	t_panel_title: STRING = "SVN Output"

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
