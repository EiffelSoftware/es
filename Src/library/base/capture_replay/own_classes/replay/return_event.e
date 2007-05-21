indexing
	description: "[
				Common interface for RET (feature-return) - events for the replay phase
				]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RETURN_EVENT

inherit
	EVENT

feature -- Stub for creation procedure

	make (a_return_value: ENTITY)
		do
			return_value := a_return_value
		end

feature -- Access

	return_value: ENTITY

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
