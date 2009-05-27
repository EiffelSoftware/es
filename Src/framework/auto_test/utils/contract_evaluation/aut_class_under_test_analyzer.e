note
	description: "Summary description for {AUT_CLASS_UNDER_TEST_ANALYZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_CLASS_UNDER_TEST_ANALYZER

inherit
	KL_STRING_EQUALITY_TESTER

	ERL_G_TYPE_ROUTINES

	AUT_SHARED_TYPE_FORMATTER

create
	make

feature{NONE} -- Initialization

	make (a_root_class_name: STRING; a_class_names: LIST [STRING]; a_system: SYSTEM_I) is
			-- Initialize Current.
		do
			system := a_system
			root_class_name := a_root_class_name.twin
			create class_names.make (a_class_names.count)
			class_names.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})
			a_class_names.do_all (agent class_names.force_last)
			fixme ("Remove the dependency to interpreter_root_class in ERL_G_TYPE_ROUTINES.base_type")
			interpreter_root_class_cell.put (root_class)
			build_types_under_test
			find_suppliers
		end

feature -- Access

	variable_declaration (a_attribute_prefix: STRING): STRING is
			-- Class attributes declaration whose types are those in `types_under_test'.
		local
			i: INTEGER
		do
			create Result.make (2048)
			from
				types_under_test.start
			until
				types_under_test.after
			loop
				Result.append ("%T%T")
				Result.append (a_attribute_prefix)
				Result.append (i.out)
				Result.append (": ")
				Result.append (type_name_with_context (types_under_test.item_for_iteration, types_under_test.item_for_iteration.associated_class, Void))
				Result.append ("%N")
				types_under_test.forth
				i := i + 1
			end
		end

	auto_test_command_line_classes: STRING is
			-- Classes under test for AutoTest
		local
			l_type: TYPE_A
			l_types: DS_HASH_SET [TYPE_A]
			l_class_name: STRING
		do
			create Result.make (2048)
			from
				suppliers.start
			until
				suppliers.after
			loop
				l_type := suppliers.key_for_iteration
				l_types := suppliers.item_for_iteration.twin
				l_types.remove (l_type)
				Result.append (l_type.associated_class.name_in_upper)
				from
					l_types.start
				until
					l_types.after
				loop
					l_class_name := l_types.item_for_iteration.associated_class.name_in_upper
					if not ignored_class_names.has (l_class_name) then
						Result.append (" ")
						Result.append (l_types.item_for_iteration.associated_class.name_in_upper)
					end
					l_types.forth
				end
				Result.append ("%N")
				suppliers.forth
			end
		end


	system: SYSTEM_I
			-- System under test

	root_class_name: STRING
			-- Root class name

	root_class: CLASS_C is
			-- Root class
		do
			Result := system.universe.classes_with_name (root_class_name).first.compiled_representation
		end

	class_names: DS_HASH_SET [STRING]
			-- List of class names to be tested

	types_under_test: DS_HASH_TABLE [TYPE_A, STRING]
			-- Table of types under test
			-- [Type, Name of the associated class]

	types: DS_HASH_SET [TYPE_A]
			-- Types under test

	suppliers: DS_HASH_TABLE [DS_HASH_SET [TYPE_A], TYPE_A]
			-- Suppliers (as in feature arguments) of types
			-- [Suppliers of the type in key (including the type in key), type]

	build_types_under_test is
			-- Build `types_under_test' from `class_names'.
		local
			l_class_names: like class_names
			l_classesi: LIST [CLASS_I]
			l_classc: detachable CLASS_C
			l_root_class: CLASS_C
			l_type: TYPE_A
			l_class_name: STRING
		do
			l_class_names := class_names
			l_root_class := root_class
			create types_under_test.make (l_class_names.count)
			types_under_test.set_key_equality_tester (create {KL_STRING_EQUALITY_TESTER})
			create types.make (l_class_names.count)
			types.set_equality_tester (type_a_equality_tester)

			from
				l_class_names.start
			until
				l_class_names.after
			loop
				l_classesi := system.universe.classes_with_name (l_class_names.item_for_iteration)
				if not l_classesi.is_empty then
					l_classc := l_classesi.first.compiled_representation
					if l_classc /= Void then
						l_class_name := l_classc.name_in_upper
						l_type := type_a_from_class_name (l_class_name, l_root_class)
						types_under_test.force_last (l_type, l_class_name)
						types.force_last (l_type)
					end
				end
				l_class_names.forth
			end
		end

	find_suppliers is
			-- Find suppliers for classes under test.
		local
			l_type: TYPE_A
			l_suppliers: DS_HASH_SET [TYPE_A]
		do
			create suppliers.make (types_under_test.count)
			from
				types_under_test.start
			until
				types_under_test.after
			loop
				l_type := types_under_test.item_for_iteration
				l_suppliers := suppliers_for_type (l_type)
				l_suppliers.force_last (l_type)
				suppliers.force_last (l_suppliers, l_type)
				from
					l_suppliers.start
				until
					l_suppliers.after
				loop
					l_suppliers.forth
				end
				types_under_test.forth
			end
		end

	suppliers_for_type (a_type: TYPE_A): DS_HASH_SET [TYPE_A] is
			-- Suppliers (as in feature arguments) for `a_type'.
		local
			l_class: CLASS_C
			l_feat_table: FEATURE_TABLE
			l_any_class: CLASS_C
			feature_i: FEATURE_I
			l_suppliers: LIST [TYPE_A]
			l_type: TYPE_A
		do
			l_any_class := system.any_class.compiled_class
			l_class := a_type.associated_class
			l_feat_table := l_class.feature_table

			create Result.make (10)
			Result.set_equality_tester (type_a_equality_tester)

			from
				l_feat_table.start
			until
				l_feat_table.after
			loop
				feature_i := l_feat_table.item_for_iteration
				if not feature_i.is_prefix and then not feature_i.is_infix then
						-- Normal exported features.
					if
						feature_i.export_status.is_exported_to (l_any_class) or else
						is_exported_creator (feature_i, a_type)
					then
						l_suppliers := feature_argument_types (feature_i, a_type)
						from
							l_suppliers.start
						until
							l_suppliers.after
						loop
							l_type := l_suppliers.item_for_iteration
							if
								(not l_type.is_basic) and then
								(not l_type.is_pointer) and then
								(not l_type.is_none) and then
								(not l_type.associated_class.is_deferred) and then
								(l_type.associated_class /= l_any_class)
							then
								Result.force_last (l_type)
							end
							l_suppliers.forth
						end
					end
				end
				l_feat_table.forth
			end

		end

	type_a_from_class_name (a_class_name: STRING; a_context_class: CLASS_C): TYPE_A is
			-- Type object for `a_class_name', anchors and generics are taken into consideration.
		local
			l_type: TYPE_A
		do
			l_type := base_type (a_class_name)
			check l_type /= Void end
			if l_type.associated_class.is_generic then
				if not attached {GEN_TYPE_A} l_type as l_gen_type then
					if attached {GEN_TYPE_A} l_type.associated_class.actual_type as l_gen_type2 then
						l_type := generic_derivation_of_type (l_gen_type2, l_gen_type2.associated_class)
					else
						check
							dead_end: False
						end
					end
				end
			end
			Result := l_type
		end

	type_a_equality_tester: AGENT_BASED_EQUALITY_TESTER [TYPE_A] is
			-- Equality tester for TYPE_A objects.
		do
			create {AGENT_BASED_EQUALITY_TESTER [TYPE_A]} Result.make (
				agent (a_type, b_type: TYPE_A): BOOLEAN
					do
						Result :=
							a_type.associated_class /= Void and then
							b_type.associated_class /= Void and then
							a_type.associated_class.class_id = b_type.associated_class.class_id
					end
			)
		end

	ignored_class_names: DS_HASH_SET [STRING] is
			-- Names of classes that are to be ignored as suppliers (as arguments)
		once
			create Result.make (10)
			Result.set_equality_tester (create {KL_STRING_EQUALITY_TESTER})
			Result.force_last ("STRING_8")
			Result.force_last ("PROCEDURE")
			Result.force_last ("FUNCTION")
			Result.force_last ("PREDICATE")
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
