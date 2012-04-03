note
	description: "An event in a system described with textual BON."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_EVENT

inherit
	TEXTUAL_BON_ELEMENT
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element_with_involved_class_list

feature -- Initialization
	make_element_with_involved_class_list (id: attached STRING; inv_cl_list: attached LIST[TBON_CLASS])
			-- Create an event element involving the given classes.
		do
			identifier := id
			involved_class_list := inv_cl_list
		end

feature -- Access
	identifier: attached STRING
			-- What is the identifier of this event?

	involved_class_list: attached LIST[TBON_CLASS]
			-- Which classes does this event involve?

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator

			i: INTEGER
			l_first_item_in_list: BOOLEAN
		do
			-- event 'identifier' involves 'class_list'
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_event_keyword, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_string_text (identifier, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_keyword_text (bti_involves_keyword, Void)
			l_text_formatter_decorator.put_space
			-- Process class names
			from
				i := 1
				l_first_item_in_list := True
			until
				i >= involved_class_list.count
			loop
				if not l_first_item_in_list then
					l_text_formatter_decorator.process_symbol_text (ti_comma)
					l_text_formatter_decorator.put_space
					l_first_item_in_list := False
				end
				involved_class_list.i_th (i).name.process_to_textual_bon
			end
		end

invariant
	must_involve_at_least_one_class: not involved_class_list.is_empty

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
