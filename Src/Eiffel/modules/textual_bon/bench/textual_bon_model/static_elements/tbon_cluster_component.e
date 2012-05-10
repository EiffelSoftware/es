note
	description: "Summary description for {TBON_CLUSTER_COMPONENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TBON_CLUSTER_COMPONENT

inherit
	TBON_STATIC_COMPONENT
		rename
			process_to_formal_textual_bon as process_to_textual_bon,
			process_to_informal_textual_bon as process_to_textual_bon
		redefine
			process_to_textual_bon
		end

create
	make_element

feature -- Initialization
	make_element (a_text_formatter_decorator: like text_formatter_decorator; a_name: like name; contained_components: LIST[TBON_STATIC_COMPONENT])
		do
			text_formatter_decorator := a_text_formatter_decorator

			if a_name /= Void then
				name := a_name
			else
				name := "NAME_OF_THE_CLUSTER"
			end

			create {LINKED_LIST[TBON_CLUSTER_COMPONENT]} clusters.make
			create {LINKED_LIST[TBON_CLASS_COMPONENT]} classes.make

			if contained_components /= Void then
				contained_components.do_all (agent (component: TBON_STATIC_COMPONENT)
											do
												if attached {TBON_CLUSTER_COMPONENT} component as a_cluster then
													clusters.extend (a_cluster)
												elseif attached {TBON_CLASS_COMPONENT} component as a_class then
													classes.extend (a_class)
												end
											end
										)
			end
		end

feature -- Access
	classes: LIST[TBON_CLASS_COMPONENT]
			-- What classes does this cluster contain?

	clusters: LIST[TBON_CLUSTER_COMPONENT]
			-- What subclusters does this cluster contain?

	name: STRING
			-- What is the name of this cluster?

feature -- Status
	has_components: BOOLEAN
		do
			Result := has_classes or has_clusters
		end

	has_classes: BOOLEAN
		do
			Result := classes /= Void and then not classes.is_empty
		end

	has_clusters: BOOLEAN
		do
			Result := clusters /= Void and then not clusters.is_empty
		end

feature -- Element change
	add_class (a_class: TBON_CLASS_COMPONENT)
		require
			a_class /= Void
		do
			classes.extend (a_class)
		ensure
			classes.count = old classes.count + 1
		end

feature -- Process
	process_to_textual_bon
		local
			l_text_formatter_decorator: like text_formatter_decorator
		do
			l_text_formatter_decorator := text_formatter_decorator
			l_text_formatter_decorator.process_keyword_text (bti_cluster_keyword, Void)
			l_text_formatter_decorator.put_space
			l_text_formatter_decorator.process_string_text (name, Void)
			l_text_formatter_decorator.put_new_line

			l_text_formatter_decorator.process_keyword_text (bti_component_keyword, Void)
			l_text_formatter_decorator.put_new_line
			l_text_formatter_decorator.indent
			if has_components then
				if has_clusters then
					process_formal_textual_bon_list (clusters, Void, True)
				end
				if has_classes then
					process_formal_textual_bon_list (classes, Void, True)
				end
				l_text_formatter_decorator.put_new_line
			end
			l_text_formatter_decorator.exdent
			l_text_formatter_decorator.process_keyword_text (bti_end_keyword, Void)
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
