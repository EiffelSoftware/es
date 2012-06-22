note
	description: "Descendant objects provide different kinds of mappings between classes and relational tables."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_MAPPING

feature -- Basic operations

	associate_column_to_attribute (a_column_name, a_column_type, a_attribute_name: STRING_8)
			-- associate `a_column_name' having `a_column_type' with `a_attribute_name'.
		require
			a_column_name_exists: not a_column_name.is_empty
			a_column_type_exists: not a_column_type.is_empty
			a_attribute_name_exists: not a_attribute_name.is_empty
		deferred
		end

end
