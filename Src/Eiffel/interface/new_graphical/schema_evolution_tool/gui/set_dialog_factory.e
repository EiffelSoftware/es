note
	description: "Factory for dialogs."
	author: "Teseo Schneider, Marco Piccioni"
	date: "07.04.09"

class
	SET_DIALOG_FACTORY

inherit
	EB_SHARED_WINDOW_MANAGER
		rename
			default_create as default_create_shared_window,
			copy as copy_shared_window
		export
			{NONE} all
		end
	EV_DIALOG
		rename
			show as show_dialog
		select
			copy,
			default_create
		end

		create
			make

feature -- Create

	make (a_title: STRING)
			-- Create a dialog given a title.
		require
			title_exists: a_title /= Void and not a_title.is_empty
		do
			make_with_title (a_title)
		end

feature  -- Action
	show
			--show the last dialog in the current window.
		do
			show_modal_to_window (window_manager.last_focused_development_window.window)
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
