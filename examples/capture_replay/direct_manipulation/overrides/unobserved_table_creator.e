indexing
	description: "[
				   Objects that are used to initialize ANY's UNOBSERVED Table.
				   Override this class to change the set of unobserved classes.
				   ]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	UNOBSERVED_TABLE_CREATOR

feature -- Access
	create_unobserved_table: HASH_TABLE [BOOLEAN, STRING] is
			-- Create a hashtable that contains the names of the classes
			-- that aren't observed.
		do
			create Result.make(10)
			Result.put (True, "CONSOLE")
			Result.put (True, "STD_FILES")
			Result.put (True, "KL_TEXT_INPUT_FILE")
			Result.put (True, "UNIX_FILE_INFO")
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
