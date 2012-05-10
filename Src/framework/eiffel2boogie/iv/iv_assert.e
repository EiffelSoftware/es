note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_ASSERT

inherit

	IV_STATEMENT

	IV_ASSERTION

create
	make

feature -- Visitor

	process (a_visitor: IV_STATEMENT_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_assert (Current)
		end

end
