note
	description: "Summary description for {EBB_VERIFICATION_PROPERTY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EBB_VERIFICATION_PROPERTY

inherit

	HASHABLE

create
	make

feature {NONE} -- Initialization

	make (a_name: attached like name)
			-- Initialize property with name `a_name'.
		require
			name_not_empty: not a_name.is_empty
		do
			name := a_name.twin
		ensure
			name_set: name ~ a_name
		end

feature -- Access

	name: attached STRING
			-- Name of property.

	hash_code: INTEGER
			-- Hash code value
		do
			Result := name.hash_code
		end

feature -- Status report



end
