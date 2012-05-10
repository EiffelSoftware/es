note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_POSTCONDITION

inherit

	IV_CONTRACT

	IV_ASSERTION

create
	make

feature -- Status report

	is_free: BOOLEAN
			-- Is this a free contract?

feature -- Status setting

	set_free
			-- Set this contract to be free.
		do
			is_free := True
		ensure
			free: is_free
		end

feature -- Visitor

	process (a_visitor: IV_CONTRACT_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_postcondition (Current)
		end

end
