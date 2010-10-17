note
	description: "Class that represents a term for a property among some objects"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_PROPERTY_TERM

inherit
	SEM_EQUATION_TERM
		redefine
			queryable,
			is_property
		end

create
	make

feature{NONE} -- Initialization

	make (a_queryable: like queryable; a_equation: like equation)
			-- Initialize Current.
		do
			initialize
			queryable := a_queryable
			equation := a_equation
			set_is_negated (a_equation.is_negated)
		end

feature -- Access

	queryable: SEM_OBJECTS
			-- Objects where current term is from

	text: STRING
			-- Text representation of Current
		do
			create Result.make (128)
			Result.append (once "Property ")
			Result.append (equation.text)
		end

feature -- Status report

	is_property: BOOLEAN = True
			-- Is current a property term (for objects)?

feature -- Process

	process (a_visitor: SEM_TERM_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_property_term (Current)
		end


end
