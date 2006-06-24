indexing
	description: "The abstract type of a message used for communication."
	author		: "Bernhard S. Buss"
	date		: "19.May.2006"
	revision: "$Revision$"

class
	EMU_MESSAGE
	
inherit
	STORABLE
	
	ANY
		undefine
			default_create
		end

end
