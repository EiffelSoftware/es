indexing
	description: "Summary description for {JS_SOOT_CODE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_JIMPLE_GENERATOR

inherit
	ANY
		redefine default_create end

	SHARED_SERVER
		export
			{NONE} all
		undefine
			default_create
		end

	SHARED_BYTE_CONTEXT
		export
			{NONE} all
		undefine
			default_create
		end

	JS_HELPER_ROUTINES
		export
			{NONE} all
		undefine
			default_create
		end

create
	default_create

feature

	default_create
		do
			create output.make
			create instruction_writer.make
		end

	process_class (c: !CLASS_C)
		local
			abstract_clause: STRING
			extends_clause: STRING
			parent_classes: FIXED_LIST [CLASS_C]
			parent_class: CLASS_C
		do
			output.reset

			if c.is_deferred then
				abstract_clause := "abstract "
			else
				abstract_clause := ""
			end

			-- TODO: Be explicit in error messages about which inheritance constructs are handled and which not.
			-- At the moment, non-conforming inheritance, renaming and replication are not handled.
			extends_clause := ""
			from
				parent_classes := c.conforming_parents_classes
				parent_classes.start
			until
				parent_classes.off
			loop
				if not extends_clause.is_empty then
					extends_clause := extends_clause + ", "
				end
				extends_clause := extends_clause + parent_classes.item.name_in_upper
				parent_classes.forth
			end
			if not extends_clause.is_empty then
				extends_clause := "extends " + extends_clause + " "
			end

			output.put_line (abstract_clause + "class " + c.name_in_upper + " " + extends_clause + "{")
			output.put_new_line

			output.indent

			-- Process the attributes
			if c.has_feature_table then
				process_attributes (c)
			end

			output.put_new_line

			-- Process the creation routines
			if c.creators /= Void then
				process_creation_routines (c)
			end

			-- Process the normal routines
			if c.has_feature_table then
				process_normal_routines (c)
			end

			output.unindent

			output.put_line ("}")
		end

	jimple_code: !STRING
		do
			Result := output.string
		end

