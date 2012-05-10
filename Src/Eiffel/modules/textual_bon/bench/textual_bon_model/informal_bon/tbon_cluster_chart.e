note
	description: "Summary description for {TBON_CLUSTER_CHART}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CLUSTER_CHART

inherit
	TBON_INFORMAL_CHART
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element(a_text_formatter_decorator: like text_formatter_decorator; a_name: like name; some_classes: like classes; an_explanation: like explanation; an_indexing_clause: like indexing_clause)
		do
			text_formatter_decorator := a_text_formatter_decorator
			if some_classes /= Void then
				classes := some_classes
			else
				create {LINKED_LIST[TBON_CLASS_CHART]} classes.make
			end

			if a_name /= Void then
				name := a_name
			else
				name := "NAME_OF_THE_CLUSTER"
			end

			indexing_clause := an_indexing_clause

			if an_explanation /= Void then
				explanation := an_explanation
			else
				explanation := "A description of your cluster."
			end
		end

feature -- Access
	name: attached STRING

	classes: LIST[TBON_CLASS_CHART]

feature -- Element change
	set_classes (other: like classes)
		do
			classes := other
		end

	add_class (new_class: like classes.first)
		do
			classes.extend (new_class)
		end

feature -- Status
	has_classes: BOOLEAN
		do
			Result := classes /= Void and then not classes.is_empty
		end

feature -- Process

	process_to_textual_bon
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_cluster_chart_keyword, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_string_text (name, Void)
			l_text_formatter_decorator.put_new_line

			if has_indexing_clause then
				indexing_clause.process_to_textual_bon
			end

			if has_explanation then
				l_text_formatter_decorator.process_keyword_text (bti_explanation_keyword, Void)
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.indent
				l_text_formatter_decorator.process_symbol_text (ti_double_quote)
				l_text_formatter_decorator.process_comment_text (explanation, Void)
				l_text_formatter_decorator.process_symbol_text (ti_double_quote)
			end

			l_text_formatter_decorator.exdent
			if has_classes then
				classes.do_all (agent (a_class: TBON_CLASS_CHART)
								do
									text_formatter_decorator.put_new_line
									text_formatter_decorator.process_keyword_text (bti_class_keyword, Void)
									text_formatter_decorator.put_space
									text_formatter_decorator.process_class_name_text (a_class.name, a_class.current_class.original_class, False)
									if a_class.has_explanation then
										text_formatter_decorator.put_new_line
										text_formatter_decorator.indent
										text_formatter_decorator.process_comment_text (a_class.explanation, Void)
										text_formatter_decorator.exdent
									end
								end
							)

			end

			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)

			if has_classes then
				from
					classes.start
				until
					classes.exhausted
				loop
					l_text_formatter_decorator.put_new_line
					l_text_formatter_decorator.put_new_line
					classes.item.set_text_formatter (l_text_formatter_decorator)
					classes.item.process_to_textual_bon
					classes.forth
				end
			end
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
