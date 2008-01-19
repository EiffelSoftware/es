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
			l_some_class: SOME_CLASS
		do
			create l_some_class.make
			bar(l_some_class)
		end

	bar(a_some_class: SOME_CLASS) is
			-- Fail with a postcondition violation.
		require
			precondition: True
		do
		
		ensure
			false_postcondition: False
		end

end
