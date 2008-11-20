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
			create expression_writer.make (name_mapper)
		end

feature -- Basic operations

	write_feature_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature'.
		local
			l_procedure_name, l_argument_name: STRING
			i: INTEGER
			l_argument_type: TYPE_A
			l_byte_code: BYTE_CODE
		do
			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.procedural_feature_name (a_feature)

			put_comment_line ("Signature")

			put ("procedure " + l_procedure_name + "(")
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

			put_line ("modifies Heap;")

			if body_server.has (a_feature.code_id) then
				l_byte_code := byte_server.item (a_feature.code_id)
				if l_byte_code.precondition /= Void then
					write_preconditions (l_byte_code.precondition)
				end
				if l_byte_code.postcondition /= Void then
					write_postconditions (l_byte_code.postcondition)
				end
			end

			-- TODO: generate invariants

			environment.output_buffer.set_indentation ("")
			put_new_line
		end

	write_creation_routine_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature' as a creation routine.
		do
			-- TODO
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
			put ("    free ensures (")
			put (l_function_name)
			put ("(Heap, Current) == Result%N")
			put_new_line
		end

feature {NONE} -- Implementation

	expression_writer: !EP_EXPRESSION_WRITER
			-- TODO

	name_mapper: !EP_NORMAL_NAME_MAPPER
			-- TODO

	write_preconditions (a_preconditions: ASSERTION_BYTE_CODE)
			-- Write Boogie code for preconditions of `a_feature'.
		require
			a_preconditions_not_void: a_preconditions /= Void
		local
			l_assertion: ASSERT_B
		do
			put_comment_line ("User preconditions")
			from
				a_preconditions.start
			until
				a_preconditions.after
			loop
				l_assertion ?= a_preconditions.item_for_iteration

				put_indentation
				put ("requires ")
				write_assertion (l_assertion)
				put (";%N")

				a_preconditions.forth
			end
		end

	write_postconditions (a_postconditions: ASSERTION_BYTE_CODE)
			-- Write Boogie code for postconditions of `a_feature'.
		require
			a_postconditions_not_void: a_postconditions /= Void
		local
			l_assertion: ASSERT_B
		do
			put_comment_line ("User postconditions")
			from
				a_postconditions.start
			until
				a_postconditions.after
			loop
				l_assertion ?= a_postconditions.item_for_iteration

				put_indentation
				put ("ensures ")
				write_assertion (l_assertion)
				put (";%N")

				a_postconditions.forth
			end
		end

	write_assertion (a_assertion: ASSERT_B)
			-- Write Boogie code for assertion `a_assertion'.
		do
			expression_writer.reset
			a_assertion.expr.process (expression_writer)
			put (expression_writer.expression.string)
		end

end
