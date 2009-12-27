note
	description: "Summary description for {AFX_RANDOM_INTEGER_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_RANDOM_INTEGER_VALUE

inherit
	AFX_RANDOM_VALUE
		undefine
			is_integer
		redefine
			process
		end

	AFX_INTEGER_VALUE
		rename
			make as old_make
		undefine
			is_random
		redefine
			process
		end

create
	make

feature{NONE} -- Initialization

	make
			-- Initialize Current.
		do
			random.forth
			item_cache := random.item
		end

feature -- Process

	process (a_visitor: AFX_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_random_integer_value (Current)
		end

end
