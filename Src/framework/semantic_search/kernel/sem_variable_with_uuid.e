note
	description: "Variable with UUID in queryables"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_VARIABLE_WITH_UUID

inherit
	HASHABLE

create
	make

feature{NONE} -- Initialization

	make (a_variable: STRING; a_uuid: STRING)
			-- Initialize Current.
		do
			variable := a_variable
			uuid := a_uuid
			hash_code := (uuid + variable).hash_code
		end

feature -- Access

	variable: STRING
			-- Name of the variable

	uuid: STRING
			-- UUID of the queryable where Current variable come from

	hash_code: INTEGER
			-- Hash code value

end
