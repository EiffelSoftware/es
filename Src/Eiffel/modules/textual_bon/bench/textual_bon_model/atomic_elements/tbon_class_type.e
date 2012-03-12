note
	description: "A specific type of class."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CLASS_TYPE

inherit
	TBON_TYPE
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Access
	actual_generics: LIST[TBON_TYPE]
			-- What are the actual generics of this class type?

	name: attached STRING
			-- What is the name of this class?

feature -- Initialization
	make_element (l_name: like name)
			-- Create a class type.
		do
			name ?= l_name
		end

feature -- Process
	process_to_textual_bon
			-- Process this class type to formal textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
			x: INTEGER
			not_first: BOOLEAN
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_string_text (name, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_symbol_text (ti_l_bracket)
			process_formal_textual_bon_list(actual_generics, ", ", False)
			l_text_formatter_decorator.process_symbol_text (ti_r_bracket)
		end

feature -- Status report
	has_actual_generics: BOOLEAN
			-- Does this class type have any actual generics?
		do
			Result := actual_generics /= Void or else actual_generics.is_empty
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
