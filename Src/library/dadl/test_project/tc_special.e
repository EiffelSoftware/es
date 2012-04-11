indexing
	description: "Summary description for {TC_SPECIAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TC_SPECIAL

create
	make


feature -- creation

	make is
			--
		local
			empty:EMPTY
		do
			create my_special.make(5)
			create empty
			my_special.put (empty, 1)

			create my_special_prim.make(3)
			my_special_prim.put(1,1)
			my_special_prim.put(200,2)

		end


feature -- access

	my_special:SPECIAL[EMPTY]

	my_special_prim:SPECIAL[INTEGER]


end
