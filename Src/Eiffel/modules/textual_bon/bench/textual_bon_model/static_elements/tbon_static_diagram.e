note
	description: "Summary description for {TBON_STATIC_DIAGRAM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_STATIC_DIAGRAM

inherit
	TEXTUAL_BON_ELEMENT
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make, make_element

feature -- Initialization
	make_element (id: like extended_id; comment_list: like comments; static_component_list: like static_components)
			-- Create a static diagram
		do
			extended_id := id
			comments := comment_list
			static_components := static_component_list
		end

feature -- Access

	extended_id: TBON_IDENTIFIER
			-- What is the extended ID of this static diagram?
			-- Can either be a textual identifier or an integer (which is wrapped inside a TBON_IDENTIFIER)		

	comments: LIST[STRING]
			-- What are the comments for this static diagram?

	static_components: attached LIST[TBON_STATIC_COMPONENT]
			-- What are the static components of this diagram?

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator

			l_is_first_comment: BOOLEAN
		do
			l_text_formatter_decorator := text_formatter_decorator

			l_text_formatter_decorator.process_keyword_text (bti_static_diagram_keyword, Void)
			l_text_formatter_decorator.put_space

			if has_extended_id then
				extended_id.process_to_textual_bon
				l_text_formatter_decorator.put_space
			end

			-- Comments
			if has_comments then
				from
					comments.start
					l_is_first_comment := True
				until
					comments.exhausted
				loop
					if not l_is_first_comment then
						l_text_formatter_decorator.put_new_line
						l_is_first_comment := False
					end
					process_textual_bon_comment (comments.item.as_string_8)
					comments.forth
				end
			end

			l_text_formatter_decorator.put_new_line

			l_text_formatter_decorator.process_keyword_text (bti_component_keyword, Void)
			l_text_formatter_decorator.put_new_line

			l_text_formatter_decorator.indent

			process_formal_textual_bon_list (static_components, Void, True)

			l_text_formatter_decorator.exdent

			l_text_formatter_decorator.put_new_line

			l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)
		end

feature -- Status report
	has_comments: BOOLEAN
			-- Does this static diagram have any comments?
		do
			Result := comments /= Void and then not comments.is_empty
		end

	has_extended_id: BOOLEAN
			-- Does this static diagram have an extended id?
		do
			Result := extended_id /= Void
		end

invariant
	must_have_at_least_one_static_component: static_components /= Void and then not static_components.is_empty

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
