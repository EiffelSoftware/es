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

			parent_classes := c.conforming_parents_classes
			extends_clause := ""
			if parent_classes.count > 1 then
				-- TODO: Multiple inheritance
				unsupported ("Multiple inheritance")
			elseif parent_classes.count = 1 then
				parent_class := parent_classes.at (1)
				extends_clause := "extends " + parent_class.name_in_upper + " "
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
					process_routine (True, l_attached_feature)
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
						process_routine (False, l_attached_feature)
					end
				end

				a_class.feature_table.forth
			end
		end

	process_routine (as_creation_routine: BOOLEAN; a_feature: !FEATURE_I)
			-- Generate code for creation routine `a_feature'.
		local
			l_argument_name, l_argument_type: STRING
			at_least_one_arg: BOOLEAN
		do
			-- First do the signature
			output.put_indentation
			if a_feature.is_deferred then
				output.put ("abstract ")
			end
			output.put (routine_signature (as_creation_routine, a_feature))
			output.put_new_line

			if not a_feature.is_deferred then
				-- Now print the opening brace
				output.put_line ("{")
				output.indent

				process_routine_body (a_feature)

				output.unindent
				-- Finally print the closing brace
				output.put_line ("}")
			else
				output.put_line (";")
			end

			output.put_new_line
		end

	process_routine_body (a_feature: !FEATURE_I)
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
			declare_temporaries
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
				-- Feature body
			output.append_lines (instruction_writer.output_instructions)

			if not t.is_void then
				output.put_line ("return " + name_for_result + ";")
			else
				output.put_line ("return;")
			end
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

	declare_temporaries
		local
			temp: TUPLE [name: STRING; type: STRING]
		do
			from
				instruction_writer.temporaries.start
			until
				instruction_writer.temporaries.after
			loop
				temp := instruction_writer.temporaries.item
				output.put_line (temp.type + " " + temp.name + ";")
				instruction_writer.temporaries.forth
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

end

