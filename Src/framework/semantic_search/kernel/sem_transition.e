note
	description: "Objects that represent trnasitions in semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TRANSITION

inherit
	EPA_SHARED_EQUALITY_TESTERS

	REFACTORING_HELPER

feature -- Access

	operands: EPA_HASH_SET [EPA_EXPRESSION]
			-- Operands mentioned in Current transition

	operand_positions: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			-- Table of positions for `operands'.
			-- Key is a operand, value is the 0-based appearing index of that
			-- operand in Current transition.

	inputs: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of variables used as inputs to Current transition

	outputs: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of variables used as outputs of Current transision

	precondition: EPA_STATE
			-- Precondition of Current transition

	postcondition: EPA_STATE
			-- Postcondition of Current transition

	content: STRING
			-- String representing the content of Current transition
			-- Can be a piece of code, should be in a form where all variables are
			-- normalized, for example:
			-- {1}.extend ({2})
			-- {1} and {2} represent the first and second operand, respectively.
		deferred
		ensure
			result_attached: Result /= Void
		end

	anonymous_expressoin_text (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' with all accesses to variables replaced by anonymoue names
			-- For example, "has (v)" will be: "{0}.has ({1})".
		local
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			create l_replacements.make (operands.count)
			l_replacements.compare_objects
			operand_positions.do_all_with_key (
				agent (a_position: INTEGER; a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING])
					do
						a_tbl.put (anonymous_operand_name (a_position), a_expr.text.as_lower)
					end (?, ?, l_replacements))

			Result := expression_rewriter.expression_text (a_expression, l_replacements)
		end

	typed_expression_text (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' with all accesses to variables replaced by the variables' static type
			-- For example, "has (v)" in LINKED_LIST [ANY] will be: {LINKED_LIST [ANY]}.has ({ANY})".
		local
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			create l_replacements.make (operands.count)
			l_replacements.compare_objects
			operands.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING])
					local
						l_type: STRING
					do
						l_type := a_expr.resolved_type.name
						l_type.replace_substring_all (once "?", once "")
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, l_replacements))

			Result := expression_rewriter.expression_text (a_expression, l_replacements)
		end

	context: STRING
			-- Context of current transition
		deferred
		end

feature{NONE} -- Implementation

	is_operand_position_valid (a_position: INTEGER; a_operand: EPA_EXPRESSION): BOOLEAN
			-- Is `a_operand' in `a_position' valid?
		do
			Result :=
				operands.has (a_operand) and then
				a_position >= 0
		end

	anonymous_operand_name (a_position: INTEGER): STRING
			-- Anonymous name for `a_position'-th operand
			-- Format: {`a_position'}, for example "{0}".
		do
			create Result.make (4)
			Result.append_character ('{')
			Result.append (a_position.out)
			Result.append_character ('}')
		end

	put_operand (a_operand: EPA_EXPRESSION; a_position: INTEGER; a_input: BOOLEAN; a_output: BOOLEAN)
			-- Add `a_operand' as the `a_position'-th position in Current transition.
			-- `a_input' indicates whether `a_operand' is an input.
			-- `a_output' indicates whether `a_operand' is an output.
		require
			a_operand_not_exist: not operands.has (a_operand)
		do
			operands.force_last (a_operand)
			operand_positions.force_last (a_position, a_operand)
			inputs.force_last (a_operand)
			outputs.force_last (a_operand)
		end

feature{NONE} -- Implementation

	expression_rewriter: SEM_TRANSITION_EXPRESSION_REWRITER
			-- Expression rewriter to rewrite `operands' in anonymous format.
		do
			if attached {SEM_TRANSITION_EXPRESSION_REWRITER} expression_rewriter_internal as l_rewriter then
				Result := l_rewriter
			else
				create expression_rewriter_internal.make
				Result := expression_rewriter_internal
			end
		end

	expression_rewriter_internal: detachable like expression_rewriter
			-- Cache of `expression_rewriter'

invariant
	operand_positions_valid: operand_positions.for_all_with_key (agent is_operand_position_valid)
	inputs_valid: inputs.for_all (agent operands.has)
	outputs_valid: outputs.for_all (agent operands.has)
	operands_equality_tester_valid: operands.equality_tester = expression_equality_tester
	operand_positions_equality_tester_valid: operand_positions.key_equality_tester = expression_equality_tester
	inputs_equality_tester_valid: inputs.equality_tester = expression_equality_tester
	outputs_equality_tester_valid: outputs.equality_tester = expression_equality_tester
	precondition_equality_tester_valid: precondition.equality_tester = equation_equality_tester
	postcondition_equality_tester_valid: postcondition.equality_tester = equation_equality_tester

end
