indexing
	description: "[
				   Objects that are used to initialize ANY's UNOBSERVED Table.
				   Override this class to change the set of unobserved classes.
				   ]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNOBSERVED_TABLE_CREATOR

feature -- Access
	unobserved_table: HASH_TABLE [BOOLEAN, STRING] is
			--
		do
			create Result.make(10)
			Result.put (True, "CONSOLE")
			Result.put (True, "STD_FILES")
		end


feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