feature {NONE}

	output: !JS_OUTPUT_BUFFER
			-- Output buffer to store generated code

	instruction_writer: !JS_JIMPLE_INSTRUCTION_GENERATOR

	process_attributes (a_class: !CLASS_C)
		require
			has_feature_table: a_class.has_feature_table
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			from
				a_class.feature_table.start
			until
				a_class.feature_table.after
			loop
				l_feature := a_class.feature_table.item_for_iteration
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Only write attributes which are written in that class
				if l_feature.is_attribute and then l_feature.written_in = a_class.class_id then
					process_attribute (l_attached_feature)
				end

				a_class.feature_table.forth
			end
		end

	process_attribute (a_feature: !FEATURE_I)
		require
			is_attribute: a_feature.is_attribute
		do
			output.put_line (type_string (a_feature.type) + " " + a_feature.feature_name + ";")
		end

	process_creation_routines (a_class: !CLASS_C)
			-- Process creation routines of class `a_class'.
		require
			creators_not_void: a_class.creators /= Void
		local
			l_creator_name: STRING
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			from
				a_class.creators.start
			until
				a_class.creators.after
			loop
				l_creator_name := a_class.creators.key_for_iteration

				l_feature := a_class.feature_named (l_creator_name)
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Check if creation routine is not yet generated. This can happen if a subclass
					-- uses the same feature as a creation routine as the parent.
				--if not feature_list.is_creation_routine_already_generated (l_attached_feature) then
					process_routine (True, l_attached_feature, a_class)
				--end

				a_class.creators.forth

			end
		end

	process_normal_routines (a_class: !CLASS_C)
		require
			has_feature_table: a_class.has_feature_table
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
		do
			from
				a_class.feature_table.start
			until
				a_class.feature_table.after
			loop
				l_feature := a_class.feature_table.item_for_iteration
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Only write routines which are written in that class, and that are not creation routines
				if l_feature.is_routine and then l_feature.written_in = a_class.class_id then
					if (a_class.creators = Void) or else (not a_class.creators.has_key (l_feature.feature_name)) then
						process_routine (False, l_attached_feature, a_class)
					end
				end

				a_class.feature_table.forth
			end
		end

	process_routine (as_creation_routine: BOOLEAN; a_feature: !FEATURE_I; a_class: !CLASS_C)
			-- Generate code for creation routine `a_feature'.
		local
			l_argument_name, l_argument_type: STRING
			at_least_one_arg: BOOLEAN
			l_ensures_clause_expression_writer: JS_JIMPLE_EXPRESSION_GENERATOR
		do
			-- First do the signature
			output.put_indentation
			if a_feature.is_deferred then
				output.put ("abstract ")
			end
			output.put (routine_signature (as_creation_routine, a_feature))
			output.put_new_line

			process_require_clauses (a_feature)

			l_ensures_clause_expression_writer := process_old_expressions (a_feature)
			process_ensure_clauses (a_feature, l_ensures_clause_expression_writer)

			if not a_feature.is_deferred then
				-- Print the opening brace
				output.put_line ("{")
				output.indent

				process_routine_body (as_creation_routine, a_feature, a_class)

				output.unindent
				-- Finally print the closing brace
				output.put_line ("}")
			else
				output.put_line (";")
			end

			output.put_new_line
		end


	process_require_clauses (a_feature: !FEATURE_I)
		local
			l_byte_code: BYTE_CODE
		do
			if has_requires_clause (a_feature) then
				output.put_line ("requires {")
				output.indent

				l_byte_code := byte_server.item (a_feature.body_index)

				build_instructions_for_require_clauses (a_feature)

				output.put_comment_line ("Declaration of registers and temporaries")
				declare_registers (l_byte_code, a_feature)

				declare_temporaries (instruction_writer.temporaries)
				output.put_new_line

				output.put_comment_line ("Initialization of registers")
				initialize_registers (l_byte_code, a_feature)
				output.put_new_line

				output.put_comment_line ("The meat of the requires clauses")
				output.append_lines (instruction_writer.output_instructions)

				output.unindent
				output.put_line ("}")
			end
		end

	process_ensure_clauses (a_feature: !FEATURE_I; a_ensures_clause_expression_writer: JS_JIMPLE_EXPRESSION_GENERATOR)
		local
			l_byte_code: BYTE_CODE
		do
			if has_ensures_clause (a_feature) then
				output.put_line ("ensures {")
				output.indent

				l_byte_code := byte_server.item (a_feature.body_index)

				build_instructions_for_ensure_clauses (a_feature, a_ensures_clause_expression_writer)

				output.put_comment_line ("Declaration of registers and temporaries")
				declare_registers (l_byte_code, a_feature)

				declare_temporaries (instruction_writer.temporaries)
				output.put_new_line

				output.put_comment_line ("Initialization of registers")
				initialize_registers (l_byte_code, a_feature)
				output.put_new_line

				output.put_comment_line ("The meat of the ensures clauses")
				output.append_lines (instruction_writer.output_instructions)

				output.unindent
				output.put_line ("}")
			end
		end

	build_instructions_for_ensure_clauses (a_feature: !FEATURE_I; a_ensures_clause_expression_writer: JS_JIMPLE_EXPRESSION_GENERATOR)
		local
			l_byte_code: BYTE_CODE
			last_clause_set_result: STRING
			l_postcondition_clauses: ASSERTION_BYTE_CODE
			l_inherited_assertion: INHERITED_ASSERTION
			l_expression_writer: JS_JIMPLE_EXPRESSION_GENERATOR
			l_false_label, l_end_label: STRING
		do
			l_byte_code := byte_server.item (a_feature.body_index)
				-- Set up byte context
			Context.clear_feature_data
			Context.clear_class_type_data
			Context.init (a_feature.written_class.types.first)
			Context.set_current_feature (a_feature)
			Context.set_byte_code (l_byte_code)
			l_byte_code.setup_local_variables (False)

			instruction_writer.reset
			instruction_writer.set_feature (a_feature)
			instruction_writer.create_new_label ("false")
			l_false_label := instruction_writer.last_label
			instruction_writer.create_new_label ("end")
			l_end_label := instruction_writer.last_label

			l_expression_writer := a_ensures_clause_expression_writer

			if a_feature.has_postcondition then
				l_postcondition_clauses := l_byte_code.postcondition
				last_clause_set_result := build_instructions_for_conjoined_assertion_clauses (l_postcondition_clauses, l_expression_writer)
				instruction_writer.output.put_line ("if " + last_clause_set_result + " == 0 goto " + l_false_label + ";")
			end

			if a_feature.assert_id_set /= Void and then not a_feature.assert_id_set.is_empty then
				l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
				l_inherited_assertion := Context.inherited_assertion
				from
					l_inherited_assertion.postcondition_start
				until
					l_inherited_assertion.postcondition_after
				loop
					l_postcondition_clauses := l_inherited_assertion.postcondition_list.item_for_iteration

					last_clause_set_result := build_instructions_for_conjoined_assertion_clauses (l_postcondition_clauses, l_expression_writer)
					instruction_writer.output.put_line ("if " + last_clause_set_result + " == 0 goto " + l_false_label + ";")

					l_inherited_assertion.precondition_forth
				end
			end

			instruction_writer.temporaries.append (l_expression_writer.temporaries)
			instruction_writer.temporaries.extend (["$res","int"])
			instruction_writer.output.put_line ("$res = 1;")
			instruction_writer.output.put_line ("goto " + l_end_label + ";")
			instruction_writer.output.put_line (l_false_label.twin + ":")
			instruction_writer.output.put_line ("$res = 0;")
			instruction_writer.output.put_line (l_end_label.twin + ":")
		end

	process_old_expressions (a_feature: !FEATURE_I): JS_JIMPLE_EXPRESSION_GENERATOR
		local
			l_byte_code: BYTE_CODE
			l_postcondition_clauses: ASSERTION_BYTE_CODE
			l_inherited_assertion: INHERITED_ASSERTION
			l_expression_writer: JS_JIMPLE_EXPRESSION_GENERATOR
			l_old_clause_generator: JS_JIMPLE_OLD_CLAUSE_GENERATOR
			l_old_expression_side_effects: LINKED_LIST [!JS_OUTPUT_BUFFER]
		do
			l_byte_code := byte_server.item (a_feature.body_index)
				-- Set up byte context
			Context.clear_feature_data
			Context.clear_class_type_data
			Context.init (a_feature.written_class.types.first)
			Context.set_current_feature (a_feature)
			Context.set_byte_code (l_byte_code)
			l_byte_code.setup_local_variables (False)

			-- It's extremely important that we do the instatiate l_expression_writer to a JS_JIMPLE_ENSURE_CLAUSE_GENERATOR
			create {JS_JIMPLE_ENSURE_CLAUSE_GENERATOR} l_expression_writer.make (instruction_writer)
			create l_old_clause_generator.make (l_expression_writer)

			if a_feature.has_postcondition then
				l_postcondition_clauses := l_byte_code.postcondition
				process_old_expressions_in_conjoined_ensures_clauses (l_postcondition_clauses, l_old_clause_generator)
			end

			if a_feature.assert_id_set /= Void and then not a_feature.assert_id_set.is_empty then
				l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
				l_inherited_assertion := Context.inherited_assertion
				from
					l_inherited_assertion.postcondition_start
				until
					l_inherited_assertion.postcondition_after
				loop
					l_postcondition_clauses := l_inherited_assertion.postcondition_list.item_for_iteration
					process_old_expressions_in_conjoined_ensures_clauses (l_postcondition_clauses, l_old_clause_generator)
					l_inherited_assertion.postcondition_forth
				end
			end

			-- Loop through and print the old clauses.
			from
				l_old_expression_side_effects := l_old_clause_generator.old_expression_side_effects
				l_old_expression_side_effects.start
			until
				l_old_expression_side_effects.off
			loop
				output.put_line ("old {")
				output.indent

				output.put_comment_line ("Declaration of registers and temporaries")
				declare_registers (l_byte_code, a_feature)

				declare_temporaries (l_expression_writer.temporaries)
				output.put_new_line

				output.put_comment_line ("Initialization of registers")
				initialize_registers (l_byte_code, a_feature)
				output.put_new_line

				output.put_comment_line ("The meat of the old expression")
				output.append_lines (l_old_expression_side_effects.item.string)

				output.unindent
				output.put_line ("}")
				l_old_expression_side_effects.forth
			end

			Result := l_expression_writer
		end

	process_old_expressions_in_conjoined_ensures_clauses (a_postcondition_clauses: ASSERTION_BYTE_CODE; a_old_clause_generator: JS_JIMPLE_OLD_CLAUSE_GENERATOR)
		local
			l_postcondition_clause: ASSERT_B
		do
			from
				a_postcondition_clauses.start
			until
				a_postcondition_clauses.off
			loop
				l_postcondition_clause ?= a_postcondition_clauses.item_for_iteration
				check l_postcondition_clause /= Void end

				l_postcondition_clause.process (a_old_clause_generator)

				a_postcondition_clauses.forth
			end
		end

	build_instructions_for_require_clauses (a_feature: !FEATURE_I)
		local
			l_byte_code: BYTE_CODE
			last_clause_set_result: STRING
			l_precondition_clauses: ASSERTION_BYTE_CODE
			l_inherited_assertion: INHERITED_ASSERTION
			l_expression_writer: JS_JIMPLE_EXPRESSION_GENERATOR
			l_true_label, l_end_label: STRING
		do
			l_byte_code := byte_server.item (a_feature.body_index)
				-- Set up byte context
			Context.clear_feature_data
			Context.clear_class_type_data
			Context.init (a_feature.written_class.types.first)
			Context.set_current_feature (a_feature)
			Context.set_byte_code (l_byte_code)
			l_byte_code.setup_local_variables (False)

			instruction_writer.reset
			instruction_writer.set_feature (a_feature)
			instruction_writer.create_new_label ("true")
			l_true_label := instruction_writer.last_label
			instruction_writer.create_new_label ("end")
			l_end_label := instruction_writer.last_label

			create l_expression_writer.make (instruction_writer)

			if a_feature.has_precondition then
				l_precondition_clauses := l_byte_code.precondition
				last_clause_set_result := build_instructions_for_conjoined_assertion_clauses (l_precondition_clauses, l_expression_writer)
				instruction_writer.output.put_line ("if " + last_clause_set_result + " == 1 goto " + l_true_label + ";")
			end

			if a_feature.assert_id_set /= Void and then not a_feature.assert_id_set.is_empty then
				l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
				l_inherited_assertion := Context.inherited_assertion
				from
					l_inherited_assertion.precondition_start
				until
					l_inherited_assertion.precondition_after
				loop
					l_precondition_clauses := l_inherited_assertion.precondition_list.item_for_iteration

					last_clause_set_result := build_instructions_for_conjoined_assertion_clauses (l_precondition_clauses, l_expression_writer)
					instruction_writer.output.put_line ("if " + last_clause_set_result + " == 1 goto " + l_true_label + ";")

					l_inherited_assertion.precondition_forth
				end
			end

			instruction_writer.temporaries.append (l_expression_writer.temporaries)
			instruction_writer.temporaries.extend (["$res","int"])
			instruction_writer.output.put_line ("$res = 0;")
			instruction_writer.output.put_line ("goto " + l_end_label + ";")
			instruction_writer.output.put_line (l_true_label.twin + ":")
			instruction_writer.output.put_line ("$res = 1;")
			instruction_writer.output.put_line (l_end_label.twin + ":")
		end

	build_instructions_for_conjoined_assertion_clauses (a_assertion_clauses: ASSERTION_BYTE_CODE; a_expression_writer: JS_JIMPLE_EXPRESSION_GENERATOR): STRING
		local
			l_assertion_clause: ASSERT_B
			l_false_label, l_end_label: STRING
			l_temp_result: STRING
		do
			instruction_writer.create_new_label ("false")
			l_false_label := instruction_writer.last_label
			instruction_writer.create_new_label ("end")
			l_end_label := instruction_writer.last_label

			from
				a_assertion_clauses.start
			until
				a_assertion_clauses.off
			loop
				l_assertion_clause ?= a_assertion_clauses.item_for_iteration
				check l_assertion_clause /= Void end

				a_expression_writer.reset_expression_and_target_and_new_side_effect
				l_assertion_clause.process (a_expression_writer)

				instruction_writer.output.append_lines (a_expression_writer.side_effect_string)
				instruction_writer.output.put_line ("if " + a_expression_writer.expression_string + " == 0 goto " + l_false_label + ";")

				a_assertion_clauses.forth
			end

			a_expression_writer.create_new_temporary
			l_temp_result := a_expression_writer.last_temporary

			a_expression_writer.temporaries.extend ([l_temp_result,"int"])
			instruction_writer.output.put_line (l_temp_result.twin + " = 1;")
			instruction_writer.output.put_line ("goto " + l_end_label + ";")
			instruction_writer.output.put_line (l_false_label.twin + ":")
			instruction_writer.output.put_line (l_temp_result.twin + " = 0;")
			instruction_writer.output.put_line (l_end_label.twin + ":")

			Result := l_temp_result
		end


	process_routine_body (as_creation_routine: BOOLEAN; a_feature: !FEATURE_I; a_class: !CLASS_C)
		local
			l_byte_code: BYTE_CODE
			l_has_locals: BOOLEAN
			l_exception: JS_NOT_SUPPORTED_EXCEPTION
			t: TYPE_A
		do
			instruction_writer.reset
			instruction_writer.set_feature (a_feature)

			if byte_server.has (a_feature.body_index) then
				l_byte_code := byte_server.item (a_feature.body_index)

					-- Set up byte context
				Context.clear_feature_data
				Context.clear_class_type_data
				Context.init (a_feature.written_class.types.first)
				Context.set_current_feature (a_feature)
				Context.set_byte_code (l_byte_code)
				l_byte_code.setup_local_variables (False)

					-- Features with rescue clauses are skipped
					-- TODO: implement rescue clauses
				if l_byte_code.rescue_clause /= Void and then not l_byte_code.rescue_clause.is_empty then
					unsupported ("Rescue clauses")
				end

				if l_byte_code.compound /= Void and then not l_byte_code.compound.is_empty then
					l_byte_code.compound.process (instruction_writer)
				end
				l_has_locals := l_byte_code.local_count > 0
			end

			output.put_comment_line ("Declaration of registers, locals, and temporaries")
			declare_registers (l_byte_code, a_feature)
			if l_has_locals then
				declare_locals (l_byte_code)
			end
				-- Remember the result pseudolocal!
			t := a_feature.type.actual_type
			if not t.is_void then
				output.put_line (type_string (t) + " " + name_for_result + ";")
			end
			declare_temporaries (instruction_writer.temporaries)
			output.put_new_line

			output.put_comment_line ("Initialization of registers and locals")
				-- Initialize registers
			initialize_registers (l_byte_code, a_feature)

				-- Initialize local variables
			if l_has_locals then
				initialize_locals (l_byte_code)
			end
				-- Initialize result
			if not t.is_void then
				output.put_line (name_for_result + " = " + default_value (t) + ";")
			end
			output.put_new_line

			output.put_comment_line ("The routine body")
				-- Inject all ancestor attributes
			if as_creation_routine then
				inject_ancestor_attributes (a_class)
			end
				-- Feature body
			output.append_lines (instruction_writer.output_instructions)

			if not t.is_void then
				output.put_line ("return " + name_for_result + ";")
			else
				output.put_line ("return;")
			end
		end

	inject_ancestor_attributes (a_class: !CLASS_C)
		local
			l_feature: FEATURE_I
			l_attached_feature: !FEATURE_I
			pointstos: STRING
		do
			pointstos := ""
			from
				a_class.feature_table.start
			until
				a_class.feature_table.after
			loop
				l_feature := a_class.feature_table.item_for_iteration
				check l_feature /= Void end
				l_attached_feature := l_feature

					-- Only write attributes which are written in other classes
				if l_attached_feature.is_attribute and then l_attached_feature.written_in /= a_class.class_id then
					if not equal ("", pointstos) then
						pointstos := pointstos + " * "
					end
					pointstos := pointstos + "Current." + attr_designator (l_attached_feature) + " |-> _"
				end

				a_class.feature_table.forth
			end
			output.put_line ("{} : {} {" + pointstos + "};")
		end

	declare_registers (a_byte_code: BYTE_CODE; a_feature: !FEATURE_I)
		local
			i: INTEGER
			t: TYPE_A
		do
			t := a_feature.written_class.actual_type
			output.put_line (type_string(t) + " " + name_for_current + ";")
			if a_byte_code.arguments /= Void then
				from
					i := 1
				until
					i > a_byte_code.arguments.count
				loop
					t := a_byte_code.arguments.item (i).actual_type
					output.put_line (type_string(t) + " r" + i.out + ";")
					i := i + 1
				end
			end
		end

	initialize_registers (a_byte_code: BYTE_CODE; a_feature: !FEATURE_I)
		local
			i: INTEGER
			t: TYPE_A
		do
			t := a_feature.written_class.actual_type
			output.put_line (name_for_current + " := @this: " + type_string (t) + ";")
			if a_byte_code.arguments /= Void then
				from
					i := 1
				until
					i > a_byte_code.arguments.count
				loop
					t := a_byte_code.arguments.item (i).actual_type
					output.put_line ("r" + i.out + " := @parameter" + (i-1).out + ": " + type_string (t) + ";")
					i := i + 1
				end
			end
		end

	declare_locals (a_byte_code: BYTE_CODE)
			-- Write local declaration
		local
			i: INTEGER
			t: TYPE_A
		do
			from
				i := 1
			until
				i > a_byte_code.local_count
			loop
				t := a_byte_code.locals.item (i).actual_type
				output.put_line (type_string(t) + " l" + i.out + ";")
				i := i + 1
			end
		end

	initialize_locals (a_byte_code: BYTE_CODE)
		local
			i: INTEGER
			t: TYPE_A
		do
			from
				i := 1
			until
				i > a_byte_code.local_count
			loop
					-- TODO: support attached types
				t := a_byte_code.locals.item (i).actual_type
				output.put_line ("l" + i.out + " = " + default_value (t) + ";")
				i := i + 1
			end
		end

	declare_temporaries (temps: LIST [TUPLE [name: STRING; type: STRING]])
		local
			temp: TUPLE [name: STRING; type: STRING]
		do
			from
				temps.start
			until
				temps.after
			loop
				temp := temps.item
				output.put_line (temp.type + " " + temp.name + ";")
				temps.forth
			end
		end

	default_value (a_type: TYPE_A): STRING
			-- Default value for variable of type `a_type'
		do
			if a_type.is_integer or a_type.is_natural then
				Result := "0"
			elseif a_type.is_boolean then
				Result := "false"
			elseif a_type.is_expanded then
				Result := "UnknownValue!!!"
			else
				Result := "null"
			end
		end

	has_requires_clause (a_feature: !FEATURE_I): BOOLEAN
		local
			l_counter: INTEGER
			l_assert_info : INH_ASSERT_INFO
		do
			Result := a_feature.has_precondition
			if a_feature.assert_id_set /= Void then
				from
					l_counter := 1
				until
					l_counter > a_feature.assert_id_set.count
				loop
					l_assert_info := a_feature.assert_id_set.at (l_counter)
					Result := Result or l_assert_info.has_precondition
					l_counter := l_counter + 1
				end
			end
		end

	has_ensures_clause (a_feature: !FEATURE_I): BOOLEAN
		local
			l_counter: INTEGER
			l_assert_info : INH_ASSERT_INFO
		do
			Result := a_feature.has_postcondition
			if a_feature.assert_id_set /= Void then
				from
					l_counter := 1
				until
					l_counter > a_feature.assert_id_set.count
				loop
					l_assert_info := a_feature.assert_id_set.at (l_counter)
					Result := Result or l_assert_info.has_postcondition
					l_counter := l_counter + 1
				end
			end
		end

end

