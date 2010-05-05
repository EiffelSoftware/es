note
	description: "Objects that represent trnasitions in semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TRANSITION

inherit
	SEM_QUERYABLE

feature -- Access

	inputs: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of variables used as inputs to Current transition			

	outputs: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of variables used as outputs of Current transision

	intermediate_variables: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of intermediate local variables
			-- Note: a new copy is created every time.
		do
			Result := variables.subtraction (inputs).subtraction (outputs)
		end

	precondition: EPA_STATE assign set_precondition
			-- Precondition of Current transition

	postcondition: EPA_STATE assign set_postcondition
			-- Postcondition of Current transition

	precondition_boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `precondition'
			-- Key is an equation in `precondition', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).

	postcondition_boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `postcondition'
			-- Key is an equation in `postcondition', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).			

	precondition_by_anonymous_expression_text (a_expr_text: STRING): detachable EPA_EQUATION
			-- Precondition equation from `precondition' by anonymouse `a_expr_text' in
			-- the form of "{0}.has ({1})".
			-- Void if no such equation is found.
		do
			Result := equation_by_anonymous_expression_text (a_expr_text, precondition)
		end

	postcondition_by_anonymous_expression_text (a_expr_text: STRING): detachable EPA_EQUATION
			-- Precondition equation from `postcondition' by anonymouse `a_expr_text' in
			-- the form of "{0}.has ({1})".
			-- Void if no such equation is found.
		do
			Result := equation_by_anonymous_expression_text (a_expr_text, postcondition)
		end

	name: STRING
			-- Name of current transition
		deferred
		end

	description: STRING
			-- Description of current transition
		deferred
		ensure
			result_attached: Result /= Void
		end

	content: STRING
			-- String representing the content of Current transition
			-- Can be a piece of code, should be in a form where all variable names are
			-- normalized, for example:
			-- {1}.extend ({2})
			-- {1} and {2} represent the first and second variable, respectively.
		deferred
		ensure
			result_attached: Result /= Void
		end

feature -- Status setting

	set_precondition (a_pre: like precondition)
			-- Set `precondition' with 'a_pre'.
		do
			set_state (a_pre, precondition)
		end

	set_postcondition (a_post: like postcondition)
			-- Set `postcondition' with 'a_post'.
		do
			set_state (a_post, postcondition)
		end

feature -- Status report

	is_input_variable (a_variable: EPA_EXPRESSION): BOOLEAN
			-- Is `a_variable' an input variable?
		do
			Result := inputs.has (a_variable)
		end

	is_output_variable (a_variable: EPA_EXPRESSION): BOOLEAN
			-- Is `a_variable' an output variable?
		do
			Result := outputs.has (a_variable)
		end

	is_operand_variable (a_variable: EPA_EXPRESSION): BOOLEAN
			-- Is `a_variable' an operand variable (either input or output)?
		do
			Result := is_input_variable (a_variable) or else is_output_variable (a_variable)
		end

	is_valid_precondition (a_equation: EPA_EQUATION): BOOLEAN
			-- Is `a_expr' a valid precondition assertion?
		do
			Result := context.expression_type (a_equation.expression.ast) /= Void
		end

	is_valid_postcondition (a_equation: EPA_EQUATION): BOOLEAN
			-- Is `a_equation' a valid postcondition assertion?
		do
			Result := context.expression_type (a_equation.expression.ast) /= Void
		end

feature -- Setting

	extend_ast_precondition_equation (a_equation: EPA_EQUATION)
			-- Extend `a_equation' into `precondition'.
		require
			a_expr_valid: is_valid_precondition (a_equation)
		do
			precondition.force_last (a_equation)
		end

	extend_ast_postcondition_equation (a_equation: EPA_EQUATION)
			-- Extend `a_equation' into `postcondition'.
		require
			a_expr_valid: is_valid_postcondition (a_equation)
		do
			postcondition.force_last (a_equation)
		end

	put_variable (a_variable: EPA_EXPRESSION; a_position: INTEGER; a_input: BOOLEAN; a_output: BOOLEAN)
			-- Add `a_variable' as the `a_position'-th position in Current transition.
			-- `a_input' indicates whether `a_variable' is an input.
			-- `a_output' indicates whether `a_variable' is an output.
		require
			a_variable_not_exist: not variables.has (a_variable)
			valid_input: a_input implies not inputs.has (a_variable)
			valid_output: a_output implies not outputs.has (a_variable)
		do
			variables.force_last (a_variable)
			variable_positions.force_last (a_position, a_variable)
			inputs.force_last (a_variable)
			outputs.force_last (a_variable)
		end

feature{NONE} -- Implementation

	initialize_boosts
			-- Initialize `precondition_boosts' and `postcondition_boosts'.
		do
			create precondition_boosts.make (20)
			precondition_boosts.set_key_equality_tester (equation_equality_tester)
			create postcondition_boosts.make (20)
			postcondition_boosts.set_key_equality_tester (equation_equality_tester)
		end

invariant
	inputs_valid: inputs.for_all (agent variables.has)
	outputs_valid: outputs.for_all (agent variables.has)
	inputs_equality_tester_valid: inputs.equality_tester = expression_equality_tester
	outputs_equality_tester_valid: outputs.equality_tester = expression_equality_tester
	precondition_equality_tester_valid: precondition.equality_tester = equation_equality_tester
	postcondition_equality_tester_valid: postcondition.equality_tester = equation_equality_tester
	precondition_boosts_valid: precondition_boosts.keys.for_all (agent precondition.has)
	precondition_boosts_key_equality_tester_valid: precondition_boosts.key_equality_tester = equation_equality_tester
	postcondition_boosts_valid: postcondition_boosts.keys.for_all (agent postcondition.has)
	postcondition_boosts_key_equality_tester_valid: postcondition_boosts.key_equality_tester = equation_equality_tester

end
