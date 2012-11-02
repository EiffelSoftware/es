note
	description: "Dialog Factory for Ebbro Tools. Provides common Dialogs."
	author: "Lucien Hansen"
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_DIALOG_FACTORY

inherit
	EB_SHARED_PREFERENCES

	ES_EBBRO_PERSISTENCE_CONSTANTS

	EIFFEL_LAYOUT

feature -- open dialog

	open_object_dialog: EB_FILE_OPEN_DIALOG
			-- a common open file dialog, used in ebbro
		local
			l_pref: STRING_PREFERENCE
		do
			l_pref := preferences.dialog_data.last_opened_object_directory_in_ebbro
			if l_pref.value = Void or else l_pref.value.is_empty then
				l_pref.set_value (eiffel_layout.user_projects_path.out)
			end

			create result.make_with_preference (l_pref)
			result.filters.extend (all_filter)
			result.filters.extend (dadl_filter)
			result.filters.extend (binary_filter)
			result.set_title ("Choose object location...")
			result.disable_multiple_selection

		ensure
			result_set: result /= void
		end


note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
