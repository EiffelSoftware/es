note
	description: "Summary description for {AFX_RANDOM_BOOLEAN_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_RANDOM_BOOLEAN_VALUE

inherit
	EPA_RANDOM_VALUE
		undefine
			is_boolean,
			as_boolean,
			is_true_boolean,
			is_false_boolean
		redefine
			process
		end

	EPA_BOOLEAN_VALUE
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
			item_cache := is_within_probability (random, 0.50)
		end

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_random_boolean_value (Current)
		end

end
