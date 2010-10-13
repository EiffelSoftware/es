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

	SEM_FIELD_NAMES

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

	text: STRING
			-- Text representation of Current
		do
			create Result.make (128)
			Result.append (once "Variable ")
			Result.append (variable.text)
			Result.append (once ": ")
			Result.append (type.name)
		end

	field_content_in_static_type_form: STRING
			-- Text of current term in static type form
		do
			Result := variables_field
		end

	field_content_in_dynamic_type_form: STRING
			-- Text of current term in static type form
		do
			Result := variables_field
		end

	field_content_in_anonymous_type_form: STRING
			-- Text of current term in static type form
		do
			Result := variables_field
		end

	operands: ARRAYED_LIST [INTEGER]
			-- Indexes of operands in Current term
		do
			create Result.make (3)
			Result.extend (queryable.variable_position (variable))
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
