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

	EPA_TYPE_UTILITY

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

feature -- Property type form name

	dynamic_type_form_name: STRING = "dynamic type form"
			-- Name for `dynamic_type_form'

	static_type_form_name: STRING = "static type form"
			-- Name for `static_type_form'

	anonymous_type_form_name: STRING
			-- Name for `anonymous_type_form'

	property_type_form_name (a_type_form: INTEGER): STRING
			-- Type form name from `a_type_form'
		require
			a_type_form_valid: is_type_form_valid (a_type_form)
		do
			if a_type_form = dynamic_type_form then
				Result := static_type_form_name
			elseif a_type_form = static_type_form then
				Result := static_type_form_name
			elseif a_type_form = anonymous_type_form then
				Result := anonymous_type_form_name
			end
		end

feature -- Status report


	is_type_form_valid (a_form: INTEGER): BOOLEAN
			-- Is `a_form' a valid type form?
		do
			Result :=
				a_form = dynamic_type_form or else
				a_form = static_type_form or else
				a_form = anonymous_type_form
		end

feature -- Field constants

	integer_prefix: STRING = "i_"
	boolean_prefix: STRING = "b_"
	string_prefix: STRING = "s_"
	text_prefix: STRING = "t_"
	by_change_prefix: STRING = "by_"
	to_change_prefix: STRING = "to_"
	change_prefix: STRING = "ch_"

	dynamic_type_form_prefix: STRING = "d_"
	static_type_form_prefix: STRING = "s_"
	anonymous_type_form_prefix: STRING = "a_"

	precondition_prefix: STRING = "pre_"
	postcondition_prefix: STRING = "post_"
	property_prefix: STRING = "prop_"

	field_prefix_generator: SEM_FIELD_PREFIX_GENERATOR
			-- Field prefix generator
		once
			create Result
		end

end


