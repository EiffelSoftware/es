note
	description: "Class that represents a term for a change in transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CHANGE_TERM

inherit
	SEM_TERM
		redefine
			queryable,
			is_change
		end

create
	make

feature{NONE} -- Initialization

	make (a_queryable: like queryable; a_expression: like expression; a_change: like change)
			-- Initialize Current.
		do
			initialize
			queryable := a_queryable
			expression := a_expression
			change := a_change
		end

feature -- Access

	expression: EPA_EXPRESSION
			-- Expression of the change

	change: LIST [EPA_EXPRESSION_CHANGE]
			-- Changes of the `expression'

	queryable: SEM_TRANSITION
			-- Transion where current term is from

feature -- Status report

	is_change: BOOLEAN = True
			-- Is current a term for a change?

feature -- Process

	process (a_visitor: SEM_TERM_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_change_term (Current)
		end

end
