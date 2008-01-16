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
			l_special: SPECIAL[INTEGER]
		do
			create l_special.make (10)
			l_special.put (0, 0)
			l_special.put (1, 1)
			l_special.put (2, 2)
			l_special.put (3, 3)
			l_special.put (4, 4)
			l_special.put (5, 5)
			l_special.put (6, 6)
			l_special.put (7, 7)
			l_special.put (8, 8)
			l_special.put (9, 9)
			bar(l_special)
		end

	bar(some_arg: SPECIAL[INTEGER]) is
			-- Fail with a postcondition violation.
		require
			precondition: True
		do

		ensure
			false_postcondition: False
		end

	frozen a_frozen_special: SPECIAL[INTEGER]

end
