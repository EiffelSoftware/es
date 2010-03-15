note
	description: "Summary description for {X}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Y

inherit X
	redefine
		do_some
	end
	
feature
	do_some(k: X): TUPLE[TUPLE[INTEGER, BOOLEAN, TUPLE[X]]] is
	do
	end


feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
