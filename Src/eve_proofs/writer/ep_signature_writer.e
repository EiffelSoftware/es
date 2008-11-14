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

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do

		end

feature -- Basic operations

	write_feature_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature'.
		local
			l_procedure_name: STRING
			i: INTEGER
			l_argument_name: STRING
			l_argument_type: TYPE_A
		do
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

			write_preconditions (a_feature)

			put_line ("    modifies Heap;")

			write_postconditions (a_feature)

			-- TODO: generate invariants

			put_new_line
		end

	write_creation_routine_signature (a_feature: !FEATURE_I)
			-- Write Boogie code signature of `a_feature' as a creation routine.
		do
			-- TODO
		end

feature {NONE} -- Implementation

	expression_writer: EP_EXPRESSION_WRITER

	write_preconditions (a_feature: !FEATURE_I)
			-- Write Boogie code for preconditions of `a_feature'.
		local
			byte_code: BYTE_CODE
		do
			if body_server.has (a_feature.code_id) then
				byte_code := byte_server.item (a_feature.code_id)
				if byte_code.precondition /= Void then
				end
			end
		end

	write_postconditions (a_feature: !FEATURE_I)
			-- Write Boogie code for postconditions of `a_feature'.
		do

		end

end
