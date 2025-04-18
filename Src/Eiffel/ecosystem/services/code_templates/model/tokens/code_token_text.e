note
	description: "[
		A code token to represent standard snippet text in a code template.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	CODE_TOKEN_TEXT

inherit
	CODE_TOKEN

create
	make

feature {NONE} -- Initialization

	make (a_text: READABLE_STRING_GENERAL)
			-- Initializes the code token using a text representation, as taken from a code template text source.
			--
			-- `a_text': A string representation of the token
		require
			a_text_attached: attached a_text
			a_text_is_valid_text: is_valid_text (a_text)
		do
			create text.make (a_text.count)
			text.append_string_general (a_text)
		ensure
			text_set: text.same_string_general (a_text)
		end

feature -- Access

	text: STRING_32
			-- <Precursor>

feature -- Status report

	is_editable: BOOLEAN
			-- <Precursor>
		do
			Result := False
		end

feature -- Query

	is_valid_text (a_text: READABLE_STRING_GENERAL): BOOLEAN
			-- <Precursor>
		do
			Result := not a_text.is_empty
		ensure then
			not_a_text_is_empty: Result implies not a_text.is_empty
		end

feature -- Visitor

	process (a_visitor: CODE_TOKEN_VISITOR_I)
			-- <Precursor>
		do
			a_visitor.process_code_token_text (Current)
		end

;note
	copyright:	"Copyright (c) 1984-2009, Eiffel Software"
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
