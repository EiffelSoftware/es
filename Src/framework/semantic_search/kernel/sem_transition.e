note
	description: "Objects that represent trnasitions in semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TRANSITION

inherit
	SEM_QUERYABLE
		redefine
			is_transition
		end

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
			-- Assertions may mention variables other than feature operands.
			-- For a list of assertions only mentioning feature operands, see `interface_precondition'.
			-- Relationship: `precondition' is a superset of `interface_precondition',
			-- `interface_preconditoin' is a superset of `written_precondition'.

	postcondition: EPA_STATE assign set_postcondition
			-- Postcondition of Current transition
			-- Assertions may mention variables other than feature operands (including result).
			-- Assertions may mention variables other than feature operands (including result).
			-- For a list of assertions only mentioning feature operands, see `interface_postcondition'.
			-- Relationship: `postcondition' is a superset of `interface_postcondition',
			-- `interface_postconditoin' is a superset of `written_postcondition'.

	precondition_boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `precondition'
			-- Key is an equation in `precondition', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).

	postcondition_boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `postcondition'
			-- Key is an equation in `postcondition', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).			

	written_preconditions: EPA_STATE
			-- Human written preconditions (if any) for current transition
			-- This is a subset of `preconditions'.

	written_postconditions: EPA_STATE
			-- Human written postconditions (if any) for current transition
			-- This is a subset of `postcondition'.

	interface_precondition: EPA_STATE
			-- Precondition assertions from `precondition' which only mention feature operands
			-- Note: Recalculation per query, so it is expensive.
		do
			Result := interface_assertions (precondition)
		end

	interface_postcondition: EPA_STATE
			-- Postcondition assertions from `postcondition' which only mention feature operands (including result)
			-- Note: Recalculation per query, so it is expensive.
		do
			Result := interface_assertions (postcondition)
		end

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

	description: STRING
			-- Description of current transition

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

	set_precondition_boosts (a_precondition_boosts: like precondition_boosts)
			-- Set `precondition_boosts' with `a_precondition_boosts'.
		do
			precondition_boosts := a_precondition_boosts.cloned_object
		end

	set_postcondition_boosts (a_postcondition_boosts: like postcondition_boosts)
			-- Set `postcondition_boosts' with `a_postcondition_boosts'.
		do
			postcondition_boosts := a_postcondition_boosts.cloned_object
		end

	set_name (a_name: like name)
			-- Set `name' with `a_name'.
			-- Make a copy of `a_name'.
		do
			name := a_name.twin
		ensure
			name_set: name ~ a_name
		end

	set_description (a_description: like description)
			-- Set `description' with `a_description'.
			-- Make a copy of `a_description'.
		do
			description := a_description.twin
		ensure
			description_set: description ~ a_description
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

	is_transition: BOOLEAN = True
			-- Is Current a transition querable (either a feature call or a snippet)?

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

	initialize_tables
			-- Initialize serval tables.
		do
			create variables.make (5)
			variables.set_equality_tester (expression_equality_tester)

			create variable_positions.make (5)

			create reversed_variable_position.make (5)

			create inputs.make (5)
			inputs.set_equality_tester (expression_equality_tester)

			create outputs.make (5)
			outputs.set_equality_tester (expression_equality_tester)
		end

	interface_assertions (a_state: EPA_STATE): EPA_STATE
			-- Assertions from `a_state' which only mention feature operands (including result)
		local
			l_expr_rewriter: like  expression_rewriter
			l_replacements: HASH_TABLE [STRING, STRING]
			l_equation: EPA_EQUATION
			l_expr: EPA_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_should_keep: BOOLEAN
			l_dummy_var_name: STRING
		do
				-- Collect the set of intermediate variables.
			l_dummy_var_name := "{_}"
			create l_replacements.make (5)
			l_replacements.compare_objects
			intermediate_variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING]; a_dummy_var_name: STRING)
					do
						a_tbl.put (a_dummy_var_name, a_expr.text)
					end (?, l_replacements, l_dummy_var_name))

			l_expr_rewriter := expression_rewriter
			Result := a_state.cloned_object
			from
				Result.start
			until
				Result.after
			loop
				l_equation := Result.item_for_iteration
				l_expr := l_equation.expression
				l_value := l_equation.value
				if
					l_expr_rewriter.expression_text (l_expr, l_replacements).has_substring (l_dummy_var_name) or else
					l_expr_rewriter.expression_value_text (l_value, l_replacements).has_substring (l_dummy_var_name)
				then
					Result.remove (l_equation)
				else
					Result.forth
				end
			end
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
	precondition_postcondition_consistent: precondition.class_ = postcondition.class_ and precondition.feature_ = postcondition.feature_

end
