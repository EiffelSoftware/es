note
	description: "Objects that represent trnasitions in semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_TRANSITION

inherit
	SEM_QUERYABLE
		rename
			preconditions as extracted_preconditions,
			postconditions as extracted_postconditions
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

	preconditions: EPA_STATE assign set_preconditions
			-- Precondition of Current transition
			-- Assertions may mention variables other than feature operands.
			-- For a list of assertions only mentioning feature operands, see `interface_preconditions'.
			-- Relationship: `preconditions' is a superset of `interface_preconditions',
			-- `interface_preconditoin' is a superset of `written_precondition'.

	postconditions: EPA_STATE assign set_postconditions
			-- Postcondition of Current transition
			-- Assertions may mention variables other than feature operands (including result).
			-- Assertions may mention variables other than feature operands (including result).
			-- For a list of assertions only mentioning feature operands, see `interface_postconditions'.
			-- Relationship: `postconditions' is a superset of `interface_postconditions',
			-- `interface_postconditoin' is a superset of `written_postcondition'.

	assertions (a_precondition: BOOLEAN): like preconditions
			-- Return `preconditions' if `a_precondition' is True,
			-- otherwise, return `postconditions'.
		do
			if a_precondition then
				Result := preconditions
			else
				Result := postconditions
			end
		end

	precondition_boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `preconditions'
			-- Key is an equation in `preconditions', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).

	postcondition_boosts: DS_HASH_TABLE [DOUBLE, EPA_EQUATION]
			-- Boost values for equations in `postconditions'
			-- Key is an equation in `postconditions', value is the boost number associated with that equation.
			-- The boost numbers will be used as boost values for a field (in Lucene sense).			

	assertion_boosts (a_precondition: BOOLEAN): like precondition_boosts
			-- Return `precondition_boosts' if `a_precondition' is True,
			-- otherwise, return `postcondition_boosts'.
		do
			if a_precondition then
				Result := precondition_boosts
			else
				Result := postcondition_boosts
			end
		end

	written_preconditions: EPA_STATE
			-- Human written preconditions (if any) for current transition
			-- This is a subset of `preconditions'.

	written_postconditions: EPA_STATE
			-- Human written postconditions (if any) for current transition
			-- This is a subset of `postconditions'.

	written_assertions (a_precondition: BOOLEAN): like written_preconditions
			-- Return `written_preconditions' if `a_precondition' is True,
			-- otherwise, return `written_postconditions'.
		do
			if a_precondition then
				Result := written_preconditions
			else
				Result := written_postconditions
			end
		end

	interface_preconditions: EPA_STATE
			-- Precondition assertions from `preconditions' which only mention feature operands
			-- Note: Recalculation per query, so it is expensive.
		do
			Result := interface_assertions_internal (preconditions)
		end

	interface_postconditions: EPA_STATE
			-- Postcondition assertions from `postconditions' which only mention feature operands (including result)
			-- Note: Recalculation per query, so it is expensive.
		do
			Result := interface_assertions_internal (postconditions)
		end

	interface_assertions (a_precondition: BOOLEAN): like interface_preconditions
			-- Return `interface_preconditions' if `a_precondition' is True,
			-- otherwise, return `interface_postconditions'.
		do
			if a_precondition then
				Result := interface_preconditions
			else
				Result := interface_postconditions
			end
		end

	assertion_by_anonymouse_expression_text (a_expr_text: STRING; a_precondition: BOOLEAN): detachable EPA_EQUATION
			-- Precondition equation from `preconditions' by anonymouse `a_expr_text' if `a_precondition' is True,
			-- otherwise, postcondition equation.
		do
			if a_precondition then
				Result := precondition_by_anonymous_expression_text (a_expr_text)
			else
				Result := postcondition_by_anonymous_expression_text (a_expr_text)
			end
		end

	precondition_by_anonymous_expression_text (a_expr_text: STRING): detachable EPA_EQUATION
			-- Precondition equation from `preconditions' by anonymouse `a_expr_text' in
			-- the form of "{0}.has ({1})".
			-- Void if no such equation is found.
		do
			Result := equation_by_anonymous_expression_text (a_expr_text, preconditions, True)
		end

	postcondition_by_anonymous_expression_text (a_expr_text: STRING): detachable EPA_EQUATION
			-- Precondition equation from `postconditions' by anonymouse `a_expr_text' in
			-- the form of "{0}.has ({1})".
			-- Void if no such equation is found.
		do
			Result := equation_by_anonymous_expression_text (a_expr_text, postconditions, False)
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

	uuid: detachable STRING
			-- UUID of current transition

	cloned_object: like Current
			-- Clonded object
		deferred
		end

	as_interface_transition: like Current
			-- Interface transition of Current
			-- Make a copy of current.
		deferred
		end

	sem_equation_from_equation (a_equation: EPA_EQUATION; a_is_precondition: BOOLEAN; a_is_written: BOOLEAN): SEM_EQUATION
			-- Equation from `a_equation'
			-- `a_is_precondition' indicates if `a_equation' is from pre-state.
			-- `a_is_written' indicates if `a_equation' is human-written.
		do
			create Result.make (a_equation, a_is_precondition, a_is_written)
		end

