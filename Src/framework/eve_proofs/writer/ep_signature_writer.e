indexing
	description:
		"[
			Boogie code writer to generate feature signatures
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_SIGNATURE_WRITER

inherit

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
			-- Initialize signature writer.
		do
			create name_mapper.make
			create expression_writer.make (name_mapper, create {EP_OLD_KEYWORD_HANDLER})
			create contract_writer.make
			contract_writer.set_expression_writer (expression_writer)
			create frame_extractor.make
			create output.make
		end

feature -- Access

	output: !EP_OUTPUT_BUFFER
			-- TODO

feature -- Basic operations

	write_feature_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature'.
		local
			l_procedure_name: STRING
		do
			output.reset

			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.procedural_feature_name (a_feature)

			write_procedure_definition (a_feature, l_procedure_name, False)

			output.set_indentation ("    ")

			output.put_comment_line ("Frame condition")
			output.put_line ("modifies Heap;")
			frame_extractor.build_frame_condition (a_feature)
			output.put_line ("ensures " + frame_extractor.last_frame_condition + "; // frame " + a_feature.written_class.name_in_upper + ":" + a_feature.feature_name)

			output.set_indentation ("")
			output.put_new_line
		end

	write_creation_routine_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature' as a creation routine of class `a_class'.
		local
			l_procedure_name: STRING
		do
			output.reset

			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.creation_routine_name (a_feature)

			write_procedure_definition (a_feature, l_procedure_name, True)

			output.set_indentation ("    ")

			output.put_comment_line ("Frame condition")

			-- TODO: Generate real frame condition
			output.put_line ("modifies Heap;")
			frame_extractor.build_frame_condition (a_feature)
			output.put_line ("ensures " + frame_extractor.last_frame_condition + "; // frame " + a_feature.written_class.name_in_upper + ":" + a_feature.feature_name)

			output.put_comment_line ("Creation routine condition")
			output.put_line ("free ensures Heap[Current, $allocated];")

			output.set_indentation ("")
			output.put_new_line
		end

