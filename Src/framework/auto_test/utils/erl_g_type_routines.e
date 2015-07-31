note

	description:

		"Common Eiffel type related routines"

	copyright: "Copyright (c) 2005, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ERL_G_TYPE_ROUTINES

inherit
	REFACTORING_HELPER

	SHARED_EIFFEL_PARSER

	SHARED_TYPES

	SHARED_STATELESS_VISITOR

	AUT_SHARED_INTERPRETER_INFO
		export
			{NONE} all
		end

	INTERNAL_COMPILER_STRING_EXPORTER

	EPA_TYPE_UTILITY
		undefine
			system
		end

--	SHARED_STATELESS_VISITOR
--		rename
--			type_output_strategy as ast_type_output_strategy
--		end

feature -- Access

	has_feature (a_class: CLASS_C; a_feature: FEATURE_I): BOOLEAN
			-- Does `a_class' contain `a_feature'?
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
		do
			Result := a_class.feature_table.has (a_feature.feature_name)
		end

	is_default_creatable (a_class: CLASS_C; a_system: SYSTEM_I): BOOLEAN
			-- Are objects of type `a_class' creatable via default creation?
		require
			a_class_not_void: a_class /= Void
			a_system_not_void: a_system /= Void
		do
			Result := a_class.allows_default_creation
		end

	generic_derivation (a_class: CLASS_C; a_system: SYSTEM_I): TYPE_A
			-- Generic derivation `a_class'; this is a type which has `a_class' as base class
			-- but where all formal parameters have been closed with types. The types to be used
			-- as actual paramenters will be ANY for unconstrained formal parameters and
			-- the constraining type for constrained parameters.
		require
			a_class_not_void: a_class /= Void
			a_class_is_generic: a_class.is_generic
			a_system_not_void: a_system /= Void
		do
			Result := generic_derivation_type_visitor.derived_type (a_class.actual_type, a_class)
		ensure
			result_attached: Result /= Void
		end

	generic_derivation_type_visitor: AUT_GENERIC_DERIVATION_TYPE_VISITOR
			-- Generic derivation type visitor
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

	generic_derivation_of_type (a_type: TYPE_A; a_context: CLASS_C): TYPE_A
			-- Generic derivation for `a_type'
		do
			Result := generic_derivation_type_visitor.derived_type (a_type, a_context)
		end

	exported_creators (a_class: CLASS_C; a_system: SYSTEM_I): LINKED_LIST [STRING]
			-- Names of creators which are exported to class ANY from `a_class'
			-- Return an empty list of no valid creator is found.
		require
			a_class_attached: a_class /= Void
			a_system_attached: a_system /= Void
		local
			l_any_class: CLASS_C
			l_creator_tbl: HASH_TABLE [EXPORT_I, STRING]
		do
			create Result.make
			l_creator_tbl := a_class.creators
			l_any_class := a_system.any_class.compiled_representation
			if l_creator_tbl /= Void then
				from
					l_creator_tbl.start
				until
					l_creator_tbl.after
				loop
						-- When a class has no exported creation procedure, e.g. XXX_CURSOR classes,
						-- test engine may end up in an infinite loop.
						-- This is a hack to break that loop.
						-- Although this doesn't seem to harm the testing process,
						-- a real fix should keep a record of non-instantiable classes,
						-- and only use objects from the pool for such classes.
--					if l_creator_tbl.item_for_iteration.is_exported_to (l_any_class) then
						Result.extend (l_creator_tbl.key_for_iteration)
--					end
					l_creator_tbl.forth
				end
			end

			if a_class.allows_default_creation then
				Result.extend (a_class.default_create_feature.feature_name)
			end
		ensure
			result_attached: Result /= Void
		end

	creation_procedure_count (a_type: TYPE_A; a_system: SYSTEM_I): INTEGER
			-- Number of exported creation procedures for class associated with `a_type'.
			-- Return 0 if `a_type' is not creatable.
		require
			a_type_attached: a_type /= Void
			a_system_not_void: a_system /= Void
		do
			if a_type.has_associated_class then
				Result := exported_creators (a_type.base_class, a_system).count
			end
		ensure
			good_result:
				(not a_type.has_associated_class implies Result = 0) and then
				(a_type.has_associated_class implies Result = exported_creators (a_type.base_class, a_system).count)
		end

	is_exported_creator (a_feature: FEATURE_I; a_type: TYPE_A): BOOLEAN
			-- Is `a_feature' declared in `a_type' a creator which is exported to all classes?
		require
			a_feature_attached: a_feature /= Void
			a_type_attached: a_type /= Void
		local
			l_class: CLASS_C
		do
			if
				a_type.has_associated_class and then
				a_type.associated_class.creators /= Void and then
				a_type.associated_class.creators.has (a_feature.feature_name)
			then
				Result := a_type.associated_class.creators.item (a_feature.feature_name).is_all
			end

			if a_type.has_associated_class then
				l_class := a_type.associated_class

				if l_class.creators /= Void and then l_class.creators.has (a_feature.feature_name) then
						-- For normal creators.
					Result := l_class.creators.item (a_feature.feature_name).is_all

				elseif l_class.allows_default_creation and then l_class.default_create_feature.feature_name.is_equal (a_feature.feature_name) then
						-- For default creators.
					Result := True
				end
			end
		end

