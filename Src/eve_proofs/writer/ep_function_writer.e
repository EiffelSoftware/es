indexing
	description:
		"[
			Boogie code writer to generate functions
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FUNCTION_WRITER

inherit {NONE}

	SHARED_EP_ENVIRONMENT
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
			create expression_writer.make (name_mapper, create {EP_INVALID_OLD_HANDLER}.make)
			create contract_writer.make
		end

feature -- Basic operations

	write_functional_representation (a_feature: !FEATURE_I)
			-- TODO
		require
			is_query: not a_feature.type.is_void
		local
			l_function_name, l_arguments, l_type: STRING
			l_argument_name, l_full_function: STRING
			i: INTEGER
		do
			l_function_name := name_generator.functional_feature_name (a_feature)
			l_full_function := l_function_name.twin
			l_arguments := "heap: [ref, <x>name]x, current: ref"
			l_full_function.append ("(heap, current")
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				l_argument_name := name_generator.argument_name (a_feature.arguments.item_name (i))
				l_arguments.append (", ")
				l_arguments.append (l_argument_name)
				l_arguments.append (": ")
				l_arguments.append (type_mapper.boogie_type_for_type (a_feature.arguments.i_th (i)))

				l_full_function.append (", ")
				l_full_function.append (l_argument_name)

				i := i + 1
			end
			l_full_function.append (")")
			l_type := type_mapper.boogie_type_for_type (a_feature.type)

			put_comment_line ("Functional representation of query")
			put_line ("function " + l_function_name + "(" + l_arguments + ") returns (" + l_type + ");")

			name_mapper.set_current_feature (a_feature)
			name_mapper.set_current_name ("current")
			name_mapper.set_target_name ("current")
			name_mapper.set_heap_name ("heap")
			name_mapper.set_result_name (l_full_function)

			expression_writer.reset

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.set_expression_writer (expression_writer)
			contract_writer.generate_contracts

			put_line ("axiom (forall " + l_arguments + " ::")
			put_line ("             { " + l_full_function + " } // Trigger")
			put_line ("        (" + contract_writer.full_precondition + ") ==> (" + contract_writer.full_postcondition + "));")

			put_new_line
		end

feature {NONE} -- Implementation

	name_mapper: !EP_NORMAL_NAME_MAPPER
			-- TODO

	expression_writer: !EP_EXPRESSION_WRITER
			-- TODO

	contract_writer: !EP_CONTRACT_WRITER
			-- TODO

end
