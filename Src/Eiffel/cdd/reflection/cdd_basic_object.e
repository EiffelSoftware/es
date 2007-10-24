indexing
	description: "Objects that represent reflection of basic values"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_BASIC_OBJECT

inherit

	CDD_OBJECT
		rename
			identifier as value
		end

create
	make_with_value

feature -- Initialization

	make_with_value (a_value: like value) is
			-- Create reflection for basic object of type 'a_type' and value 'a_value'
		require
			a_value_not_empty: a_value /= Void and then not a_value.is_empty
		do
			value := a_value
		ensure
			correct_value: value = a_value
		end

feature -- Access

	value: STRING
		-- Value of the object during execution

invariant
	value_not_empty: value /= Void and then not value.is_empty

end
