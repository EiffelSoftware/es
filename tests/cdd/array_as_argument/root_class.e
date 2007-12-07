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
		do
			bar (<< 1, 2, 3 >>)
		end

	bar (an_array: ARRAY [INTEGER]) is
		require
			an_array_valid: an_array.count > 3
		do
		end

end
