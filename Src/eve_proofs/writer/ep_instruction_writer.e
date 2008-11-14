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

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do
			create output.make
			create expression_writer.make (create {EP_NORMAL_NAME_MAPPER}.make)
		end

feature -- Access

	output: EP_OUTPUT_BUFFER
		-- Buffer where output is stored

feature -- Basic operations

	reset
			-- Reset output buffer.
		do
			output.reset
			output.set_indentation ("    ")
		end

feature -- Processing

	process_assign_b (a_node: ASSIGN_B)
			-- Process `a_node'.
		do

		end

	process_check_b (a_node: CHECK_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Check: ignored")
				-- TODO: add error
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
			output.put_comment_line ("Debug (" + l_keys + ") ignored")
				-- Ignore debug clauses
		end

	process_if_b (a_node: IF_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("If: ignored")
				-- TODO: add error
		end

	process_inspect_b (a_node: INSPECT_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Inspect statement: ignored")
				-- TODO: add error
		end

	process_instr_call_b (a_node: INSTR_CALL_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Instruction call: ignored")
				-- TODO: add error
		end

	process_loop_b (a_node: LOOP_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Loop: ignored")
				-- TODO: add error
		end

	process_retry_b (a_node: RETRY_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Retry instruction: ignored")
				-- TODO: add error
		end

	process_reverse_b (a_node: REVERSE_B)
			-- Process `a_node'.
		do
			output.put_comment_line ("Reverse assignment: ignored")
				-- TODO: add error
		end

feature {NONE} -- Implementation

	expression_writer: !EP_EXPRESSION_WRITER
			-- Writer used to produce Boogie code for expressions

end
