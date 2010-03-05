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

feature{NONE} -- Implementation

	is_operand_position_valid (a_position: INTEGER; a_operand: EPA_EXPRESSION): BOOLEAN
			-- Is `a_operand' in `a_position' valid?
		do
			Result :=
				operands.has (a_operand) and then
				a_position >= 0
		end

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
