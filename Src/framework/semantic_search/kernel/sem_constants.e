note
	description: "Constants for semantic search"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_CONSTANTS

feature -- Queryable type names

	transition_field_value: STRING = "transition"

	snippet_field_value: STRING = "snippet"

	object_field_value: STRING = "object"

feature -- Type names

	string_field_type: STRING = "STRING"

	boolean_field_type: STRING = "BOOLEAN"

	integer_field_type: STRING = "INTEGER"

feature -- Default boost

	default_boost_value: DOUBLE = 1.0

end

