note
	description: "Class that represents a state invariant derived from generated test cases"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_STATE_INVARIANT

inherit
	EPA_UTILITY

	HASHABLE


create
	make

feature{NONE} -- Initialization

	make (a_expression: EPA_EXPRESSION; a_context_class: CLASS_C; a_feature: FEATURE_I)
			-- Initialize Current.
		local
		do
			expression := a_expression
			context_class := a_context_class
			feature_ := a_feature
			create id.make (64)
			id.append (a_context_class.name_in_upper)
			id.append_character ('.')
			id.append (a_feature.feature_name)
			id.append_character ('.')
			id.append (a_expression.text)
			hash_code := id.hash_code

			feature_id := a_context_class.name_in_upper + "." + feature_.feature_name.as_lower
		end

feature -- Access

	feature_: FEATURE_I
			-- The feature whose state invariant Current class stands for

	context_class: CLASS_C
			-- Context class from with `feature_' is viewed

	expression: EPA_EXPRESSION
			-- Expression representing the state invariant

	hash_code: INTEGER
			-- Hash code value

	id: STRING
			-- Identifier of current invariant

	feature_id: STRING
			-- Indentifer of `context_class'.`feature_'
			-- In form of "CLASS_NAME.feature_name'

	text: STRING
			-- String representation of `expression'
		do
			Result := expression.text
		end

feature -- Basic operations



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
