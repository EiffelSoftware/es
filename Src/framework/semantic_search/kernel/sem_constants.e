note
	description: "Constants for semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CONSTANTS

inherit
	IR_TERM_OCCURRENCE

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

	is_type_form_valid (a_form: INTEGER): BOOLEAN
			-- Is `a_form' a valid type form?
		do
			Result :=
				a_form = dynamic_type_form or else
				a_form = static_type_form or else
				a_form = anonymous_type_form
		end

feature -- Type names

	string_field_type: INTEGER = 1

	boolean_field_type: INTEGER = 2

	integer_field_type: INTEGER = 3

	string_field_type_name: STRING = "STRING"

	boolean_field_type_name: STRING = "BOOLEAN"

	integer_field_type_name: STRING = "INTEGER"

	field_type_name (a_type: INTEGER): STRING
			-- Name of the field with `a_type'
		do
			if a_type = string_field_type then
				Result := string_field_type_name
			elseif a_type = boolean_field_type then
				Result := boolean_field_type_name
			elseif a_type = integer_field_type then
				Result := integer_field_type_name
			end
		end

	field_type_from_name (a_name: STRING): INTEGER
			-- Field type from `a_name'
		do
			Result := field_type_name_table.item (a_name)
		end

	field_type_name_table: HASH_TABLE [INTEGER, STRING]
			-- Table from field name to field type
		once
			create Result.make (3)
			Result.force (integer_field_type, integer_field_type_name)
			Result.force (boolean_field_type, boolean_field_type_name)
			Result.force (string_field_type, string_field_type_name)
		end

feature -- Status report

	is_field_type_valid (a_type: INTEGER): BOOLEAN
			-- Is `a_type' a valid field type?
		do
			Result :=
				a_type = boolean_field_type or else
				a_type = integer_field_type or else
				a_type = string_field_type
		end

	is_field_type_name_valid (a_type_name: STRING): BOOLEAN
			-- Is `a_type_name' a valid type name?
		do
			Result := field_type_name_table.has (a_type_name)
		end

feature -- Default boost

	default_boost_value: DOUBLE = 1.0

end