feature -- Status setting

	set_preconditions (a_pre: like preconditions)
			-- Set `preconditions' with 'a_pre'.
		do
			set_state (a_pre, preconditions)
		end

	set_postconditions (a_post: like postconditions)
			-- Set `postconditions' with 'a_post'.
		do
			set_state (a_post, postconditions)
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

	set_uuid (a_uuid: like uuid)
			-- Set `uuid' with `a_uuid'.
		do
			if a_uuid = Void then
				uuid := Void
			else
				uuid := a_uuid.twin
			end
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
			-- Extend `a_equation' into `preconditions'.
		require
			a_expr_valid: is_valid_precondition (a_equation)
		do
			preconditions.force_last (a_equation)
		end

	extend_ast_postcondition_equation (a_equation: EPA_EQUATION)
			-- Extend `a_equation' into `postconditions'.
		require
			a_expr_valid: is_valid_postcondition (a_equation)
		do
			postconditions.force_last (a_equation)
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

	interface_assertions_internal (a_state: EPA_STATE): EPA_STATE
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

	extend_equation_into_hash_set (a_equation: EPA_EQUATION; a_is_precondition: BOOLEAN; a_is_human_written: BOOLEAN; a_hash_set: DS_HASH_SET [SEM_EQUATION])
			-- Extend `a_equation' into `a_hash_set'.
			-- `a_is_precondition' indicates if `a_equation' is from pre-state.
			-- `a_is_human_written' indicates if `a_equation' is human-provided.
		do
			a_hash_set.force_last (create {SEM_EQUATION}.make (a_equation, a_is_precondition, a_is_human_written))
		end

invariant
	inputs_valid: inputs.for_all (agent variables.has)
	outputs_valid: outputs.for_all (agent variables.has)
	inputs_equality_tester_valid: inputs.equality_tester = expression_equality_tester
	outputs_equality_tester_valid: outputs.equality_tester = expression_equality_tester
	precondition_equality_tester_valid: preconditions.equality_tester = equation_equality_tester
	postcondition_equality_tester_valid: postconditions.equality_tester = equation_equality_tester
	precondition_boosts_valid: precondition_boosts.keys.for_all (agent preconditions.has)
	precondition_boosts_key_equality_tester_valid: precondition_boosts.key_equality_tester = equation_equality_tester
	postcondition_boosts_valid: postcondition_boosts.keys.for_all (agent postconditions.has)
	postcondition_boosts_key_equality_tester_valid: postcondition_boosts.key_equality_tester = equation_equality_tester
	precondition_postcondition_consistent: preconditions.class_ = postconditions.class_ and preconditions.feature_ = postconditions.feature_

end
