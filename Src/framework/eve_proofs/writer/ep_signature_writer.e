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

			if not ignore_framing (a_feature) then
				frame_extractor.build_frame_condition (a_feature)
				output.put_line ("ensures " + frame_extractor.last_frame_condition + "; // frame " + a_feature.written_class.name_in_upper + ":" + a_feature.feature_name)
			end

-- MML test
--			write_precondition_predicate (a_feature)
--			write_postcondition_predicate (a_feature)
-- TODO: refactor
			if feature_list.is_pure (a_feature) and a_feature.has_return_value then
				write_functional_predicate (a_feature)
			end

			output.set_indentation ("")
			output.put_new_line
		end

	write_generic_feature_signature (a_feature: !FEATURE_I; a_type: !TYPE_A)
			-- Write Boogie code signature of `a_feature'.
		local
			l_procedure_name: STRING
		do
			output.reset

			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.generic_procedural_feature_name (a_feature, a_type)

			write_generic_procedure_definition (a_feature, a_type, l_procedure_name, False)

			output.set_indentation ("    ")

			output.put_comment_line ("Frame condition")
			output.put_line ("modifies Heap;")

			if not ignore_framing (a_feature) then
				frame_extractor.build_generic_frame_condition (a_feature, a_type)
				output.put_line ("ensures " + frame_extractor.last_frame_condition + "; // frame " + a_feature.written_class.name_in_upper + ":" + a_feature.feature_name)
			end

-- MML test
--			write_precondition_predicate (a_feature)
--			write_postcondition_predicate (a_feature)
-- TODO: refactor
			if feature_list.is_pure (a_feature) and a_feature.has_return_value then
				write_generic_functional_predicate (a_feature, a_type)
			end

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

			output.put_line ("modifies Heap;")
			if not ignore_framing (a_feature) then
				frame_extractor.build_frame_condition (a_feature)
				output.put_line ("ensures " + frame_extractor.last_frame_condition + "; // frame " + a_feature.written_class.name_in_upper + ":" + a_feature.feature_name)
			end

-- TODO: not necessary anymore?
--			output.put_comment_line ("Creation routine condition")
--			output.put_line ("free ensures Heap[Current, $allocated];")

			output.set_indentation ("")
			output.put_new_line
		end

	write_generic_creation_routine_signature (a_feature: !FEATURE_I; a_type: !TYPE_A)
			-- Write Boogie code signature of `a_feature' as a creation routine of class `a_class'.
		local
			l_procedure_name: STRING
		do
			output.reset

			name_mapper.set_current_feature (a_feature)
			l_procedure_name := name_generator.generic_creation_routine_name (a_feature, a_type)

			write_generic_procedure_definition (a_feature, a_type, l_procedure_name, True)

			output.set_indentation ("    ")

			output.put_comment_line ("Frame condition")

			output.put_line ("modifies Heap;")
			if not ignore_framing (a_feature) then
				frame_extractor.build_generic_frame_condition (a_feature, a_type)
				output.put_line ("ensures " + frame_extractor.last_frame_condition + "; // frame " + a_feature.written_class.name_in_upper + ":" + a_feature.feature_name)
			end

-- TODO: not necessary anymore?
--			output.put_comment_line ("Creation routine condition")
--			output.put_line ("free ensures Heap[Current, $allocated];")

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
			l_argument_name, l_type_name: STRING
			i: INTEGER
			l_argument_type: TYPE_A
		do
			output.put_comment_line ("Signature")

			output.put ("procedure " + a_procedure_name + "(")
			l_type_name := name_generator.type_name (a_feature.written_class.actual_type)
			type_list.record_type_needed (a_feature.written_class.actual_type)
			if a_feature.argument_count = 0 then
				output.put ("Current: ref where IsAttachedType(Heap, Current, " + l_type_name + ")")
			else
				output.put ("%N")
				output.put ("            Current: ref where IsAttachedType(Heap, Current, " + l_type_name + ")")

				from
					i := 1
				until
					i > a_feature.argument_count
				loop
					l_argument_name :=  name_generator.argument_name (a_feature.arguments.item_name (i))
					l_argument_type := a_feature.arguments.i_th (i)
					l_type_name := name_generator.type_name (l_argument_type)
					type_list.record_type_needed (l_argument_type)
						-- TODO: fix this hack
