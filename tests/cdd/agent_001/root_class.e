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
			l_procedure: PROCEDURE[ROOT_CLASS,TUPLE[INTEGER]]
		do
			l_procedure := agent current.bar(?)
			l_procedure.call([3])
		end

	bar(some_arg: INTEGER) is
			-- Fail with a postcondition violation.
		require
			precondition: True
		do

		ensure
			false_postcondition: False
		end

end
