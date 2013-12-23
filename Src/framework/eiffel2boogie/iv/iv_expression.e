note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IV_EXPRESSION

feature -- Access

	type: IV_TYPE
			-- Type of expression.
		deferred
		end

	is_false: BOOLEAN
			-- Is this expression literal "false"?
		do
		end

	is_true: BOOLEAN
			-- Is this expression literal "true"?
		do
		end

feature -- Comparison

	same_expression (a_other: IV_EXPRESSION): BOOLEAN
			-- Does this expression equal `a_other' (if considered in the same context)?
		deferred
		end

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- Process `a_visitor'.
		deferred
		end

invariant
	type_attached: attached type

end
