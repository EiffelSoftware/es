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

	EPA_ARGUMENTLESS_PRIMITIVE_FEATURE_FINDER
		export
			{NONE} all
		end

	AUT_SHARED_TYPE_FORMATTER
		rename
			type_printer as old_type_output_strategy
		end

	ERL_G_TYPE_ROUTINES

	AUT_PREDICATE_UTILITY

	AUT_SHARED_PREDICATE_CONTEXT

create
	make

feature{NONE} -- Initialization

	make (a_config: like configuration) is
			-- Initialize `configuration' with `a_config'.
		do
			configuration := a_config
		ensure
			configuration_set: configuration = a_config
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

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration associated with current AutoTest run

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

				-- Generate routines to check preconditions
			put_precondition_checking_routines

				-- Generate predicate related routines
			put_predicate_related_routines

				-- Generate routines for test case serialization
			put_test_case_serialization_routines (a_type_list)

			put_class_footer
			stream := Void
		end

feature {NONE} -- Implementation

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
					stream.put_string ("l_type := {")
					stream.put_string (l_type)
					stream.put_line ("}")
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

feature -- Object state retrieval

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

	is_object_state_retrieval_needed: BOOLEAN is
			-- Is object state retrieval needed?
		do
			Result :=
				configuration.is_object_state_retrieval_enabled or
				configuration.is_precondition_checking_enabled or
				configuration.is_test_case_serialization_enabled
		end

	put_object_state_routines (a_types: attached DS_LINEAR [STRING]) is
			-- Generate routines to support object state retrieval.
			-- Note: If the recording from byte-code works, this feature should be removed.
			-- This is a walkaround for the moment. 4.10.2009 Jasonw
		local
			l_class_info: LINKED_LIST [TUPLE [a_class_name: STRING; a_type: TYPE_A; a_type_name: STRING]]
		do
			if is_object_state_retrieval_needed then
				l_class_info := topologically_sorted_classes_info (a_types)

					-- Generate routines to record states.
				put_record_queries_routine (l_class_info)
				put_record_queries_with_static_type_routine (l_class_info)

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
				put_empty_record_queries_with_static_type_routine
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

	put_record_queries_with_static_type_routine (a_classes: LIST [TUPLE [a_class_name: STRING; a_type: TYPE_A; a_type_name: STRING]]) is
			-- Generate `record_queries_with_static_type' routine for record argumentless queries
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
			stream.put_line ("record_queries_with_static_type (o: detachable ANY; a_static_type: STRING)")
			stream.indent
			stream.put_line ("do")
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
					stream.put_string ("if a_static_type.is_equal (%"" + a_classes.item.a_type_name + "%") and then ")
				else
					stream.put_string ("elseif a_static_type.is_equal (%"" + a_classes.item.a_type_name + "%") and then ")
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

	put_empty_record_queries_with_static_type_routine
			-- Generate an empty `record_queires_with_static_type' feature.
			-- Note: If the recording from byte-code works, this feature should be removed.
		do
			stream.indent
			stream.put_line ("record_queries_with_static_type (o: ANY; a_static_type: STRING)")
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
				a_type.is_character_32 or else
				a_type.is_pointer
			then
				stream.put_line ("record_object_state_basic (o)")
			else
				l_features := argumentless_primitive_queries (a_type)
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

feature -- Precondition satisfaction

--	predicates: DS_HASH_SET [AUT_PREDICATE]
--			-- Set of predicates that are to be checked

