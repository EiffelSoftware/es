note
	description: "[
			index using 2 bytes
		]"
	author: "$Author$"
	date: "$Date$"
	revision: "$Revision$"

class
	PE_EVENT_INDEX_16_ITEM

inherit
	PE_EVENT_INDEX_ITEM
		rename
			make as make_item
		end

	PE_INDEX_16_ITEM_WITH_TABLE

create
	make

convert
	value: {NATURAL_16}

end