--					if {l_temp: GEN_TYPE_A} l_argument_type or l_type_name.is_equal ("STRING_8") then
--						l_type_name := "ANY"
--					end

					output.put (",%N")
					output.put ("            " + l_argument_name + ": " + type_mapper.boogie_type_for_type (l_argument_type))

						-- Add type based conditions
						-- TODO: make more generic
					if l_argument_type.is_natural then
						output.put (" where IsNatural(" + l_argument_name +")")
					elseif l_argument_type.is_expanded then
							-- TODO
					elseif l_argument_type.is_formal then
							-- TODO: constrained generics?
					elseif l_argument_type.is_attached then
						output.put (" where IsAttachedType(Heap, " + l_argument_name + ", " + l_type_name + ")")
					elseif l_argument_type.is_reference then
						output.put (" where IsDetachedType(Heap, " + l_argument_name + ", " + l_type_name + ")")
					else
						check false end
					end

					i := i + 1
				end
				output.put ("%N        ")
			end

			output.put (")")
			if a_feature.has_return_value then
				output.put (" returns (Result: " + type_mapper.boogie_type_for_type (a_feature.type) + ")")
				type_list.record_type_needed (a_feature.type)
			end
			output.put (";%N")

			output.set_indentation ("    ")

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.generate_contracts

			if contract_writer.is_generation_failed then
					-- TODO: improve message
				event_handler.add_proof_skipped_event (a_feature.written_class, a_feature, "(signature) " + contract_writer.fail_reason)
				output.put_comment_line ("Contract ignored (skipped due to exception)")
			else
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
			end

				-- Add type based conditions
				-- TODO: make more generic
			if a_feature.has_return_value then
				if a_feature.type.is_natural then
					output.put_comment_line ("Result type constraint")
					output.put_line ("free ensures IsNatural(Result);")
				elseif a_feature.type.is_expanded then
						-- TODO
				elseif a_feature.type.is_formal then
						-- TODO: constrained generics?
				elseif a_feature.type.is_attached then
					l_type_name := name_generator.type_name (a_feature.type)
					output.put_comment_line ("Result type constraint")
					output.put_line ("free ensures IsAttachedType(Heap, Result, " + l_type_name + ");")
				elseif a_feature.type.is_reference then
					l_type_name := name_generator.type_name (a_feature.type)
					output.put_comment_line ("Result type constraint")
					output.put_line ("free ensures IsDetachedType(Heap, Result, " + l_type_name + ");")
				else
					check false end
				end
			end

			output.set_indentation ("")
		end

	write_generic_procedure_definition (a_feature: !FEATURE_I; a_type: !TYPE_A; a_procedure_name: STRING; a_is_creation_routine: BOOLEAN)
			-- Write procedure definition of feature `a_feature_name'
			-- using `a_procedure_name' for the Boogie name.
		local
			l_argument_name, l_type_name: STRING
			i: INTEGER
			l_argument_type: TYPE_A
			l_result_type: TYPE_A
		do
			output.put_comment_line ("Signature")

			output.put ("procedure " + a_procedure_name + "(")
			l_type_name := name_generator.type_name (a_type)
			type_list.record_type_needed (a_type)
			if a_feature.argument_count = 0 then
				output.put ("Current: ref where IsAttachedType(Heap, Current, " + l_type_name + ")")
			else
				output.put ("%N")
				output.put ("            Current: ref where IsAttachedType(Heap, Current, " + l_type_name + ")")

				from
					i := 1
				until
					i > a_feature.argument_count
				loop
					l_argument_name :=  name_generator.argument_name (a_feature.arguments.item_name (i))
					l_argument_type := a_feature.arguments.i_th (i)
					l_type_name := name_generator.type_name (l_argument_type)
					type_list.record_type_needed (l_argument_type)
						-- TODO: fix this hack
--					if {l_temp: GEN_TYPE_A} l_argument_type or l_type_name.is_equal ("STRING_8") then
--						l_type_name := "ANY"
--					end

					output.put (",%N")
					output.put ("            " + l_argument_name + ": " + type_mapper.generic_boogie_type_for_type (l_argument_type, a_type))

						-- Add type based conditions
					l_argument_type := l_argument_type.actual_type
					check not l_argument_type.is_like end

						-- TODO: make more generic
					if l_argument_type.is_natural then
						output.put (" where IsNatural(" + l_argument_name +")")
					elseif l_argument_type.is_expanded then
							-- TODO
					elseif l_argument_type.is_formal then
							-- TODO: constrained generics?
					elseif l_argument_type.is_attached then
						output.put (" where IsAttachedType(Heap, " + l_argument_name + ", " + l_type_name + ")")
					elseif l_argument_type.is_reference then
						output.put (" where IsDetachedType(Heap, " + l_argument_name + ", " + l_type_name + ")")
					else
						check false end
					end

					i := i + 1
				end
				output.put ("%N        ")
			end

			output.put (")")
			if a_feature.has_return_value then
				output.put (" returns (Result: " + type_mapper.boogie_type_for_type (a_feature.type) + ")")
				type_list.record_type_needed (a_feature.type)
			end
			output.put (";%N")

			output.set_indentation ("    ")

			contract_writer.reset
			contract_writer.set_feature (a_feature)
			contract_writer.set_generic_type (a_type)
			contract_writer.generate_contracts

			if contract_writer.is_generation_failed then
					-- TODO: improve message
				event_handler.add_proof_skipped_event (a_feature.written_class, a_feature, "(signature) " + contract_writer.fail_reason)
				output.put_comment_line ("Contract ignored (skipped due to exception)")
			else
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
			end

				-- Add type based conditions
				-- TODO: make more generic
			if a_feature.has_return_value then
				l_result_type := a_feature.type.deep_actual_type
				if l_result_type.is_natural then
					output.put_comment_line ("Result type constraint")
					output.put_line ("free ensures IsNatural(Result);")
				elseif l_result_type.is_expanded then
						-- TODO
				elseif l_result_type.is_formal then
						-- TODO: constrained generics?
				elseif l_result_type.is_attached then
					l_type_name := name_generator.type_name (a_feature.type)
					output.put_comment_line ("Result type constraint")
					output.put_line ("free ensures IsAttachedType(Heap, Result, " + l_type_name + ");")
				elseif l_result_type.is_reference then
					l_type_name := name_generator.type_name (a_feature.type)
					output.put_comment_line ("Result type constraint")
					output.put_line ("free ensures IsDetachedType(Heap, Result, " + l_type_name + ");")
				else
					check false end
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
					-- TODO: remove "free" when predicate testing is done
