note
	description: "Preferences for the extract constant refactoring."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_CONSTANT_PREFERENCES

inherit
	ERF_PREFERENCES
		redefine
			initialize_preferences
		end

feature -- Value

	descendants_flag: BOOLEAN
			-- Descendants flag
		do
			Result := descendants_preference.value
		end

	ancestors_flag: BOOLEAN
			-- Ancestors flag
		do
			Result := ancestors_preference.value
		end

	whole_class_flag: BOOLEAN
			-- whole_class flag
		do
			Result := whole_class_preference.value
		end

	constant_name: STRING
			-- Name of constant
		do
			Result := constant_name_preference.value
		end

feature -- Change value

	set_descendants (a_state: BOOLEAN)
			-- Set descendants flag
		do
			descendants_preference.set_value (a_state)
		end

	set_ancestors (a_state: BOOLEAN)
			-- Set ancestors flag
		do
			ancestors_preference.set_value (a_state)
		end

	set_whole_class (a_state: BOOLEAN)
			-- Set whole_class flag
		do
			whole_class_preference.set_value (a_state)
		end

	set_constant_name (a_name: STRING)
			-- Set constant name to `a_name'
		require
			non_void: a_name /= void
		do
			constant_name_preference.set_value (a_name)
		end

feature {NONE} -- Preference

	ancestors_preference: BOOLEAN_PREFERENCE
	descendants_preference: BOOLEAN_PREFERENCE
	whole_class_preference: BOOLEAN_PREFERENCE
	constant_name_preference: STRING_PREFERENCE

feature {NONE} -- Preference Strings

	ancestors_string: STRING = "tools.refactoring.extract_constant.ancestors"
	descendants_string: STRING = "tools.refactoring.extract_constant.descendants"
	constant_name_string: STRING = "tools.refactoring.extract_constant.constant_name"
	whole_class_string: STRING = "tools.refactoring.extract_constant.whole_class"

feature {NONE} -- Implementation

	initialize_preferences
			-- Initialize preference values.
		local
			l_manager: EB_PREFERENCE_MANAGER
			l_update_agent: PROCEDURE [ANY, TUPLE]
		do
			create l_manager.make (preferences, "refactoring.extract_method")
			l_update_agent := agent update

			ancestors_preference := l_manager.new_boolean_preference_value (l_manager, ancestors_string, true)
			ancestors_preference.change_actions.extend (l_update_agent)

			descendants_preference := l_manager.new_boolean_preference_value (l_manager, descendants_string, true)
			descendants_preference.change_actions.extend (l_update_agent)

			constant_name_preference := l_manager.new_string_preference_value (l_manager, constant_name_string, "constant")
			constant_name_preference.change_actions.extend (l_update_agent)

			whole_class_preference := l_manager.new_boolean_preference_value (l_manager, whole_class_string, true)
			whole_class_preference.change_actions.extend (l_update_agent)
		end

invariant
	ancestors_preference_not_void: ancestors_preference /= Void
	descendants_preference_not_void: descendants_preference /= Void
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
