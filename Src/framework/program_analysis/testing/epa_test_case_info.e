note
	description: "Information of a test case"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_TEST_CASE_INFO

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_name, a_id: STRING)
			-- Initialization.
		require
			name_attached: a_name /= Void and then not a_name.is_empty
		do
			name := a_name.twin
			if a_id = Void or else a_id.is_empty then
				id := a_name.twin
			else
				id := a_id.twin
			end
		end

feature -- Access

	name: STRING
			-- Name of the test case.

	id: STRING
			-- ID of the test case.

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result := name ~ other.name and then id ~ other.id
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code value
		do
			Result := id.hash_code
		end

end
