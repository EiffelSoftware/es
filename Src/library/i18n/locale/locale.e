indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LOCALE

feature -- Access
	language_id: STRING
		-- Language id

feature -- Basic operations
	set_language_id(a_id: STRING) is
			-- Set language id.
		do
			language_id := a_id
		end

invariant
	invariant_clause: True -- Your invariant here

end -- class LOCALE
