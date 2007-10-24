indexing
	description: "Objects that print class text for a test case"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CASE_PRINTER

inherit

	CDD_PRINTER

feature -- Access

	print_test_case (reflection: CDD_REFLECTION; test_class_name: STRING; a_file: like output_file) is
			-- Print class text for a new cdd test case.
		require
			valid_reflection: reflection /= Void and then reflection.reflection_succeded
			valid_test_class_name: test_class_name /= Void and then not test_class_name.is_empty
			a_file_writeable: a_file /= Void and then a_file.is_open_write
		local
			rlist: DS_LIST [CDD_COMPOSITE_OBJECT]
			root_object: CDD_COMPOSITE_OBJECT
			l_feature: E_FEATURE
			l_feature_name: STRING
		do
			output_file := a_file
			root_object := reflection.root_object
			l_feature := reflection.called_feature
			rlist := reflection.composite_objects

			-- Extract correct feature name
			if l_feature.is_infix then
				l_feature_name := l_feature.infix_symbol
			elseif l_feature.is_prefix then
				l_feature_name := l_feature.prefix_symbol
			else
				l_feature_name := l_feature.name
			end

			append_indexing (reflection, l_feature_name)
			append_class_header (test_class_name)

			append_text ("%N%Tset_up is%N")
			append_comment ("Set up test case")

			append_text ("%T%Tdo%N")
			append_comment ("Create objects")
			from
				rlist.start
			until
				rlist.after
			loop
				rlist.item_for_iteration.append_creation (Current)
				rlist.forth
			end

			append_comment ("Assign attributes")
			from
				rlist.start
			until
				rlist.after
			loop
				rlist.item_for_iteration.append_assignment (Current)
				rlist.forth
			end
			append_instruction ("object_under_test := " + root_object.identifier)
			append_text ("%T%Tend%N")


			append_text ("%N%Trun_feature_under_test is%N")
			append_comment ("Run feature under test")
			if l_feature.is_function then
				append_text ("%T%Tlocal%N")
				append_instruction ("l_result: ANY")
			end
			append_text ("%T%Tdo%N")
			append_text (indent)
			if reflection.is_creation_feature then
				append_text ("create object_under_test")
			elseif l_feature.is_function then
				append_text ("l_result ?= ")
			end
			if l_feature.is_infix then
				append_text ("object_under_test " + l_feature.infix_symbol + " ")
				append_text (reflection.arguments.first.identifier)
			elseif l_feature.is_prefix then
				append_text (l_feature.prefix_symbol + " object_under_test")
			elseif not reflection.is_creation_feature or not l_feature.name.is_equal ("default_create") then
				append_text ("object_under_test." + l_feature.name)
				if reflection.arguments.count > 0 then
					append_text (" (")
					from
						reflection.arguments.start
					until
						reflection.arguments.after
					loop
						append_text (reflection.arguments.item_for_iteration.identifier)
						reflection.arguments.forth
						if not reflection.arguments.after then
							append_text (", ")
						end
					end
					append_text (")")
				end
			end
			append_text ("%N%T%Tend%N%N")
			append_text ("%Tobject_under_test: " + root_object.type + "%N")
			append_text ("%T%T%T-- Name of the class under test.%N")
			append_text ("%T%T%T-- NOTE: Do not modify this attribute!%N%N")
			append_text ("%Tclass_under_test: STRING is %"" + root_object.dynamic_type.name + "%"%N")
			append_text ("%T%T%T-- Name of the class under test.%N")
			append_text ("%T%T%T-- NOTE: Do not modify this attribute!%N%N")
			append_text ("%Tfeature_under_test: STRING is %"" + l_feature_name + "%"%N")
			append_text ("%T%T%T-- Name of the feature under test.%N")
			append_text ("%T%T%T-- NOTE: Do not modify this attribute!%N%N")

			append_text ("feature -- Access%N%N")
			if reflection.is_creation_feature then
				append_object_declaration (reflection.root_object)
			end
			from
				rlist.start
			until
				rlist.after
			loop
				append_object_declaration (rlist.item_for_iteration)
				rlist.forth
			end
			append_text ("%T%T%T-- Attributes needed for initialize original object state.%N")
			append_text ("%T%T%T-- NOTE: Do not modify this attributes!%N%N")

			append_class_footer (test_class_name)
			output_file.flush
			output_file := Void
		end


