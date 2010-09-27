note
	description: "Class representing an expression = value equation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_EQUATION

inherit
	HASHABLE

create
	make

feature{NONE} -- Initialization

	make (a_equation: like equation; a_is_precondition: BOOLEAN; a_is_human_written: BOOLEAN)
			-- Initialize Current.
		do
			equation := a_equation
			is_precondition := a_is_precondition
			is_human_written := a_is_human_written
		end

feature -- Access

	equation: EPA_EQUATION
			-- Equation represented by current

	hash_code: INTEGER
			-- Hash code value
		do
			Result := equation.hash_code
		end

	text: STRING
			-- Text representation of current
		do
			Result := equation.text
		end

	type: TYPE_A
			-- Type of the expression inside `equation'
		do
			Result := equation.type
		end

	expression: EPA_EXPRESSION
			-- Expression inside `equation'
		do
			Result := equation.expression
		end

	value: EPA_EXPRESSION_VALUE
			-- Value index `equation'.
		do
			Result := equation.value
		end

feature -- Status report

	is_precondition: BOOLEAN
			-- Is current equation from pre-state?

	is_postcondition: BOOLEAN
			-- Is current equation from post-state?
		do
			Result := not is_precondition
		ensure
			good_result: Result = not is_precondition
		end

	is_human_written: BOOLEAN
			-- Is current equation written by programmer?
			-- That is, the contract assertion represented by
			-- current equation is human-provided.

end
