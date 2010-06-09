note
	description: "String attribute in Weka ARFF format"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WEKA_ARFF_STRING_ATTRIBUTE

inherit
	WEKA_ARFF_ATTRIBUTE
		redefine
			is_string
		end

create
	make


feature{NONE} -- Initialization

	make (a_name: like name)
			-- Initialize current nominal attribute with `a_name'.
		do
			name := a_name.twin
		end

feature -- Access

	type_string: STRING = "STRING"
			-- String representing the type of current attribute

	value (a_value: STRING): STRING
			-- Value from `a_value', possibly processed to fit the type of current attribute
		do
			if a_value = Void then
				Result := missing_value
			else
				Result := a_value.twin
			end
		end

feature -- Status report

	is_string: BOOLEAN = True
			-- Is current attribute of string type?

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' a valid value for current attribute?
		do
			if a_value /= Void then
				if a_value.has (' ') or a_value.has ('%T') then
					Result := a_value.item (1) = '%"' and a_value.item (a_value.count) = '%"'
				else
					Result := True
				end
			else
				Result := True
			end
		end


end
