note
	description: "Class that represents an integer value which is not equal to a given value"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_INTEGER_EXCLUSION_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			is_integer_exclusion,
			text
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item)
			-- Initialize `item' with `a_item'.
		do
			item_cache := a_item
			text := once "not " + item_cache.out
		ensure
			item_set: item = item_cache
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		do
			Result := integer_type
		end

	item: INTEGER
			-- Value item in current
		do
			Result := item_cache
		end

	text: STRING
			-- New string containing terse printable representation
			-- of current object

feature -- Status report

	is_integer_exclusion: BOOLEAN = True
			-- Is current an integer exclusion value?

feature -- Process


	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_integer_exclusion_value (Current)
		end

feature{NONE} -- Implementation

	item_cache: INTEGER
			-- Cache for `item'

end
