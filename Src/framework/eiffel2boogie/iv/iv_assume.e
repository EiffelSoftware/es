note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_ASSUME

inherit

	IV_STATEMENT

	IV_ASSERTION

create
	make

feature -- Visitor

	process (a_visitor: IV_STATEMENT_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_assume (Current)
		end

end
