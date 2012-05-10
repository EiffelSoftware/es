note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_FORALL

inherit

	IV_QUANTIFIER

create
	make

feature -- Visitor

	process (a_visitor: IV_EXPRESSION_VISITOR)
			-- Process `a_visitor'.
		do
			a_visitor.process_forall (Current)
		end

end
