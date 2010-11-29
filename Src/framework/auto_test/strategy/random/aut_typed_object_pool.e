note
	description: "Object pool for AutoTest"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_TYPED_OBJECT_POOL

inherit
	ERL_G_TYPE_ROUTINES

	AUT_SHARED_TYPE_FORMATTER

	AUT_SHARED_RANDOM

	AUT_PREDICATE_UTILITY
		undefine
			system
		end

create
	make

feature{NONE} -- Initialization

	make (a_system: like system; a_types_under_test: DS_LIST [TYPE_A]; a_root_class: CLASS_C) is
			-- Initialize current.
		require
			a_system_attached: a_system /= Void
			a_types_under_test_attached: a_types_under_test /= Void
			a_root_class_attached: a_root_class /= Void
		local
			l_types: DS_LIST [TYPE_A]
			l: ARRAY2 [INTEGER]
		do
			system := a_system
			root_class := a_root_class
			l_types := suppliers_of_types (a_types_under_test)
			sort_types (l_types)
			create storage.make (1000)
			storage.set_key_equality_tester (
				create {AGENT_BASED_EQUALITY_TESTER [ITP_VARIABLE]}.make (
					agent (a, b: ITP_VARIABLE): BOOLEAN
						do
							Result := a.index = b.index
						end))
			setup_variable_table
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

	conforming_variables (a_context_class: CLASS_C; a_type: TYPE_A): DS_ARRAYED_LIST [ITP_VARIABLE] is
			-- List of variables whose type conforms to `a_type' viewed fron `a_context_class'
		require
			a_context_class_attached: a_context_class /= Void
			a_type_attached: a_type /= Void
		local
			l_var_table: like variable_table
			l_type: TYPE_A
			l_list: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_storage: like storage
			l_root_class: CLASS_C
			l_vlist: DS_ARRAYED_LIST [ITP_VARIABLE]
			l_typ: TYPE_A
		do
			l_var_table := variable_table
			if l_var_table.has (a_type) then
				Result := l_var_table.item (a_type)
			else
				l_root_class := a_context_class
				l_storage := storage
				create l_vlist.make (initial_object_list_capacity)
				from
					l_var_table.start
				until
					l_var_table.after
				loop
					l_type := l_var_table.key_for_iteration

					if a_type.conform_to (l_root_class, l_type) then
						l_list := l_var_table.item_for_iteration
						from
							l_list.start
						until
							l_list.after
						loop
							if attached {TYPE_A} l_storage.item (l_list.item_for_iteration) as typ and then typ.conform_to (l_root_class, a_type) then
								l_vlist.force_last (l_list.item_for_iteration)
							end
							l_list.forth
						end
					end
					l_var_table.forth
				end
				l_var_table.force_last (l_vlist, a_type)
				sort_types (l_var_table.keys)
				Result := l_vlist
			end
		end

	random_conforming_variable (a_context_class: CLASS_C; a_type: TYPE_A): detachable ITP_VARIABLE
			-- Random variable of `conforming_variables (a_type)' or Void if list
			-- is emtpy
		require
			a_context_class_not_Void: a_context_class /= Void
			a_context_class_valid: a_context_class.is_valid
			a_type_not_void: a_type /= Void
		local
			list: like conforming_variables
			cs: DS_LINEAR_CURSOR [ITP_VARIABLE]
			i: INTEGER
			j: INTEGER
			l_variable: detachable ITP_VARIABLE
		do
			list := conforming_variables (a_context_class, a_type)
			if not list.is_empty then
				random.forth
				i := (random.item  \\ list.count) + 1
				l_variable := list.item (i)
				if l_variable /= Void and then is_variable_defined (l_variable) then
					Result := l_variable
				end
			end
		end

	root_class: CLASS_C
			-- Root class of Current system

	variable_type (a_variable: ITP_VARIABLE): TYPE_A
			-- Type of `a_variable'
		do
			Result := storage.item (a_variable)
		ensure
			result_set: Result = storage.item (a_variable)
		end

