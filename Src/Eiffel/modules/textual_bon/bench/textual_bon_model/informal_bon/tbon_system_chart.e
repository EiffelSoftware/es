note
	description: "A chart describing a system at the cluster level."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_SYSTEM_CHART

inherit
	TBON_INFORMAL_CHART
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element(a_text_formatter_decorator: like text_formatter_decorator; a_name: like name; some_clusters: like clusters; an_explanation: like explanation; an_indexing_clause: like indexing_clause)
		do
			text_formatter_decorator := a_text_formatter_decorator
			if a_name /= Void then
				name := a_name
			else
				name := "NAME_OF_THE_SYSTEM"
			end

			clusters := some_clusters

			if an_explanation /= Void then
				explanation := an_explanation
			else
				explanation := "A description of your system."
			end

			indexing_clause := an_indexing_clause
		end

feature -- Access
	name: attached STRING
			-- What is the name of this system?

	clusters: LIST[TBON_CLUSTER_CHART]
			-- Which clusters does this system have?


feature -- Status
	has_clusters: BOOLEAN
			-- Does this system have clusters?
		do
			Result := clusters /= Void and then not clusters.is_empty
		end

	has_exlanation: BOOLEAN
		do
			Result := explanation /= Void
		end

feature -- Process
	process_to_textual_bon
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_system_chart_keyword, Void)
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
			if has_clusters then
				clusters.do_all (agent (cluster: TBON_CLUSTER_CHART)
								do
									text_formatter_decorator.put_new_line
									text_formatter_decorator.process_keyword_text (bti_cluster_keyword, Void)
									text_formatter_decorator.put_space
									text_formatter_decorator.process_string_text (cluster.name, Void)
									if cluster.has_explanation then
										text_formatter_decorator.put_new_line
										text_formatter_decorator.indent
										text_formatter_decorator.process_symbol_text (ti_double_quote)
										text_formatter_decorator.process_comment_text (cluster.explanation, Void)
										text_formatter_decorator.process_symbol_text (ti_double_quote)
										text_formatter_decorator.exdent
									end
								end
							)
			end


			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)

			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.put_new_line

			if has_clusters then
				clusters.do_all (agent (cluster: TBON_CLUSTER_CHART)
								do
									cluster.process_to_textual_bon
								end
							)
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
