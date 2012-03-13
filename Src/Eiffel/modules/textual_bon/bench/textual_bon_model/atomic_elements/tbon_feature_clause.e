note
	description: "A feature clause containing features in a textual BON specification."
	author: "Sune Alkaersig <sual@itu.dk> and Thomas Didriksen <thdi@itu.dk>"
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_FEATURE_CLAUSE

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
	make_element (comment_strings: like comments; feature_list: attached like features; sel_export: like selective_export)
			-- Create a feature clause element.
		do
			comments := comment_strings
			features := feature_list
			selective_export := sel_export
		end

feature -- Access
	comments: LIST[STRING]
			-- What is the comments for this feature clause?

	features: attached LIST[TBON_FEATURE]
			-- What features are in this feature clause?

	selective_export: TBON_SELECTIVE_EXPORT
			-- What is the selective export of this feature clause?

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator

			l_text_formatter_decorator.process_keyword_text (bti_feature_keyword, Void)
			-- Process selective export
			if has_selective_export then
				l_text_formatter_decorator.put_space
				selective_export.process_to_textual_bon
			end
			-- Process comments
			if has_comments then
				l_text_formatter_decorator.put_space
				--process_textual_bon_comment (comments)
			end

			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.indent

			-- Process features
			process_formal_textual_bon_list (features, Void, True)

		end

feature -- Status report
	has_comments: BOOLEAN
			-- Does this feaure clause have comments?
		do
			Result := comments /= Void
		end

	has_selective_export: BOOLEAN
			-- Does this feature clause have a selective export clause?
		do
			Result := selective_export /= Void
		end

invariant
	must_include_at_least_one_feature: not features.is_empty

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
