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

	as_nominal (a_values: DS_HASH_SET [STRING]): WEKA_ARFF_NOMINAL_ATTRIBUTE
			-- Norminal attribute from Current under the set of values `a_values'
		do
			create Result.make (name, a_values)
		end

	cloned_objects: like Current
			-- Cloned version of Current.
		do
			create Result.make (name)
		end

feature -- Status report

	is_string: BOOLEAN = True
			-- Is current attribute of string type?

	is_valid_value (a_value: STRING): BOOLEAN
			-- Is `a_value' a valid value for current attribute?
		do
			if a_value /= Void then
--				if a_value.has (' ') or a_value.has ('%T') then
--					Result := a_value.item (1) = '%"' and a_value.item (a_value.count) = '%"'
--				else
--					Result := True
--				end
				Result := True
			else
				Result := True
			end
		end

feature -- Process

	process (a_visitor: WEKA_ARFF_ATTRIBUTE_VISITOR)
			-- Visit Current with `a_visitor'.
		do
			a_visitor.process_string_attribute (Current)
		end

end
