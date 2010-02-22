note
	description: "Objects that represent a numeric attribute in ARFF file format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_NUMERIC_ATTRIBUTE

inherit
	WEKA_ARFF_ATTRIBUTE
		redefine
			is_numeric
		end

create
	make

feature{NONE} -- Initialization

	make (a_name: STRING)
			-- Initialize Current.
		do
			name := a_name.twin
		end

feature -- Access

	type_string: STRING = "NUMERIC"
			-- String representing the type of current attribute

	value (a_value: STRING): STRING
			-- Value from `a_value', possibly processed to fit the type of current attribute
		do
			if a_value.is_integer or a_value.is_real then
				Result := a_value.twin
			else
				Result := missing_value
			end
		end

feature -- Status report

	is_numeric: BOOLEAN = True
			-- Is current attribute of numeric type?

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' a valid value for current attribute?
		do
			if is_missing_value (a_value) then
				Result := True
			else
				Result := a_value.is_integer or a_value.is_real
			end
		end

end
