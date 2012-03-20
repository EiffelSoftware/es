note
	description: "An identifier in a textual BON specification."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_IDENTIFIER

inherit
	TEXTUAL_BON_ELEMENT
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element (string_id: attached STRING)
			-- Create an identifier from a string.
		do
			string_value := string_id
			create regex_matcher.make
			regex_matcher.compile (validation_pattern)
		end

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_string_text (string_value, Void)
		end

feature -- Access
	string_value: attached STRING
			-- What is the string representation of this identifier?

feature {NONE} -- Implementation
	is_valid: BOOLEAN
			-- Is this identifier valid?
			-- An identifier must begin with an alphanumeric [a-zA-Z0-9] character.
			-- An identifier must not end must not end with an underscore.
		do
			Result := regex_matcher.matches (string_value) and not string_value.ends_with (bti_underscore)
		end

	regex_matcher: RX_PCRE_MATCHER
			-- Regex matcher used to determine validity of the identifier.

	validation_pattern: STRING = "^[a-zA-Z0-9]+.+$"
			-- The pattern to which the string representation must conform.

invariant
	is_valid_identifier: is_valid

;note
	copyright: "Copyright (c) 1984-2012, Eiffel Software"
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
