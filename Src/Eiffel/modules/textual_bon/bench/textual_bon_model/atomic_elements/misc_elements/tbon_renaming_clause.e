note
	description: "A renaming clause of a feature in a class in textual BON."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_RENAMING_CLAUSE

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
	make_element (a_text_formatter_decorator: like text_formatter_decorator ancestor: attached TBON_CLASS_TYPE; final_name_string: attached STRING)
			-- Create a renaming clause element.
		do
			ancestor_class := ancestor
			final_name := final_name_string
			text_formatter_decorator := a_text_formatter_decorator
		end

feature -- Access
	ancestor_class: attached TBON_CLASS_TYPE
			-- From which ancestor class is this feature being renamed?

	final_name: attached STRING
			-- What is the final name of the feature?

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_symbol_text (ti_l_curly)
			l_text_formatter_decorator.put_space
			-- ^class_name.final_name
			l_text_formatter_decorator.process_symbol_text (bti_power_operator)
			ancestor_class.process_to_textual_bon
			l_text_formatter_decorator.process_symbol_text (ti_dot)
			l_text_formatter_decorator.process_string_text (final_name, Void)

			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_symbol_text (ti_r_curly)
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
