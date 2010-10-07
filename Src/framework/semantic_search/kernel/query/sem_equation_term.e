note
	description: "Class that represents a term based on an equation (precondition, postcondition, properties)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_EQUATION_TERM

inherit
	SEM_TERM

feature -- Access

	equation: EPA_EQUATION
			-- Equation of current contract, is must from `queryable'

	expression: EPA_EXPRESSION
			-- Expression of `equation'
		do
			Result := equation.expression
		end

	value: EPA_EXPRESSION_VALUE
			-- Value of `equation'
		do
			Result := equation.value
		end

	type: TYPE_A
			-- Type of `equation'
		do
			Result := equation.expression.type
		end

end
