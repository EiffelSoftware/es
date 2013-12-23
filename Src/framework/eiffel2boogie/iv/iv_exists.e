note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_EXISTS

inherit

	IV_QUANTIFIER

create
	make

feature -- Comparison

	same_expression (a_other: IV_EXPRESSION): BOOLEAN
			-- Does this expression equal `a_other' (if considered in the same context)?
			-- ToDo: this is not really correct, we should be comparing DeBrujn versions.
		do
			Result := attached {IV_FORALL} a_other as q and then
				(expression.same_expression (q.expression) and
				bound_variables.count = q.bound_variables.count and
				across 1 |..| bound_variables.count as i all
					bound_variables [i.item].entity.same_expression (q.bound_variables [i.item].entity)
				end)
		end

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- Process `a_visitor'.
		do
			a_visitor.process_exists (Current)
		end

end
