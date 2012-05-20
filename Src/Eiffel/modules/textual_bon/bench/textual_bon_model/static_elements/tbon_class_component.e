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
	make_element (a_text_formatter: like text_formatter_decorator; a_class: TBON_CLASS; a_cluster: TBON_CLUSTER_COMPONENT; an_output_strategy: like associated_output_strategy)
			-- Create a class component
		do
			parent_cluster := a_cluster
			associated_class := a_class
			associated_output_strategy := an_output_strategy
			text_formatter_decorator := a_text_formatter
		end

feature -- Access
	associated_class: attached TBON_CLASS
			-- Which class does this component describe?

	associated_output_strategy: TEXTUAL_BON_FORMAL_OUTPUT_STRATEGY

	parent_cluster: TBON_CLUSTER_COMPONENT

feature -- Processing
	process_to_textual_bon
			-- Process this element into textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
			l_belongs_to_index: TBON_INDEX
			l_term_list: LIST[STRING]
			l_index_id: TBON_IDENTIFIER
			l_parent_cluster_string: STRING
			l_indexing_clause: TBON_INDEXING_CLAUSE
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
			l_text_formatter_decorator.process_class_name_text (associated_class.name.string_value, current_class.original_class, False)
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

			l_text_formatter_decorator.put_new_line

			-- Indexing clause
			create {LINKED_LIST[STRING]} l_term_list.make
			l_parent_cluster_string := parent_cluster.name.string
			l_parent_cluster_string.prepend (ti_double_quote)
			l_parent_cluster_string.append (ti_double_quote)
			l_term_list.extend (l_parent_cluster_string)
			create l_index_id.make_element (text_formatter_decorator, "belongs_to")
			create l_belongs_to_index.make_element (text_formatter_decorator, l_index_id, l_term_list)
			if associated_class.has_indexing_clause then
				associated_class.indexing_clause.add_index (l_belongs_to_index)
				associated_class.indexing_clause.process_to_textual_bon
			else
				create l_indexing_clause.make_element (l_text_formatter_decorator, Void)
				l_indexing_clause.add_index (l_belongs_to_index)
			end
			l_text_formatter_decorator.put_new_line

			-- Inherit clause
			if associated_class.has_ancestors then
				l_text_formatter_decorator.process_keyword_text (bti_inherit_keyword, Void)
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.indent

				process_formal_textual_bon_list (associated_class.ancestors, ";", True)

				l_text_formatter_decorator.exdent
				l_text_formatter_decorator.put_new_line
				l_text_formatter_decorator.put_new_line
			end

			-- Features
			process_formal_textual_bon_list (associated_class.feature_clauses, Void, True)
			l_text_formatter_decorator.put_new_line

			-- Invariant
			if associated_class.has_invariant then
				associated_class.class_invariant.process_to_formal_textual_bon
				l_text_formatter_decorator.put_new_line
			end

			l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)
		end

feature -- Status
	has_parent_cluster: BOOLEAN
		do
			Result := parent_cluster /= Void
		end

feature -- Implementation
	find_descendants
		require
			has_parent_cluster
		do
			current_class.direct_descendants.do_all (agent (descendant: CLASS_C)
										local
											l_descendant_spec: TBON_CLASS
											l_descendant_component:TBON_CLASS_COMPONENT
										do
											create l_descendant_spec.make (descendant.ast, text_formatter_decorator, associated_output_strategy)
											create l_descendant_component.make_element (text_formatter_decorator, l_descendant_spec, parent_cluster, associated_output_strategy)
											l_descendant_component.set_current_class (descendant)
											parent_cluster.add_class (l_descendant_component)
											l_descendant_component.find_descendants
										end
									)
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
