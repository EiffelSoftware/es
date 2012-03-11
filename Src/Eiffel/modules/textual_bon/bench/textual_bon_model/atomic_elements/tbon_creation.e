note
	description: "A creation in a system described in a BON specification."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CREATION

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
	make_element (creator_class: attached TBON_CLASS; created_classes: attached LIST[TBON_CLASS])
			-- Create a creation element.
		do
			creator := creator_class
			created_class_list := created_classes
		end

feature -- Access
	creator: attached TBON_CLASS
			-- Which class is the creator of this creation?

	created_class_list: attached LIST[TBON_CLASS]
			-- Which classes are created by the creator of this chart?

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator

			l_is_first_list_item: BOOLEAN
			i: INTEGER
		do
			l_text_formatter_decorator := text_formatter_decorator

			l_text_formatter_decorator.process_keyword_text (bti_creator_keyword, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_string_text (creator.name, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_keyword_text (bti_creates_keyword, Void)
			l_text_formatter_decorator.put_space
			-- Process class names
			from
				i := 0
				l_is_first_list_item := True
			until
				i >= created_class_list.count
			loop
				if not l_is_first_list_item then
					l_text_formatter_decorator.process_symbol_text (ti_comma)
					l_text_formatter_decorator.put_space
					l_is_first_list_item := False
				end
				l_text_formatter_decorator.process_string_text (created_class_list.i_th (i).name, Void)
			end

		end

invariant
	must_create_at_least_one_class: not created_class_list.is_empty

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
