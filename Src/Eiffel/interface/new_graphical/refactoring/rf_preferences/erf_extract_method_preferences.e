note
	description: "Preferences for the extract method refactoring."
	date: "$Date$"
	revision: "$Revision$"

class
	ERF_EXTRACT_METHOD_PREFERENCES

inherit
	ERF_PREFERENCES
		redefine
			initialize_preferences
		end

feature -- Value

	start_line: INTEGER
			-- Line where to start extracting
		do
			Result := start_line_preference.value
		end

	end_line: INTEGER
			-- Line where to end extracting
		do
			Result := end_line_preference.value
		end

	extracted_method_name: STRING
			-- Name of the extracted method
		do
			Result := extracted_method_name_preference.value
		end

feature -- Change value

	set_extracted_method_name (a_name: STRING)
			-- Set name of the extracted method
		require
			a_name_not_void: a_name /= void
		do
			extracted_method_name_preference.set_value (a_name)
		end

	set_start_line (a_line: INTEGER)
			-- Set the start line
		do
			start_line_preference.set_value (a_line)
		end

	set_end_line (a_line: INTEGER)
			-- Set the end line
		do
			end_line_preference.set_value (a_line)
		end

feature {NONE} -- Preference

	start_line_preference: INTEGER_PREFERENCE
	end_line_preference: INTEGER_PREFERENCE
	extracted_method_name_preference: STRING_PREFERENCE

feature {NONE} -- Preference Strings

	start_line_string: STRING = "tools.refactoring.extract_method.start_line"
	end_line_string: STRING = "tools.refactoring.extract_method.end_line"
	extracted_method_name_string: STRING = "tools.refactoring.extract_method.extracted_method_name"

feature {NONE} -- Implementation

	initialize_preferences
			-- Initialize preference values.
		local
			l_manager: EB_PREFERENCE_MANAGER
			l_update_agent: PROCEDURE [ANY, TUPLE]
		do
			create l_manager.make (preferences, "refactoring.extract_method")
			l_update_agent := agent update

			start_line_preference := l_manager.new_integer_preference_value (l_manager, start_line_string, 0)
			start_line_preference.change_actions.extend (l_update_agent)

			end_line_preference := l_manager.new_integer_preference_value (l_manager, end_line_string, 0)
			end_line_preference.change_actions.extend (l_update_agent)

			extracted_method_name_preference := l_manager.new_string_preference_value (l_manager, extracted_method_name_string, "extracted")
			extracted_method_name_preference.change_actions.extend (l_update_agent)
		end

invariant
	start_line_preference_not_void: start_line_preference /= Void
	end_line_preference_not_void: end_line_preference /= Void
	extracted_method_name_preference_not_void: extracted_method_name_preference /= void
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
