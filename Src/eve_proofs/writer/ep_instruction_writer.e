indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_INSTRUCTION_WRITER

inherit

	EP_VISITOR
		redefine
			process_assign_b,
			process_check_b,
			process_debug_b,
			process_if_b,
			process_inspect_b,
			process_instr_call_b,
			process_loop_b,
			process_retry_b,
			process_reverse_b
		end

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	SHARED_EP_CONTEXT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do
			create output.make
			create name_mapper.make
			create expression_writer.make (name_mapper, create {EP_INVALID_OLD_HANDLER}.make)
			create {LINKED_LIST [TUPLE [name: STRING; type: STRING]]} locals.make
		end

feature -- Access

	output: !EP_OUTPUT_BUFFER
			-- Buffer where output is stored

	current_feature: !FEATURE_I
			-- Feature which is currently processed

	locals: LIST [TUPLE [name: STRING; type: STRING]]
			-- List of locals needed for side effects

feature -- Element change

	set_current_feature (a_feature: like current_feature)
			-- Set `current_feature' to `a_feature'.
		do
			current_feature := a_feature
			name_mapper.set_current_feature (a_feature)
		ensure
			current_feature_set: current_feature = a_feature
		end

feature -- Basic operations

	reset
			-- Reset output buffer.
		do
			output.reset
			output.set_indentation ("    ")
			locals.wipe_out
			current_label_number := 0
		end

