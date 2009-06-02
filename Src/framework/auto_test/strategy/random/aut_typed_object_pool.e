note
	description: "Summary description for {AUT_TYPED_OBJECT_POOL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TYPED_OBJECT_POOL

inherit
	ERL_G_TYPE_ROUTINES

	AUT_SHARED_TYPE_FORMATTER

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_types_under_test: DS_LIST [TYPE_A]) is
			-- Initialize current.
		local
			l_types: DS_LIST [TYPE_A]
		do
			system := a_system
			l_types := suppliers_of_types (a_types_under_test)
			sort_types (l_types)
			sorted_types_cursor := sorted_types.new_cursor
			create storage.make (1000)
			storage.set_key_equality_tester (
				create {AGENT_BASED_EQUALITY_TESTER [ITP_VARIABLE]}.make (
					agent (a, b: ITP_VARIABLE): BOOLEAN
						do
							Result := a.index = b.index
						end))
			setup_variable_table
		end

	setup_variable_table is
			-- Setup `variable_table'.
		local
			l_list: DS_ARRAYED_LIST [ITP_VARIABLE]
		do
			create variable_table.make (sorted_types.count)
			variable_table.set_key_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [TYPE_A]}.make (
				agent (a_type, b_type: TYPE_A): BOOLEAN
					do
						Result :=
							a_type.conform_to (system.root_type.associated_class, b_type) and then
							b_type.conform_to (system.root_type.associated_class, a_type)
					end
			))
			from
				sorted_types.start
			until
				sorted_types.after
			loop
				create l_list.make (100)
				variable_table.put (l_list, sorted_types.item_for_iteration)
				sorted_types.forth
			end
		end

feature -- Access

	system: SYSTEM_I
			-- System under test

	variable_table: DS_HASH_TABLE [DS_ARRAYED_LIST [ITP_VARIABLE], TYPE_A]
			-- Table of variables
			-- [List of variables of the type, type]

	sorted_types: DS_ARRAYED_LIST [TYPE_A]
			-- Sorted types
			-- The most specific types appear at first

	sorted_types_cursor: DS_ARRAYED_LIST_CURSOR [TYPE_A]
			-- Cursor to iterate `sorted_types'.

	conforming_variables (a_type: TYPE_A): DS_ARRAYED_LIST [ITP_VARIABLE] is
			-- List of variables whose type conforms to `a_type'
		local
			l_var_table: like variable_table
			l_type: TYPE_A
			l_list: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_storage: like storage
			l_root_class: CLASS_C
			l_vlist: DS_ARRAYED_LIST [ITP_VARIABLE]
		do
			l_var_table := variable_table
			if l_var_table.has (a_type) then
				Result := l_var_table.item (a_type)
			else
				l_root_class := system.root_type.associated_class
				l_storage := storage
				from
					l_var_table.start
				until
					l_var_table.after
				loop
					l_type := l_var_table.key_for_iteration
					create l_vlist.make (50)
					if a_type.conform_to (l_root_class, l_type) then
						l_list := l_var_table.item_for_iteration
						from
							l_list.start
						until
							l_list.after
						loop
							if l_storage.item (l_list.item_for_iteration).conform_to (l_root_class, a_type) then
								l_vlist.force_last (l_list.item_for_iteration)
							end
							l_list.forth
						end
					end
					l_var_table.forth
				end
				l_var_table.force_last (l_vlist, a_type)
				Result := l_vlist
			end
		end

feature -- Basic operations

	put_variable (a_variable: ITP_VARIABLE; a_type: TYPE_A) is
			-- Put `a_variable' of `a_type' into current pool.
		local
			l_cursor: like sorted_types_cursor
			l_root_class: CLASS_C
			l_var_tbl: like variable_table
			l_type: TYPE_A
		do
			l_root_class := system.root_type.associated_class
			l_cursor := sorted_types_cursor
			l_var_tbl := variable_table
			storage.force_last (a_type, a_variable)
			from
				l_cursor.start
			until
				l_cursor.after
			loop
				l_type := l_cursor.item
				if a_type.conform_to (l_root_class, l_type) then
					l_var_tbl.item (l_type).force_last (a_variable)
				end
				l_cursor.forth
			end
		end

	wipe_out is
			-- Wipe out current pool.
		local
			l_vtable: like variable_table
		do
			l_vtable := variable_table
			from
				l_vtable.start
			until
				l_vtable.after
			loop
				l_vtable.item_for_iteration.wipe_out
				l_vtable.forth
			end
		end

feature{NONE} -- Implementation

	storage: DS_HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- Table of all variables along with their type

	sort_types (a_types: DS_LIST [TYPE_A]) is
			-- Sort types in `a_types' topologically
			-- and store resultin `sorted_types'.
			-- The most specific types appear at first in `sorted_types'.
		local
			l_sorter: DS_TOPOLOGICAL_SORTER [TYPE_A]
			l_list: LINKED_LIST [TYPE_A]
			l_type1, l_type2: TYPE_A
			l_root_class: CLASS_C
		do
			l_root_class := system.root_type.associated_class
			create l_sorter.make (a_types.count)
			create l_list.make
			from
				a_types.start
			until
				a_types.after
			loop
				l_type1 := a_types.item_for_iteration
				l_sorter.force (a_types.item_for_iteration)
				from
					l_list.start
				until
					l_list.after
				loop
					l_type2 := l_list.item_for_iteration
					if l_type1.is_conformant_to (l_root_class, l_type2) then
						l_sorter.put_relation (l_type1, l_type2)
					elseif l_type2.is_conformant_to (l_root_class, l_type1) then
						l_sorter.put_relation (l_type2, l_type1)
					end
					l_list.forth
				end
				l_list.extend (a_types.item_for_iteration)
				a_types.forth
			end
			l_sorter.sort

			create sorted_types.make (l_sorter.sorted_items.count)
			l_sorter.sorted_items.do_all (agent sorted_types.force_last)
		end

	suppliers_of_types (a_types: DS_LIST [TYPE_A]): DS_LIST [TYPE_A] is
			-- Supplier types of `a_types'.
			-- Suppliers only include `a_types' and type of arguments appear in `a_types'.
		local
			l_classc: CLASS_C
			l_feat_tbl: FEATURE_TABLE
			l_type_set: DS_HASH_SET [TYPE_A]
			l_types: LIST [TYPE_A]
		do
			create l_type_set.make (50)
			l_type_set.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [TYPE_A]}.make (agent (a, b: TYPE_A): BOOLEAN do Result := a.is_equivalent (b) end))
			from
				a_types.start
			until
				a_types.after
			loop
				l_type_set.force_last (a_types.item_for_iteration)
				l_classc := a_types.item_for_iteration.associated_class
				l_feat_tbl := l_classc.feature_table
				from
					l_feat_tbl.start
				until
					l_feat_tbl.after
				loop
					l_types := feature_argument_types (l_feat_tbl.item_for_iteration, a_types.item_for_iteration)
					if l_types /= Void then
						l_types.do_all (agent l_type_set.force_last)
					end
					l_feat_tbl.forth
				end
				a_types.forth
			end
			create {DS_LINKED_LIST [TYPE_A]} Result.make
			l_type_set.do_all (agent Result.force_last)
		end

;note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
