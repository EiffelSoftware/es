note
	description: "A specific indexing tag in a indexing clause."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_INDEX

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

feature -- Access
	identifier: attached TBON_IDENTIFIER
			-- What is this index's identifier?

	terms: attached LIST[STRING]
			-- What are this index's terms?

feature -- Initialization
	make_element (a_text_formatter: like text_formatter_decorator; an_identifier: like identifier; a_term_list: like terms)
			-- Make a index for an indexing clause.
		do
			make (a_text_formatter)
			identifier := an_identifier
			terms := a_term_list
		end

feature -- Process
	process_to_textual_bon
			-- Process this index to formal textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
			i: INTEGER
			not_first: BOOLEAN
		do
			l_text_formatter_decorator := text_formatter_decorator
			identifier.process_to_textual_bon
			l_text_formatter_decorator.process_symbol_text (bti_colon_operator)
			from
				i := 1
			until
				i >= terms.count
			loop
				if not_first then
					l_text_formatter_decorator.process_symbol_text (ti_comma)
				end
				l_text_formatter_decorator.put_space
				l_text_formatter_decorator.process_symbol_text (ti_quote)
				l_text_formatter_decorator.process_string_text (terms.i_th (i), Void)
				l_text_formatter_decorator.process_symbol_text (ti_quote)
			end
		end

invariant
	terms_not_empty: not terms.is_empty
			-- An indexing tag must have at least one indexing term.

note
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
