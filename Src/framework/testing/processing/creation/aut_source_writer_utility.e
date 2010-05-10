note
	description: "Summary description for {AUT_SOURCE_WRITER_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_SOURCE_WRITER_UTILITY

inherit
	SHARED_WORKBENCH

	ERL_G_TYPE_ROUTINES

feature -- Access

	topologically_sorted_classes_info (a_types: attached DS_LINEAR [STRING]): LINKED_LIST [TUPLE [class_name: STRING; type: TYPE_A; type_name: STRING]] is
			-- Information of classes from `a_types', topologically sorted by inheritance relation.
			-- The most specific class appears at the beginning of the list.
		local
			l_class_info: LINKED_LIST [TUPLE [a_class_name: STRING; a_type: TYPE_A; a_type_name: STRING]]
			l_class: CLASS_C
			l_classi: LIST [CLASS_I]
			l_class_name: STRING
			l_type: TYPE_A
			l_processed: DS_HASH_SET [CLASS_C]
			l_list: LIST [CLASS_C]
			l_sorter: DS_TOPOLOGICAL_SORTER [CLASS_C]
			l_sorted_classes: DS_ARRAYED_LIST [CLASS_C]
			l_class_type: STRING
		do
				-- Get the list of classes whose state should be recorded.
			create l_processed.make (50)
			l_processed.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [CLASS_C]}.make (
				agent (a, b: CLASS_C): BOOLEAN do Result := a.class_id = b.class_id end))
			from
				a_types.start
			until
				a_types.after
			loop
				l_classi := universe.classes_with_name (a_types.item_for_iteration.as_upper)
				if not l_classi.is_empty  then
					l_class := l_classi.first.compiled_representation
					l_list := l_class.suppliers.classes.twin
					l_list.extend (l_class)
					from
						l_list.start
					until
						l_list.after
					loop
						if not l_processed.has (l_list.item_for_iteration) then
							l_processed.force_last (l_list.item_for_iteration)
							l_class_name := l_list.item_for_iteration.name_in_upper
							l_type := l_list.item_for_iteration.actual_type
						end
						l_list.forth
					end
				end
				a_types.forth
			end

				-- Topologically sort classes, so more specific classes
				-- appear first.
			create l_class_info.make
			l_sorted_classes := topologically_sorted_classes (l_processed)
			from
				l_sorted_classes.start
			until
				l_sorted_classes.after
			loop
				l_class_name := l_sorted_classes.item_for_iteration.name_in_upper
				l_type := l_sorted_classes.item_for_iteration.actual_type
				l_class_type := full_type_name (l_class_name, root_class)
				check l_class_name /= Void end
				check l_type /= Void end
				if l_class_type /= Void then
					l_class_info.extend ([l_class_name, l_type, l_class_type])
				end
				l_sorted_classes.forth
			end
			Result := l_class_info
		end

	topologically_sorted_classes (a_classes: DS_HASH_SET [CLASS_C]): DS_ARRAYED_LIST [CLASS_C] is
			-- Topologically sorted classes from `a_classes'
			-- The most specific class appears at the first position in the sorted
			-- result
		local
			l_sorter: DS_TOPOLOGICAL_SORTER [CLASS_C]
			l_list: LINKED_LIST [CLASS_C]
			l_type1, l_type2: TYPE_A
			l_class1, l_class2: CLASS_C
		do
			create l_sorter.make (a_classes.count)
			create l_list.make
			from
				a_classes.start
			until
				a_classes.after
			loop
				l_class1 := a_classes.item_for_iteration
				l_type1 := l_class1.actual_type

				l_sorter.force (a_classes.item_for_iteration)
				from
					l_list.start
				until
					l_list.after
				loop
					l_class2 := l_list.item_for_iteration

					l_type2 := l_class2.actual_type
					if l_type1.is_conformant_to (root_class, l_type2) then
						l_sorter.put_relation (l_class1, l_class2)
					elseif l_type2.is_conformant_to (root_class, l_type1) then
						l_sorter.put_relation (l_class2, l_class1)
					end
					l_list.forth
				end
				l_list.extend (a_classes.item_for_iteration)
				a_classes.forth
			end
			l_sorter.sort
			Result := l_sorter.sorted_items
		end

	root_class: CLASS_C
			-- Root class of current system
		deferred
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
