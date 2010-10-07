note
	description: "Class that represents a document used in information retrieval system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IR_DOCUMENT

inherit
	EPA_HASH_SET [IR_FIELD]
		redefine
			make
		end

	IR_SHARED_EQUALITY_TESTERS
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
			set_equality_tester (ir_field_equality_tester)
		end

end
