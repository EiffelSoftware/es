note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	D[G]

inherit
	B[G]
	redefine f ,g ,make
	 end

create
	make

feature -- Access

	make is
		-- bla
		local
			d: D[X]
			d_sep: attached separate D[X]
		do

		end

	f(a:D[G]): D[INTEGER] is

	     do
	     end

	g(a: attached separate D[TUPLE[INTEGER, BOOLEAN, TUPLE[attached separate X]]];
	  b: attached separate D[TUPLE[INTEGER, BOOLEAN, TUPLE[attached separate X]]];
	  c: attached separate D[G]): D[X] is
		require else
			is_true: a.assert(b)
		do
			if b.assert(a) then end
			io.put_string("nice")
		ensure then
			is_true: b.assert(a) or b.assert(a)
		end
  
	assert(a : D[G]): BOOLEAN is
			-- bla
			do

			end


end
