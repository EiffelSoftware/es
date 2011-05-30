note
	description : "Translate body of a routine to JavaScript."
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

class
	JSC_BODY_WRITER

inherit
	SHARED_JSC_CONTEXT
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize object
		do
			create output.make
			create instruction_writer.make
			create expression_writer.make
			reset("")
		end

feature -- Access

	output: attached JSC_SMART_BUFFER
			-- Generated JavaScript

	dependencies1: attached SET[INTEGER]
			-- Level 1 dependencies

	dependencies2: attached SET[INTEGER]
			-- Level 2 dependencies

feature -- Basic Operations

	reset (a_indentation: attached STRING)
			-- Reset state
		do
			output.reset (a_indentation)
			create {LINKED_SET[INTEGER]}dependencies1.make
			create {LINKED_SET[INTEGER]}dependencies2.make
			this_used_in_closure := false
		end

	set_proper_context (a_feature: attached FEATURE_I)
			-- Set up all the context for translating `a_feature'.
		local
			l_byte_server: BYTE_SERVER
			l_context: BYTE_CONTEXT
			l_byte_code: BYTE_CODE
			l_body1: FEATURE_AS
			l_body2: BODY_AS
			l_routine: ROUTINE_AS
			l_local: TYPE_DEC_AS
			l_id_list: IDENTIFIER_LIST
			l_names_heap: NAMES_HEAP
			l_name: STRING_32
			l_written_class: CLASS_C
			l_types: TYPE_LIST
			l_locals_names : LINKED_LIST[attached STRING]
		do
			l_byte_server := byte_server
			check l_byte_server /= Void end

			l_context := context
			check l_context /= Void end

			if l_byte_server.has (a_feature.body_index) then
				l_byte_code := l_byte_server.item (a_feature.body_index)
				check l_byte_code /= Void end

				l_context.inherited_assertion.wipe_out
				if a_feature.assert_id_set /= Void then
					l_byte_code.formulate_inherited_assertions (a_feature.assert_id_set)
				end

				create l_locals_names.make
				if not a_feature.is_inline_agent then
					l_body1 := a_feature.body
					check l_body1 /= Void end

					l_body2 := l_body1.body
					check l_body2 /= Void end

					l_routine := l_body2.as_routine
					check l_routine /= Void end

					if attached l_routine.locals as safe_locals then
						from
							safe_locals.start
						until
							safe_locals.after
						loop
							l_local := safe_locals.item
							check l_local /= Void end

							l_id_list := l_local.id_list
							check l_id_list /= Void end

							l_names_heap := l_local.names_heap
							check l_names_heap /= Void end

							from
								l_id_list.start
							until
								l_id_list.after
							loop
								l_name := l_names_heap.item_32 (l_id_list.item)
								check l_name /= Void end

								l_locals_names.extend (l_name)
								l_id_list.forth
							end

							safe_locals.forth
						end
					end
				end
				jsc_context.name_mapper.set_locals_names (l_locals_names)

				l_written_class := a_feature.written_class
				check l_written_class /= Void end

				l_types := l_written_class.types
				check l_types /= Void end

					-- Set up byte context
				l_context.clear_feature_data
				l_context.clear_class_type_data
				l_context.init (l_types.first)
				l_context.set_current_feature (a_feature)
				l_context.set_byte_code (l_byte_code)
			else
				check false end
			end
		end

	write_feature_body (a_feature: attached FEATURE_I)
			-- Generate JavaScript translation for body of feature `a_feature'
		local
			l_byte_server: BYTE_SERVER
			l_byte_code: BYTE_CODE
			body, postcondition, rescue_code: JSC_BUFFER_DATA
		do
			l_byte_server := byte_server
			check l_byte_server /= Void end

			if l_byte_server.has (a_feature.body_index) then
				l_byte_code := l_byte_server.item (a_feature.body_index)
				check l_byte_code /= Void end

					-- Initialize context
				set_proper_context (a_feature)
				instruction_writer.reset (output.indentation)

					-- Process rescue clause
				if attached l_byte_code.rescue_clause as safe_rescue_clause
					and then not safe_rescue_clause.is_empty then
					output.indent
					output.indent
						instruction_writer.reset (output.indentation)
						safe_rescue_clause.process (instruction_writer)
						rescue_code := instruction_writer.output.data
						dependencies1.fill (instruction_writer.dependencies1)
						dependencies2.fill (instruction_writer.dependencies2)
						this_used_in_closure := this_used_in_closure or instruction_writer.this_used_in_closure
					output.unindent
					output.unindent
				end

					-- Process the actual body and store it in `body'
				if attached l_byte_code.compound as safe_compound
					and then not safe_compound.is_empty then

					if rescue_code /= Void then
						output.indent
						output.indent
					end

					instruction_writer.reset (output.indentation)
					safe_compound.process (instruction_writer)
					body := instruction_writer.output.data
					dependencies1.fill (instruction_writer.dependencies1)
					dependencies2.fill (instruction_writer.dependencies2)
					this_used_in_closure := this_used_in_closure or instruction_writer.this_used_in_closure

					if rescue_code /= Void then
						output.unindent
						output.unindent
					end
				end

				if attached a_feature.written_class as safe_feature_class then
					if safe_feature_class.assertion_level.is_precondition then
							-- Process the preconditions and write them to output
						write_preconditions (safe_feature_class.class_id, l_byte_code)
					end

					if safe_feature_class.assertion_level.is_postcondition then
						-- Process the postconditions and save them in `postcondition'
						output.push (output.indentation)
							write_postconditions (l_byte_code)
							postcondition := output.data
						output.pop
					end
				end

				if a_feature.has_return_value or l_byte_code.local_count > 0 or this_used_in_closure
					or jsc_context.current_old_locals.count > 0 or jsc_context.current_object_test_locals > 0 or jsc_context.current_reverse_locals > 0
					or rescue_code /= Void then
						-- The feature has locals
					write_locals (l_byte_code, a_feature, this_used_in_closure, rescue_code /= Void)
				end

				if attached rescue_code as safe_rescue_code then
					output.put_line ("while ($retry) {")
					output.indent
					output.put_line ("$retry = false;")
					output.put_line ("try {")
				end

				if attached body as safe_body then
						-- The feature has a body
					output.put_data (safe_body)
				end

				if attached rescue_code as safe_rescue_code then
					output.put_line ("} catch ($err) {")
					output.put_data (safe_rescue_code)
					output.indent
					output.put_line ("if (!$retry) { throw $err; }")
					output.unindent
					output.put_line ("}")
					output.unindent
					output.put_line ("}")
				end

				if a_feature.is_once then
						-- If it is a once feature, cache result in $cached
					output.put_indentation
					output.put ("$cached = ")
					output.put (jsc_context.name_mapper.result_name)
					output.put (";")
					output.put_new_line
				end

				if attached postcondition as safe_postcondition then
						-- The feature has a postcondition
					output.put_data (safe_postcondition)
				end

				if a_feature.has_return_value then
						-- The feature has a return value
					output.put_indentation
					output.put ("return ")
					output.put (jsc_context.name_mapper.result_name)
					output.put (";")
					output.put_new_line
				end
			end
		end

