note
	description: "Class that represents a term based on an equation (precondition, postcondition, properties)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEM_EQUATION_TERM

inherit
	SEM_EXPR_VALUE_TERM

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

	field_content_in_static_type_form: STRING
			-- Text of current term in static type form
		do
			Result := queryable.text_in_static_type_form (expression)
		end

	field_content_in_dynamic_type_form: STRING
			-- Text of current term in static type form
		do
			Result := queryable.text_in_dynamic_type_form (expression)
		end

	field_content_in_anonymous_type_form: STRING
			-- Text of current term in static type form
		do
			Result := queryable.text_in_anonymous_type_form (expression)
		end

	operands: LINKED_LIST [INTEGER]
			-- Indexes of operands in Current term
		do
			Result := operand_indexes (field_content_in_anonymous_type_form)
		end

end
