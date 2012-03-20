note
	description: "A formal generic."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_FORMAL_GENERIC

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
	class_type: TBON_CLASS_TYPE
			-- What is this formal generic’s class type?
	formal_generic_name: TBON_FORMAL_GENERIC_NAME
			-- What is this formal generic’s formal generic name?

feature -- Initializatoin
	make_element (l_formal_generic_name: like formal_generic_name; l_class_type_bound: like class_type)
			-- Create a formal generic.
		do
			formal_generic_name := l_formal_generic_name
			class_type := l_class_type_bound
		end

feature -- Process
	process_to_textual_bon
			-- Process this formal generic name.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			formal_generic_name.process_to_textual_bon
			if has_generic_class_type then
				l_text_formatter_decorator.put_space
				l_text_formatter_decorator.process_symbol_text (bti_implication_operator)
				l_text_formatter_decorator.put_space
				class_type.process_to_textual_bon
			end
		end

feature -- Status report
	has_generic_class_type: BOOLEAN
			-- Does this formal generic have a class type?
		do
			Result := class_type /= Void
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
