indexing
	description:
		"[
			Boogie code writer to generate feature signatures
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_SIGNATURE_WRITER

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do
			create name_mapper.make
			create expression_writer.make (name_mapper, create {EP_OLD_KEYWORD_HANDLER}.make)
			create contract_writer.make
			contract_writer.set_expression_writer (expression_writer)
		end

feature -- Basic operations

	write_feature_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature'.
		local
			l_procedure_name: STRING
		do
			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.procedural_feature_name (a_feature)

			write_procedure_definition (a_feature, l_procedure_name)

			environment.output_buffer.set_indentation ("    ")

			put_comment_line ("Frame condition")
			put_line ("modifies Heap;")

			environment.output_buffer.set_indentation ("")
			put_new_line
		end

	write_creation_routine_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature' as a creation routine.
		local
			l_procedure_name: STRING
		do
			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.creation_routine_name (a_feature)

			write_procedure_definition (a_feature, l_procedure_name)

			environment.output_buffer.set_indentation ("    ")

			put_comment_line ("Frame condition")
			put_line ("modifies Heap;")
			put_comment_line ("Creation routine condition")
			put_line ("free ensures Heap[Current, $allocated];")

			environment.output_buffer.set_indentation ("")
			put_new_line
		end

	write_attribute_signature (a_feature: !FEATURE_I)
			-- TODO
		require
			is_attribute: a_feature.is_attribute
		local
			l_procedure_name, l_function_name: STRING
		do
			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.procedural_feature_name (a_feature)
			l_function_name := name_generator.functional_feature_name (a_feature)

			put_comment_line ("Signature")

			put ("procedure ")
			put (l_procedure_name)
			put ("(Current: ref where Current != null && Heap[Current, $allocated]) returns (Result:")
			put (type_mapper.boogie_type_for_type (a_feature.type))
			put (");%N")
			put ("    free ensures ")
			put (l_function_name)
			put ("(Heap, Current) == Result;%N")
			put_new_line
		end

feature {NONE} -- Implementation

	expression_writer: !EP_EXPRESSION_WRITER
			-- TODO

	contract_writer: !EP_CONTRACT_WRITER
			-- TODO

	name_mapper: !EP_NORMAL_NAME_MAPPER
			-- TODO

	write_procedure_definition (a_feature: !FEATURE_I; a_procedure_name: STRING)
			-- TODO
		local
			l_argument_name: STRING
			i: INTEGER
			l_argument_type: TYPE_A
		do
			put_comment_line ("Signature")

			put ("procedure " + a_procedure_name + "(")
			if a_feature.argument_count = 0 then
				put ("Current: ref where Current != null && Heap[Current, $allocated]")
			else
				put ("%N")
				put ("            Current: ref where Current != null && Heap[Current, $allocated]")

				from
					i := 1
				until
					i > a_feature.argument_count
				loop
					l_argument_name :=  name_generator.argument_name (a_feature.arguments.item_name (i))
					l_argument_type := a_feature.arguments.i_th (i)

					put (",%N")
					put ("            " + l_argument_name + ": " + type_mapper.boogie_type_for_type (l_argument_type))
					if not l_argument_type.is_expanded then
						if l_argument_type.is_attached then
							put (" where " + l_argument_name + " != null && Heap[" + l_argument_name + ", $allocated]")
						else
							put (" where " + l_argument_name + " != null ==> Heap[" + l_argument_name + ", $allocated]")
						end
					end

					i := i + 1
				end
				put ("%N        ")
			end

			put (")")
			if not a_feature.type.is_void then
				put (" returns (Result: " + type_mapper.boogie_type_for_type (a_feature.type) + ")")
			end
			put (";%N")

			environment.output_buffer.set_indentation ("    ")

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.generate_contracts

			if not contract_writer.preconditions.is_empty then
				write_preconditions
			end
			if not contract_writer.postconditions.is_empty then
				write_postconditions
			end

			-- TODO: generate invariants

			environment.output_buffer.set_indentation ("")
		end

	write_preconditions
			-- Write Boogie code for preconditions from `contract_writer'.
		local
			l_item: TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]
		do
			put_comment_line ("User preconditions")
			if contract_writer.has_weakened_preconditions then
					-- Write combined precondition
				put_line ("requires " + contract_writer.full_precondition + "; // combined precondition")
			else
					-- Write individual preconditions
				from
					contract_writer.preconditions.start
				until
					contract_writer.preconditions.after
				loop
					l_item := contract_writer.preconditions.item
					put_indentation
					put ("requires ")
					put (l_item.expression)
					put ("; //")
					if l_item.tag /= Void then
						put (" tag:" + l_item.tag)
					end
					put (" class:" + system.class_of_id (l_item.class_id).name_in_upper + ":" + l_item.line_number.out)
					put ("%N")

					contract_writer.preconditions.forth
				end
			end
		end

	write_postconditions
			-- Write Boogie code for postconditions from `contract_writer'.
		local
			l_item: TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]
		do
			put_comment_line ("User postconditions")
				-- Write individual preconditions
			from
				contract_writer.postconditions.start
			until
				contract_writer.postconditions.after
			loop
				l_item := contract_writer.postconditions.item
				put_indentation
				put ("ensures ")
				put (l_item.expression)
				put ("; //")
				if l_item.tag /= Void then
					put (" tag:" + l_item.tag)
				end
				put (" class:" + system.class_of_id (l_item.class_id).name_in_upper + ":" + l_item.line_number.out)
				put ("%N")

				contract_writer.postconditions.forth
			end
		end

end
