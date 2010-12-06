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
			is_nominal
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		undefine
			is_equal
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
			if a_value /= Void and then a_value.is_boolean then
				Result := a_value.twin
			else
				Result := missing_value
			end
		end

	as_nominal (a_values: DS_HASH_SET [STRING]): WEKA_ARFF_NOMINAL_ATTRIBUTE
			-- Norminal attribute from Current under the set of values `a_values'
		local
			l_values: DS_HASH_SET [STRING]
		do
			create l_values.make (2)
			l_values.set_equality_tester (string_equality_tester)
			l_values.force_last (once "True")
			l_values.force_last (once "False")
			create Result.make (name, l_values)
		end

	cloned_objects: like Current
			-- Cloned version of Current.
		do
			create Result.make (name)
		end

feature -- Status report

	is_nominal: BOOLEAN = True
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

feature -- Process

	process (a_visitor: WEKA_ARFF_ATTRIBUTE_VISITOR)
			-- Visit Current with `a_visitor'.
		do
			a_visitor.process_boolean_attribute (Current)
		end

end
