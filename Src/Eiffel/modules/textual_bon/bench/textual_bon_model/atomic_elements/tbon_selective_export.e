note
	description: "The export clause in a textual BON feature describing its visibility."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_SELECTIVE_EXPORT

inherit
	TEXTUAL_BON_ELEMENT
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element, make_element_with_class_list

feature -- Initialization
	make_element (a_text_formatter: like text_formatter_decorator)
			-- Create a selective export element.
		do
			make (a_text_formatter)
			class_list := Void
		end

	make_element_with_class_list (a_text_formatter: like text_formatter_decorator; cl_list: like class_list)
			-- Create a selective export element with the given class list.
		do
			make (a_text_formatter)
			class_list := cl_list
		end

feature -- Access
	class_list: LIST[TBON_CLASS_TYPE]
			-- What classes are listed in this export clause?
			-- Empty list: export status NONE
			-- No/Void list: export status ANY

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator

			l_is_first_list_item: BOOLEAN
		do
			l_text_formatter_decorator := text_formatter_decorator

			if has_class_list then
				l_text_formatter_decorator.process_symbol_text (ti_l_curly)

				if class_list.count > 0 then
					from
						class_list.start
						l_is_first_list_item := True
					until
						class_list.exhausted
					loop
						if not l_is_first_list_item then
							l_text_formatter_decorator.process_symbol_text (ti_comma)
							l_text_formatter_decorator.put_space
						end
						l_is_first_list_item := False

						class_list.item.process_to_textual_bon

						class_list.forth
					end
				else
					l_text_formatter_decorator.process_string_text (bti_none_class_name, Void)
				end
				
				l_text_formatter_decorator.process_symbol_text (ti_r_curly)

			end
				-- If no list is present, the implied export status is equivalent to { ANY }
		end

feature -- Status report
	has_class_list: BOOLEAN
			-- Does this export clause have an export list?
		do
			Result := class_list /= Void
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
