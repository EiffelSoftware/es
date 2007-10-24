indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AP_INTEGER

create

	make

feature {NONE} -- Initialization

	make
		do
		end

	x: ANY

invariant

	x_not_void: x /= Void

end