feature {CDD_OBJECT} -- Testcase generation

	append_object_declaration (an_object: CDD_COMPOSITE_OBJECT) is
			-- Append declaration text for 'an_object'
		require
			an_object_not_void: an_object /= Void
		do
			append_text ("%T" + an_object.identifier + ": " + an_object.type + "%N")
		end

	append_regular_creation (an_object: CDD_REGULAR_OBJECT) is
			-- Append creation text for 'an_object'
		require
			an_object_not_void: an_object /= Void
		do
			append_instruction (an_object.identifier + " ?= build_object (%"" +an_object.type + "%")")
		end

	append_regular_assignment (an_object: CDD_REGULAR_OBJECT) is
			-- Append assignment text for 'an_object'.
		require
			an_object_not_void: an_object /= Void
		local
			instr: STRING
			a_key: STRING
			a_value: CDD_OBJECT
		do
			append_instruction ("create attributes.make (" + an_object.attributes.count.out + ")")
			from
				an_object.attributes.start
			until
				an_object.attributes.after
			loop
				a_key := an_object.attributes.key_for_iteration
				a_value := an_object.attributes.item_for_iteration
				instr := "attributes.put (" + a_value.identifier + ", %""
				instr.append (a_key + "%")")
				append_instruction (instr)
				an_object.attributes.forth
			end
			append_instruction ("set_attributes (" + an_object.identifier + ")")
		end

	append_string_creation (a_string: CDD_STRING_OBJECT) is
			-- Append creation text for 'a_string'
		require
			a_string_not_void: a_string /= Void
		do
			append_instruction (a_string.identifier + " := " + a_string.representation)
		end

	append_string_assignment (a_string: CDD_STRING_OBJECT) is
			-- Append assignment text for 'a_string'
		require
			a_string_not_void: a_string /= Void
		do
			-- NOTE: do nothing since strings get fully assigned at creation
		end


	append_special_creation (a_special: CDD_SPECIAL_OBJECT) is
			-- Append creation text for 'a_special'
		require
			a_special_not_void: a_special /= Void
		do
			append_instruction ("create " + a_special.identifier + ".make(" + a_special.attributes.count.out + ")")
		end

	append_special_assignment (a_special: CDD_SPECIAL_OBJECT) is
			-- Append assignment text for 'a_special'.
		require
			a_special_not_void: a_special /= Void
		local
			i: INTEGER
			instr: STRING
		do
			from
				i := 0
			until
				i = a_special.attributes.count
			loop
				instr := a_special.identifier + ".put ("
				instr.append (a_special.attributes.item (i.out).identifier)
				instr.append (", " + i.out + ")")
				append_instruction (instr)
				i := i + 1
			end
		end

	append_tuple_creation (a_tuple: CDD_TUPLE_OBJECT) is
			-- Append creation text for 'a_tuple'.
		require
			a_tuple_not_void: a_tuple /= Void
		do
			append_instruction ("create " + a_tuple.identifier)
		end

	append_tuple_assignment (a_tuple: CDD_TUPLE_OBJECT) is
			-- Append assignment text for 'a_tuple'.
		require
			a_tuple_not_void: a_tuple /= Void
		local
			i: INTEGER
			instr: STRING
		do
			from
				i := 1
			until
				i > a_tuple.attributes.count
			loop
				instr := a_tuple.identifier + ".put ("
				instr.append (a_tuple.attributes.item (i.out).identifier + ", " + i.out)
				instr.append (")")
				append_instruction (instr)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	append_indexing (a_reflection: CDD_REFLECTION; a_name: STRING) is
			-- Append indexing clause for 'a_reflection'
		require
			a_reflection_not_void: a_reflection /= Void
			a_name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			l_class: EIFFEL_CLASS_C
		do
			l_class := a_reflection.root_object.dynamic_type
			append_text ("indexing%N")
			append_text ("%Tdescription: %"Objects used for running tests%"%N")
			append_text ("%Tcdd_cluster: %"" + l_class.cluster.cluster_name + "%"%N")
			append_text ("%Tcdd_class: %"" + l_class.name_in_upper + "%"%N")
			append_text ("%Tcdd_feature: %"" + a_name + "%"%N")
			append_text ("%Tauthor: %"CDD_TEST_CASE_PRINTER%"%N")
			append_text ("%Tdate: %"$Date$%"%N")
			append_text ("%Trevision: %"$Revision$%"%N%N")
		end

	append_class_header (test_class_name: STRING) is
			-- Append class header text for 'test_class_name'
		require
			test_class_name_not_void: test_class_name /= Void
		do
			append_text ("class%N%T" + test_class_name + "%N%N")
			append_text ("inherit%N%TCDD_SHARED_TESTING%N%N")
			append_text ("feature -- Testing%N%N")
		end

	append_class_footer (test_class_name: STRING) is
			-- Append class footer for test_class_name.
		require
			test_class_name_not_void: test_class_name /= Void
		do
			append_text ("%N%Nend -- " + test_class_name + "%N%N")
		end

end
