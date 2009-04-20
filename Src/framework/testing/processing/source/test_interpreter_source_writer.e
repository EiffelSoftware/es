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

	AUT_OBJECT_STATE_REQUEST_UTILITY
		export
			{NONE} all
		end

feature -- Access

	class_name: attached STRING = "ITP_INTERPRETER_ROOT"
			-- <Precursor>

	root_feature_name: attached STRING = "execute"
			-- <Precursor>

	ancestor_names: attached ARRAY [attached STRING]
			-- <Precursor>
		do
			Result := << "ITP_INTERPRETER" >>
		end

feature {NONE} -- Access

	root_group: detachable CONF_GROUP
	root_class: detachable CLASS_C
	root_feature: detachable FEATURE_I

feature -- Basic operations

	write_class (a_file: attached KI_TEXT_OUTPUT_STREAM; a_type_list: attached DS_LINEAR [STRING]; a_system: attached SYSTEM_I)
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

			if not a_system.root_creators.is_empty then
				l_root := a_system.root_creators.first
				root_group := l_root.cluster
				l_class := l_root.root_class.compiled_class
				if l_class /= Void then
					root_feature := l_class.feature_named (l_root.procedure_name)
					root_class := l_class
					if root_feature /= Void and root_group /= Void then
						put_anchor_routine (a_type_list)
					end
				end
			end

				-- Generate routines for object state retrieval
			put_object_state_routines (a_type_list)

			put_class_footer
			stream := Void
		end

	is_object_state_retrieval_enabled: BOOLEAN
			-- Should object state retrieval be enabled?

feature -- Setting

	set_is_object_state_retrieval_enabled (b: BOOLEAN) is
			-- Set `is_object_state_retrieval_enabled' with `b'.
		do
			is_object_state_retrieval_enabled := b
		ensure
			is_object_state_retrieval_enabled_set: is_object_state_retrieval_enabled = b
		end

