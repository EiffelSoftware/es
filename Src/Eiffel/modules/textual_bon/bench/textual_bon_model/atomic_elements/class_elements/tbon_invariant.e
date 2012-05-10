note
	description: "An invariant for a feature."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_INVARIANT

inherit
	TBON_CONSTRAINT
		redefine
			process_to_informal_textual_bon,
			process_to_formal_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element (a_text_formatter: like text_formatter_decorator; an_assertion_list: like assertions)
			-- Make an invariant for a class.
		do
			make (a_text_formatter)
			assertions := an_assertion_list
		end

feature -- Processing
	process_to_formal_textual_bon
			-- Process class invariant to formal bon
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_invariant_keyword, Void)
			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.indent
			process_formal_textual_bon_list (assertions, Void, True)
			l_text_formatter_decorator.exdent
		end
		
	process_to_informal_textual_bon
			-- Process class invariant to formal bon
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_invariant_keyword, Void)
			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.indent
			process_informal_textual_bon_list (assertions, Void, True)
			l_text_formatter_decorator.exdent
		end

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
