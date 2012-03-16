note
	description: "[
	{STORABLE} objects allowing testing of data structure objects for serialization.
	]"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

class
	DATA_STRUCTURES_CLASS_2_FOR_STORABLE

inherit
		STORABLE
			undefine out end
		DATA_STRUCTURES_CLASS_2
			create make
end