--	predicate_pattern_by_feature: DS_HASH_TABLE [DS_LINKED_LIST [AUT_PREDICATE_ACCESS_PATTERN], AUT_FEATURE_OF_TYPE]
--			-- Table of predicate access patterns associated with each feature

	generate_precondition_checker (a_feature: AUT_FEATURE_OF_TYPE; a_preconditions: DS_ARRAYED_LIST [AUT_PREDICATE_ACCESS_PATTERN]) is
			-- Generate precondition checker for `a_feature' whose preconditions are `a_preconditions'.
		local
			l_feat_name: STRING
			l_feat: FEATURE_I
			i: INTEGER
			l_arg_count: INTEGER
			l_arg_types: LIST [TYPE_A]
			l_text: STRING
			l_sorter: DS_QUICK_SORTER [AUT_PREDICATE_ACCESS_PATTERN]
		do
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [AUT_PREDICATE_ACCESS_PATTERN]}.make (agent (a, b: AUT_PREDICATE_ACCESS_PATTERN): BOOLEAN do Result := a.break_point_slot < b.break_point_slot end))
			l_sorter.sort (a_preconditions)

			l_feat := a_feature.feature_
			create l_feat_name.make (64)
			l_feat_name.append (precondition_evaluator_name (a_feature))
			stream.indent

				-- Generate feature signature.
			stream.put_string (l_feat_name)
			stream.put_string (" (")
			append_type_dec (0, resolved_type_from_name (a_feature.associated_class.name, system.root_type.associated_class), l_feat)
			if l_feat.argument_count > 0 then
				l_arg_types := feature_argument_types (l_feat, resolved_type_from_name (a_feature.associated_class.name, a_feature.associated_class))
				from
					i := 1
					l_arg_types.start
				until
					l_arg_types.after
				loop
					stream.put_string ("; ")
					append_type_dec (i, l_arg_types.item_for_iteration, l_feat)
					i := i + 1
					l_arg_types.forth
				end
			end
			stream.put_line ("): TUPLE")
			stream.indent
			stream.put_line ("local")
			stream.indent
			stream.put_line ("l_satisfied: BOOLEAN")
			stream.put_line ("l_failing_predicate_index: INTEGER")
			stream.dedent
			stream.put_line ("do")
			stream.indent
			stream.put_line ("l_failing_predicate_index := 1")

				-- Generate code to check preconditions.
			from
				i := 1
				a_preconditions.start
			until
				a_preconditions.after
			loop
				if i > 1 then
					stream.put_line ("if l_satisfied then")
					stream.indent
					stream.put_line ("l_failing_predicate_index := " + i.out)
				end

				stream.put_string ("l_satisfied := ")
				l_text := predicate_text (a_preconditions.item_for_iteration)
				stream.put_line (l_text)

				if i > 1 then
					stream.dedent
					stream.put_line ("end")
				end

