note
	description: "Class that represents term for a variable"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_VARIABLE_TERM

inherit
	SEM_TERM
		redefine
			is_variable
		end

create
	make

feature{NONE} -- Initialization

	make (a_queryable: like queryable; a_variable: EPA_EXPRESSION)
			-- Initialize Current.
		do
			initialize
			queryable := a_queryable
			variable := a_variable
		end

feature -- Access

	variable: EPA_EXPRESSION
			-- Expression of current variable

	type: TYPE_A
			-- Type of current variable
		do
			Result := variable.type
		end

feature -- Status report

	is_variable: BOOLEAN = True
			-- Is current a variable term?

feature -- Process

	process (a_visitor: SEM_TERM_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_variable_term (Current)
		end


end
