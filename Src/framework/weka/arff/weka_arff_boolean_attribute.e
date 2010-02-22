note
	description: "Summary description for {WEKA_ARFF_BOOLEAN_ATTRIBUTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_BOOLEAN_ATTRIBUTE

inherit
	WEKA_ARFF_ATTRIBUTE
		redefine
			is_norminal
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

	type_string: STRING = "{True, False}"
			-- String representing the type of current attribute

	value (a_value: STRING): STRING
			-- Value from `a_value', possibly processed to fit the type of current attribute
		do
			if a_value.is_boolean then
				Result := a_value.twin
			else
				Result := missing_value
			end
		end

feature -- Status report

	is_norminal: BOOLEAN = True
			-- Is current attribute of norminal type?

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' a valid value for current attribute?
		do
			if is_missing_value (a_value) then
				Result := True
			else
				Result := a_value.is_boolean
			end
		end
end
