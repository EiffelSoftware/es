note
	description: "Class that represents a matching criterion in semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_MATCHING_CRITERION

inherit
	HASHABLE

	DEBUG_OUTPUT

	SHARED_WORKBENCH

create
	make

feature{NONE} -- Initialization

	make (a_criterion: like criterion; a_value: like value; a_variables: like variables; a_variable_types: like variable_types)
			-- Initialize.
		do
			criterion := a_criterion
			variables := a_variables
			value := a_value
			hash_code := criterion.hash_code
			variable_types := a_variable_types
		end

feature -- Access

	criterion: STRING
			-- Text of Current criterion content

	variables: ARRAYED_LIST [INTEGER]
			-- IDs of variables mentioned in Current criterion.
			-- The order of the operands are the same as their appearing
			-- order in `criterion'

	variable_type (i: INTEGER): TYPE_A
			-- Type of the variable with index `i'
		require
			i_valid: variable_types.has (i)
		do
			Result := variable_types.item (i)
		end

	variable_types: HASH_TABLE [TYPE_A, INTEGER]
			-- Types of variables
			-- Key is index of variables in `variables', value is the type of that variable

	variable_count: INTEGER
			-- Number of mentioned variables in `criterion'
		do
			Result := variables.count
		ensure
			good_result: Result = variables.count
		end

	value: IR_VALUE
			-- Value of current criterion		

	text: STRING
			-- String representation of Current
		do
			create Result.make (128)
			Result.append (criterion)
			Result.append (once " == ")
			Result.append (value.text)
			Result.append (once ", operands: ")
			across variables as l_operands loop
				Result.append_character (',')
				Result.append (l_operands.item.out)
			end
		end

	term: detachable SEM_TERM
			-- Term associated with current criterion

feature -- Access

	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	is_variable_type_conformant_to (a_variable, b_variable: TYPE_A): BOOLEAN
			-- Is `a_variable' conforms to `b_variable'?
		local
			l_context: CLASS_C
		do
			l_context := workbench.system.root_type.associated_class
			Result := a_variable.conform_to (l_context, b_variable)
		end

	is_negated: BOOLEAN
			-- Is the appearence of Current negated?		
		do
			if term /= Void then
				Result := term.is_negated
			end
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Setting

	set_term (a_term: like term)
			-- Set `term' with `a_term'.
		do
			term := a_term
		ensure
			term_set: term = a_term
		end
		
end
