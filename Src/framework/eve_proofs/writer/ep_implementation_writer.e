indexing
	description:
		"[
			Boogie code writer to generate feature implementations
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_IMPLEMENTATION_WRITER

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	EP_DEFAULT_NAMES
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize implementation writer.
		do
			create instruction_writer.make
		end

feature -- Basic operations

	write_feature_implementation (a_feature: !FEATURE_I; is_creation_routine: BOOLEAN)
			-- Write Boogie code for implementation of `a_feature'.
		local
			l_procedure_name, l_argument_name: STRING
			i: INTEGER
			l_argument_type: TYPE_A
			l_byte_code: BYTE_CODE
			l_has_locals: BOOLEAN
		do
			if is_creation_routine then
				l_procedure_name := creation_routine_name (a_feature)
			else
				l_procedure_name := procedural_feature_name (a_feature)
			end

			put_comment_line ("Implementation")

			-- TODO: code reuse with signature writer => inherit from signature writer?

			put ("implementation " + l_procedure_name + "(Current: ref")
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				l_argument_name := name_generator.argument_name (a_feature.arguments.item_name (i))
				l_argument_type := a_feature.arguments.i_th (i)
				put (", " + l_argument_name + ": " + type_mapper.boogie_type_for_type (l_argument_type))
				i := i + 1
			end
			put (")")
			if not a_feature.type.is_void then
				put (" returns (Result: " + type_mapper.boogie_type_for_type (a_feature.type) + ")")
			end
			put ("%N")

			instruction_writer.reset
			instruction_writer.set_current_feature (a_feature)

			put_line ("{")
			environment.output_buffer.set_indentation ("    ")

			if byte_server.has (a_feature.body_index) then
				l_byte_code := byte_server.item (a_feature.body_index)

					-- Set up byte context
				Context.clear_feature_data
				Context.clear_class_type_data
				Context.init (a_feature.written_class.types.first)
				Context.set_current_feature (a_feature)
				Context.set_byte_code (l_byte_code)
				l_byte_code.setup_local_variables (False)

				if l_byte_code.compound /= Void and then not l_byte_code.compound.is_empty then
					l_byte_code.compound.process (instruction_writer)
				end
				l_has_locals := l_byte_code.local_count > 0
			end

			if l_has_locals then
				write_locals (l_byte_code)
			end
			write_temproary_locals

			put ("  entry:%N")

				-- Initialize local variables
			if l_has_locals then
				put_comment_line ("Initialization of locals")
				write_locals_initialization (l_byte_code)
			end

				-- Initialize result
			if not a_feature.type.is_void then
				put_comment_line ("Initialization of result")
				put_line ("Result := " + default_value (a_feature.type) + ";")
			end

				-- Feature body
			put (instruction_writer.output.string)

			put_line ("return;")

			environment.output_buffer.set_indentation ("")
			put_line ("}")
		end

feature {NONE} -- Implementation

	instruction_writer: !EP_INSTRUCTION_WRITER
			-- Writer to transform instructions to Boogie code

	write_locals (a_byte_code: BYTE_CODE)
			-- Write local declaration
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_byte_code.local_count
			loop
				if i = 1 then
					put ("  var ")
				else
					put (", ")
				end
				put (name_generator.local_name (i) + ": ")
				put (type_mapper.boogie_type_for_type (a_byte_code.locals.item (i).actual_type))
				i := i + 1
				if i > a_byte_code.local_count then
					put (";%N")
				end
			end
		end

	write_temproary_locals
			-- Write temporary locals
		do
			from
				instruction_writer.locals.start
			until
				instruction_writer.locals.after
			loop
				if instruction_writer.locals.index = 1 then
					put ("  var ")
				else
					put (", ")
				end
				put (instruction_writer.locals.item.name + ": ")
				put (instruction_writer.locals.item.type)
				instruction_writer.locals.forth
				if instruction_writer.locals.after then
					put (";%N")
				end
			end
			put_new_line
		end

	write_locals_initialization (a_byte_code: BYTE_CODE)
			-- Write locals initialization
		local
			i: INTEGER
			l_type: TYPE_A
		do
			from
				i := 1
			until
				i > a_byte_code.local_count
			loop
				l_type := a_byte_code.locals.item (i).actual_type
				if l_type.is_attached and not l_type.is_expanded then
					put_line ("assume IsAllocatedAndNotVoid(Heap, " + name_generator.local_name (i) + ");")
				else
					put_line (name_generator.local_name (i) + " := " + default_value (a_byte_code.locals.item (i)) + ";")
				end
				i := i + 1
			end
		end

	default_value (a_type: TYPE_A): STRING
			-- Default value for variable of type `a_type'
		do
			if a_type.is_integer or a_type.is_natural or a_type.is_character then
				Result := "0"
			elseif a_type.is_boolean then
				Result := "false"
			else
				Result := "Void"
			end
		end

end
