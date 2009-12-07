indexing
	description:
		"[
			Boogie code writer to generate functions
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FUNCTION_WRITER

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create

	make

feature {NONE} -- Initialization

	make
			-- Initialize function writer.
		do
			create name_mapper.make
			create expression_writer.make (name_mapper, create {EP_INVALID_OLD_HANDLER})
			create contract_writer.make
			create output.make
		end

feature -- Access

	output: !EP_OUTPUT_BUFFER
			-- TODO

feature -- Basic operations

	write_functional_representation (a_feature: !FEATURE_I)
			-- Write functional representation of `a_feature'.
		require
			is_query: not a_feature.type.is_void
		local
			l_function_name, l_arguments, l_type: STRING
			l_argument_name, l_full_function: STRING
			i: INTEGER
		do
			output.reset

			l_function_name := name_generator.functional_feature_name (a_feature)
			l_full_function := l_function_name.twin
			l_arguments := "heap: HeapType, current: ref"
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

			output.put_comment_line ("Functional representation of query")
			output.put_line ("function " + l_function_name + "(" + l_arguments + ") returns (" + l_type + ");")

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

			if contract_writer.is_generation_failed then
					-- TODO: improve message
				event_handler.add_proof_skipped_event (a_feature.written_class, a_feature, "(function axiom) " + contract_writer.fail_reason)
				output.put_comment_line ("Axiom ignored (skipped due to exception)")
			else
				output.put_line ("axiom (forall " + l_arguments + " ::")
				output.put_line ("             { " + l_full_function + " } // Trigger")
				output.put_line ("        (" + contract_writer.full_precondition + ") ==> (" + contract_writer.full_postcondition + "));")
			end

			output.put_new_line
		end

	write_generic_functional_representation (a_feature: !FEATURE_I; a_type: !TYPE_A)
			-- Write functional representation of `a_feature'.
		require
			is_query: not a_feature.type.is_void
		local
			l_function_name, l_arguments, l_type: STRING
			l_argument_name, l_full_function: STRING
			i: INTEGER
		do
			output.reset

			l_function_name := name_generator.generic_functional_feature_name (a_feature, a_type)
			l_full_function := l_function_name.twin
			l_arguments := "heap: HeapType, current: ref"
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
				l_arguments.append (type_mapper.generic_boogie_type_for_type (a_feature.arguments.i_th (i), a_type))

				l_full_function.append (", ")
				l_full_function.append (l_argument_name)

				i := i + 1
			end
			l_full_function.append (")")
			l_type := type_mapper.generic_boogie_type_for_type (a_feature.type, a_type)

			output.put_comment_line ("Functional representation of query")
			output.put_line ("function " + l_function_name + "(" + l_arguments + ") returns (" + l_type + ");")

			name_mapper.set_current_feature (a_feature)
			name_mapper.set_current_name ("current")
			name_mapper.set_target_name ("current")
			name_mapper.set_heap_name ("heap")
			name_mapper.set_result_name (l_full_function)

			expression_writer.reset

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.set_expression_writer (expression_writer)
			contract_writer.set_generic_type (a_type)
			contract_writer.generate_contracts

			if contract_writer.is_generation_failed then
					-- TODO: improve message
				event_handler.add_proof_skipped_event (a_feature.written_class, a_feature, "(function axiom) " + contract_writer.fail_reason)
				output.put_comment_line ("Axiom ignored (skipped due to exception)")
			else
				output.put_line ("axiom (forall " + l_arguments + " ::")
				output.put_line ("             { " + l_full_function + " } // Trigger")
				output.put_line ("        (" + contract_writer.full_precondition + ") ==> (" + contract_writer.full_postcondition + "));")
			end

			output.put_new_line
		end

	write_postcondition_predicate (a_feature: !FEATURE_I)
			-- TODO: move someplace else
			-- TODO: REFACTOR!
		local
			l_predicate_name, l_arguments, l_type: STRING
			l_argument_name, l_full_function, l_full_arguments: STRING
			i: INTEGER
			l_old_handler: EP_OLD_HEAP_HANDLER
			l_expression_writer: EP_EXPRESSION_WRITER
			l_parent_feature: FEATURE_I
			l_assert_info: INH_ASSERT_INFO
		do
			output.reset

			create l_old_handler.make ("old_heap")
			create l_expression_writer.make (name_mapper, l_old_handler)

			l_predicate_name := name_generator.postcondition_predicate_name (a_feature)
			l_arguments := "heap: HeapType, old_heap: HeapType, current: ref"
			l_full_arguments := "(heap, old_heap, current"
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

				l_full_arguments.append (", ")
				l_full_arguments.append (l_argument_name)

				i := i + 1
			end

			if a_feature.has_return_value then
				l_arguments.append (", result")
				l_arguments.append (": ")
				l_arguments.append (type_mapper.boogie_type_for_type (a_feature.type))

				l_full_arguments.append (", ")
				l_full_arguments.append ("result")
			end

			l_full_arguments.append (")")

			l_full_function := l_predicate_name.twin + l_full_arguments

			output.put_comment_line ("Postcondition predicate")
			output.put_line ("function " + l_predicate_name + "(" + l_arguments + ") returns (bool);")

			name_mapper.set_current_feature (a_feature)
			name_mapper.set_current_name ("current")
			name_mapper.set_target_name ("current")
			name_mapper.set_heap_name ("heap")
			name_mapper.set_result_name ("result")

			expression_writer.reset

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.set_expression_writer (l_expression_writer)
			contract_writer.generate_contracts

			if contract_writer.is_generation_failed then
					-- TODO: improve message
				event_handler.add_proof_skipped_event (a_feature.written_class, a_feature, "(postcondition predicate axiom) " + contract_writer.fail_reason)
				output.put_comment_line ("Axiom ignored (skipped due to exception)")
			else
				output.put_line ("axiom (forall " + l_arguments + " ::")
				output.put_line ("             { " + l_full_function + " } // Trigger")
				output.put_line ("        (" + l_full_function + ") ==> (" + contract_writer.full_postcondition + "));")
			end
			output.put_new_line

			l_type := name_generator.type_name (a_feature.written_class.actual_type)
			type_list.record_type_needed (a_feature.written_class.actual_type)

			if a_feature.assert_id_set /= Void then
				from
					i := 1
				until
					i > a_feature.assert_id_set.count
				loop
					l_assert_info := a_feature.assert_id_set.item (i)
					l_parent_feature := l_assert_info.written_class.feature_of_body_index (l_assert_info.body_index)
					check l_parent_feature /= Void end
					l_predicate_name := name_generator.postcondition_predicate_name (l_parent_feature)
					feature_list.record_feature_needed (l_parent_feature)

					l_full_function := l_predicate_name + l_full_arguments

					output.put_comment_line ("Inheritance predicate for class " + l_assert_info.written_class.name_in_upper)
					if contract_writer.is_generation_failed then
							-- TODO: improve message
						output.put_comment_line ("Axiom ignored (skipped due to exception)")
					else
						output.put_line ("axiom (forall " + l_arguments + " ::")
						output.put_line ("             { " + l_full_function + " } // Trigger")
						output.put_line ("        (heap[current, $type] <: " + l_type + ") ==> ((" + l_full_function + ") ==> (" + contract_writer.full_postcondition + ")));")
					end


					output.put_new_line

					i := i + 1
				end
			end

		end

	write_precondition_predicate (a_feature: !FEATURE_I)
			-- TODO: move someplace else
			-- TODO: REFACTOR!
		local
			l_predicate_name, l_arguments, l_type: STRING
			l_argument_name, l_full_function, l_full_arguments: STRING
			i: INTEGER
			l_old_handler: EP_OLD_HEAP_HANDLER
			l_expression_writer: EP_EXPRESSION_WRITER
			l_parent_feature: FEATURE_I
			l_assert_info: INH_ASSERT_INFO
		do
			output.reset

			create l_old_handler.make ("old_heap")
			create l_expression_writer.make (name_mapper, l_old_handler)

			l_predicate_name := name_generator.precondition_predicate_name (a_feature)
			l_arguments := "heap: HeapType, current: ref"
			l_full_arguments := "(heap, current"
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

				l_full_arguments.append (", ")
				l_full_arguments.append (l_argument_name)

				i := i + 1
			end

			l_full_arguments.append (")")

			l_full_function := l_predicate_name.twin + l_full_arguments

			output.put_comment_line ("Precondition predicate")
			output.put_line ("function " + l_predicate_name + "(" + l_arguments + ") returns (bool);")

			name_mapper.set_current_feature (a_feature)
			name_mapper.set_current_name ("current")
			name_mapper.set_target_name ("current")
			name_mapper.set_heap_name ("heap")
			name_mapper.set_result_name ("result")

			expression_writer.reset

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.set_expression_writer (l_expression_writer)
			contract_writer.generate_contracts

			if contract_writer.is_generation_failed then
					-- TODO: improve message
				event_handler.add_proof_skipped_event (a_feature.written_class, a_feature, "(precondition predicate axiom) " + contract_writer.fail_reason)
				output.put_comment_line ("Axiom ignored (skipped due to exception)")
			else
				output.put_line ("axiom (forall " + l_arguments + " ::")
				output.put_line ("             { " + l_full_function + " } // Trigger")
				output.put_line ("        (" + contract_writer.full_precondition + ") ==> (" + l_full_function + "));")
			end
			output.put_new_line

			l_type := name_generator.type_name (a_feature.written_class.actual_type)
			type_list.record_type_needed (a_feature.written_class.actual_type)

			if a_feature.assert_id_set /= Void then
				from
					i := 1
				until
					i > a_feature.assert_id_set.count
				loop
					l_assert_info := a_feature.assert_id_set.item (i)
					l_parent_feature := l_assert_info.written_class.feature_of_body_index (l_assert_info.body_index)
					check l_parent_feature /= Void end
					l_predicate_name := name_generator.precondition_predicate_name (l_parent_feature)
					feature_list.record_feature_needed (l_parent_feature)

					l_full_function := l_predicate_name + l_full_arguments

					output.put_comment_line ("Inheritance predicate for class " + l_assert_info.written_class.name_in_upper)
					if contract_writer.is_generation_failed then
							-- TODO: improve message
						output.put_comment_line ("Axiom ignored (skipped due to exception)")
					else
						output.put_line ("axiom (forall " + l_arguments + " ::")
						output.put_line ("             { " + l_full_function + " } // Trigger")
						output.put_line ("        (heap[current, $type] <: " + l_type + ") ==> ((" + contract_writer.full_precondition + ") ==> (" + l_full_function + ")));")
					end


					output.put_new_line

					i := i + 1
				end
			end

		end

feature {NONE} -- Implementation

	name_mapper: !EP_NORMAL_NAME_MAPPER
			-- Name mapper used for the expression writer

	expression_writer: !EP_EXPRESSION_WRITER
			-- Expression writer used for the contracts

	contract_writer: !EP_CONTRACT_WRITER
			-- Contract writer used to generate the contracts

end
