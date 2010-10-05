note
	description: "Class represents a document (in search engine sense)"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SEM_DOCUMENT

inherit
	EPA_HASH_SET [SEM_DOCUMENT_FIELD]
		redefine
			make
		end

	SEM_SHARED_EQUALITY_TESTER
		undefine
			copy,
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (n: INTEGER)
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
		do
			Precursor (n)
			set_equality_tester (document_field_equality_tester)
		end

end
