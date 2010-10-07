note
	description: "Constants for semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CONSTANTS

inherit
	IR_TERM_OCCURRENCE

	IR_VALUE_TYPES

	IR_CONSTANTS

feature -- Queryable type names

	transition_field_value: STRING = "transition"

	snippet_field_value: STRING = "snippet"

	object_field_value: STRING = "object"

feature -- Property type forms

	dynamic_type_form: INTEGER = 1
			-- Dynamic type form where operands of an expression
			-- are replaced by the dynamic type of those operands
			-- For example: For l.has (o), where l is of type LINKED_LIST [ANY]
			-- and o is of type STRING, the dynamic type form is: {LINKED_LIST [ANY]}.has ({STRING})

	static_type_form: INTEGER = 2
			-- Static type form where operands of an expression
			-- are replaced by the static type of those operands
			-- For example: For l.has (o), where l is of type LINKED_LIST [ANY]
			-- and o is of type STRING, the dynamic type form is: {LINKED_LIST [ANY]}.has ({ANY})

	anonymous_type_form: INTEGER = 3
			-- Anonymous type form  where operands of an expression
			-- are replaced by the indexes of those operands
			-- For example: For l.has (o), where l is of type LINKED_LIST [ANY]
			-- and o is of type STRING, the dynamic type form is: {0}.has ({1})

feature -- Status report

	is_type_form_valid (a_form: INTEGER): BOOLEAN
			-- Is `a_form' a valid type form?
		do
			Result :=
				a_form = dynamic_type_form or else
				a_form = static_type_form or else
				a_form = anonymous_type_form
		end

end