feature {NONE} -- Implementation

	put_object_state_routines (a_types: attached DS_LINEAR [STRING]) is
			-- Generate routines to support object state retrieval.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
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
		do
			if is_object_state_retrieval_enabled then

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
					l_class_info.extend ([l_class_name, l_type, full_type_name (l_class_name)])
					l_sorted_classes.forth
				end

					-- Generate routines to record states.
				put_record_queries_routine (l_class_info)
				from
					l_class_info.start
				until
					l_class_info.after
				loop
					put_record_query_routine (l_class_info.item.a_class_name, l_class_info.item.a_type, l_class_info.item.a_type_name)
					l_class_info.forth
				end
				put_record_query_default
				put_record_query_for_void
			else
				put_empty_record_queries_routine
			end
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

	put_record_queries_routine (a_classes: LIST [TUPLE [a_class_name: STRING; a_type: TYPE_A; a_type_name: STRING]]) is
			-- Generate `record_queries' routine for record argumentless queries
			-- of type BOOLEAN and INTEGER.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
		local
			l_class: CLASS_C
			l_classi: LIST [CLASS_I]
			l_class_name: STRING
			l_local_name: STRING
			i: INTEGER
		do
			stream.indent
			stream.put_line ("record_queries (o: detachable ANY)")
			stream.indent
			STREAM.put_line ("do")
			stream.indent
			from
				type_a_checker.init_for_checking (root_feature, root_class, Void, Void)
				a_classes.start
				i := 1
			until
				a_classes.after
			loop
				l_class_name := a_classes.item.a_class_name
				l_local_name := "l_" + l_class_name.as_lower
				if i = 1 then
					stream.put_string ("if ")
				else
					stream.put_string ("elseif ")
				end
				stream.put_string ("attached {")
				stream.put_string (a_classes.item.a_type_name)
				stream.put_string ("} o as ")
				stream.put_string (l_local_name)
				stream.put_line (" then")

				stream.indent
				stream.put_string ("record_query_")
				stream.put_string (l_class_name)
				stream.put_string (" (")
				stream.put_string (l_local_name)
				stream.put_line (")")
				stream.dedent
				i := i + 1
				a_classes.forth
			end

			if a_classes.is_empty then
				stream.put_string ("if ")
			else
				stream.put_string ("elseif ")
			end
			stream.put_line ("attached {ANY} o as l_obj_of_any then")
			stream.indent
			stream.put_line ("record_query_default_for_any (l_obj_of_any)")
			stream.dedent

			stream.put_line ("else")
			stream.indent
			stream.put_line ("record_query_for_void")

			stream.dedent
			stream.put_line ("end")

			stream.dedent
			stream.put_line ("end")

			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_empty_record_queries_routine is
			-- Generate an empty `record_queires' feature.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
		do
			stream.indent
			stream.put_line ("record_queries (o: ANY)")
			stream.indent
			stream.put_line ("do")
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_record_query_routine (a_class_name: STRING; a_type: TYPE_A; a_full_type_name: STRING) is
			-- Put routine to record queries for `a_type'.
		require
			a_class_name_attached: a_class_name /= Void
			a_type_attached: a_full_type_name /= Void
		local
			l_features: LIST [FEATURE_I]
		do

			stream.indent
			stream.put_string ("record_query_")
			stream.put_string (a_class_name)
			stream.put_string (" (o: ")
			stream.put_string (a_full_type_name)
			stream.put_line (")")
			stream.indent
			stream.put_line ("do")
			stream.indent

			if
				a_type.is_integer or else
				a_type.is_natural or else
				a_type.is_real_32 or else
				a_type.is_real_64 or else
				a_type.is_character or else
				a_type.is_boolean or else
				a_type.is_character_32
			then
				stream.put_line ("record_object_state_basic (o)")
			else
				l_features := supported_queries_of_type (a_type)
				from
					l_features.start
				until
					l_features.after
				loop
					stream.put_string ("record_query (agent o.")
					stream.put_string (l_features.item.feature_name.as_lower)
					stream.put_line (")")
					l_features.forth
				end
			end

			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_record_query_default is
			-- Put "record_query_default_for_any" into stream.
		do
			stream.indent
			stream.put_line ("record_query_default_for_any (a_obj: ANY)")
			stream.indent
			stream.put_line ("do end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_record_query_for_void is
			-- Put "record_query_default_for_any" into stream.
		do
			stream.indent
			stream.put_line ("record_query_for_void")
			stream.indent
			stream.put_line ("do")
			stream.indent
			 stream.put_line ("record_query (agent: STRING do Result := %"Void%" end)")
			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.dedent
			stream.put_line ("")
		end

	put_anchor_routine (a_types: attached DS_LINEAR [STRING])
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
			l_type_a, l_gtype: TYPE_A
			l_class: CLASS_C
			l_type: detachable STRING
			i: INTEGER
		do
--			type_parser.parse_from_string ("type " + a_type, root_class)
--			error_handler.wipe_out
--			if attached {CLASS_TYPE_AS} type_parser.type_node as l_type_as then
--				l_type_a := type_a_generator.evaluate_type_if_possible (l_type_as, root_class)
--				if l_type_a /= Void then
--					create l_type.make (20)
--					l_type.append (l_type_a.name)
--					if l_type_a.generics = Void then
--						l_class := l_type_a.associated_class
--						check l_class /= Void end
--						if l_class.is_generic then
--								-- In this case we try to insert constrains to receive a valid type
--							l_type.append (" [")
--							from
--								i := 1
--							until
--								not l_class.is_valid_formal_position (i)
--							loop
--								if i > 1 then
--									l_type.append (", ")
--								end
--								if l_class.generics [i].is_multi_constrained (l_class.generics) then
--									l_type.append ("NONE")
--								else
--									l_gtype := l_class.constrained_type (i)
--									append_type (l_type, l_gtype)
--								end
--								i := i + 1
--							end
--							l_type.append ("]")
--						end
--					end
					stream.put_string ("l_type := {")
					stream.put_string (full_type_name (a_type))
					stream.put_line ("}")
--				end
--			end
		end

	full_type_name (a_type: STRING): STRING
			-- Full type name of `a_type'
		require
			a_type_not_void: a_type /= Void
			root_group_attached: root_group /= Void
			root_class_attached: root_class /= Void
			root_feature_attached: root_feature /= Void
		local
			l_type_a, l_gtype: TYPE_A
			l_class: CLASS_C
			l_type: detachable STRING
			i: INTEGER
		do
			type_parser.parse_from_string ("type " + a_type, root_class)
			error_handler.wipe_out
			if attached {CLASS_TYPE_AS} type_parser.type_node as l_type_as then
				l_type_a := type_a_generator.evaluate_type_if_possible (l_type_as, root_class)
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
									append_type (l_type, l_gtype)
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

	append_type (a_string: attached STRING; a_type: TYPE_A)
			-- Append type name for `a_type' to `a_string' without formal parameters.
		local
			i: INTEGER
		do
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
						append_type (a_string, l_class_type.generics.item (i))
						i := i + 1
					end
					a_string.append ("]")
				end
			else
				a_string.append ("NONE")
			end
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
