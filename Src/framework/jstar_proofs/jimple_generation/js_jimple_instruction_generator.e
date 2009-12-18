indexing
	description: "Summary description for {JS_SOOT_INSTRUCTION_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_JIMPLE_INSTRUCTION_GENERATOR

inherit
	JS_VISITOR
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

	JS_HELPER_ROUTINES
		export {NONE} all end

create
	make

feature

	make
		do
			create output.make
			create expression_writer.make (Current)
			create {LINKED_LIST [TUPLE [name: STRING; type: STRING]]} temporaries.make
		end

	set_feature (a_feature: !FEATURE_I)
		do
			current_feature := a_feature
		end

	reset
		do
			output.reset
			temporaries.wipe_out
			current_feature := Void
			expression_writer.reset
			expression_writer.reset_temporary_number
			current_label_number := 0
		end

	output_instructions: STRING
		do
			Result := output.string
		end

	temporaries: LIST [TUPLE [name: STRING; type: STRING]]

feature -- Node processing

	process_assign_b (a_node: ASSIGN_B)
			-- Process `a_node'.
		local
			l_local: LOCAL_B
			l_attribute: ATTRIBUTE_B
		do
			expression_writer.reset
			a_node.source.process (expression_writer)

			temporaries.append (expression_writer.temporaries)

			output.append_lines (expression_writer.side_effect_string)

			output.put_indentation
			if a_node.target.is_local then
				l_local ?= a_node.target
				check l_local /= Void end
				output.put (name_for_local (l_local))
			elseif a_node.target.is_result then
				output.put (name_for_result)
			elseif a_node.target.is_attribute then
				l_attribute ?= a_node.target
				check l_attribute /= Void end
				output.put (name_for_current + "." + attribute_designator (l_attribute))
			else
				check should_not_be_here: false end
			end
			output.put (" = ")
			output.put (expression_writer.expression_string)
			output.put (";")
			output.put_new_line
		end

	process_check_b (a_node: CHECK_B)
		do
			output.put_comment_line ("Check instruction ignored")
		end

	process_debug_b (a_node: DEBUG_B)
		do
			output.put_comment_line ("Debug instruction ignored")
		end

	process_if_b (a_node: IF_B)
		local
			l_if_label, l_end_label: STRING
			l_condition: STRING
			l_elseif_labels: ARRAY [STRING]
			i: INTEGER
			l_elseif: ELSIF_B
		do
			create_new_label ("if")
			l_if_label := last_label
			create_new_label ("end")
			l_end_label := last_label

			expression_writer.reset
			a_node.condition.process (expression_writer)
			temporaries.append (expression_writer.temporaries)

			output.put (expression_writer.side_effect_string)
			l_condition := expression_writer.expression_string

			output.put_line ("if " + l_condition + " == 1 goto " + l_if_label + ";")

				-- Handle the elseif parts: create tests & labels
			if a_node.elsif_list /= Void then
				create l_elseif_labels.make (1, a_node.elsif_list.count)
				from
					a_node.elsif_list.start
					i := 1
				until
					a_node.elsif_list.off
				loop
					create_new_label ("elseif")
					l_elseif_labels [i] := last_label

					expression_writer.reset
					a_node.condition.process (expression_writer)
					temporaries.append (expression_writer.temporaries)

					output.append_lines (expression_writer.side_effect_string)
					l_condition := expression_writer.expression_string

					output.put_line ("if " + l_condition + " == 1 goto " + l_elseif_labels [i] + ";")

					a_node.elsif_list.forth
					i := i + 1
				end
			end

			output.indent
				-- Handle the else part
			if a_node.else_part /= Void then
				a_node.else_part.process (Current)
			end
			output.put_line ("goto " + l_end_label + ";")
			output.unindent

				-- Handle the elseif parts: generate code for their bodies
			if a_node.elsif_list /= Void then
				from
					a_node.elsif_list.finish
					i := a_node.elsif_list.count
				until
					a_node.elsif_list.before
				loop
					output.put_line (l_elseif_labels [i] + ":")
					output.indent
					l_elseif ?= a_node.elsif_list.item
					check l_elseif /= Void end
					if l_elseif.compound /= Void then
						l_elseif.compound.process (Current)
					end
					output.put_line ("goto " + l_end_label + ";")
					output.unindent
					a_node.elsif_list.back
					i := i - 1
				end
			end

				-- Handle the true branch
			output.put_line (l_if_label + ":")
			if a_node.compound /= Void then
				output.indent
				a_node.compound.process (Current)
				output.unindent
			end

			output.put_line (l_end_label + ":")
		end

	process_loop_b (a_node: LOOP_B)
		local
			l_start_label, l_end_label: STRING
			l_until_expression: STRING
		do
			safe_process (a_node.from_part)

			create_new_label ("loop_start")
			l_start_label := last_label
			create_new_label ("loop_end")
			l_end_label := last_label

			output.put_line (l_start_label + ":")
			output.indent

			expression_writer.reset
			a_node.stop.process (expression_writer)
			temporaries.append (expression_writer.temporaries)
			output.append_lines (expression_writer.side_effect_string)
			l_until_expression := expression_writer.expression_string

			output.put_line ("if " + l_until_expression + " == 1 goto " + l_end_label + ";")

			safe_process (a_node.compound)

			output.put_line ("goto " + l_start_label + ";")

			output.unindent
			output.put_line (l_end_label + ":")
		end

	process_instr_call_b (a_node: INSTR_CALL_B)
		do
			expression_writer.reset
			a_node.call.process (expression_writer)
			temporaries.append (expression_writer.temporaries)
				-- The actual expression of the call is ignored.
			output.append_lines (expression_writer.side_effect_string)
		end

	process_inspect_b (a_node: INSPECT_B)
			-- Process `a_node'.
		local
			l_exception: JS_NOT_SUPPORTED_EXCEPTION
		do
			unsupported ("Inspect statements")

				-- TODO: implement
			check false end
		end

	process_retry_b (a_node: RETRY_B)
			-- Process `a_node'.
		local
			l_exception: JS_NOT_SUPPORTED_EXCEPTION
		do
			unsupported ("Retry")

				-- TODO: implement
			check false end
		end

	process_reverse_b (a_node: REVERSE_B)
			-- Process `a_node'.
		local
			l_exception: JS_NOT_SUPPORTED_EXCEPTION
		do
			unsupported ("Reverse assignments")

				-- TODO: implement
			check false end
		end

	output: !JS_OUTPUT_BUFFER

feature {NONE}

	current_feature: FEATURE_I

	expression_writer: !JS_JIMPLE_EXPRESSION_GENERATOR

feature -- Label handling

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

end
