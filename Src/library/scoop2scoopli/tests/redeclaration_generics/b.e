note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	B[G]

inherit
	A[G]
	redefine f, g end

create
	make

feature -- Access
	make is
			-- bla
		do
		end


	f(a: D[G]): D[INTEGER] is

	     do
	     end

	g(a,b: separate D[TUPLE[INTEGER, BOOLEAN, TUPLE[separate X]]];c: separate D[G]): D[X] is

	     do
	     end

end
