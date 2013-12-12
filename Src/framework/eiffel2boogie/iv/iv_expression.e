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

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- Process `a_visitor'.
		deferred
		end

invariant
	type_attached: attached type

end
