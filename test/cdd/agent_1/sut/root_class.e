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
			-- Creation procedure.
		local
			p: PROCEDURE [ANY, TUPLE]
		do
			p := agent foo
			p.call ([])
		end

	foo is
		require
			False
		do
		end

end -- class ROOT_CLASS