feature -- Status report

	is_variable_defined (a_variable: ITP_VARIABLE): BOOLEAN
			-- Is variable `a_variable' defined in interpreter?
		require
			a_variable_not_void: a_variable /= Void
		do
			Result := storage.has (a_variable)
		ensure
			good_result: Result = storage.has (a_variable)
		end

	is_variable_defined_by_index (a_index: INTEGER): BOOLEAN is
			-- Is variable with `a_index' defined?
		require
			a_index_valid: a_index > 0
		do
			Result := is_variable_defined (create {ITP_VARIABLE}.make (a_index))
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
			storage.wipe_out
		ensure
			variable_table_wiped_out: variable_table.for_all (agent (a_vars: DS_ARRAYED_LIST [ITP_VARIABLE]): BOOLEAN do Result := a_vars.is_empty end)
			storage_wiped_out: storage.is_empty
		end

	mark_invalid_object (a_index: INTEGER; a_context_class: CLASS_C) is
			-- Mark that object with index `a_index' violates it class invariant.
		require
			a_index_positive: a_index > 0
		local
			l_variable: ITP_VARIABLE
			l_var_table_cursor: DS_HASH_TABLE_CURSOR [DS_ARRAYED_LIST [ITP_VARIABLE], TYPE_A]
			l_type: TYPE_A
			l_storage: like storage
			l_var_table: like variable_table
			l_list_type: TYPE_A
			l_var_list: DS_ARRAYED_LIST [ITP_VARIABLE]
		do
			create l_variable.make (a_index)
			l_storage := storage

			l_type := l_storage.item (l_variable)
			if l_type /= Void then
				from
					l_var_table_cursor := variable_table.new_cursor
					l_var_table_cursor.start
				until
					l_var_table_cursor.after
				loop
					l_list_type := l_var_table_cursor.key
					if l_type.conform_to (a_context_class, l_list_type) then
						remove_variable_from_list (l_variable, l_var_table_cursor.item)
					end
					l_var_table_cursor.forth
				end
			end
			l_storage.remove (l_variable)
		end

feature{NONE} -- Implementation

	storage: DS_HASH_TABLE [TYPE_A, ITP_VARIABLE]
			-- Table of all variables along with their type

	sort_types (a_types: DS_LINEAR [TYPE_A]) is
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
			sorted_types_cursor := sorted_types.new_cursor
		end

	suppliers_of_types (a_types: DS_LIST [TYPE_A]): DS_LIST [TYPE_A] is
			-- Supplier types of `a_types'.
			-- Suppliers only include `a_types' and type of arguments appear in `a_types'.
		local
			l_classc: CLASS_C
			l_feat_tbl: FEATURE_TABLE
			l_type_set: DS_HASH_SET [TYPE_A]
			l_types: LIST [TYPE_A]
			l_cursor: CURSOR
		do
			create l_type_set.make (50)
			l_type_set.set_equality_tester (
				create {AGENT_BASED_EQUALITY_TESTER [TYPE_A]}.make (
					agent (a, b: TYPE_A): BOOLEAN
					local
						a_type, b_type: TYPE_A
					do
						a_type := a.actual_type
						b_type := b.actual_type
						Result := a_type.conform_to (root_class, b_type) and then b_type.conform_to (root_class, a_type)
					end))
			from
				a_types.start
			until
				a_types.after
			loop
				l_type_set.force_last (a_types.item_for_iteration)
				l_classc := a_types.item_for_iteration.associated_class
				l_feat_tbl := l_classc.feature_table
				l_cursor := l_feat_tbl.cursor
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
				l_feat_tbl.go_to (l_cursor)
				a_types.forth
			end
			create {DS_LINKED_LIST [TYPE_A]} Result.make
			l_type_set.do_all (agent Result.force_last)
		end

	initial_object_list_capacity: INTEGER is 500
			-- Initial capacity for the list to store object of each type

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
				create l_list.make (initial_object_list_capacity)
				l_list.set_equality_tester (variable_equality_tester)
				variable_table.put (l_list, sorted_types.item_for_iteration)
				sorted_types.forth
			end
		end

	remove_variable_from_list (a_variable: ITP_VARIABLE; a_var_list: DS_ARRAYED_LIST [ITP_VARIABLE]) is
			-- Remove `a_variable' from `a_var_list'.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [ITP_VARIABLE]
			l_done: BOOLEAN
			l_var_index: INTEGER
		do
			l_var_index := a_variable.index
			from
				l_cursor := a_var_list.new_cursor
				l_cursor.start
			until
				l_cursor.after or l_done
			loop
				if l_cursor.item.index = l_var_index then
					a_var_list.remove_at_cursor (l_cursor)
					l_done := True
				else
					l_cursor.forth
				end
			end
		end

;note
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
