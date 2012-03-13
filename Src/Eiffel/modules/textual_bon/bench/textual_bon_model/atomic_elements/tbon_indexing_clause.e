note
	description: "The indexing clause of a class containing meta-information about it."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_INDEXING_CLAUSE

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
	indexing_tags: attached LIST[TBON_INDEX]
			-- What are this indexing clause's indexing tags?

feature -- Initialization
	make_element (l_indexing_tags: like indexing_tags)
			-- Make a indexing clause for a class.
		do
			indexing_tags ?= l_indexing_tags
		end

feature -- Process
	process_to_textual_bon
			-- Process this indexing clause to formal textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_indexing_keyword, Void)
			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.indent
			process_informal_textual_bon_list (indexing_tags, ";", True)
			l_text_formatter_decorator.exdent
		end

invariant
	indexing_tags_not_empty: not indexing_tags.is_empty
			-- An indexing tag must have an identifier.
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
