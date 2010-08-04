note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	A[G]

feature -- Access

	f (a: D[G]): separate D[INTEGER] is

	     do
	     	-- do nothing
	     end
	g(a:attached separate D[TUPLE[INTEGER, BOOLEAN, TUPLE[attached separate X]]];
	  b: attached D[TUPLE[INTEGER, BOOLEAN, TUPLE[attached separate X]]] ;
	  c:attached separate D[G]): separate D[X] is
		do
			--do nothing
		end

  h (str : STRING)
    do
    end

end
