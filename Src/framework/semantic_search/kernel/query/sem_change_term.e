note
	description: "Class that represents a term for a change in transition"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CHANGE_TERM

inherit
	SEM_EXPR_VALUE_TERM
		redefine
			queryable,
			is_change
		end

	REFACTORING_HELPER

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

	type: TYPE_A
			-- Type of `expression'
		do
			Result := expression.type
		end

	change: EPA_EXPRESSION_CHANGE
			-- Changes of the `expression'

	queryable: SEM_TRANSITION
			-- Transion where current term is from

	text: STRING
			-- Text representation of Current
		do
			create Result.make (128)
			Result.append (once "Change for ")
			Result.append (expression.text)
			Result.append (once " : ")
			if change.is_relative then
				Result.append (once "by:: ")
			else
				Result.append (once "to:: ")
			end
			Result.append (change.debug_output)
		end

	value: EPA_EXPRESSION_VALUE
			-- Value from the first value in `change'
		local
			l_value_text: STRING
		do
			fixme ("This is only a simplified solution, which may give wrong information if there are multiple values in the original change or the change value is not a boolean nor an integer. 10.10.2010 Jasonw")
			if change.values.is_no_change then
				create {EPA_ANY_VALUE} Result.make (Void)
			else
				l_value_text := change.values.first.text
				if l_value_text.is_boolean then
					create {EPA_BOOLEAN_VALUE} Result.make (l_value_text.to_boolean)
				elseif l_value_text.is_integer then
					create {EPA_INTEGER_VALUE} Result.make (l_value_text.to_integer)
				end
			end
		end

	field_content_in_static_type_form: STRING
			-- Text of current term in static type form
		do
			Result := queryable.text_in_static_type_form (expression)
		end

	field_content_in_dynamic_type_form: STRING
			-- Text of current term in static type form
		do
			Result := queryable.text_in_dynamic_type_form (expression)
		end

	field_content_in_anonymous_type_form: STRING
			-- Text of current term in static type form
		do
			Result := queryable.text_in_anonymous_type_form (expression)
		end

	operands: ARRAYED_LIST [INTEGER]
			-- Indexes of operands in Current term
		do
			Result := operand_indexes (field_content_in_anonymous_type_form)
		end

feature -- Status report


	is_change: BOOLEAN = True
			-- Is current a term for a change?

	is_relative: BOOLEAN
			-- Is `change' a relative change?
		do
			Result := change.is_relative
		end

	is_absolute: BOOLEAN
			-- Is `change' an absolute change?
		do
			Result := change.is_absolute
		end

feature -- Process

	process (a_visitor: SEM_TERM_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_change_term (Current)
		end

end
