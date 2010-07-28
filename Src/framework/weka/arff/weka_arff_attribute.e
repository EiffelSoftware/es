note
	description: "Objects thar represent an attribute in ARFF format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WEKA_ARFF_ATTRIBUTE

inherit
	HASHABLE
		redefine
			is_equal
		end

	DEBUG_OUTPUT
		undefine
			is_equal
		end

feature -- Access

	name: STRING
			-- name of current attribute

	hash_code: INTEGER
			-- Hash code value
		do
			Result := name.hash_code
		ensure then
			good_result: Result = name.hash_code
		end

	type_string: STRING
			-- String representing the type of current attribute
		deferred
		ensure
			not_result_is_empty: not Result.is_empty
		end

	signature: STRING
			-- String representing the signature of Current attribute.
		do
			create Result.make (128)
			Result.append (attribute_header)
			Result.append_character (' ')

			Result.append_character ('%"')
			Result.append (name)
			Result.append_character ('%"')

			Result.append_character ('%T')
			Result.append (type_string)
		end

	value (a_value: STRING): STRING
			-- Value from `a_value', possibly processed to fit the type of current attribute
		deferred
		ensure
			result_is_valid: is_valid_value (Result)
		end

	as_nominal (a_values: DS_HASH_SET [STRING]): WEKA_ARFF_NOMINAL_ATTRIBUTE
			-- Norminal attribute from Current under the set of values `a_values'
		deferred
		end

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			create Result.make (64)
			Result.append (name)
			Result.append_character (':')
			Result.append_character (' ')
			Result.append (type_string)
		end

feature -- Constants

	attribute_header: STRING = "@ATTRIBUTE"

feature -- Constants

	missing_value: STRING = "?"
			-- String representation for a missing value

feature -- Status report

	is_numeric: BOOLEAN
			-- Is current attribute of numeric type?
		do
		end

	is_boolean: BOOLEAN
			-- Is current attribute of boolean type?
		do
		end

	is_nominal: BOOLEAN
			-- Is current attribute of norminal type?
		do
		end

	is_date: BOOLEAN
			-- Is current attribute of date type?
		do
		end

	is_string: BOOLEAN
			-- Is current attribute of string type?
		do
		end

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' a valid value for current attribute?
		deferred
		ensure
			missing_value_is_valid: is_missing_value (a_value) implies Result
		end

	is_missing_value (a_value: STRING): BOOLEAN
			-- Is `a_value' equal to `missing_value'?
		do
			Result := a_value ~ missing_value
		ensure
			good_result: Result = (a_value ~ missing_value)
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := name ~ other.name
		end

invariant
	not_name_is_empty: not name.is_empty

end