feature {NONE} -- Implementation

	expression_writer: !EP_EXPRESSION_WRITER
			-- Expression writer used for the contract writer

	contract_writer: !EP_CONTRACT_WRITER
			-- Contract writer used to generate Boogie code

	frame_extractor: !EP_FRAME_EXTRACTOR
			-- Frame extractor to generate frame condition

	name_mapper: !EP_NORMAL_NAME_MAPPER
			-- Name mapper used for the expression writer

	write_procedure_definition (a_feature: !FEATURE_I; a_procedure_name: STRING; a_is_creation_routine: BOOLEAN)
			-- Write procedure definition of feature `a_feature_name'
			-- using `a_procedure_name' for the Boogie name.
		local
			l_argument_name: STRING
			i: INTEGER
			l_argument_type: TYPE_A
		do
			output.put_comment_line ("Signature")

			output.put ("procedure " + a_procedure_name + "(")
			if a_feature.argument_count = 0 then
				output.put ("Current: ref where Current != Void && Heap[Current, $allocated]")
			else
				output.put ("%N")
				output.put ("            Current: ref where Current != Void && Heap[Current, $allocated]")

				from
					i := 1
				until
					i > a_feature.argument_count
				loop
					l_argument_name :=  name_generator.argument_name (a_feature.arguments.item_name (i))
					l_argument_type := a_feature.arguments.i_th (i)

					output.put (",%N")
					output.put ("            " + l_argument_name + ": " + type_mapper.boogie_type_for_type (l_argument_type))
					if not l_argument_type.is_expanded then
						if l_argument_type.is_attached then
							output.put (" where IsAllocatedAndNotVoid(Heap, " + l_argument_name + ")")
						else
							output.put (" where IsAllocatedIfNotVoid(Heap, " + l_argument_name + ")")
						end
					end

					i := i + 1
				end
				output.put ("%N        ")
			end

			output.put (")")
			if a_feature.has_return_value then
				output.put (" returns (Result: " + type_mapper.boogie_type_for_type (a_feature.type) + ")")
			end
			output.put (";%N")

			output.set_indentation ("    ")

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.generate_contracts

			if not contract_writer.preconditions.is_empty then
				write_preconditions
			end
			if not contract_writer.postconditions.is_empty then
				write_postconditions
			end

				-- Invariants are generated for creation routines and public features,
				-- i.e. features exported to more than the current class
				-- TODO: this check won't work for half-public features, i.e features
				-- exported to multiple classes: {A, B, C} in class A should be considered public
			if
				a_is_creation_routine or else
				a_feature.export_status.is_all
			then
				if not contract_writer.invariants.is_empty then
					write_invariants (a_is_creation_routine)
				end
			end

			output.set_indentation ("")
		end

	write_preconditions
			-- Write Boogie code for preconditions from `contract_writer'.
		local
			l_item: TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]
		do
			output.put_comment_line ("User preconditions")
			if contract_writer.has_weakened_preconditions then
					-- Write combined precondition
				output.put_line ("requires " + contract_writer.full_precondition + "; // pre DUMMY:combined")
			else
					-- Write individual preconditions
				from
					contract_writer.preconditions.start
				until
					contract_writer.preconditions.after
				loop
					l_item := contract_writer.preconditions.item
					output.put_indentation
					output.put ("requires ")
					output.put (l_item.expression)
					output.put ("; // ")
					output.put (assert_location ("pre", l_item))
					output.put_new_line

					contract_writer.preconditions.forth
				end
			end
		end

	write_postconditions
			-- Write Boogie code for postconditions from `contract_writer'.
		local
			l_item: TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]
		do
			output.put_comment_line ("User postconditions")
				-- Write individual preconditions
			from
				contract_writer.postconditions.start
			until
				contract_writer.postconditions.after
			loop
				l_item := contract_writer.postconditions.item
				output.put_indentation
				output.put ("ensures ")
				output.put (l_item.expression)
				output.put ("; // ")
				output.put (assert_location ("post", l_item))
				output.put_new_line

				contract_writer.postconditions.forth
			end
		end

	write_invariants (a_is_creation_routine: BOOLEAN)
			-- Write Boogie code for postconditions from `contract_writer'.
		local
			l_item: TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]
		do
			if a_is_creation_routine then
				output.put_comment_line ("User invariants (entry) ommited")
			else
				output.put_comment_line ("User invariants (entry)")
				from
					contract_writer.invariants.start
				until
					contract_writer.invariants.after
				loop
					l_item := contract_writer.invariants.item
					output.put_indentation
					output.put ("free requires ")
					output.put (l_item.expression)
					output.put ("; // ")
					output.put (assert_location ("inv", l_item))
					output.put_new_line

					contract_writer.invariants.forth
				end
			end
			output.put_comment_line ("User invariants (exit)")
			from
				contract_writer.invariants.start
			until
				contract_writer.invariants.after
			loop
				l_item := contract_writer.invariants.item
				output.put_indentation
				output.put ("ensures ")
				output.put (l_item.expression)
				output.put ("; // ")
				output.put (assert_location ("inv", l_item))
				output.put_new_line

				contract_writer.invariants.forth
			end
		end

-- TODO: this is some code duplication from {EP_INSTRUCTION_WRITER}
	assert_location (a_type: STRING; a_item: TUPLE [tag: STRING; expression: !STRING; class_id: INTEGER; line_number: INTEGER]): STRING
			-- Location of `a_assert'
		require
			a_type_not_void: a_type /= Void
			a_item_not_void: a_item /= Void
		do
			Result := a_type.twin
			Result.append (" ")
			Result.append (system.class_of_id (a_item.class_id).name_in_upper)
			Result.append (":")
			Result.append (a_item.line_number.out)
			if a_item.tag /= Void then
				Result.append (" tag:")
				Result.append (a_item.tag)
			end
		end

end