feature -- Processing

	process_assign_b (a_node: ASSIGN_B)
			-- Process `a_node'.
		local
			l_local: LOCAL_B
			l_attribute: ATTRIBUTE_B
			l_result: RESULT_B
			l_feature: !FEATURE_I
		do
			expression_writer.reset
			a_node.source.process (expression_writer)
			locals.append (expression_writer.locals)

			output.put_comment_line ("Assignment --- " + file_location(a_node))
			output.put (expression_writer.side_effect.string)

			output.put (output.indentation)
			if a_node.target.is_local then
				l_local ?= a_node.target
				check l_local /= Void end
				output.put (expression_writer.name_mapper.local_name (l_local))
			elseif a_node.target.is_result then
				l_result ?= a_node.target
				check l_result /= Void end
				output.put (expression_writer.name_mapper.result_name)
			elseif a_node.target.is_attribute then
				l_attribute ?= a_node.target
				check l_attribute /= Void end
				output.put (name_mapper.heap_name)
				output.put ("[")
				output.put (name_mapper.current_name)
				output.put (", ")
				l_feature ?= system.class_of_id (l_attribute.written_in).feature_of_name_id (l_attribute.attribute_name_id)
				output.put (name_generator.attribute_name (l_feature))
				output.put ("]")
			else
				check should_not_be_here: false end
			end
			output.put (" := ")
			output.put (expression_writer.expression.string)
			output.put (";")
			output.put_new_line
			if a_node.target.is_attribute then
				output.put_line ("assume IsHeap(" + name_mapper.heap_name + ");")
			end
		end

	process_check_b (a_node: CHECK_B)
			-- Process `a_node'.
		local
			l_assert: ASSERT_B
		do
			output.put_comment_line ("Check instruction --- " + file_location(a_node))
			from
				a_node.check_list.start
			until
				a_node.check_list.after
			loop
				l_assert ?= a_node.check_list.item
				check l_assert /= Void end

				expression_writer.reset
				l_assert.expr.process (expression_writer)
				locals.append (expression_writer.locals)

				output.put (expression_writer.side_effect.string)
				output.put (output.indentation)
				output.put ("assert (")
				output.put (expression_writer.expression.string)
				output.put ("); // ")
				output.put (assert_location ("check", l_assert))

				output.put_new_line
				a_node.check_list.forth
			end
		end

	process_debug_b (a_node: DEBUG_B)
			-- Process `a_node'.
		local
			l_keys: STRING
		do
			from
				create l_keys.make_empty
				a_node.keys.start
			until
				a_node.keys.after
			loop
				l_keys.append_character ('"')
				l_keys.append (a_node.keys.item)
				l_keys.append_character ('"')
				a_node.keys.forth
				if not a_node.keys.after then
					l_keys.append (", ")
				end
			end
			output.put_comment_line ("Debug (" + l_keys + ") ignored --- " + file_location(a_node))
		end

	process_if_b (a_node: IF_B)
			-- Process `a_node'.
		local
			l_if_label, l_else_label, l_end_label: STRING
			l_condition: STRING
			l_elseif: ELSIF_B
		do
			create_new_label ("if_branch")
			l_if_label := last_label
			create_new_label ("else_branch")
			l_else_label := last_label
			create_new_label ("end")
			l_end_label := last_label

				-- Branch condition
			output.put_comment_line ("Conditional --- " + file_location(a_node))
			expression_writer.reset
			a_node.condition.process (expression_writer)
			locals.append (expression_writer.locals)

			output.put (expression_writer.side_effect.string)
			l_condition := expression_writer.expression.string

			output.put_line ("goto " + l_if_label + ", " + l_else_label + ";")
			output.put_new_line

				-- If branch
			output.put ("  " + l_if_label + ":%N")
			output.put_line ("assume (" + l_condition + ");")
			if a_node.compound /= Void then
				a_node.compound.process (Current)
			end
			output.put_line ("goto " + l_end_label + ";")
			output.put_new_line

				-- Else if parts
			if a_node.elsif_list /= Void then
				from
					a_node.elsif_list.start
				until
					a_node.elsif_list.after
				loop
					l_elseif ?= a_node.elsif_list.item
					check l_elseif /= Void end

					output.put ("  " + l_else_label + ":%N")
					output.put_line ("assume (!(" + l_condition + "));")

					create_new_label ("if_branch")
					l_if_label := last_label
					create_new_label ("else_branch")
					l_else_label := last_label

					expression_writer.reset
					l_elseif.expr.process (expression_writer)
					locals.append (expression_writer.locals)

					output.put (expression_writer.side_effect.string)
					l_condition := expression_writer.expression.string

					output.put_line ("goto " + l_if_label + ", " + l_else_label + ";")
					output.put_new_line

					output.put ("  " + l_if_label + ":%N")
					output.put_line ("assume (" + l_condition + ");")

					if l_elseif.compound /= Void then
						l_elseif.compound.process (Current)
					end

					output.put_line ("goto " + l_end_label + ";")
					output.put_new_line

					a_node.elsif_list.forth
				end
			end

				-- Else part
			output.put ("  " + l_else_label + ":%N")
			output.put_line ("assume (!(" + l_condition + "));")
			if a_node.else_part /= Void then
				a_node.else_part.process (Current)
			end
			output.put_line ("goto " + l_end_label + ";")
			output.put_new_line

				-- End
			output.put ("  " + l_end_label + ":")
			output.put_new_line
		end

	process_inspect_b (a_node: INSPECT_B)
			-- Process `a_node'.
		local
			l_error: EP_UNSUPPORTED_ERROR
		do
			output.put_comment_line ("Inspect statement: ignored")
				-- TODO: implement
			create l_error.make ("Inspect statement not supported")
			errors.extend (l_error)
		end

	process_instr_call_b (a_node: INSTR_CALL_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Instruction call --- " + file_location(a_node))

			expression_writer.reset
			a_node.call.process (expression_writer)
			locals.append (expression_writer.locals)
				-- The actual expression of the call is ignored.
				-- Only functional representations will be in the expression
				-- while the actual calls are in the side effect.
			output.put (expression_writer.side_effect.string)
		end

	process_loop_b (a_node: LOOP_B)
			-- Process `a_node'.
		local
			l_head_label, l_end_label: STRING
			l_until_expression, l_until_side_effect: STRING
			l_invariant_asserts, l_invariant_side_effect: STRING
			l_assert: ASSERT_B
		do
			output.put_comment_line ("Loop --- " + file_location(a_node))

			create_new_label ("loop_head")
			l_head_label := last_label
			create_new_label ("loop_end")
			l_end_label := last_label

			safe_process (a_node.from_part)

			expression_writer.reset
			a_node.stop.process (expression_writer)
			locals.append (expression_writer.locals)
			l_until_expression := expression_writer.expression.string
			l_until_side_effect := expression_writer.side_effect.string

			create l_invariant_asserts.make_empty
			create l_invariant_side_effect.make_empty
			if a_node.invariant_part /= Void then
				from
					a_node.invariant_part.start
				until
					a_node.invariant_part.after
				loop
					l_assert ?= a_node.invariant_part.item
					check l_assert /= Void end
					expression_writer.reset
					l_assert.process (expression_writer)
					locals.append (expression_writer.locals)
					l_invariant_asserts.append ("    assert (")
					l_invariant_asserts.append (expression_writer.expression.string)
					l_invariant_asserts.append ("); // ")
					l_invariant_asserts.append (assert_location ("loop", l_assert))
					l_invariant_asserts.append ("%N")
					l_invariant_side_effect := expression_writer.side_effect.string
					a_node.invariant_part.forth
				end
			end

			-- TODO: generate assertion for variant

			output.put (l_until_side_effect)
			output.put (l_invariant_side_effect)
			output.put (l_invariant_asserts)
			output.put_line ("goto " + l_head_label + ", " + l_end_label + ";")
			output.put_new_line

			output.put ("  " + l_head_label + ":%N")
			output.put_line ("assume (!(" + l_until_expression + "));")

			safe_process (a_node.compound)

			output.put (l_until_side_effect)
			output.put (l_invariant_side_effect)
			output.put (l_invariant_asserts)
			output.put_line ("goto " + l_head_label + ", " + l_end_label + ";")
			output.put_new_line

			output.put ("  " + l_end_label + ":%N")

			output.put_line ("assume (" + l_until_expression + ");")
		end

	process_retry_b (a_node: RETRY_B)
			-- Process `a_node'.
		local
			l_error: EP_UNSUPPORTED_ERROR
		do
			output.put_comment_line ("Retry instruction: ignored")
			create l_error.make ("Retry instruction not supported")
			errors.extend (l_error)
		end

	process_reverse_b (a_node: REVERSE_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Reverse assignment: treated as normal assignment!")
			process_assign_b (a_node)
				-- TODO: implement
		end

feature {NONE} -- Implementation

	expression_writer: !EP_EXPRESSION_WRITER
			-- Writer used to produce Boogie code for expressions

	name_mapper: !EP_NORMAL_NAME_MAPPER
			-- Name mapper to resolve variable names

	current_label_number: INTEGER
			-- Current label number

	create_new_label (a_name: STRING)
			-- Create a new label.
		do
			current_label_number := current_label_number + 1
			last_label := "label_" + a_name + current_label_number.out
		end

	last_label: STRING
			-- Last created label

	file_location (a_node: INSTR_B): STRING
			-- Location of `a_node'
		require
			a_node_not_void: a_node /= Void
		do
			Result := current_feature.written_class.file_name + ":" + a_node.line_number.out
		end

	assert_location (a_type: STRING; a_assert: ASSERT_B): STRING
			-- Location of `a_assert'
		require
			a_type_not_void: a_type /= Void
			a_assert_not_void: a_assert /= Void
		do
			Result := a_type.twin
			Result.append (" ")
			Result.append (current_feature.written_class.name_in_upper)
			Result.append (":")
			Result.append (a_assert.line_number.out)
			if a_assert.tag /= Void then
				Result.append (" tag:")
				Result.append (a_assert.tag)
			end
		end

end