--					output.put ("free requires ")
-- MML TEST
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

	write_postcondition_predicate (a_feature: !FEATURE_I)
			-- TODO
		local
			l_predicate_name, l_argument_name, l_argument_type: STRING
			i: INTEGER
		do
			output.put_comment_line ("Postcondition predicate")

			output.put_indentation
			output.put ("free ensures ");
			l_predicate_name := name_generator.postcondition_predicate_name (a_feature);
			output.put (l_predicate_name + "(Heap, old(Heap), Current")

			-- TODO: code reuse with implementation writer => inherit from signature writer?
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				l_argument_name := name_generator.argument_name (a_feature.arguments.item_name (i))
				output.put (", " + l_argument_name)
				i := i + 1
			end
			if not a_feature.type.is_void then
				output.put (", Result")
			end
			output.put (");")
			output.put_new_line
		end

	write_precondition_predicate (a_feature: !FEATURE_I)
			-- TODO
		local
			l_predicate_name, l_argument_name, l_argument_type: STRING
			i: INTEGER
		do
			output.put_comment_line ("Precondition predicate")

			output.put_indentation
			output.put ("requires ");
			l_predicate_name := name_generator.precondition_predicate_name (a_feature);
			output.put (l_predicate_name + "(Heap, Current")

			-- TODO: code reuse with implementation writer => inherit from signature writer?
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				l_argument_name := name_generator.argument_name (a_feature.arguments.item_name (i))
				output.put (", " + l_argument_name)
				i := i + 1
			end
			output.put ("); // pre DUMMY:predicate")
			output.put_new_line
		end

	write_functional_predicate (a_feature: !FEATURE_I)
			-- TODO
		local
			l_predicate_name, l_argument_name, l_argument_type: STRING
			i: INTEGER
		do
			output.put_comment_line ("Functional predicate")

			output.put_indentation
			output.put ("free ensures Result == ");
			l_predicate_name := name_generator.functional_feature_name (a_feature);
			output.put (l_predicate_name + "(Heap, Current")

			-- TODO: code reuse with implementation writer => inherit from signature writer?
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				l_argument_name := name_generator.argument_name (a_feature.arguments.item_name (i))
				output.put (", " + l_argument_name)
				i := i + 1
			end
			output.put (");")
			output.put_new_line
		end

	write_generic_functional_predicate (a_feature: !FEATURE_I; a_type: !TYPE_A)
			-- TODO
		local
			l_predicate_name, l_argument_name, l_argument_type: STRING
			i: INTEGER
		do
			output.put_comment_line ("Functional predicate")

			output.put_indentation
			output.put ("free ensures Result == ");
			l_predicate_name := name_generator.generic_functional_feature_name (a_feature, a_type);
			output.put (l_predicate_name + "(Heap, Current")

			-- TODO: code reuse with implementation writer => inherit from signature writer?
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				l_argument_name := name_generator.argument_name (a_feature.arguments.item_name (i))
				output.put (", " + l_argument_name)
				i := i + 1
			end
			output.put (");")
			output.put_new_line
		end

	ignore_framing (a_feature: !FEATURE_I): BOOLEAN
			-- Is framing ignored for this feature?
		local
			l_indexing_clause: INDEXING_CLAUSE_AS
			l_index: INDEX_AS
			l_bool: BOOL_AS
			l_found: BOOLEAN
		do
			Result := False
			l_indexing_clause := a_feature.written_class.ast.feature_with_name (a_feature.feature_name_id).indexes
			if l_indexing_clause /= Void then
				from
					l_indexing_clause.start
				until
					l_indexing_clause.after or l_found
				loop
					l_index := l_indexing_clause.item
					if l_index.tag.name_8.as_lower.is_equal ("ignore_framing") then
						l_found := True
						l_bool ?= l_index.index_list.first
						if l_bool /= Void then
							Result := l_bool.value
						end
					end
					l_indexing_clause.forth
				end
			end
		end

end
