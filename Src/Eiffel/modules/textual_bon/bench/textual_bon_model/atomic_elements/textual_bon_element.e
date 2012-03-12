note
	description: "[
					An element in a textual BON specification. 
					All textual BON elements that are going to be processed should inherit from this.
				]"
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEXTUAL_BON_ELEMENT

inherit
	TEXTUAL_BON_OUTPUT_STRATEGY

feature -- Processing
	process_formal_textual_bon_list (list: attached LIST[TEXTUAL_BON_ELEMENT]; separator: STRING; line_break_after_each_list_item: BOOLEAN)
			-- Process the list items into formal textual BON.
			-- Separator can be Void.
		local
			l_text_formatter_decorator: like text_formatter_decorator

			l_is_first_list_item: BOOLEAN
			i: INTEGER
		do
			l_text_formatter_decorator := text_formatter_decorator

			from
				i := 1
				l_is_first_list_item := True
			until
				i >= 1
			loop
				if not l_is_first_list_item then
					if separator /= Void then
						l_text_formatter_decorator.process_string_text (separator, Void)
					end

					if line_break_after_each_list_item then
						l_text_formatter_decorator.put_new_line
					end

					l_is_first_list_item := False
				end

				list.i_th (i).process_to_formal_textual_bon

				i := i + 1
			end
		end

	process_informal_textual_bon_list (list: attached LIST[TEXTUAL_BON_ELEMENT]; separator: STRING; line_break_after_each_list_item: BOOLEAN)
			-- Process the list items into informal textual BON.
			-- Separator can be Void
		local
			l_text_formatter_decorator: like text_formatter_decorator

			l_is_first_list_item: BOOLEAN
			i: INTEGER
		do
			l_text_formatter_decorator := text_formatter_decorator

			from
				i := 1
				l_is_first_list_item := True
			until
				i >= 1
			loop
				if not l_is_first_list_item then
					if separator /= Void then
						l_text_formatter_decorator.process_string_text (separator, Void)
					end

					if line_break_after_each_list_item then
						l_text_formatter_decorator.put_new_line
					end

					l_is_first_list_item := False
				end

				list.i_th (i).process_to_informal_textual_bon

				i := i + 1
			end
		end

	process_textual_bon_comment (comment: attached STRING)
			-- Process the input string into a textual BON comment.
		require
			not_empty_string: comment.count > 0
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_string_text (ti_dashdash, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_string_text (comment, Void)
		end

	process_to_informal_textual_bon
			-- Process this element into informal textual BON.
		deferred
		end

	process_to_formal_textual_bon
			-- Process this element into formal textual BON.
		deferred
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