feature {NONE} -- Implementation

	process_assertion (a_expr: attached EXPR_B): attached JSC_BUFFER_DATA
		do
			expression_writer.reset ("")
			a_expr.process (expression_writer)

			dependencies1.fill (expression_writer.dependencies1)
			dependencies2.fill (expression_writer.dependencies2)
			this_used_in_closure := this_used_in_closure or expression_writer.this_used_in_closure
			Result := expression_writer.output.data
		end

	write_preconditions (current_class_id: INTEGER; l_byte_code: attached BYTE_CODE)
			-- Process the preconditions and write them to output
		local
			l_assertion_byte_code: ASSERTION_BYTE_CODE
			l_assert: ASSERT_B
			l_expr: EXPR_B
			l_context: BYTE_CONTEXT
			l_preconditions: HASH_TABLE[attached LINKED_LIST[attached JSC_BUFFER_DATA], INTEGER]
			per_class: LINKED_LIST[attached JSC_BUFFER_DATA]
			l_class_id: INTEGER
			all_preconditions: LINKED_LIST[attached JSC_BUFFER_DATA]
		do
			l_context := context
			check l_context /= Void end

			create l_preconditions.make (1)

				-- Add inherited preconditions (if any)
			if attached l_context.inherited_assertion as safe_inherited_assertions then
				from
					safe_inherited_assertions.precondition_start
				until
					safe_inherited_assertions.precondition_after
				loop
					l_assertion_byte_code ?= safe_inherited_assertions.precondition_list.item_for_iteration
					check l_assertion_byte_code /= Void end

					l_class_id := safe_inherited_assertions.precondition_types.item_for_iteration.associated_class.class_id

					if l_preconditions.has (l_class_id) then
						per_class := l_preconditions[l_class_id]
					else
						create per_class.make
						l_preconditions[l_class_id] := per_class
					end

					from
						l_assertion_byte_code.start
					until
						l_assertion_byte_code.after
					loop
						l_assert := l_assertion_byte_code.item
						check l_assert /= Void end

						l_expr := l_assert.expr
						check l_expr /= Void end

						per_class.extend (process_assertion(l_expr))

						l_assertion_byte_code.forth
					end

					safe_inherited_assertions.precondition_forth
				end
			end

				-- Add preconditions from current feature (if any)
			if attached l_byte_code.precondition as precondition_byte_code then
				if l_preconditions.has (current_class_id) then
					per_class := l_preconditions[current_class_id]
				else
					create per_class.make
					l_preconditions[current_class_id] := per_class
				end

				from
					precondition_byte_code.start
				until
					precondition_byte_code.after
				loop
					l_assert := precondition_byte_code.item
					check l_assert /= Void end

					l_expr := l_assert.expr
					check l_expr /= Void end

					per_class.extend (process_assertion(l_expr))

					precondition_byte_code.forth
				end
			end

			from
				create all_preconditions.make
				l_preconditions.start
			until
				l_preconditions.after
			loop
				output.push ("")
					output.put ("(")
					output.put_data_list (l_preconditions.item_for_iteration, ") && (")
					output.put (")")
					all_preconditions.extend (output.data)
				output.pop


				l_preconditions.forth
			end

			if all_preconditions.count > 0 then
				output.put_indentation
				output.put ("if(!(")
				output.put_data_list (all_preconditions, " || ")
				output.put (")) {")
				output.put_new_line

				output.indent
				output.put_indentation
				output.put ("throw %"Precondition at ")
				output.put (jsc_context.current_class_name)

				if jsc_context.has_current_feature then
					output.put (".")
					output.put (jsc_context.current_feature_name)
				end

				output.put (" does not hold.%";")
				output.put_new_line

				output.unindent
				output.put_indentation
				output.put ("}")
				output.put_new_line
			end
		end

	write_postconditions (l_byte_code: attached BYTE_CODE)
			-- Process the postconditionsand write them to output
		local
			l_assertion_byte_code: ASSERTION_BYTE_CODE
			l_assert: ASSERT_B
			l_expr: EXPR_B
			l_context: BYTE_CONTEXT
			all_postconditions: LINKED_LIST[attached JSC_BUFFER_DATA]
		do
			l_context := context
			check l_context /= Void end

			create all_postconditions.make

				-- Add inherited postconditions (if any)
			if attached l_context.inherited_assertion as safe_inherited_assertions then
				from
					safe_inherited_assertions.postcondition_start
				until
					safe_inherited_assertions.postcondition_after
				loop
					l_assertion_byte_code ?= safe_inherited_assertions.postcondition_list.item_for_iteration
					check l_assertion_byte_code /= Void end

					from
						l_assertion_byte_code.start
					until
						l_assertion_byte_code.after
					loop
						l_assert := l_assertion_byte_code.item
						check l_assert /= Void end

						l_expr := l_assert.expr
						check l_expr /= Void end

						all_postconditions.extend (process_assertion(l_expr))

						l_assertion_byte_code.forth
					end

					safe_inherited_assertions.postcondition_forth
				end
			end

				-- Add postconditions from current feature (if any)
			if attached l_byte_code.postcondition as postcondition_byte_code then
				from
					postcondition_byte_code.start
				until
					postcondition_byte_code.after
				loop
					l_assert := postcondition_byte_code.item
					check l_assert /= Void end

					l_expr := l_assert.expr
					check l_expr /= Void end

					all_postconditions.extend (process_assertion(l_expr))

					postcondition_byte_code.forth
				end
			end

			if all_postconditions.count > 0 then
				output.put_indentation
				output.put ("if(!((")
				output.put_data_list (all_postconditions, ") && (")
				output.put ("))) {")
				output.put_new_line

				output.indent
				output.put_indentation
				output.put ("throw %"Postcondition at ")
				output.put (jsc_context.current_class_name)

				if jsc_context.has_current_feature then
					output.put (".")
					output.put (jsc_context.current_feature_name)
				end

				output.put (" does not hold.%";")
				output.put_new_line

				output.unindent
				output.put_indentation
				output.put ("}")
				output.put_new_line
			end
		end

	write_locals (a_byte_code: attached BYTE_CODE; a_feature: attached FEATURE_I; a_this_used_in_closure: BOOLEAN; a_has_rescue_code: BOOLEAN)
			-- Write local declaration
		local
			l_result_type: TYPE_A
			l_local_type: TYPE_A
			i: INTEGER
			locals: LINKED_LIST[attached JSC_BUFFER_DATA]
			default_value_writer: JSC_DEFAULT_VALUE_WRITER
		do
			create locals.make
			create default_value_writer.make

			if a_feature.has_return_value then
					-- Write the result variable
				l_result_type := a_byte_code.result_type
				check l_result_type /= Void end

				output.push ("")
					output.put (jsc_context.name_mapper.result_name)
					output.put (" = ")
					output.put (default_value_writer.default_value (l_result_type))
					locals.extend (output.data)
				output.pop
			end

			if a_this_used_in_closure and not jsc_context.name_mapper.is_inside_agent then
					-- Write the closure self reference
				output.push ("")
					output.put ("$this = this")
					locals.extend (output.data)
				output.pop
			end

			if a_has_rescue_code then
					-- Write the rescue "retry" variable
				output.push ("")
					output.put ("$retry = true")
					locals.extend (output.data)
				output.pop
			end

			if attached a_byte_code.locals as safe_locals then
					-- Write the programmer's locals
				from
					i := safe_locals.lower
				until
					i > safe_locals.upper
				loop
					l_local_type := safe_locals[i]
					check l_local_type /= Void end

					l_local_type := l_local_type.actual_type
					check l_local_type /= Void end

					output.push ("")
						output.put (jsc_context.name_mapper.local_name (i))
						output.put (" = ")
						output.put (default_value_writer.default_value (l_local_type))
						locals.extend (output.data)
					output.pop
					i := i + 1
				end
			end

				-- Write locals generated from old() expressions
			from
				i := 1
			until
				i > jsc_context.current_old_locals.count
			loop
				output.push ("")
					output.put (jsc_context.old_local_name (i))
					output.put (" = ")
					output.put_data (jsc_context.current_old_locals[i])
					locals.extend (output.data)
				output.pop
				i := i + 1
			end

				-- Write locals generated from object tests
			from
				i := 1
			until
				i > jsc_context.current_object_test_locals
			loop
				output.push ("")
					output.put (jsc_context.object_test_local_name (i))
					output.put (" = null")
					locals.extend (output.data)
				output.pop
				i := i + 1
			end


				-- Write locals generated from reverse
			from
				i := 1
			until
				i > jsc_context.current_reverse_locals
			loop
				output.push ("")
					output.put (jsc_context.reverse_local_name (i))
					output.put (" = null")
					locals.extend (output.data)
				output.pop
				i := i + 1
			end

			output.put_indentation
			output.put ("var ")
			output.put_data_list (locals, ", ")
			output.put (";")
			output.put_new_line
		end

	instruction_writer: attached JSC_INSTRUCTION_WRITER

	expression_writer: attached JSC_EXPRESSION_WRITER

	this_used_in_closure: BOOLEAN

end