--				predicates.force_last (a_preconditions.item_for_iteration.predicate)
				i := i + 1
				a_preconditions.forth
			end

				-- Generate return value.
			stream.put_line ("if l_satisfied then")
			stream.indent
			stream.put_string ("Result := [")
			from
				i := 0
				l_arg_count := l_feat.argument_count
			until
				i > l_arg_count
			loop
				stream.put_string (argument_name (i))
				if i < l_arg_count then
					stream.put_string (", ")
				end
				i := i + 1
			end
			stream.put_line ("]")
			stream.dedent
			stream.put_line ("end")

			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.put_line ("")
			stream.dedent
		end

	predicate_text (a_predicate: AUT_PREDICATE_ACCESS_PATTERN): STRING is
			-- Name of predicate
		local
			l_text: STRING
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
		do
			l_text := a_predicate.predicate.text.twin

			from
				l_cursor := a_predicate.access_pattern.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_text.replace_substring_all ("{" + l_cursor.key.out + "}", argument_name (l_cursor.item))
				l_cursor.forth
			end
			Result := l_text
		end

	argument_name (a_index: INTEGER): STRING is
			-- Name of argument with `a_index'
		do
			Result := "l_arg" + a_index.out
		end

	append_type_dec (a_argument_index: INTEGER; a_type: TYPE_A; a_feature: FEATURE_I) is
			-- Append a type declaration in `stream'.
		do
			stream.put_string (argument_name (a_argument_index))
			stream.put_string (": ")
			stream.put_string (type_name (a_type, a_feature))
		end

	put_precondition_checking_routine (a_feature: AUT_FEATURE_OF_TYPE) is
			-- Generate routine to evaluate the precondition of `a_feature'.
		local
			l_predicates: DS_ARRAYED_LIST [AUT_PREDICATE_ACCESS_PATTERN]
		do
			if precondition_access_pattern.has (a_feature) then
					-- Generate routine to check precondition of `a_feature'.
				create l_predicates.make (5)
				precondition_access_pattern.item (a_feature).do_all (agent l_predicates.force_last)
				generate_precondition_checker (a_feature, l_predicates)
			end
		end

	features_with_precondition: DS_LINKED_LIST [AUT_FEATURE_OF_TYPE]
			-- features under test that has precondition

	put_precondition_checking_routines is
			-- Generate routines to evaluate the preconditions of exported features
			-- in `types_under_test'.
		local
			l_classi: LIST [CLASS_I]
			l_classc: CLASS_C
			l_feat_table: FEATURE_TABLE
			l_feati: FEATURE_I
			l_any_class: CLASS_C
			l_feature: AUT_FEATURE_OF_TYPE
			l_type: TYPE_A
			types_under_test: like class_types_under_test
		do
			fixme ("This feature is similar to AUT_DYNAMIC_PRIORITY_QUEUE.set_static_priority_of_type. Refactoring is needed.")
			create features_with_precondition.make

			if configuration.is_precondition_checking_enabled then
				l_any_class := system.any_class.compiled_class
				from
					types_under_test := class_types_under_test
					types_under_test.start
				until
					types_under_test.after
				loop
					l_type := types_under_test.item_for_iteration
					l_classc := l_type.associated_class
					l_feat_table := l_classc.feature_table
					from
						l_feat_table.start
					until
						l_feat_table.after
					loop
						l_feati := l_feat_table.item_for_iteration

						if not l_feati.is_prefix and then not l_feati.is_infix then
							if
								l_feati.export_status.is_exported_to (l_any_class) or else
								is_exported_creator (l_feati, l_type)
							then
								create l_feature.make (l_feati, l_type)
								features_under_test.force_last (l_feature)
								put_precondition_checking_routine (l_feature)
							end
						end
						l_feat_table.forth
					end

					types_under_test.forth
				end
			end
			put_initialize_precondition_table_routine (features_with_precondition)
		end

	feature_identifier (a_feature: AUT_FEATURE_OF_TYPE): STRING is
			-- Identifier of `a_feature'
		do
			create Result.make (30)
			Result.append (a_feature.associated_class.name_in_upper)
			Result.append ("__")
			Result.append (a_feature.feature_.feature_name.as_lower)
		end

	precondition_evaluator_name (a_feature: AUT_FEATURE_OF_TYPE): STRING is
			-- Name of the precondition evaluator for `a_feature's
		do
			create Result.make (48)
			Result.append ("satisfied_objects__")
			Result.append (feature_identifier (a_feature))
		end

	put_initialize_precondition_table_routine (a_features: DS_LIST [AUT_FEATURE_OF_TYPE]) is
			-- Generate routine to initialize precondition checking agent table.
		do
			stream.indent
			stream.put_line ("initialize_precondition_table is")
			stream.indent
			stream.put_line ("do")
			if configuration.is_precondition_checking_enabled then
				stream.indent
				stream.put_string ("create precondition_table.make (")
				stream.put_string (a_features.count.out)
				stream.put_line (")")
				stream.put_line ("precondition_table.compare_objects")

				from
					a_features.start
				until
					a_features.after
				loop
					stream.put_string ("precondition_table.put (agent ")
					stream.put_string (precondition_evaluator_name (a_features.item_for_iteration))
					stream.put_string (", %"")
					stream.put_string (feature_identifier (a_features.item_for_iteration))
					stream.put_line ("%")")
					a_features.forth
				end
				stream.dedent
			end

			stream.put_line ("end")
			stream.put_line ("")
			stream.dedent
			stream.dedent
		end

feature -- Predicate evaluation

	put_predicate_related_routines is
			-- Geneate routines for predicate monitoring.
		local
			l_writer: AUT_PREDICATE_SOURCE_WRITER
		do
			create l_writer.make (configuration, stream)
			l_writer.generate_predicates
		end

feature -- Test case serialization

	put_test_case_serialization_routines (a_types: DS_LINEAR [STRING]) is
			-- Generate routines for test case serialization.
		local
			l_writer: AUT_TEST_CASE_SERIALIZATION_WRITER
		do
			create l_writer.make (configuration, stream, topologically_sorted_classes_info (a_types))
			l_writer.generate
		end

note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
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
