note
	description: "Summary description for {TBON_CLASS_COMPONENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CLASS_COMPONENT

inherit
	TBON_STATIC_COMPONENT
		rename
			process_to_informal_textual_bon as process_to_textual_bon,
			process_to_formal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element (assoc_class: TBON_CLASS)
			-- Create a class component
		do
			associated_class := assoc_class
		end

feature -- Access
	associated_class: attached TBON_CLASS
			-- Which class does this component describe?

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator

			-- Set root/deferred/effective
			if associated_class.is_root then
				l_text_formatter_decorator.process_keyword_text (bti_root_keyword, Void)
			elseif associated_class.is_deferred then
				l_text_formatter_decorator.process_keyword_text (bti_deferred_keyword, Void)
			elseif associated_class.is_effective then
				l_text_formatter_decorator.process_keyword_text (bti_effective_keyword, Void)
			end
			-- 'class' keyword
			l_text_formatter_decorator.process_keyword_text (bti_class_keyword, Void)
			l_text_formatter_decorator.put_space

			-- Class name
			l_text_formatter_decorator.process_class_name_text (associated_class.name.string_value, Void, False)
			l_text_formatter_decorator.put_space

			-- Formal generics
			if associated_class.has_type_parameters then
				l_text_formatter_decorator.process_symbol_text (ti_l_bracket)
				process_formal_textual_bon_list (associated_class.type_parameters, ", ", False)
				l_text_formatter_decorator.process_symbol_text(ti_r_bracket)
				l_text_formatter_decorator.put_space
			end

			-- Add reused/persistent/interfaced
			if associated_class.is_reused then
				l_text_formatter_decorator.process_keyword_text (bti_reused_keyword, Void)
			elseif associated_class.is_persistent then
				l_text_formatter_decorator.process_keyword_text (bti_persistent_keyword, Void)
			elseif associated_class.is_interfaced then
				l_text_formatter_decorator.process_keyword_text (bti_interfaced_keyword, Void)
			end

			-- Comments (no comments for classes are extracted from Eiffel. Relevant information is in the indexing clause.)

			-- Indexing clause
			if associated_class.has_indexing_clause then
				associated_class.indexing_clause.process_to_textual_bon
				l_text_formatter_decorator.put_new_line
			end

			-- Inherit clause
			if associated_class.has_ancestors then
				l_text_formatter_decorator.process_keyword_text (bti_inherit_keyword, Void)
				
			end

			l_text_formatter_decorator.put_new_line

			l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)
		end

invariant
	must_describe_a_class: associated_class /= Void

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
