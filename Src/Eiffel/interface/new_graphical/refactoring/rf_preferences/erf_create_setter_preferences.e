note
	description: "Summary description for {ERF_EXTRACT_METHOD_PREFERENCES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_CREATE_SETTER_PREFERENCES

inherit
	ERF_PREFERENCES
		redefine
			initialize_preferences
		end

feature -- Value

	assignment: STRING
			-- Text of assignment
		do
			Result := assignment_preference.value
		end

	postcondition: STRING
			-- Text of postcondition
		do
			Result := postcondition_preference.value
		end

	setter_name: STRING
			-- Name of setter
		do
			Result := setter_name_preference.value
		end

	argument_name: STRING
			-- Name of argument
		do
			Result := argument_name_preference.value
		end

feature -- Change value

	set_assignment (a_text: STRING)
			-- Set text of assignment
		require
			a_text_not_void: a_text /= void
		do
			assignment_preference.set_value (a_text)
		end

	set_postcondition (a_text: STRING)
			-- Set text of postcondition
		require
			a_text_not_void: a_text /= void
		do
			postcondition_preference.set_value (a_text)
		end

	set_setter_name (a_text: STRING)
			-- Set name of setter
		require
			a_text_not_void: a_text /= void
		do
			setter_name_preference.set_value (a_text)
		end

	set_argument_name (a_text: STRING)
			-- Set name of argument
		require
			a_text_not_void: a_text /= void
		do
			argument_name_preference.set_value (a_text)
		end

feature {NONE} -- Preference

	assignment_preference: STRING_PREFERENCE
	postcondition_preference: STRING_PREFERENCE
	setter_name_preference: STRING_PREFERENCE
	argument_name_preference: STRING_PREFERENCE

feature {NONE} -- Preference Strings

	assignment_string: STRING = "tools.refactoring.create_setter.assignment"
	postcondition_string: STRING = "tools.refactoring.create_setter.postcondition"
	setter_name_string: STRING = "tools.refactoring.create_setter.setter_name"
	argument_name_string: STRING = "tools.refactoring.create_setter.argument_name"

feature {NONE} -- Implementation

	initialize_preferences
			-- Initialize preference values.
		local
			l_manager: EB_PREFERENCE_MANAGER
			l_update_agent: PROCEDURE [ANY, TUPLE]
		do
			create l_manager.make (preferences, "refactoring.create_setter")
			l_update_agent := agent update

			assignment_preference := l_manager.new_string_preference_value (l_manager, assignment_string, "<uninit>")
			assignment_preference.change_actions.extend (l_update_agent)

			postcondition_preference := l_manager.new_string_preference_value (l_manager, postcondition_string, "<uninit>")
			postcondition_preference.change_actions.extend (l_update_agent)

			setter_name_preference := l_manager.new_string_preference_value (l_manager, setter_name_string, "<uninit>")
			setter_name_preference.change_actions.extend (l_update_agent)

			argument_name_preference := l_manager.new_string_preference_value (l_manager, argument_name_string, "<uninit>")
			argument_name_preference.change_actions.extend (l_update_agent)
		end

invariant
	assignment_preference_not_void: assignment_preference /= Void
	postcondition_preference_not_void: postcondition_preference /= Void
	setter_name_preference_not_void: setter_name_preference /= Void
	argument_name_preference_not_void: argument_name_preference /= Void
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
