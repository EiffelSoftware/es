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

	variables: EPA_HASH_SET [EPA_EXPRESSION]
			-- Variables mentioned in Current transition
			-- Variables can be input, output or intermediate locals.
			-- Input and output variables can be seen from outside of current transition,
			-- while intermedidate locals is hidden from the outside.
			-- A variable can be both input and output. An intermediate local can neither
			-- be input nor be output.

	variable_positions: DS_HASH_TABLE [INTEGER, EPA_EXPRESSION]
			-- Table of positions for `variables'.
			-- Key is a variable, value is the 0-based appearing index of that
			-- variable in Current transition.

	reversed_variable_position: DS_HASH_TABLE [EPA_EXPRESSION, INTEGER]
			-- Revsersed table for `variable_position'
			-- Key is variable expression, value is the index of that variable

	variable_type_table: DS_HASH_TABLE [INTEGER, TYPE_A]
			-- Table of types of `variables'
			-- Key is the type, value is the number of times that a certain
			-- type appears in `variables'.
			-- Create a new table each time.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EXPRESSION]
			l_type: TYPE_A
		do
			create Result.make (variables.count)
			Result.set_key_equality_tester (
				create {AGENT_BASED_EQUALITY_TESTER [TYPE_A]}.make (
					agent (a, b: TYPE_A): BOOLEAN
						do
							Result := a.name ~ b.name
						end))

			from
				l_cursor := variables.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				l_type := l_cursor.item.resolved_type
				if Result.has (l_type) then
					Result.replace (Result.item (l_type) + 1, l_type)
				else
					Result.put (1, l_type)
				end
				l_cursor.forth
			end
		end

	inputs: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of variables used as inputs to Current transition			

	outputs: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of variables used as outputs of Current transision

	intermediate_variables: EPA_HASH_SET [EPA_EXPRESSION]
			-- List of intermediate local variables
		do
			Result := variables.subtraction (inputs).subtraction (outputs)
		end

	precondition: EPA_STATE
			-- Precondition of Current transition

	postcondition: EPA_STATE
			-- Postcondition of Current transition

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

	anonymous_expressoin_text (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' with all accesses to variables replaced by anonymoue names
			-- For example, "has (v)" will be: "{0}.has ({1})".
		local
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			create l_replacements.make (variables.count)
			l_replacements.compare_objects
			variable_positions.do_all_with_key (
				agent (a_position: INTEGER; a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING])
					do
						a_tbl.put (anonymous_variable_name (a_position), a_expr.text.as_lower)
					end (?, ?, l_replacements))

			Result := expression_rewriter.expression_text (a_expression, l_replacements)
		end

	typed_expression_text (a_expression: EPA_EXPRESSION): STRING
			-- Text of `a_expression' with all accesses to variables replaced by the variables' static type
			-- For example, "has (v)" in LINKED_LIST [ANY] will be: {LINKED_LIST [ANY]}.has ({ANY})".
		local
			l_replacements: HASH_TABLE [STRING, STRING]
		do
			create l_replacements.make (variables.count)
			l_replacements.compare_objects
			variables.do_all (
				agent (a_expr: EPA_EXPRESSION; a_tbl: HASH_TABLE [STRING, STRING])
					local
						l_type: STRING
					do
						l_type := a_expr.resolved_type.name
						l_type.replace_substring_all (once "?", once "")
						l_type.prepend_character ('{')
						l_type.append_character ('}')
						a_tbl.put (l_type, a_expr.text.as_lower)
					end (?, l_replacements))

			Result := expression_rewriter.expression_text (a_expression, l_replacements)
		end

	description: STRING
			-- Description of current transition
		deferred
		end

	environment_class: CLASS_C
			-- Environment class in which Current transition should be type checked
		deferred
		end

	environment_feature: FEATURE_I
			-- Enviroment feature in which Current transition should be type checked
		deferred
		end

	pre_state_serialization: detachable STRING
			-- Serialization data for pre-state objects

	post_state_serialization: detachable STRING
			-- Serialization data for post-state objects

	exception_trace: detachable STRING
			-- Exception trace of current transition, if any.
			-- For example, if current transition is from a failing test case,
			-- we would like to store the exception trace.

feature -- Setting

	set_pre_state_serialization (a_serialization: like pre_state_serialization)
			-- Set `pre_state_serialization' with `a_serialization'.
			-- Make a copy of `a_serialization'.
		do
			if a_serialization = Void then
				pre_state_serialization := Void
			else
				pre_state_serialization := a_serialization.twin
			end
		ensure
			pre_state_serialization_set: pre_state_serialization ~ a_serialization
		end

	set_post_state_serialization (a_serialization: like post_state_serialization)
			-- Set `post_state_serialization' with `a_serialization'.
			-- Make a copy of `a_serialization'.
		do
			if a_serialization = Void then
				post_state_serialization := Void
			else
				post_state_serialization := a_serialization.twin
			end
		ensure
			post_state_serialization_set: post_state_serialization ~ a_serialization
		end

	set_exception_trace (a_trace: like exception_trace)
			-- Set `exception_trace' with `a_trace'.
			-- Make a copy of `a_trace'.
		do
			if a_trace = Void then
				exception_trace := Void
			else
				exception_trace := a_trace.twin
			end
		ensure
			exception_trace_set: exception_trace ~ a_trace
		end

feature{NONE} -- Implementation

	is_variable_position_valid (a_position: INTEGER; a_variable: EPA_EXPRESSION): BOOLEAN
			-- Is `a_variable' in `a_position' valid?
		do
			Result :=
				variables.has (a_variable) and then
				a_position >= 0
		end

	anonymous_variable_name (a_position: INTEGER): STRING
			-- Anonymous name for `a_position'-th variable
			-- Format: {`a_position'}, for example "{0}".
		do
			create Result.make (4)
			Result.append_character ('{')
			Result.append (a_position.out)
			Result.append_character ('}')
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

	expression_rewriter: SEM_TRANSITION_EXPRESSION_REWRITER
			-- Expression rewriter to rewrite `variables' in anonymous format.
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

	extend_variable (a_variable: EPA_EXPRESSION; a_index: INTEGER)
			-- Extend `a_vairable' at `a_index' in `variables'.
		require
			a_variable_not_exists: not variables.has (a_variable)
		do
			variables.force_last (a_variable)
			variable_positions.force_last (a_index, a_variable)
			reversed_variable_position.force_last (a_variable, a_index)
		end

invariant
	variable_positions_valid: variable_positions.for_all_with_key (agent is_variable_position_valid)
	inputs_valid: inputs.for_all (agent variables.has)
	outputs_valid: outputs.for_all (agent variables.has)
	variable_equality_tester_valid: variables.equality_tester = expression_equality_tester
	variable_positions_equality_tester_valid: variable_positions.key_equality_tester = expression_equality_tester
	inputs_equality_tester_valid: inputs.equality_tester = expression_equality_tester
	outputs_equality_tester_valid: outputs.equality_tester = expression_equality_tester
	precondition_equality_tester_valid: precondition.equality_tester = equation_equality_tester
	postcondition_equality_tester_valid: postcondition.equality_tester = equation_equality_tester

end
