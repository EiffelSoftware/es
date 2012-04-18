indexing
	description: "All shared preferences for the Ebbro tool."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_EBBRO_TOOL_DATA

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

feature {EB_SHARED_PREFERENCES, EB_TOOL} -- Value


	is_split_screen_enabled: BOOLEAN is
			-- Is the split screen enabled?
		do
			Result := split_screen_preference.value
		end

	is_addr_column_shown: BOOLEAN is
			-- Is address column shown?
		do
			Result := show_addr_column_preference.value
		end

	is_cyclic_browsing_enabled: BOOLEAN is
			-- Is cyclic browsing through objects enabled?
		do
			Result := cyclic_browsing_preference.value
		end

	split_position: INTEGER is
			-- The position of the split screen.
		do
			Result := split_position_preference.value
		end

	is_filter_in_enabled:BOOLEAN is
			-- Is currently filter IN enabled, not filter OUT of objects?
		do
			Result := filter_in_preference.value
		end

	show_overwrite_question_on_save:BOOLEAN is
			-- Is a question prompt shown, when the user is clicking SAVE
		do
			Result := show_overwrite_question_preference.value
		end



feature {EB_SHARED_PREFERENCES,EB_TOOL} -- Preference

	split_screen_preference:BOOLEAN_PREFERENCE
	show_addr_column_preference:BOOLEAN_PREFERENCE
	cyclic_browsing_preference:BOOLEAN_PREFERENCE
	filter_in_preference:BOOLEAN_PREFERENCE
	split_position_preference:INTEGER_PREFERENCE
	show_overwrite_question_preference:BOOLEAN_PREFERENCE


feature {NONE} -- Preference Strings

	split_screen_string: STRING is "tools.ebbro.split_screen"
	show_addr_column_string: STRING is "tools.ebbro.show_addr_column"
	cyclic_browsing_string: STRING is "tools.ebbro.cyclic_browsing"
	filter_in_string: STRING is "tools.ebbro.filter_in"
	split_position_string: STRING is "tools.ebbro.split_position"
	show_overwrite_question_string:STRING is "tools.ebbro.show_overwrite_question"


feature {NONE} -- Implementation

	initialize_preferences is
			-- Initialize preference values.
		local
			l_manager: EB_PREFERENCE_MANAGER
		do
			create l_manager.make (preferences, "tools.ebbro")

			split_screen_preference := l_manager.new_boolean_preference_value (l_manager,split_screen_string , False)
			show_addr_column_preference := l_manager.new_boolean_preference_value (l_manager,show_addr_column_string , False)
			cyclic_browsing_preference := l_manager.new_boolean_preference_value (l_manager,cyclic_browsing_string , False)
			filter_in_preference := l_manager.new_boolean_preference_value (l_manager,filter_in_string , True)
			split_position_preference := l_manager.new_integer_preference_value (l_manager,split_position_string , 20)
			show_overwrite_question_preference := l_manager.new_boolean_preference_value (l_manager, show_overwrite_question_string, True)

			-- Default value is not stored in the 'default.xml' file, thus it is set here
			split_screen_preference.set_default_value ("False")
			show_addr_column_preference.set_default_value ("False")
			cyclic_browsing_preference.set_default_value ("False")
			filter_in_preference.set_default_value ("True")
			split_position_preference.set_default_value ("20")
			show_overwrite_question_preference.set_default_value("True")

		end

	preferences: PREFERENCES
			-- Preferences

invariant
	preferences_not_void: preferences /= Void

indexing
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
