indexing
	description: "All shared attributes specific to Origo."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_DATA

create
	make

feature {EB_PREFERENCES} -- Initialization

	make (a_preferences: PREFERENCES) is
			-- Create
		require
			preferences_not_void: a_preferences /= Void
		do
			preferences := a_preferences
			initialize_preferences
		ensure
			preferences_not_void: preferences /= Void
		end

feature {EB_SHARED_PREFERENCES, EB_DEVELOPMENT_WINDOW_MAIN_BUILDER} -- Value

	xml_rpc_client_path: STRING is
			-- Path of origo xml rpc command line client
		do
			Result := xml_rpc_client_path_preference.value
		end

	user_key: STRING is
			-- Origo user key
		do
			Result := user_key_preference.value
		end

	number_of_workitems: INTEGER is
			-- number of workitems to show
		do
			Result := number_of_workitems_preference.value
		end

	show_unread_only: BOOLEAN is
			-- show only unread workitems?
		do
			Result := show_unread_only_preference.value
		end

feature {EB_SHARED_PREFERENCES} -- Preference

	xml_rpc_client_path_preference: STRING_PREFERENCE
	user_key_preference: STRING_PREFERENCE
	number_of_workitems_preference: INTEGER_PREFERENCE
	show_unread_only_preference: BOOLEAN_PREFERENCE

feature {NONE} -- Preference Strings

	xml_rpc_client_path_string: STRING is "tools.origo.xml_rpc_client_path"
	user_key_string: STRING is "tools.origo.user_key"
	number_of_workitems_string: STRING is "tools.origo.number_of_workitems"
	show_unread_only_string: STRING is "tools.origo.show_unread_only"

feature {NONE} -- Implementation

	initialize_preferences is
			-- Initialize preference values.
		local
			l_manager: EB_PREFERENCE_MANAGER
		do
			create l_manager.make (preferences, "origo")
			xml_rpc_client_path_preference := l_manager.new_string_preference_value (l_manager, xml_rpc_client_path_string, "")
			user_key_preference := l_manager.new_string_preference_value (l_manager, user_key_string, "")
			number_of_workitems_preference := l_manager.new_integer_preference_value (l_manager, number_of_workitems_string, 25)
			show_unread_only_preference := l_manager.new_boolean_preference_value (l_manager, show_unread_only_string, False)
		end

	preferences: PREFERENCES
			-- Preferences

invariant
	preferences_not_void: preferences /= Void

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EB_CONTEXT_TOOL_DATA

