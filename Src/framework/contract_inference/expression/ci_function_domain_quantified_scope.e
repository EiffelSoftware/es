note
	description: "Class that represents a scope which is defined by the domain of a function"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_FUNCTION_DOMAIN_QUANTIFIED_SCOPE

inherit
	CI_QUANTIFIED_SCOPE

	EPA_SHARED_EQUALITY_TESTERS

create
	make

feature{NONE} -- Initialization

	make (a_function: like function; a_operand_index: INTEGER; a_pre_state: BOOLEAN)
			-- Initialize `function' with `a_function' and
			-- `is_pre_state' with `a_pre_state'.
		require
			a_operand_index_valid: a_operand_index >= 1 and a_function.arity <= a_operand_index + 1
		do
			function := a_function
			is_pre_state := a_pre_state
			operand_index := a_operand_index
		end

feature -- Access

	scope (a_context: CI_TEST_CASE_TRANSITION_INFO): DS_HASH_SET [EPA_FUNCTION]
			-- Values in current scope
		local
			l_state: like state_valuations
			l_valuations: EPA_FUNCTION_VALUATIONS
		do
			create Result.make (5)
			Result.set_equality_tester (function_equality_tester)

			l_state := state_valuations (a_context, is_pre_state)
			l_state.search (function)
			if l_state.found then
				l_valuations := l_state.found_item
				l_valuations.values.item (operand_index).do_all (agent Result.force_last)
			end
		end

	function: EPA_FUNCTION
			-- Function whose domain defines current scope

	operand_index: INTEGER
			-- Index of the operand whose domain defined current scope

feature{NONE} -- Implementation

	state_valuations (a_context: CI_TEST_CASE_TRANSITION_INFO; a_pre_state: BOOLEAN): DS_HASH_TABLE [EPA_FUNCTION_VALUATIONS, EPA_FUNCTION]
			-- Expression valuation from `a_context'
			-- `a_pre_state' indicates whether the expressions are evaluated before or
			-- after test case execution.
		do
			if a_pre_state then
				Result := a_context.pre_state_valuations
			else
				Result := a_context.post_state_valuations
			end
		end

end
