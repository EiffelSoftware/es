indexing
	description	: "System's root class"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_CLASS

create
	make

feature -- Initialization

	make is
		local
			l_tuple: TUPLE[INTEGER, LINKED_LIST[ANY], LINKED_LIST[NUMERIC]]
		do
			l_tuple := [15, create {LINKED_LIST[ANY]}.make, create {LINKED_LIST[NUMERIC]}.make]
			bar(l_tuple)
		end

	bar(a_tuple: TUPLE[INTEGER, LINKED_LIST[ANY]]) is
			-- Fail with a postcondition violation.
		require
			precondition: True
		do

		ensure
			false_postcondition: False
		end

end
