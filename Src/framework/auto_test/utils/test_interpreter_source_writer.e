note
	description: "[
		Source writer for printing ITP_INTERPRETER_ROOT class.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_INTERPRETER_SOURCE_WRITER

inherit
	TEST_CLASS_SOURCE_WRITER
		redefine
			ancestor_names
		end

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	SHARED_EIFFEL_PARSER
		export
			{NONE} all
		end

	SHARED_STATELESS_VISITOR
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

	AUT_SHARED_INTERPRETER_INFO
		export
			{NONE} all
		end

create
	make

feature{NONE} -- Initialization

	make (a_config: like configuration)
			-- Initialize `configuration' with `a_config'.
		do
			configuration := a_config
		ensure
			configuration_set: configuration = a_config
		end

feature -- Access

	class_name: STRING = "ITP_INTERPRETER_ROOT"
			-- <Precursor>

	root_feature_name: STRING = "execute"
			-- <Precursor>

	ancestor_names: ARRAY [STRING]
			-- <Precursor>
		do
			Result := << "ITP_INTERPRETER" >>
		end

	configuration: TEST_GENERATOR
			-- Configuration associated with current AutoTest run

feature {NONE} -- Access

	root_group: detachable CONF_GROUP
	root_class: detachable CLASS_C
	root_feature: detachable FEATURE_I