feature {NONE} -- Parsing class types

	base_type (a_name: STRING): TYPE_A
			-- Type parsed from `a_name'
			-- If `a_name' is "NONE", return {NONE_A}.
			-- If `a_name' is an unknown type, return Void.
			-- The result is resolved in `a_context_class'.
		require
			a_name_not_void: a_name /= Void
		local
			l_name: STRING
			l_type_as: TYPE_AS
			l_new_line_index: INTEGER
		do
			l_new_line_index := a_name.index_of ('%N', 1)
			if l_new_line_index > 0 then
				l_name := a_name.substring (1, l_new_line_index - 1)
			else
				l_name := a_name
			end
			if l_name.is_case_insensitive_equal ("NONE") then
				Result := none_type
			else
					-- Parse `l_name' into a type AST node.
				type_parser.set_syntax_version (type_parser.provisional_syntax)
				type_parser.parse_from_string_32 ("type " + l_name, Void)
				l_type_as := type_parser.type_node

					-- Generate TYPE_A object from type AST node.
				Result := evaluated_base_type (l_type_as)
			end
		end

	evaluated_base_type (a_type: TYPE_AS): detachable TYPE_A
			-- Retrieve evaluated base type for given parsed type representation.
		require
			a_type_attached: a_type /= Void
		local
			l_roots: ARRAYED_LIST [SYSTEM_ROOT]
		do
			l_roots := system.root_creators
			from
				l_roots.start
			until
				l_roots.after or Result /= Void
			loop
				if attached l_roots.item_for_iteration.root_class.compiled_class as l_root_class then
					Result := type_a_generator.evaluate_type (a_type, l_root_class)
				end
				l_roots.forth
			end
		end

feature{NONE} -- Implementation

	add_feature_argument_type_in_input_creator (a_feature: FEATURE_I; a_context: TYPE_A; a_input_creator: AUT_RANDOM_INPUT_CREATOR)
			-- Add types of arguments in `a_feature' if any into `a_input_creator'.
			-- Types are evaluated in context `a_context'.
		require
			a_feature_attached: a_feature /= Void
			a_context_attached: a_context /= Void
			a_input_creator_attached: a_input_creator /= Void
		local
			l_arg_types: LIST [TYPE_A]
		do
			l_arg_types := feature_argument_types (a_feature, a_context)
			l_arg_types.do_all (agent a_input_creator.add_type)
		end

	add_feature_argument_type_in_deterministic_input_creator (a_feature: FEATURE_I; a_context: TYPE_A; a_input_creator: AUT_DETERMINISTIC_INPUT_CREATOR)
			-- Add types of arguments in `a_feature' if any into `a_input_creator'.
			-- Types are evaluated in context `a_context'.
		require
			a_feature_attached: a_feature /= Void
			a_context_attached: a_context /= Void
			a_input_creator_attached: a_input_creator /= Void
		local
			l_arg_types: LIST [TYPE_A]
		do
			l_arg_types := feature_argument_types (a_feature, a_context)
			l_arg_types.do_all (agent a_input_creator.add_type)
		end

	feature_argument_types (a_feature: FEATURE_I; a_context: TYPE_A): LIST [TYPE_A]
			-- List of types for arguments in `a_feature'. Types are evaluated in context `a_context'.
			-- If `a_feature' doesn't have any argument, return an empty list.
		require
			a_feature_attached: a_feature /= Void
			a_context_attached: a_context /= Void
		local
			i: INTEGER
			count: INTEGER
			l_type: TYPE_A
			l_class: CLASS_C
			l_class_id: INTEGER
		do
			create {LINKED_LIST [TYPE_A]} Result.make
			if a_feature.arguments /= Void then
				l_class := a_context.associated_class
				l_class_id := l_class.class_id
				from
					i := 1
					count := a_feature.arguments.count
				until
					i > count
				loop
					l_type := a_feature.arguments.i_th (i).actual_type
					l_type := l_type.actual_type.instantiation_in (a_context, l_class_id)
					if l_type.is_loose then
						l_type := actual_type_from_formal_type (l_type, l_class)
					end
					fixme ("The following code is used to avoid a problem which a type cannot be correctly resolved. For example, the first argument of LINKED_LIST.append. 10.04.2011. Jasonw")
					l_type := type_a_from_string (output_type_name (l_type.name), interpreter_root_class)
					Result.extend (l_type)
					i := i + 1
				end
			end
		ensure
			result_attached: Result /= Void
			good_result: not Result.has (Void)
		end

feature -- Types

	resolved_type_from_name (a_type_name: STRING; a_context: CLASS_C): detachable TYPE_A
			-- Note: Code taken from `build_types_and_classes_under_test'
		local
			l_type: TYPE_A
			l_name: STRING
		do
			fixme ("Note: Code taken from `build_types_and_classes_under_test'. Refactoring is needed.")
			l_type := base_type_with_context (a_type_name, a_context) --system.root_type.associated_class)
			if l_type /= Void then
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
				if attached {CL_TYPE_A} l_type as l_class_type then
						-- Only compiled classes are taken into consideration.
					if l_class_type.associated_class /= Void then
						if not interpreter_related_classes.has (l_class_type.name) then
							Result := l_class_type
						end
					end
				else
					check
						dead_end: False
					end
				end
			end
		end

	base_type_with_context (a_name: STRING; a_context_class: CLASS_C): TYPE_A
			-- Type parsed from `a_name'
			-- If `a_name' is "NONE", return {NONE_A}.
			-- If `a_name' is an unknown type, return Void.
			-- The result is resolved in `a_context_class'.
		require
			a_name_not_void: a_name /= Void
		local
			l_type_as: TYPE_AS
			l_options: CONF_OPTION
		do
			fixme ("Code is similar to ERL_G_TYPE_ROUTINES.base_type. Refactoring is needed.")
			if a_name.is_case_insensitive_equal ("NONE") then
				Result := none_type
			else
					-- Setup syntax level according to `a_context_class'.
				l_options := a_context_class.lace_class.options
				inspect l_options.syntax.index
				when {CONF_OPTION}.syntax_index_obsolete then
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.obsolete_syntax)
				when {CONF_OPTION}.syntax_index_transitional then
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.transitional_syntax)
				when {CONF_OPTION}.syntax_index_provisional then
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.provisional_syntax)
				else
					type_parser.set_syntax_version ({EIFFEL_SCANNER}.ecma_syntax)
				end

					-- Parse `a_name' into a type AST node.
				type_parser.parse_from_utf8_string ("type " + a_name, a_context_class)
				l_type_as := type_parser.type_node

					-- Generate TYPE_A object from type AST node.
				if l_type_as /= Void and then attached {CLASS_C} a_context_class as l_context_class then
					Result := type_a_generator.evaluate_type (l_type_as, l_context_class)
				end
			end
		end

	full_type_name (a_type: STRING; a_context_class: CLASS_C): STRING
			-- Full type name of `a_type'
			-- Note: Code copied from TEST_INTERPRETER_SOURCE_WRITER.`put_type_assignment'. `put_type_assignment'
			-- can be simplified using current feature. 05.06.2009 Jasonw
		require
			a_type_not_void: a_type /= Void
			a_context_class_class_attached: a_context_class /= Void
		local
			l_type_a, l_gtype: TYPE_A
			l_class: CLASS_C
			l_type: detachable STRING
			i: INTEGER
		do
			fixme ("Refactoring, see header comment.")
			type_parser.set_syntax_version (type_parser.provisional_syntax)
			type_parser.parse_from_utf8_string ("type " + a_type, a_context_class)
			if attached {CLASS_TYPE_AS} type_parser.type_node as l_type_as then
				l_type_a := type_a_generator.evaluate_type (l_type_as, a_context_class)
				if l_type_a /= Void then
					create l_type.make (20)
					l_type.append (l_type_a.name)
					if l_type_a.generics = Void then
						l_class := l_type_a.associated_class
						check l_class /= Void end
						if l_class.is_generic then
								-- In this case we try to insert constrains to receive a valid type
							l_type.append (" [")
							from
								i := 1
							until
								not l_class.is_valid_formal_position (i)
							loop
								if i > 1 then
									l_type.append (", ")
								end
								if l_class.generics [i].is_multi_constrained (l_class.generics) then
									l_type.append ("NONE")
								else
									l_gtype := l_class.constrained_type (i)
									append_type_in_string (l_type, l_gtype)
								end
								i := i + 1
							end
							l_type.append ("]")
						end
					end
					Result := l_type
				end
			end
		end

	append_type_in_string (a_string: attached STRING; a_type: TYPE_A)
			-- Append type name for `a_type' to `a_string' without formal parameters.
		local
			i: INTEGER
		do
			fixme ("Refactoring this and {TEST_INTERPRETER_SOURCE_WRITER}.append_type")
			if not a_type.is_formal and attached {CL_TYPE_A} a_type as l_class_type then
				a_string.append (l_class_type.associated_class.name)
				if l_class_type.has_generics then
					a_string.append (" [")
					from
						i := l_class_type.generics.lower
					until
						i > l_class_type.generics.upper
					loop
						if i > l_class_type.generics.lower then
							a_string.append (", ")
						end
						append_type_in_string (a_string, l_class_type.generics.i_th (i))
						i := i + 1
					end
					a_string.append ("]")
				end
			else
				a_string.append ("NONE")
			end
		end

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
