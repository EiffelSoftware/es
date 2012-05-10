note
	description: "Summary description for {TEXTUAL_BON_INFORMAL_OUTPUT_STRATEGY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEXTUAL_BON_INFORMAL_OUTPUT_STRATEGY

inherit
	TEXTUAL_BON_OUTPUT_STRATEGY
		redefine
			process_class_as
		end

create
	make

feature -- Processing
	process_class_as (l_as: CLASS_AS)
			-- Process the abstract syntax (represented by 'CLASS_AS') for an Eiffel class into informal textual BON.
		local
			l_text_formatter_decorator: like text_formatter_decorator
			system_chart: TBON_SYSTEM_CHART
			cluster_chart: TBON_CLUSTER_CHART
			textual_bon_spec: TBON_CLASS
			textual_bon_class_chart: TBON_CLASS_CHART
			cluster_list: LIST[TBON_CLUSTER_CHART]
			l_cluster_name: STRING
			l_system_name: STRING
		do
			l_text_formatter_decorator := text_formatter_decorator

			create textual_bon_spec.make (l_as, l_text_formatter_decorator, Current)

			l_cluster_name := "CLUSTER_OF_"
			l_cluster_name.append (l_as.class_name.string_value_32)
			create cluster_chart.make_element (l_text_formatter_decorator, l_cluster_name, Void, Void, Void)

			create {LINKED_LIST[TBON_CLUSTER_CHART]} cluster_list.make

			cluster_list.extend (cluster_chart)

			l_system_name := "SYSTEM_OF_"
			l_system_name.append (l_as.class_name.string_value_32)
			create system_chart.make_element (l_text_formatter_decorator, l_system_name, cluster_list, Void, Void)

			create textual_bon_class_chart.make_element (textual_bon_spec, l_text_formatter_decorator, cluster_chart, Current)
			textual_bon_class_chart.set_current_class (current_class)

			cluster_chart.add_class (textual_bon_class_chart)
			textual_bon_class_chart.find_descendants
			system_chart.process_to_textual_bon
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