feature -- Basic operations

	write_class (a_file: KI_TEXT_OUTPUT_STREAM; a_type_list: DS_LINEAR [STRING]; a_system: SYSTEM_I)
			-- Print root class refering to types in `a_type_list'
		require
			a_file_open_write: a_file.is_open_write
		local
			l_root: SYSTEM_ROOT
			l_class: like root_class
		do
			create stream.make (a_file)
			put_indexing
			put_class_header
			put_execute_byte_code

			if not a_system.root_creators.is_empty then
				l_root := a_system.root_creators.first
				root_group := l_root.cluster
				l_class := l_root.root_class.compiled_class
				if l_class /= Void then
					root_feature := l_class.feature_named_32 (l_root.procedure_name)
					root_class := l_class
					if root_feature /= Void and root_group /= Void then
						put_anchor_routine (a_type_list)
					end
				end
			end

				-- Generate predicate related routines
			put_predicate_related_routines

			put_class_footer
			stream := Void
		end

feature {NONE} -- Implementation

	put_execute_byte_code
			-- Put a dummy `execute_byte_code' routine.
		require
			stream_valid: is_writing
			root_group_attached: root_group /= Void
			root_class_attached: root_class /= Void
			root_feature_attached: root_feature /= Void
		local
			l_type: STRING
		do
			stream.indent
			stream.put_line ("execute_byte_code")
			stream.indent
			stream.put_line ("local")
			stream.indent
			stream.put_line ("v_1: ANY")
			stream.dedent
			stream.put_line ("do")
			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.put_line ("")
		end

	put_anchor_routine (a_types: DS_LINEAR [STRING])
			--
		require
			stream_valid: is_writing
			root_group_attached: root_group /= Void
			root_class_attached: root_class /= Void
			root_feature_attached: root_feature /= Void
		local
			l_type: STRING
		do
			stream.indent
			stream.put_line ("type_anchors")
			stream.indent
			stream.put_line ("local")
			stream.indent
			stream.put_line ("l_type: TYPE [ANY]")
			stream.dedent
			stream.put_line ("do")
			stream.indent
			stream.indent
			stream.put_line ("-- One assignment to avoid warnings")
			stream.dedent
			stream.put_line ("l_type := {ANY}")
			stream.put_line ("")

			from
				a_types.start
				type_a_checker.init_for_checking (root_feature, root_class, Void, Void)
			until
				a_types.after
			loop
				l_type := a_types.item_for_iteration
				put_type_assignment (l_type)
				a_types.forth
			end

			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_type_assignment (a_type: STRING)
			-- Print valid assignment for `a_type'.
		require
			a_type_not_void: a_type /= Void
			root_group_attached: root_group /= Void
			root_class_attached: root_class /= Void
			root_feature_attached: root_feature /= Void
		local
			l_type_a, l_creatable_type, t, l_gtype: TYPE_A
			l_class: CLASS_C
			l_type: detachable STRING
			i: INTEGER
			l_types: DS_HASH_SET [TYPE_A]
		do
			type_parser.set_syntax_version (type_parser.provisional_syntax)
			type_parser.parse_from_string_32 ("type " + a_type, root_class)
			error_handler.wipe_out
			if attached {CLASS_TYPE_AS} type_parser.type_node as l_type_as then
				l_type_a := type_a_generator.evaluate_type (l_type_as, root_class)
				if l_type_a /= Void then
					create l_types.make_equal (2)
					l_types.put (l_type_a)

					-- If the type's base class doesn't have public creation procedure,
					--		AutoTest will try to use a creatable descendant class to instantiate objects.
					-- Such a descendant class should also be declared, otherwise AutoTest will fail.
					-- See {AUT_RANDOM_INPUT_CREATOR}.random_creatable_descendant		
					--																	April 5, 2013 Max
					if not l_type_a.is_expanded and then creation_procedure_count (l_type_a, system) = 0 then
						l_creatable_type := creatable_descendant (l_type_a)
						if l_creatable_type /= Void then
							l_types.put (l_creatable_type)
						end
					end

					from l_types.start
					until l_types.after
					loop
						t := l_types.item_for_iteration

						if t.base_class.is_generic then
							t := generic_derivation (t.base_class, system)
						else
							t := t.base_class.actual_type
						end
						stream.put_string ("l_type := {")
						l_type := t.name
						l_type.replace_substring_all ("?", "")
						stream.put_string (l_type)
						stream.put_string ("}%N")

						l_types.forth
					end
				end
			end
		end

	creatable_descendant (a_type: TYPE_A): TYPE_A
			-- Arbitrary creatable descendant of `a_type; Void if none exists.
		require
			a_type_not_void: a_type /= Void
		local
			class_: CLASS_C
			cs: DS_LINEAR_CURSOR [CLASS_C]
			t: TYPE_A
			l_interp_classes: like interpreter_related_classes
		do
			fixme ("Adapted from {AUT_RANDOM_INPUT_CREATOR}.        -- April 5, 2013. Max")
			from
				l_interp_classes := interpreter_related_classes
				class_ := a_type.base_class
				cs := descendants (class_).new_cursor
				cs.start
			until
				cs.off or Result /= Void
			loop
				if cs.item.is_generic then
					t := generic_derivation (cs.item, system)
				else
					t := cs.item.actual_type
				end
				if
					not l_interp_classes.has (t.name) and then
					(t.is_expanded or creation_procedure_count (t, system) > 0)
				 then
					Result := t
				end
				cs.forth
			end
			cs.go_after
		end

	descendants (a_class: CLASS_C): DS_HASH_SET [CLASS_C]
			-- Descendants of `a_class'.
		require
			a_class_attached: a_class /= Void
		local
			l_recursive_descendants: DS_HASH_SET [CLASS_C]
		do
			fixme ("Adapted from {AUT_RANDOM_INPUT_CREATOR}.        -- April 5, 2013. Max")
			create l_recursive_descendants.make (20)
			compute_recursive_descendants (a_class, l_recursive_descendants)
			Result := l_recursive_descendants
		ensure
			result_attached: Result /= Void
		end

	compute_recursive_descendants (a_class: CLASS_C; a_descendants: DS_HASH_SET [CLASS_C])
			-- Compute all the recursive descendants for `a_class' and store result in `a_descendants'.
		require
			a_class_not_void: a_class /= Void
		local
			l_classes: LIST [CLASS_C]
		do
			fixme ("Adapted from {AUT_RANDOM_INPUT_CREATOR}.        -- April 5, 2013. Max")
			a_descendants.force_last (a_class)
			from
				l_classes := a_class.direct_descendants
				l_classes.start
			until
				l_classes.after
			loop
				compute_recursive_descendants (l_classes.item, a_descendants)
				l_classes.forth
			end
		end


	append_type (a_string: STRING; a_type: TYPE_A)
			-- Append type name for `a_type' to `a_string' without formal parameters.
		local
			i: INTEGER
		do
			if not a_type.is_formal and attached {CL_TYPE_A} a_type as l_class_type then
				a_string.append (l_class_type.associated_class.name)
				if l_class_type.has_generics then
					a_string.append (" [")
					across l_class_type.generics as l_generics_cursor loop
						if i = 0 then
							a_string.append (", ")
							i := 1
						end
						append_type (a_string, l_generics_cursor.item)
					end

--					from
--						i := l_class_type.generics.lower
--					until
--						i > l_class_type.generics.upper
--					loop
--						if i > l_class_type.generics.lower then
--							a_string.append (", ")
--						end
--						append_type (a_string, l_class_type.generics.item (i))
--						i := i + 1
--					end

					a_string.append ("]")
				end
			else
				a_string.append ("NONE")
			end
		end

feature -- Predicate evaluation

	put_predicate_related_routines
			-- Geneate routines for predicate monitoring.
		local
			l_writer: AUT_PREDICATE_SOURCE_WRITER
		do
			create l_writer.make (configuration, stream)
			l_writer.generate_predicates
		end


note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
