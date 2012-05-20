note
	description: "Summary description for {TBON_CLASS_CHART}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CLASS_CHART

inherit
	TBON_INFORMAL_CHART
		redefine
			process_to_textual_bon,
			set_current_class
		end

create
	make_element

feature -- Initialization
	make_element (a_class: TBON_CLASS; a_text_formatter_decorator: like text_formatter_decorator; a_parent_cluster: like parent_cluster; an_output_strategy: like associated_output_strategy)
		local
			l_belongs_to_index: TBON_INDEX
			l_term_list: LIST[STRING]
			l_index_id: TBON_IDENTIFIER
			l_parent_cluster_string: STRING
		do
			name := a_class.name.string_value

			create {LINKED_LIST[TBON_FEATURE]} queries.make
			create {LINKED_LIST[TBON_FEATURE]} commands.make

			a_class.feature_clauses.do_all (agent (a_feature_clause: TBON_FEATURE_CLAUSE)
										do
											 a_feature_clause.features.do_all (agent (a_feature: TBON_FEATURE)
																			do
																				if a_feature.has_type then
																					queries.extend (a_feature)
																				else
																					commands.extend (a_feature)
																				end
																			end
																		)
										end
									)


			constraints := a_class.class_invariant

			associated_output_strategy := an_output_strategy

			ancestors := a_class.ancestors

			text_formatter_decorator := a_text_formatter_decorator

			indexing_clause := a_class.indexing_clause

			parent_cluster := a_parent_cluster

			if a_class.is_deferred then
				set_to_deferred
			end

			from
				indexing_clause.indexing_tags.start
			until
				indexing_clause.indexing_tags.exhausted
			loop
				if is_explanation_string (indexing_clause.indexing_tags.item.identifier.string_value) then
					from  indexing_clause.indexing_tags.item.terms.start
					until indexing_clause.indexing_tags.item.terms.exhausted
					loop
						if has_explanation then
							explanation.append (", ")
							explanation.append (indexing_clause.indexing_tags.item.terms.item_for_iteration)
						else
							explanation := indexing_clause.indexing_tags.item.terms.item_for_iteration
						end

						indexing_clause.indexing_tags.item.terms.forth
					end
					indexing_clause.indexing_tags.remove
				else
					indexing_clause.indexing_tags.forth
				end
			end
			create {LINKED_LIST[STRING]} l_term_list.make
			l_parent_cluster_string := parent_cluster.name.string
			l_parent_cluster_string.prepend (ti_double_quote)
			l_parent_cluster_string.append (ti_double_quote)
			l_term_list.extend (l_parent_cluster_string)
			create l_index_id.make_element (text_formatter_decorator, "belongs_to")
			create l_belongs_to_index.make_element (text_formatter_decorator, l_index_id, l_term_list)
			indexing_clause.add_index(l_belongs_to_index)
		end

feature -- Access
	ancestors: LIST[TBON_CLASS_TYPE]

	commands: LIST[TBON_FEATURE]
			-- Which commands does this class have?
	constraints: TBON_INVARIANT
			-- Which constraints does this class have?
	name: STRING
			-- Which class does this chart describe?
	parent_cluster: TBON_CLUSTER_CHART

	queries: LIST[TBON_FEATURE]
			-- Which queries does this class have?

feature -- Status
	has_ancestors: BOOLEAN
		do
			Result := ancestors /= Void and then not ancestors.is_empty
		end
	has_commands: BOOLEAN
		do
			Result := commands /= Void and then not commands.is_empty
		end

	has_constrains: BOOLEAN
		do
			Result := constraints /= Void
		end

	has_parent_cluster: BOOLEAN
		do
			Result := parent_cluster /= Void
		end

	has_queries: BOOLEAN
		do
			Result := queries /= Void and then not queries.is_empty
		end

	is_deferred: BOOLEAN

feature -- Status setting
	set_to_deferred
		do
			is_deferred := True
		end

feature -- Element change
	set_current_class (other_class: like current_class)
		do
			current_class := other_class
		end

feature -- Process
	process_to_textual_bon
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_class_chart_keyword, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_class_name_text (name, current_class.original_class, False)

			if is_deferred then
				l_text_formatter_decorator.put_space
				l_text_formatter_decorator.process_symbol_text (ti_dashdash)
				l_text_formatter_decorator.put_space
				l_text_formatter_decorator.process_comment_text ("deferred", Void)
			end

			if has_indexing_clause then
				l_text_formatter_decorator.put_new_line
				indexing_clause.process_to_textual_bon
			end

			if has_explanation then
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.process_keyword_text (bti_explanation_keyword, Void)
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.indent
				l_text_formatter_decorator.process_comment_text (explanation, Void)
				l_text_formatter_decorator.exdent
			end

			if has_ancestors then
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.process_keyword_text (bti_inherit_keyword, Void)
				l_text_formatter_decorator.indent
				l_text_formatter_decorator.put_new_line
				process_informal_textual_bon_list (ancestors, ",", True)
				l_text_formatter_decorator.exdent
			end

			if has_queries then
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.process_keyword_text (bti_query_keyword, Void)
				l_text_formatter_decorator.indent
				l_text_formatter_decorator.put_new_line
				process_informal_textual_bon_list (queries, ",", True)
				l_text_formatter_decorator.exdent
			end

			if has_commands then
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.process_keyword_text (bti_command_keyword, Void)
				l_text_formatter_decorator.indent
				l_text_formatter_decorator.put_new_line
				process_informal_textual_bon_list (commands, ",", True)
				l_text_formatter_decorator.exdent
			end

			if has_constrains then
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.process_keyword_text (bti_constraint_keyword, Void)
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.indent
				process_informal_textual_bon_list (constraints.assertions, ", ", True)
				l_text_formatter_decorator.exdent
			end

			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)

		end


feature -- Implementation
	find_descendants
		require
			has_parent_cluster
		do
			current_class.direct_descendants.do_all (agent (descendant: CLASS_C)
										local
											l_descendant_spec: TBON_CLASS
											l_descendant_chart:TBON_CLASS_CHART
										do
											create l_descendant_spec.make (descendant.ast, text_formatter_decorator, associated_output_strategy)
											create l_descendant_chart.make_element (l_descendant_spec, text_formatter_decorator, parent_cluster, associated_output_strategy)
											l_descendant_chart.set_current_class (descendant)
											parent_cluster.add_class (l_descendant_chart)
											l_descendant_chart.find_descendants
										end
									)
		end

feature {NONE} -- Implementation
	associated_output_strategy: TEXTUAL_BON_OUTPUT_STRATEGY

	is_explanation_string (s: STRING): BOOLEAN
		local
			strings: LIST[STRING]
		do
			strings := explanation_strings
			strings.compare_objects

			Result := strings.has (s.as_lower)
		end

	explanation_strings: LIST[STRING]
		once
			create {LINKED_LIST[STRING]} Result.make
			Result.extend ("description")
			Result.extend ("explanation")
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
