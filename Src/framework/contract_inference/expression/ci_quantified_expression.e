note
	description: "Quantified expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_QUANTIFIED_EXPRESSION

inherit
	EPA_SHARED_EQUALITY_TESTERS
		undefine
			out
		end

	HASHABLE
		undefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

	EPA_STRING_UTILITY
		undefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_index: INTEGER; a_predicate: like predicate; a_scope: like scope; a_for_all: BOOLEAN; a_operand_map: like operand_map)
			-- Initialize Current.
		do
			quantified_variable_operand_index := a_index
			predicate := a_predicate
			scope := a_scope
			is_for_all := a_for_all
			operand_map := a_operand_map.twin
		end

feature -- Access

	quantified_variable_operand_index: INTEGER
			-- Index of the quanfied variable as operand in `predicate'

	quantified_variabale_type: TYPE_A
			-- Type of current quantified variable
		do
			Result := predicate.argument_type (quantified_variable_operand_index)
		end

	scope: CI_QUANTIFIED_SCOPE
			-- Scope of the quantified variable

	predicate: EPA_FUNCTION
			-- Predicate of current quantified expression

	operand_map: HASH_TABLE [INTEGER, INTEGER]
			-- Map from 1-based operand index in `predicate' to 0-based operand index in the feature under test
			-- Key is 1-based operand index of `predicate', value is 0-based operand index in the feature under test

	quantifier_free_functions (a_context: CI_TEST_CASE_TRANSITION_INFO): DS_HASH_SET [EPA_FUNCTION]
			-- Set of quantifier free expressions
			-- with the quantifier replaced with a value in `scope' in `a_context'
		local
			l_values: DS_HASH_SET [EPA_FUNCTION]
			l_cursor: DS_HASH_SET_CURSOR [EPA_FUNCTION]
			l_predicate: like predicate
			l_quantified_variable_operand_index: INTEGER
		do
			l_quantified_variable_operand_index := quantified_variable_operand_index
			create Result.make (5)
			Result.set_equality_tester (function_equality_tester)

			l_predicate := predicate
			l_values := scope.scope (a_context)
			from
				l_cursor := l_values.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.force_last (l_predicate.partially_evalauted (l_cursor.item, l_quantified_variable_operand_index))
				l_cursor.forth
			end
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := predicate.hash_code
		end

	quantifier_name: STRING
			-- Name of the quantifier
		do
			if is_for_all then
				Result := once "forall"
			else
				Result := once "exists"
			end
		end

feature -- Status report

	is_for_all: BOOLEAN
			-- Is `predicate' quantified by a for_all quantifier?

	is_there_exists: BOOLEAN
			-- Is `predicate' quantified by a there_exists quantifier?
		do
			Result := not is_for_all
		end

feature -- Debug

	out, debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (64)
			Result.append (quantifier_name)
			Result.append (curly_brace_surrounded_integer (quantified_variable_operand_index))
			Result.append (once " :: ")
			Result.append (predicate.debug_output)
		end

end
