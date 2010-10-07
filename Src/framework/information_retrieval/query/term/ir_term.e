note
	description: "Term"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_TERM

inherit
	IR_TERM_OCCURRENCE

	DEBUG_OUTPUT

	HASHABLE

create
	make

feature{NONE} -- Initialization

	make (a_field: like field; a_occurrence: INTEGER)
			-- Initialize Current.
		require
			a_occurrence_vaild: is_term_occurrence_valid (a_occurrence)
		do
			field := a_field
			occurrence := a_occurrence
			hash_code := full_text.hash_code
		end

feature -- Access

	field: IR_FIELD
			-- Field wrapped in Curent term

	type: INTEGER
			-- Type of `field'
		do
			Result := field.type
		end

	type_name: STRING
			-- Name of `type'
		do
			Result := field.type_name
		end

	field_name: STRING
			-- Field name of current term
		do
			Result := field.name
		end

	boost: DOUBLE
			-- Boost of current term
		do
			Result := field.boost
		end

	occurrence: INTEGER
			-- Occurrence flag of current term

	value: IR_VALUE
			-- Value of current term
		do
			Result := field.value
		end

	text: STRING
			-- Text representation of Current, containing only `field_name' and `value'
		do
			create Result.make (64)
			Result.append (field_name)
			Result.append ({EPA_CONSTANTS}.query_value_separator)
			Result.append (value.text)
		end

	full_text: STRING
			-- Text representation of Current, containing `field_name', `value', `occurrence' and `boost'
		do
			create Result.make (64)
			Result.append (field_name)
			Result.append ({EPA_CONSTANTS}.query_value_separator)
			Result.append (value.text)
			Result.append_character (',')
			Result.append (term_occurrence_name (occurrence))
			Result.append_character (',')
			Result.append (boost.out)
		end

	hash_code: INTEGER
			-- Hash code value

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := full_text
		end

invariant
	occurrence_valid: is_term_occurrence_valid (occurrence)
	field_name_not_empty: not field_name.is_empty
	boost_non_negative: boost >= 0.0

end
